# frozen_string_literal: true

module Decor
  module Forms
    class ButtonRadioGroup < FormField
      prop :choices, Array
      prop :selected_choice, _Nilable(String)

      # Button groups mostly don't have labels
      prop :show_label, _Boolean, default: false

      # Variant styling options
      prop :variant, _Union(:outline, :solid, :ghost, :link), default: :outline
      prop :size, _Union(:xs, :sm, :md, :lg, :xl), default: :md
      prop :color, _Union(:primary, :secondary, :accent, :neutral, :success, :warning, :info, :error), default: :primary

      stimulus do
        classes valid_label: -> { @disabled ? "text-disabled" : "text-gray-900" },
          invalid_label: "text-error-dark",
          valid_helper_text: -> { @disabled ? "text-disabled" : "text-gray-500" },
          invalid_helper_text: "text-error"
      end

      def view_template
        root_element do |el|
          layout = ::Decor::Forms::FormFieldLayout.new(
            **form_field_layout_options(el),
            stimulus_classes: {
              valid_label: @disabled ? "text-disabled" : "text-gray-900",
              invalid_label: "text-error-dark"
            },
            html_options: {
              class: "relative"
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
            div(class: "join") do
              @choices.each_with_index do |(value, label), idx|
                input(
                  data_controller: form_control_controller,
                  **input_html_attributes(idx, value),
                  data: {
                    **(control_actions? ? stimulus_action(*@control_actions) : {}),
                    **(control_targets? ? stimulus_target(*@control_targets) : {})
                  }
                )
                label(
                  class: button_classes(value),
                  **label_html_attributes(idx)
                ) do
                  label&.strip
                end
              end
            end

            render ::Decor::Forms::ErrorIconSection.new(
              error_text: error_text,
              show_floating_message: floating_error_text?,
              html_options: {
                class: "#{errors? ? "" : "hidden"} right-3"
              }
            )
          end
        end
      end

      private

      def input_html_attributes(idx, value)
        attrs = {
          id: "#{id}-input-#{idx + 1}",
          type: "radio",
          name: @name,
          value: value,
          class: "sr-only"
        }
        attrs[:checked] = true if @selected_choice == value
        attrs[:required] = nil if @required
        attrs[:disabled] = nil if @disabled
        attrs
      end

      def label_html_attributes(idx)
        attrs = {
          for: "#{id}-input-#{idx + 1}"
        }
        attrs[:disabled] = nil if @disabled
        attrs
      end

      def selected?(val)
        val == @selected_choice
      end

      def input_container_classes
        "py-1 flex " + super
      end

      def button_classes(value)
        classes = ["join-item", "btn"]
        classes << button_variant_class unless @variant == :outline
        classes << button_size_class unless @size == :md
        classes << button_color_class unless @color == :primary
        classes << "btn-active" if @selected_choice == value
        classes << "btn-disabled" if @disabled
        classes.compact.join(" ")
      end

      def button_variant_class
        case @variant
        when :solid then "btn-primary"
        when :ghost then "btn-ghost"
        when :link then "btn-link"
        else ""
        end
      end

      def button_size_class
        case @size
        when :xs then "btn-xs"
        when :sm then "btn-sm"
        when :lg then "btn-lg"
        when :xl then "btn-xl"
        else ""
        end
      end

      def button_color_class
        case @color
        when :secondary then "btn-secondary"
        when :accent then "btn-accent"
        when :neutral then "btn-neutral"
        when :success then "btn-success"
        when :warning then "btn-warning"
        when :info then "btn-info"
        when :error then "btn-error"
        else ""
        end
      end
    end
  end
end
