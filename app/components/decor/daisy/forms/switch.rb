# frozen_string_literal: true

module Decor
  module Daisy
    module Forms
      class Switch < ::Decor::Components::Forms::Switch
        def view_template
          root_element do |el|
            layout = ::Decor::Daisy::Forms::FormFieldLayout.new(
              **form_field_layout_options(el),
              stimulus_classes: {
                valid_label: @disabled ? "text-disabled" : "text-gray-900",
                invalid_label: "text-error-dark"
              }
            )

            layout.helper_text_section do
              render ::Decor::Daisy::Forms::HelperTextSection.new(
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
      end
    end
  end
end
