# frozen_string_literal: true

module Decor
  module Daisy
    module Forms
      # Shared rendering for daisyUI text-input-shaped fields (TextField,
      # NumberField, ...). Including class must define daisyui_input_classes,
      # input_classes (label class hint), and the component_*_classes
      # overrides for its visual variant.
      module TextFieldTemplate
        private

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
              if has_any_add_on?
                label(class: input_classes) do
                  render_leading_add_on(el) if has_leading_add_on?

                  input(
                    data_hj_whitelist: true,
                    data_controller: form_control_controller,
                    class: daisyui_input_classes,
                    **html_attributes,
                    data: {
                      **el.stimulus_target(:input),
                      **(control_actions? ? el.stimulus_action(*@control_actions) : {}),
                      **(control_targets? ? el.stimulus_target(*@control_targets) : {}),
                      **(control_data_attributes || {})
                    }
                  )

                  render_trailing_add_on(el) if has_trailing_add_on?
                end
              else
                input(
                  data_hj_whitelist: true,
                  data_controller: form_control_controller,
                  class: input_classes + " " + daisyui_input_classes,
                  **html_attributes,
                  data: {
                    **el.stimulus_target(:input),
                    **(control_actions? ? el.stimulus_action(*@control_actions) : {}),
                    **(control_targets? ? el.stimulus_target(*@control_targets) : {}),
                    **(control_data_attributes || {})
                  }
                )
              end

              # CODEMOD-REVIEW: interpolated class expression — verify ternary branches inside #{} are already prefixed or prefix manually
              render ::Decor::Daisy::Forms::ErrorIconSection.new(
                error_text: error_text,
                show_floating_message: floating_error_text?,
                html_options: {
                  class: "#{errors? ? "" : "hidden"} #{number_field? ? "right-7" : "right-3"}"
                }
              )
            end
          end
        end

        # Classes for the input wrapper or input itself if no label/add-on
        def input_classes
          classes = ["decor:d-input"]
          classes << "decor:d-validator" if @required || @pattern.present? || @minimum_length.present? || @maximum_length.present?
          classes.join(" ")
        end

        # daisyUI input classes (size/color/style)
        def daisyui_input_classes
          classes = []
          classes << (@html_size ? "" : "decor:w-full")
          classes << ((@numerical && @type == :tel) ? "decor:tabular-nums" : "")
          classes << component_size_classes(@size).join(" ")
          classes << component_color_classes(@color).join(" ")
          classes << component_style_classes(@style).join(" ")
          classes.join(" ").strip
        end

        def component_size_classes(size)
          case size
          when :xs then ["decor:d-input-xs"]
          when :sm then ["decor:d-input-sm"]
          when :md then [] # default
          when :lg then ["decor:d-input-lg"]
          when :xl then ["decor:d-input-lg"] # DaisyUI doesn't have xl, use lg
          else []
          end
        end

        def component_color_classes(color)
          case color
          when :primary then ["decor:d-input-primary"]
          when :secondary then ["decor:d-input-secondary"]
          when :accent then ["decor:d-input-accent"]
          when :success then ["decor:d-input-success"]
          when :error then ["decor:d-input-error"]
          when :warning then ["decor:d-input-warning"]
          when :info then ["decor:d-input-info"]
          when :ghost then ["decor:d-input-ghost"]
          when :neutral then [] # neutral is default
          else [] # base/neutral
          end
        end

        def component_style_classes(style)
          case style
          when :filled then [] # default
          when :outlined then ["decor:d-input-bordered"]
          when :ghost then ["decor:d-input-ghost"]
          else []
          end
        end

        def render_leading_add_on(el)
          if @leading_add_on.present?
            render @leading_add_on
          elsif @leading_icon_name.present?
            render ::Decor::Daisy::Icon.new(name: @leading_icon_name, html_options: {class: "decor:h-[1em] decor:opacity-50"})
          elsif @leading_text_add_on.present?
            span(
              class: "decor:opacity-50",
              data: {**el.stimulus_target(:leading_text_add_on)}
            ) do
              @leading_text_add_on
            end
          end
        end

        def render_trailing_add_on(el)
          if @trailing_add_on.present?
            render @trailing_add_on
          elsif @trailing_icon_name.present?
            render ::Decor::Daisy::Icon.new(name: @trailing_icon_name, html_options: {class: "decor:h-[1em] decor:opacity-50"})
          elsif @trailing_text_add_on.present?
            span(
              class: "decor:opacity-50",
              data: {**el.stimulus_target(:trailing_text_add_on)}
            ) do
              @trailing_text_add_on
            end
          end
        end
      end
    end
  end
end
