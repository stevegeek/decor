# frozen_string_literal: true

module Decor
  module Suite
    module Forms
      # Suite Switch — toggle styled distinctly from a checkbox. A compact
      # 26x15 track with an 11x11 round knob that slides between ends. Track
      # uses suite-hairline when off, suite-{color}-500 when on. Knob is a
      # white circle with a soft drop shadow. Track-side check / X glyphs
      # reinforce the state visually.
      #
      # Wraps the inputs in a label so clicking the label/track flips the
      # control. Renders an optional helper / error caption below.
      class Switch < ::Decor::Components::Forms::Switch
        def view_template
          root_element do |el|
            div(class: container_classes) do
              if (label_top? || label_left?) && @label.present?
                label_block
              end

              div(class: row_classes) do
                control_block(el)
                if (label_right? || label_inline?) && @label.present?
                  label_block
                end
              end

              if helper_or_error_text.present?
                p(class: helper_text_classes) { plain helper_or_error_text }
              end
            end
          end
        end

        private

        def container_classes
          "decor:w-full decor:flex decor:flex-col decor:suite-field-gap"
        end

        def row_classes
          "decor:inline-flex decor:items-center decor:gap-3"
        end

        def label_block
          label(
            for: "#{id}-control",
            class: "#{label_text_classes} #{cursor_classes}".strip
          ) do
            plain label_with_required
          end
        end

        def control_block(el)
          span(class: "decor:relative decor:inline-flex decor:items-center decor:align-middle decor:select-none") do
            input(
              type: "checkbox",
              role: "switch",
              id: "#{id}-control",
              name: @name,
              value: @value,
              checked: @checked || nil,
              required: required_individual? || nil,
              disabled: @disabled || nil,
              class: input_classes_str,
              data: input_data_attributes(el, target_name: :checkbox)
            )
            track_span
            tick_glyph
            cross_glyph
          end
        end

        def input_classes_str
          [
            "decor:peer decor:absolute decor:inset-0 decor:h-full decor:w-full decor:m-0 decor:p-0",
            "decor:appearance-none decor:rounded-full",
            "decor:bg-none decor:checked:bg-none",
            "decor:cursor-pointer decor:disabled:cursor-not-allowed",
            "decor:focus:outline-hidden"
          ].join(" ")
        end

        def track_span
          span(aria_hidden: true, class: track_classes)
        end

        def track_classes
          on_bg = track_on_color_class
          [
            "decor:pointer-events-none decor:relative",
            "decor:w-[26px] decor:h-[15px]",
            "decor:rounded-full",
            "decor:bg-suite-hairline",
            errors? ? "decor:peer-checked:bg-suite-danger-500" : "decor:peer-checked:#{on_bg}",
            "decor:transition-[background-color,box-shadow] decor:duration-suite-base decor:ease-out",
            "decor:peer-disabled:opacity-50 decor:peer-disabled:cursor-not-allowed",
            track_focus_ring_class,
            # Thumb (::after)
            "decor:after:content-[''] decor:after:absolute",
            "decor:after:top-0.5 decor:after:left-0.5",
            "decor:after:w-[11px] decor:after:h-[11px]",
            "decor:after:bg-white decor:after:rounded-full",
            "decor:after:shadow-[0_1px_3px_rgba(0,0,0,0.18)]",
            "decor:after:z-10",
            "decor:after:transition-transform decor:after:duration-suite-base decor:after:ease-[cubic-bezier(.2,.85,.32,1.2)]",
            "decor:after:translate-x-0",
            "decor:peer-checked:after:translate-x-[11px]"
          ].join(" ")
        end

        def track_on_color_class
          case @color
          when :success then "bg-suite-success-500"
          when :warning then "bg-suite-warning-500"
          when :error, :danger then "bg-suite-danger-500"
          else "bg-suite-primary-500"
          end
        end

        def track_focus_ring_class
          case @color
          when :success then "decor:peer-focus-visible:shadow-[0_0_0_3px_var(--color-suite-success-100)]"
          when :warning then "decor:peer-focus-visible:shadow-[0_0_0_3px_var(--color-suite-warning-100)]"
          when :error, :danger then "decor:peer-focus-visible:shadow-[0_0_0_3px_var(--color-suite-danger-100)]"
          else "decor:peer-focus-visible:shadow-[0_0_0_3px_var(--color-suite-primary-100)]"
          end
        end

        def tick_glyph
          span(aria_hidden: true, class: tick_classes) do
            raw safe(<<~SVG)
              <svg viewBox="0 0 8 8" fill="none" stroke="currentColor" stroke-width="1.4" stroke-linecap="round" stroke-linejoin="round">
                <path d="M1.5 4.2 L3.2 6 L6.5 2.2" />
              </svg>
            SVG
          end
        end

        def tick_classes
          [
            "decor:pointer-events-none decor:absolute",
            "decor:w-[6px] decor:h-[6px]",
            "decor:left-1 decor:top-1/2 decor:-translate-y-1/2",
            "decor:text-white",
            "decor:opacity-0 decor:peer-checked:opacity-100",
            "decor:transition-opacity decor:duration-suite-fast decor:ease-out"
          ].join(" ")
        end

        def cross_glyph
          span(aria_hidden: true, class: cross_classes) do
            raw safe(<<~SVG)
              <svg viewBox="0 0 8 8" fill="none" stroke="currentColor" stroke-width="1.4" stroke-linecap="round">
                <path d="M2 2 L6 6 M6 2 L2 6" />
              </svg>
            SVG
          end
        end

        def cross_classes
          [
            "decor:pointer-events-none decor:absolute",
            "decor:w-[6px] decor:h-[6px]",
            "decor:right-1 decor:top-1/2 decor:-translate-y-1/2",
            "decor:text-suite-hairline-strong",
            "decor:opacity-100 decor:peer-checked:opacity-0",
            "decor:transition-opacity decor:duration-suite-fast decor:ease-out"
          ].join(" ")
        end

        def label_text_classes
          color =
            if errors?
              "decor:text-suite-danger-700"
            elsif disabled?
              "decor:text-gray-400"
            else
              "decor:text-gray-900"
            end
          "decor:suite-field-label #{color}"
        end

        def helper_or_error_text
          errors? ? error_text : @helper_text
        end

        def helper_text_classes
          color =
            if errors?
              "decor:text-suite-danger-700"
            else
              "decor:text-gray-500"
            end
          gap = (label_inline? || label_right?) ? "decor:ml-[38px]" : ""
          # suite-field-help owns margin-top: 2px; mx-0/mb-0 hold the other
          # axes at zero so the caption sits tight against the row.
          "decor:suite-field-help #{color} decor:mx-0 decor:mb-0 #{gap}".strip
        end
      end
    end
  end
end
