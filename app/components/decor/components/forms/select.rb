# frozen_string_literal: true

module Decor
  module Components
    module Forms
      # Abstract base for Select. Owns the prop API + stimulus block + the
      # option-mapping helpers. Concrete skins (Daisy, Suite) inherit and
      # provide `view_template` plus the daisy-specific class builders.
      class Select < ::Decor::Components::Forms::FormField
        include ::Phlex::Rails::Helpers::OptionsForSelect
        include ::Phlex::Rails::Helpers::GroupedOptionsForSelect

        class << self
          def map_options_for_select(options)
            {
              options_array: options.map { |o| [o[:title], o[:value]] },
              disabled_options: options.select { |o| o[:disabled] }.pluck(:value),
              selected_option: options.find { |o| o[:selected] }&.[](:value)
            }
          end

          def map_grouped_options_for_select(options)
            options_array = options.map do |group|
              [
                group[:title],
                group[:value].map { |o| [o[:title], o[:value]] }
              ]
            end
            {
              options_array: options_array,
              disabled_options: plain_options(options).select { |o| o[:disabled] }.pluck(:value),
              selected_option: plain_options(options).find { |o| o[:selected] }&.[](:value)
            }
          end

          private

          def plain_options(options)
            options.flat_map { |o| o[:value] }
          end
        end

        # The <option>s in the select
        prop :options_array, _Array(_Any), default: -> { [] }
        prop :selected_option, _Nilable(String) do |value|
          value&.to_s
        end
        prop :disabled_options, _Nilable(_Array(_Any)), default: -> { [] }

        # Include a blank options (when a placeholder of label is inside the placeholder is also a blank option).
        # This is useful for when you have no placeholder but want to include a blank option.
        prop :include_blank_option, _Boolean, default: false

        # This option will disable selecting the blank option
        prop :disable_blank_option, _Boolean, default: true

        prop :compact, _Boolean, default: false

        stimulus do
          values has_blank_or_placeholder: -> { @include_blank_option || label_inside? || @placeholder.present? }
        end

        private

        def html_attributes
          attrs = {
            id: "#{id}-control",
            name: @name
          }
          attrs[:autocomplete] = @autocomplete if @autocomplete
          attrs[:required] = true if @required
          attrs[:disabled] = true if @disabled
          attrs
        end

        def grouped?
          return false unless @options_array.first.is_a?(Array)
          @options_array.first&.last&.is_a? Array
        end

        def all_options_array
          options = @options_array.dup
          if @include_blank_option
            options.unshift([" ", ""])
          end
          if label_inside?
            options.unshift([label_with_required, ""])
          elsif @placeholder.present?
            options.unshift([@placeholder, ""])
          end
          options
        end

        def resolve_selected_option
          return "" if @selected_option.blank?
          @selected_option
        end

        def all_disabled_options
          options = @disabled_options.dup
          if @disable_blank_option && (@include_blank_option || label_inside? || @placeholder.present?)
            options << ""
          end
          options
        end
      end
    end
  end
end
