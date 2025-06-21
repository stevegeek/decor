# frozen_string_literal: true

module Decor
  module Forms
    class Switch < FormField
      include ::Decor::Forms::Concerns::CheckableFormField

      attribute :label_position, Symbol, default: :right

      attribute :submit_on_change, :boolean, default: false
      attribute :confirm_on_submit, String, default: nil, allow_nil: true, allow_blank: false
      attribute :confirm_on_submit_yes, String, default: "Yes, continue", allow_nil: true, allow_blank: false
      attribute :confirm_on_submit_no, String, default: "Cancel", allow_nil: true, allow_blank: false

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
                type: "checkbox",
                data_controller: form_control_controller,
                class: toggle_classes,
                **html_attributes,
                data: input_data_attributes(el, target_name: :checkbox)
              )
            end
          end
        end
      end

      private

      def root_element_attributes
        values = [
          {label: @label}
        ]

        values << {submit_on_change: true} if @submit_on_change

        if @confirm_on_submit.present?
          values << {confirm_on_submit: @confirm_on_submit}
          values << {confirm_on_submit_yes: @confirm_on_submit_yes}
          values << {confirm_on_submit_no: @confirm_on_submit_no}
        end

        {
          actions: [[:change, :handle_change]],
          values: values
        }
      end

      def html_attributes
        attrs = {
          role: "switch",
          id: "#{id}-control",
          name: @name,
          value: @value
        }
        attrs[:checked] = nil if @checked
        attrs[:required] = nil if required_individual?
        attrs[:disabled] = nil if @disabled
        attrs
      end

      def toggle_classes
        classes = ["toggle"]
        classes << toggle_color_class if @color && @color != :primary
        classes << toggle_size_class unless @size == :md
        classes << "toggle-error" if errors?
        classes.compact.join(" ")
      end

      def toggle_color_class
        case @color
        when :secondary then "toggle-secondary"
        when :accent then "toggle-accent"
        when :success then "toggle-success"
        when :error then "toggle-error"
        when :warning then "toggle-warning"
        when :info then "toggle-info"
        else ""
        end
      end

      def toggle_size_class
        case @size
        when :xs then "toggle-xs"
        when :sm then "toggle-sm"
        when :lg then "toggle-lg"
        else ""
        end
      end

      def confirm_on_submit?
        @confirm_on_submit.present?
      end
    end
  end
end
