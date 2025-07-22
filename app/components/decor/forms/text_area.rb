# frozen_string_literal: true

module Decor
  module Forms
    class TextArea < FormField
      # HTML textarea size attributes by character rows and columns
      prop :rows, Integer, default: 5
      prop :cols, _Nilable(Integer)

      # A pattern to test against (a JavaScript Regex in a string)
      prop :pattern, _Nilable(String)

      # The min and max length HTML5 attributes are set with the following
      prop :maximum_length, _Nilable(Integer)
      prop :minimum_length, _Nilable(Integer)

      stimulus do
        classes invalid_input: "invalid:border-error-dark"
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
            textarea(
              data_hj_whitelist: true,
              data_controller: form_control_controller,
              class: textarea_classes,
              **html_attributes,
              data: input_data_attributes(el)
            ) { @value }

            render ::Decor::Forms::ErrorIconSection.new(
              error_text: error_text,
              show_floating_message: floating_error_text?,
              html_options: {
                class: "right-3 #{errors? ? "" : "hidden"}"
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
        attrs[:rows] = @rows if @rows
        attrs[:cols] = @cols if @cols
        attrs[:disabled] = nil if @disabled
        attrs[:required] = nil if @required
        attrs[:minlength] = @minimum_length if @minimum_length
        attrs[:maxlength] = @maximum_length if @maximum_length
        attrs[:pattern] = resolved_pattern if @pattern
        attrs[:autocomplete] = @autocomplete if @autocomplete
        if @placeholder || (label_inside? && @label.present?)
          attrs[:placeholder] = @placeholder || label_with_required
        end
        attrs
      end

      def textarea_classes
        classes = ["textarea", "w-full"]
        classes << component_size_classes(@size).join(" ")
        classes << component_color_classes(@color).join(" ")
        classes << component_style_classes(@style).join(" ")
        classes << "textarea-error" if errors?
        classes << input_classes if input_classes.present?
        classes.compact.join(" ").strip
      end

      def component_size_classes(size)
        case size
        when :xs then ["textarea-xs"]
        when :sm then ["textarea-sm"]
        when :md then [] # default
        when :lg then ["textarea-lg"]
        when :xl then ["textarea-lg"] # DaisyUI doesn't have xl, use lg
        else []
        end
      end

      def component_color_classes(color)
        case color
        when :primary then ["textarea-primary"]
        when :secondary then ["textarea-secondary"]
        when :accent then ["textarea-accent"]
        when :success then ["textarea-success"]
        when :error then ["textarea-error"]
        when :warning then ["textarea-warning"]
        when :info then ["textarea-info"]
        when :ghost then ["textarea-ghost"]
        when :neutral then [] # neutral is default
        else [] # base/neutral
        end
      end

      def component_style_classes(style)
        case style
        when :filled then [] # default
        when :outlined then ["textarea-bordered"]
        when :ghost then ["textarea-ghost"]
        else []
        end
      end

      def resolved_pattern
        if @pattern.is_a?(Proc)
          @pattern.call(self)
        else
          @pattern
        end
      end
    end
  end
end
