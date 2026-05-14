# frozen_string_literal: true

module Decor
  module Daisy
    module Forms
      class Radio < ::Decor::Components::Forms::Radio
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
                html_options: {class: (@label_inline || @label_position == :right) ? "decor:ml-8" : "decor:ml-0"},
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
          classes = ["decor:d-radio"]
          classes << component_size_classes(@size).join(" ")
          classes << component_color_classes(@color).join(" ")
          classes << "decor:d-radio-error" if errors?
          classes.compact.join(" ").strip
        end

        def component_size_classes(size)
          case size
          when :xs then ["decor:d-radio-xs"]
          when :sm then ["decor:d-radio-sm"]
          when :md then [] # default
          when :lg then ["decor:d-radio-lg"]
          when :xl then ["decor:d-radio-xl"]
          else []
          end
        end

        def component_color_classes(color)
          case color
          when :primary then ["decor:d-radio-primary"]
          when :secondary then ["decor:d-radio-secondary"]
          when :accent then ["decor:d-radio-accent"]
          when :success then ["decor:d-radio-success"]
          when :error then ["decor:d-radio-error"]
          when :warning then ["decor:d-radio-warning"]
          when :info then ["decor:d-radio-info"]
          when :neutral then ["decor:d-radio-neutral"]
          else [] # base/neutral
          end
        end
      end
    end
  end
end
