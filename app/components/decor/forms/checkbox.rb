# frozen_string_literal: true

module Decor
  module Forms
    class Checkbox < FormField
      include ::Decor::Forms::Concerns::CheckableFormField

      prop :label_position, _Union(:left, :right, :top), default: :right

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
              html_options: {class: (label_inline? || label_right?) ? "ml-8" : "ml-0"},
              helper_text: @helper_text,
              error_text: error_text,
              disabled: @disabled,
              error_section: !floating_error_text?,
              collapsing_helper_text: @collapsing_helper_text
            )
          end

          render layout do
            input(
              type: "checkbox",
              data_controller: form_control_controller,
              class: checkbox_classes,
              **input_html_attributes,
              data: input_data_attributes(el, target_name: :checkbox)
            )
          end
        end
      end

      private

      def checkbox_classes
        classes = ["checkbox"]
        classes << component_size_classes(@size).join(" ")
        classes << component_color_classes(@color).join(" ")
        classes << "checkbox-error" if errors?
        classes.compact.join(" ").strip
      end

      def component_size_classes(size)
        case size
        when :xs then ["checkbox-xs"]
        when :sm then ["checkbox-sm"]
        when :md then [] # default
        when :lg then ["checkbox-lg"]
        when :xl then ["checkbox-xl"]
        else []
        end
      end

      def component_color_classes(color)
        case color
        when :primary then ["checkbox-primary"]
        when :secondary then ["checkbox-secondary"]
        when :accent then ["checkbox-accent"]
        when :success then ["checkbox-success"]
        when :error then ["checkbox-error"]
        when :warning then ["checkbox-warning"]
        when :info then ["checkbox-info"]
        when :neutral then ["checkbox-neutral"]
        else [] # base/neutral
        end
      end

      def input_html_attributes
        attrs = {
          id: "#{id}-control",
          type: "checkbox",
          name: @name,
          value: @value
        }
        attrs[:checked] = true if @checked
        attrs[:required] = true if required_individual?
        attrs[:disabled] = true if @disabled
        attrs
      end
    end
  end
end
