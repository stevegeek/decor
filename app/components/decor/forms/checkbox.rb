# frozen_string_literal: true

module Decor
  module Forms
    class Checkbox < FormField
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
              html_options: {class: (label_inline? || label_right?) ? "ml-8" : "ml-0"},
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
                type: "checkbox",
                data_controller: form_control_controller,
                class: checkbox_classes,
                **input_html_attributes,
                data: input_data_attributes(el, target_name: :checkbox)
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

      def checkbox_classes
        classes = ["checkbox"]
        classes << checkbox_color_class if @color && @color != :primary
        classes << checkbox_size_class unless @size == :md
        classes << "checkbox-error" if errors?
        classes.compact.join(" ")
      end

      def checkbox_color_class
        case @color
        when :secondary then "checkbox-secondary"
        when :accent then "checkbox-accent"
        when :neutral then "checkbox-neutral"
        when :success then "checkbox-success"
        when :warning then "checkbox-warning"
        when :info then "checkbox-info"
        when :error then "checkbox-error"
        else ""
        end
      end

      def checkbox_size_class
        case @size
        when :xs then "checkbox-xs"
        when :sm then "checkbox-sm"
        when :lg then "checkbox-lg"
        when :xl then "checkbox-xl"
        else ""
        end
      end

      def input_html_attributes
        attrs = {
          id: "#{id}-control",
          type: "checkbox",
          name: @name,
          value: @value
        }
        attrs[:checked] = nil if @checked
        attrs[:required] = nil if required_individual?
        attrs[:disabled] = nil if @disabled
        attrs
      end

    end
  end
end
