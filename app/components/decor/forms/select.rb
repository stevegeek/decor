# frozen_string_literal: true

module Decor
  module Forms
    class Select < FormField
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
        value.to_s if value
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

      def view_template
        root_element do |el|
          layout = ::Decor::Forms::FormFieldLayout.new(
            **form_field_layout_options(el),
            stimulus_classes: {
              valid_label: @disabled ? "text-disabled" : "text-gray-900",
              invalid_label: "text-error-dark"
            }
          )

          layout.helper_text_section do
            render ::Decor::Forms::HelperTextSection.new(
              helper_text: @helper_text,
              error_text: error_text,
              disabled: @disabled,
              error_section: !floating_error_text?,
              collapsing_helper_text: @collapsing_helper_text
            )
          end

          render layout do
            select(
              data_controller: form_control_controller,
              class: select_classes,
              data: input_data_attributes(el, target_name: :input),
              **html_attributes
            ) do
              send(
                (grouped? ? :grouped_options_for_select : :options_for_select),
                all_options_array,
                disabled: all_disabled_options,
                selected: resolve_selected_option
              )
            end

            render ::Decor::Forms::ErrorIconSection.new(
              error_text: error_text,
              show_floating_message: floating_error_text?,
              html_options: {
                class: "right-7 #{errors? ? "" : "hidden"}"
              }
            )
          end
        end
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

      def select_classes
        classes = ["select", "w-full"]
        classes << component_size_classes(@size).join(" ")
        classes << component_color_classes(@color).join(" ")
        classes << component_style_classes(@style).join(" ")
        classes << "select-error" if errors?
        classes << input_classes if input_classes.present?
        classes.compact.join(" ").strip
      end

      def component_size_classes(size)
        case size
        when :xs then ["select-xs"]
        when :sm then ["select-sm"]
        when :md then [] # default
        when :lg then ["select-lg"]
        when :xl then ["select-xl"]
        else []
        end
      end

      def component_color_classes(color)
        case color
        when :primary then ["select-primary"]
        when :secondary then ["select-secondary"]
        when :accent then ["select-accent"]
        when :success then ["select-success"]
        when :error then ["select-error"]
        when :warning then ["select-warning"]
        when :info then ["select-info"]
        when :ghost then ["select-ghost"]
        when :neutral then [] # neutral is default
        else [] # base/neutral
        end
      end

      def component_style_classes(style)
        case style
        when :filled then [] # default
        when :outlined then ["select-bordered"]
        when :ghost then ["select-ghost"]
        else []
        end
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
