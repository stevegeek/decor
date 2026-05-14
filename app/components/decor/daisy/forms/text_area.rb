# frozen_string_literal: true

module Decor
  module Daisy
    module Forms
      class TextArea < ::Decor::Components::Forms::TextArea
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
                helper_text: @helper_text,
                error_text: error_text,
                disabled: @disabled,
                error_section: !floating_error_text?,
                collapsing_helper_text: @collapsing_helper_text
              )
            end

            render layout do
              textarea(
                data_hj_whitelist: true,
                data_controller: form_control_controller,
                class: textarea_classes,
                **html_attributes,
                data: input_data_attributes(el)
              ) { @value }

              render ::Decor::Daisy::Forms::ErrorIconSection.new(
                error_text: error_text,
                show_floating_message: floating_error_text?,
                html_options: {
                  class: "decor:right-3 #{errors? ? "" : "decor:hidden"}"
                }
              )
            end
          end
        end

        private

        def textarea_classes
          classes = ["decor:d-textarea", "decor:w-full"]
          classes << component_size_classes(@size).join(" ")
          classes << component_color_classes(@color).join(" ")
          classes << component_style_classes(@style).join(" ")
          classes << "decor:d-textarea-error" if errors?
          classes << input_classes if input_classes.present?
          classes.compact.join(" ").strip
        end

        def component_size_classes(size)
          case size
          when :xs then ["decor:d-textarea-xs"]
          when :sm then ["decor:d-textarea-sm"]
          when :md then [] # default
          when :lg then ["decor:d-textarea-lg"]
          when :xl then ["decor:d-textarea-lg"] # DaisyUI doesn't have xl, use lg
          else []
          end
        end

        def component_color_classes(color)
          case color
          when :primary then ["decor:d-textarea-primary"]
          when :secondary then ["decor:d-textarea-secondary"]
          when :accent then ["decor:d-textarea-accent"]
          when :success then ["decor:d-textarea-success"]
          when :error then ["decor:d-textarea-error"]
          when :warning then ["decor:d-textarea-warning"]
          when :info then ["decor:d-textarea-info"]
          when :ghost then ["decor:d-textarea-ghost"]
          when :neutral then [] # neutral is default
          else [] # base/neutral
          end
        end

        def component_style_classes(style)
          case style
          when :filled then [] # default
          when :outlined then ["decor:d-textarea-bordered"]
          when :ghost then ["decor:d-textarea-ghost"]
          else []
          end
        end
      end
    end
  end
end
