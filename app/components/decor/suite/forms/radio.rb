# frozen_string_literal: true

module Decor
  module Suite
    module Forms
      class Radio < ::Decor::Components::Forms::Radio
        def view_template
          root_element do |el|
            render_helper_and_error_section

            label(class: label_wrapper_classes, data: form_field_target_data(:label)) do
              # Overlaid input — opacity 0.01 + absolute + peer keeps the
              # native control hit-target large for Selenium while letting
              # peer-* selectors style the visual circle.
              child_element(
                :input,
                **html_attributes,
                class: input_overlay_classes,
                stimulus_actions: @control_actions,
                stimulus_targets: ([:input] + @control_targets).uniq
              )

              span(class: ring_classes, "aria-hidden": "true") do
                span(class: dot_classes)
              end

              if @label.present?
                span(class: label_text_classes) { plain label_with_required }
              end
            end

            if @label.present? && @description.present?
              p(class: description_classes) { plain @description }
            end
          end
        end

        private

        def root_element_classes
          [
            "decor--suite--forms--radio",
            "decor:relative decor:w-full",
            disabled? ? "decor:disabled" : nil,
            *grid_span_class
          ].compact.join(" ")
        end

        def label_wrapper_classes
          [
            "decor:relative decor:inline-flex decor:items-start decor:gap-[9px]",
            disabled? ? "decor:cursor-not-allowed decor:opacity-60" : "decor:cursor-pointer"
          ].compact.join(" ")
        end

        def input_overlay_classes
          "decor:absolute decor:inset-0 decor:w-full decor:h-full decor:opacity-[0.01] decor:cursor-pointer decor:peer"
        end

        # Variant order matters: `peer-checked:[&>span]:` (peer-checked outer,
        # child selector inner) is the form Tailwind v4 compiles correctly.
        # The reverse — `[&>span]:peer-checked:` — silently produces a broken
        # selector under v4.
        def ring_classes
          [
            "decor:pointer-events-none decor:shrink-0 decor:mt-px",
            "decor:flex decor:items-center decor:justify-center",
            "decor:w-4 decor:h-4 decor:rounded-full decor:border-[1.5px]",
            "decor:bg-white decor:border-suite-hairline-strong",
            "decor:peer-hover:border-gray-400",
            "decor:peer-checked:border-suite-primary-500",
            "decor:peer-focus-visible:shadow-[0_0_0_3px_var(--color-suite-primary-100)]",
            "decor:transition-[border-color,box-shadow] decor:duration-suite-fast decor:ease-out",
            "decor:peer-checked:[&>span]:opacity-100 decor:peer-checked:[&>span]:scale-100"
          ].join(" ")
        end

        def dot_classes
          [
            "decor:w-2 decor:h-2 decor:rounded-full decor:bg-suite-primary-500",
            "decor:opacity-0 decor:scale-0",
            "decor:transition-[opacity,transform] decor:duration-suite-fast decor:ease-out"
          ].join(" ")
        end

        def label_text_classes
          [
            "decor:suite-field-label",
            disabled? ? "decor:text-disabled" : "decor:text-gray-900",
            errors? ? "decor:text-suite-danger-700" : nil
          ].compact.join(" ")
        end

        def description_classes
          [
            "decor:suite-field-help decor:text-gray-500",
            (label_inline? || label_right?) ? "decor:ml-[25px]" : "decor:ml-0"
          ].join(" ")
        end

        # See Decor::Suite::Forms::Checkbox#render_helper_and_error_section
        # for the dual-paragraph rationale.
        def render_helper_and_error_section
          margin = (label_inline? || label_right?) ? "decor:ml-[25px]" : "decor:ml-0"
          helper_color = disabled? ? "decor:text-disabled" : "decor:text-gray-500"

          p(
            class: ["decor:suite-field-help #{helper_color} #{margin}", (errors? || @helper_text.blank?) ? "decor:hidden" : nil].compact.join(" "),
            data: form_field_target_data(:helperText)
          ) { plain @helper_text.to_s }

          p(
            class: ["decor:suite-field-help decor:text-suite-danger-500 #{margin}", (errors? && !floating_error_text?) ? nil : "decor:hidden"].compact.join(" "),
            data: form_field_target_data(:errorText)
          ) { plain((errors? && !floating_error_text?) ? error_text : "") }
        end

        def form_field_target_data(target_name)
          stimulus_target(target_name).to_h
        end
      end
    end
  end
end
