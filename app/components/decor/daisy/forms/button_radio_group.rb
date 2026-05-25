# frozen_string_literal: true

module Decor
  module Daisy
    module Forms
      class ButtonRadioGroup < ::Decor::Components::Forms::ButtonRadioGroup
        def view_template
          root_element do |el|
            layout = ::Decor::Daisy::Forms::FormFieldLayout.new(
              **form_field_layout_options(el),
              stimulus_classes: {
                valid_label: @disabled ? "text-disabled" : "text-gray-900",
                invalid_label: "text-error-dark"
              },
              html_options: {
                class: "decor:relative"
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
              div(class: "decor:d-join") do
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

              render ::Decor::Daisy::Forms::ErrorIconSection.new(
                error_text: error_text,
                show_floating_message: floating_error_text?,
                html_options: {
                  class: "#{"hidden" unless errors?} decor:right-3"
                }
              )
            end
          end
        end

        private

        def input_container_classes
          "decor:py-1 decor:flex " + super
        end

        def button_classes(value)
          classes = ["decor:d-join-item", "decor:d-btn"]
          classes << size_classes unless @size == :md
          classes << color_classes unless @color == :primary
          classes << style_classes unless @style == :outlined
          classes << "decor:d-btn-active" if @selected_choice == value
          classes << "decor:d-btn-disabled" if @disabled
          classes.compact.join(" ")
        end

        def component_style_classes(style)
          case style
          when :filled then "decor:d-btn-primary"
          when :ghost then "decor:d-btn-ghost"
          when :link then "decor:d-btn-link"
          when :outlined then ""  # outline is default btn style
          else ""
          end
        end

        def component_size_classes(size)
          case size
          when :xs then "decor:d-btn-xs"
          when :sm then "decor:d-btn-sm"
          when :lg then "decor:d-btn-lg"
          when :xl then "decor:d-btn-xl"
          else ""  # md is default
          end
        end

        def component_color_classes(color)
          case color
          when :secondary then "decor:d-btn-secondary"
          when :accent then "decor:d-btn-accent"
          when :neutral then "decor:d-btn-neutral"
          when :success then "decor:d-btn-success"
          when :warning then "decor:d-btn-warning"
          when :info then "decor:d-btn-info"
          when :error then "decor:d-btn-error"
          when :base then ""
          else ""  # primary is default
          end
        end
      end
    end
  end
end
