# frozen_string_literal: true

module Decor
  module Forms
    class Switch < FormField
      include ::Decor::Forms::Concerns::CheckableFormField

      prop :label_position, _Union(:top, :left, :right, :inline, :inside), default: :right

      prop :submit_on_change, _Boolean, default: false
      prop :confirm_on_submit, _Nilable(_String(&:present?))
      prop :confirm_on_submit_yes, _Nilable(_String(&:present?)), default: "Yes, continue"
      prop :confirm_on_submit_no, _Nilable(_String(&:present?)), default: "Cancel"

      stimulus do
        actions [:change, :handle_change]
        values_from_props :label,
          :submit_on_change
        values confirm_on_submit: -> { @confirm_on_submit.present? ? @confirm_on_submit : nil },
          confirm_on_submit_yes: -> { @confirm_on_submit.present? ? @confirm_on_submit_yes : nil },
          confirm_on_submit_no: -> { @confirm_on_submit.present? ? @confirm_on_submit_no : nil }
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

      def html_attributes
        attrs = {
          role: "switch",
          id: "#{id}-control",
          name: @name,
          value: @value
        }
        attrs[:checked] = true if @checked
        attrs[:required] = true if required_individual?
        attrs[:disabled] = true if @disabled
        attrs
      end

      def toggle_classes
        classes = ["toggle"]
        classes << component_size_classes(@size).join(" ")
        classes << component_color_classes(@color).join(" ")
        classes << "toggle-error" if errors?
        classes.compact.join(" ").strip
      end

      def component_size_classes(size)
        case size
        when :xs then ["toggle-xs"]
        when :sm then ["toggle-sm"]
        when :md then [] # default
        when :lg then ["toggle-lg"]
        when :xl then ["toggle-lg"] # DaisyUI doesn't have xl, use lg
        else []
        end
      end

      def component_color_classes(color)
        case color
        when :primary then ["toggle-primary"]
        when :secondary then ["toggle-secondary"]
        when :accent then ["toggle-accent"]
        when :success then ["toggle-success"]
        when :error then ["toggle-error"]
        when :warning then ["toggle-warning"]
        when :info then ["toggle-info"]
        when :neutral then [] # neutral is default
        else [] # base/neutral
        end
      end

      def confirm_on_submit?
        @confirm_on_submit.present?
      end
    end
  end
end
