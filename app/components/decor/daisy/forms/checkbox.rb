# frozen_string_literal: true

module Decor
  module Daisy
    module Forms
      class Checkbox < ::Decor::Components::Forms::Checkbox
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
                html_options: {class: (label_inline? || label_right?) ? "decor:ml-8" : "decor:ml-0"},
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
          classes = ["decor:d-checkbox"]
          classes << component_size_classes(@size).join(" ")
          classes << component_color_classes(@color).join(" ")
          classes << "decor:d-checkbox-error" if errors?
          classes.compact.join(" ").strip
        end

        def component_size_classes(size)
          case size
          when :xs then ["decor:d-checkbox-xs"]
          when :sm then ["decor:d-checkbox-sm"]
          when :md then [] # default
          when :lg then ["decor:d-checkbox-lg"]
          when :xl then ["decor:d-checkbox-xl"]
          else []
          end
        end

        def component_color_classes(color)
          case color
          when :primary then ["decor:d-checkbox-primary"]
          when :secondary then ["decor:d-checkbox-secondary"]
          when :accent then ["decor:d-checkbox-accent"]
          when :success then ["decor:d-checkbox-success"]
          when :error then ["decor:d-checkbox-error"]
          when :warning then ["decor:d-checkbox-warning"]
          when :info then ["decor:d-checkbox-info"]
          when :neutral then ["decor:d-checkbox-neutral"]
          else [] # base/neutral
          end
        end
      end
    end
  end
end
