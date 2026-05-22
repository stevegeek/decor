# frozen_string_literal: true

module Decor
  module Daisy
    module Forms
      class Select < ::Decor::Components::Forms::Select
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
              select(
                data_controller: form_control_controller,
                class: select_classes,
                data: input_data_attributes(el, target_name: :input),
                **html_attributes
              ) do
                send(
                  (grouped? ? :grouped_options_for_select : :options_for_select),
                  all_options_array,
                  disabled: all_disabled_options,
                  selected: resolve_selected_option
                )
              end

              render ::Decor::Daisy::Forms::ErrorIconSection.new(
                error_text: error_text,
                show_floating_message: floating_error_text?,
                html_options: {
                  class: "decor:right-7 #{errors? ? "" : "hidden"}"
                }
              )
            end
          end
        end

        private

        def select_classes
          classes = ["decor:d-select", "decor:w-full"]
          classes << component_size_classes(@size).join(" ")
          classes << component_color_classes(@color).join(" ")
          classes << component_style_classes(@style).join(" ")
          classes << "decor:d-select-error" if errors?
          classes << input_classes if input_classes.present?
          classes.compact.join(" ").strip
        end

        def component_size_classes(size)
          case size
          when :xs then ["decor:d-select-xs"]
          when :sm then ["decor:d-select-sm"]
          when :md then [] # default
          when :lg then ["decor:d-select-lg"]
          when :xl then ["decor:d-select-xl"]
          else []
          end
        end

        def component_color_classes(color)
          case color
          when :primary then ["decor:d-select-primary"]
          when :secondary then ["decor:d-select-secondary"]
          when :accent then ["decor:d-select-accent"]
          when :success then ["decor:d-select-success"]
          when :error then ["decor:d-select-error"]
          when :warning then ["decor:d-select-warning"]
          when :info then ["decor:d-select-info"]
          when :ghost then ["decor:d-select-ghost"]
          when :neutral then [] # neutral is default
          else [] # base/neutral
          end
        end

        def component_style_classes(style)
          case style
          when :filled then [] # default
          when :outlined then ["decor:d-select-bordered"]
          when :ghost then ["decor:d-select-ghost"]
          else []
          end
        end
      end
    end
  end
end
