# frozen_string_literal: true

module Decor
  module Components
    module Forms
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
        # May be a String (single-select) or an Array of Strings (multi-select).
        prop :selected_option, _Nilable(_Any)
        prop :disabled_options, _Nilable(_Array(_Any)), default: -> { [] }

        # Include a blank options (when a placeholder of label is inside the placeholder is also a blank option).
        # This is useful for when you have no placeholder but want to include a blank option.
        prop :include_blank_option, _Boolean, default: false

        # Rails-compatible `include_blank`. May be `true`/`false` (empty-label blank option)
        # or a String (the label to use for the blank option).
        prop :include_blank, _Nilable(_Any)

        # Render a multi-select (<select multiple>).
        prop :multiple, _Boolean, default: false

        # This option will disable selecting the blank option
        prop :disable_blank_option, _Boolean, default: true

        # Suppresses helper text + error icon chrome. The control still gets an
        # error-state border but no caption is rendered. Useful inside compact
        # admin rows.
        prop :silent_helper_and_error_text, _Boolean, default: false

        prop :compact, _Boolean, default: false

        stimulus do
          values has_blank_or_placeholder: -> { blank_option? || label_inside? || @placeholder.present? },
            label: -> { @label.to_s }
        end

        private

        def html_attributes
          attrs = {
            id: "#{id}-control",
            name: @multiple ? multi_select_name : @name
          }
          attrs[:autocomplete] = @autocomplete if @autocomplete
          attrs[:required] = true if @required
          attrs[:disabled] = true if @disabled
          attrs[:multiple] = true if @multiple
          attrs
        end

        def multi_select_name
          @name.to_s.end_with?("[]") ? @name : "#{@name}[]"
        end

        def grouped?
          return false unless @options_array.first.is_a?(Array)
          @options_array.first&.last&.is_a? Array
        end

        def blank_option?
          @include_blank_option || !@include_blank.nil?
        end

        def blank_option_label
          return @include_blank if @include_blank.is_a?(String)
          " "
        end

        def all_options_array
          options = @options_array.dup
          if blank_option?
            options.unshift([blank_option_label, ""])
          end
          if label_inside?
            options.unshift([label_with_required, ""])
          elsif @placeholder.present?
            options.unshift([@placeholder, ""])
          end
          options
        end

        def resolve_selected_option
          if @multiple
            return [] if @selected_option.blank?
            Array(@selected_option).map(&:to_s)
          else
            return "" if @selected_option.blank?
            @selected_option.to_s
          end
        end

        def all_disabled_options
          options = @disabled_options.dup
          if @disable_blank_option && (blank_option? || label_inside? || @placeholder.present?)
            options << ""
          end
          options
        end

        def silent_helper_and_error_text?
          @silent_helper_and_error_text
        end
      end
    end
  end
end
