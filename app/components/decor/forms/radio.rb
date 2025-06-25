# frozen_string_literal: true

module Decor
  module Forms
    class Radio < FormField
      include ::Decor::Forms::Concerns::CheckableFormField

      attribute :label_position, Symbol, default: :right

      def view_template
        render parent_element do |el|
          layout = ::Decor::Forms::FormFieldLayout.new(
            **form_field_layout_options(el),
            named_classes: {
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
            label(class: "inline-flex items-center #{cursor_classes}") do
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
      end

      private

      def root_element_attributes
        {
          named_classes: {
            invalid_input: "invalid:border-error-dark"
          }
        }
      end

      def radio_classes
        classes = ["radio"]
        classes << radio_color_class if @color && @color != :primary
        classes << radio_size_class unless @size == :md
        classes << "radio-error" if errors?
        classes.compact.join(" ")
      end

      def radio_color_class
        case @color
        when :neutral then "radio-neutral"
        when :secondary then "radio-secondary"
        when :accent then "radio-accent"
        when :success then "radio-success"
        when :warning then "radio-warning"
        when :info then "radio-info"
        when :error then "radio-error"
        else ""
        end
      end

      def radio_size_class
        case @size
        when :xs then "radio-xs"
        when :sm then "radio-sm"
        when :lg then "radio-lg"
        when :xl then "radio-xl"
        else ""
        end
      end

      def html_attributes
        attrs = {
          id: "#{id}-control",
          type: "radio",
          name: @name,
          value: @value
        }
        attrs[:checked] = nil if @checked
        attrs[:required] = nil if @required
        attrs[:disabled] = nil if @disabled
        attrs
      end
    end
  end
end
