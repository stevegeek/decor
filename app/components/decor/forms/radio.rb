# frozen_string_literal: true

module Decor
  module Forms
    class Radio < FormField
      include ::Decor::Forms::Concerns::CheckableFormField

      prop :label_position, _Union(:left, :right), default: :right

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
              html_options: {class: (@label_inline || @label_position == :right) ? "ml-8" : "ml-0"},
              helper_text: @helper_text,
              error_text: error_text,
              disabled: @disabled,
              error_section: !floating_error_text?,
              collapsing_helper_text: @collapsing_helper_text
            )
          end

          render layout do
            input(
              type: "radio",
              data_controller: form_control_controller,
              class: radio_classes,
              **html_attributes,
              data: input_data_attributes(el, target_name: :radio)
            )
          end
        end
      end

      private

      def radio_classes
        classes = ["radio"]
        classes << component_size_classes(@size).join(" ")
        classes << component_color_classes(@color).join(" ")
        classes << "radio-error" if errors?
        classes.compact.join(" ").strip
      end

      def component_size_classes(size)
        case size
        when :xs then ["radio-xs"]
        when :sm then ["radio-sm"]
        when :md then [] # default
        when :lg then ["radio-lg"]
        when :xl then ["radio-xl"]
        else []
        end
      end

      def component_color_classes(color)
        case color
        when :primary then ["radio-primary"]
        when :secondary then ["radio-secondary"]
        when :accent then ["radio-accent"]
        when :success then ["radio-success"]
        when :error then ["radio-error"]
        when :warning then ["radio-warning"]
        when :info then ["radio-info"]
        when :neutral then ["radio-neutral"]
        else [] # base/neutral
        end
      end

      def html_attributes
        attrs = {
          id: "#{id}-control",
          type: "radio",
          name: @name,
          value: @value
        }
        attrs[:checked] = true if @checked
        attrs[:required] = true if @required
        attrs[:disabled] = true if @disabled
        attrs
      end
    end
  end
end
