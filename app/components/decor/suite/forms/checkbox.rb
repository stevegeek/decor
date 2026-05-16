# frozen_string_literal: true

module Decor
  module Suite
    module Forms
      # Suite skin of the Checkbox form field.
      #
      # Renders a custom 16px square with a 1.5px hairline border, an SVG tick
      # that draws on via a stroke-dashoffset transition when checked, and a
      # focus ring (3px primary-100 halo). The native <input> is overlaid on
      # the label with opacity 0.01 so point-based clicks (Selenium/Capybara)
      # land on it directly while keyboard focus and screen-reader semantics
      # remain intact.
      #
      # Self-contained: emits its own label / helper-text / error chrome
      # using suite-* tokens. Does not depend on a separate FormFieldLayout
      # skin (Suite's form-layout primitives aren't ported yet).
      class Checkbox < ::Decor::Components::Forms::Checkbox
        # Default label position for a checkbox is to the right of the box.
        prop :label_position, _Union(:left, :right, :top), default: :right

        def view_template
          root_element do |el|
            render_helper_and_error_section unless silent_helper_and_error_text?

            label(class: label_wrapper_classes) do
              # Overlaid input — opacity 0.01 + absolute + peer keeps the
              # native control hit-target large for Selenium while letting
              # peer-* selectors style the visual box.
              child_element(
                :input,
                **input_html_attributes,
                class: input_overlay_classes,
                stimulus_actions: @control_actions,
                stimulus_targets: ([:input] + @control_targets).uniq
              )

              span(class: box_classes, "aria-hidden": "true") do
                render ::Decor::Icon.new(
                  name: "check-tick",
                  sprite: :decor,
                  view_box: "0 0 12 10",
                  width: 12,
                  height: 10,
                  classes: tick_classes
                )
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
            "decor--suite--forms--checkbox",
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

        # Variant order matters: `peer-checked:[&>svg]:` (peer-checked outer,
        # child selector inner) is the form Tailwind v4 compiles correctly.
        # The reverse — `[&>svg]:peer-checked:` — silently produces a broken
        # selector under v4.
        def box_classes
          [
            "decor:pointer-events-none decor:shrink-0 decor:mt-px",
            "decor:flex decor:items-center decor:justify-center",
            "decor:w-4 decor:h-4 decor:rounded-[4px] decor:border-[1.5px]",
            "decor:bg-white decor:border-suite-hairline-strong",
            "decor:peer-hover:border-gray-400",
            "decor:peer-checked:bg-suite-primary-500 decor:peer-checked:border-suite-primary-500",
            "decor:peer-focus-visible:shadow-[0_0_0_3px_var(--color-suite-primary-100)]",
            "decor:transition-[border-color,background-color,box-shadow] decor:duration-suite-fast decor:ease-out",
            "decor:peer-checked:[&>svg]:[stroke-dashoffset:0]"
          ].join(" ")
        end

        def tick_classes
          "decor:text-white [stroke-dasharray:16] [stroke-dashoffset:16] " \
            "decor:transition-[stroke-dashoffset] decor:duration-suite-base " \
            "decor:delay-100 decor:ease-out"
        end

        def label_text_classes
          [
            "decor:suite-body",
            disabled? ? "decor:text-disabled" : "decor:text-gray-900",
            errors? ? "decor:text-suite-danger-700" : nil
          ].compact.join(" ")
        end

        def description_classes
          [
            "decor:suite-description decor:text-gray-500 decor:mt-1",
            (label_inline? || label_right?) ? "decor:ml-[25px]" : "decor:ml-0"
          ].join(" ")
        end

        # Renders helper text and/or error text below the control, mirroring
        # the Confinus checkbox's helper/error layout but using Suite tokens
        # so we don't depend on a Suite FormFieldLayout/HelperTextSection that
        # hasn't been ported yet.
        def render_helper_and_error_section
          margin = (label_inline? || label_right?) ? "decor:ml-[25px]" : "decor:ml-0"

          if @helper_text.present? && !errors?
            p(class: "decor:suite-description #{disabled? ? "decor:text-disabled" : "decor:text-gray-500"} #{margin} decor:mt-1") do
              plain @helper_text
            end
          end

          if !floating_error_text? && errors?
            p(class: "decor:suite-description decor:text-suite-danger-700 #{margin} decor:mt-1") do
              plain error_text
            end
          end
        end

        def silent_helper_and_error_text?
          @helper_text.blank? && !errors?
        end
      end
    end
  end
end
