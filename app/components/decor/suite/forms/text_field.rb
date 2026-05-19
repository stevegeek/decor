# frozen_string_literal: true

module Decor
  module Suite
    module Forms
      # Suite TextField — input control with optional label, helper / error
      # text, and leading / trailing add-ons (text, icon, or block slot).
      #
      # Two add-on styles:
      #   :text  — add-on sits *inside* the input, absolutely positioned, the
      #            input pads itself to clear it. Icon-style.
      #   :boxed — a "shell" wraps a borderless input plus boxed leading /
      #            trailing cells. The shell owns the chrome (border, focus
      #            ring, error state). Boxed cells light up to primary-500 on
      #            focus-within (suppressed in error).
      #
      # Self-contained: emits its own label / helper-text / error chrome with
      # suite-* tokens. Does not depend on a separate FormFieldLayout skin.
      class TextField < ::Decor::Components::Forms::TextField
        prop :silent_helper_and_error_text, _Boolean, default: false

        def view_template(&block)
          # Allow callers to register a leading/trailing add-on slot inside
          # the render block, matching the Components::Forms::TextField
          # `leading_add_on { ... }` / `trailing_add_on { ... }` setters.
          capture(self, &block) if block_given?

          root_element do |el|
            div(class: outer_layout_classes, data: form_field_target_data(:container)) do
              # Label (top / left)
              if @label.present? && (label_top? || label_left?)
                div(class: label_section_classes) do
                  render_label
                  render_description if @description.present?
                end
              end

              div(class: input_section_classes) do
                render_input_block(el)

                # Label (right / inline) — sits after the control on the row.
                if @label.present? && (label_right? || label_inline?)
                  div(class: "decor:ml-4") do
                    render_label
                    render_description if @description.present?
                  end
                end

                render_helper_or_error_text unless silent_helper_and_error_text?
              end
            end
          end
        end

        private

        def silent_helper_and_error_text?
          @silent_helper_and_error_text
        end

        def root_element_classes
          [
            "decor--suite--forms--text-field",
            "decor:w-full",
            disabled? ? "decor:disabled" : nil,
            *grid_span_class
          ].compact.join(" ")
        end

        # ── outer layout: top vs side-by-side label ─────────────────────────

        def outer_layout_classes
          if label_left? || label_inline?
            "decor:flex decor:flex-col decor:sm:flex-row decor:sm:items-baseline decor:sm:gap-x-4"
          else
            "decor:flex decor:flex-col decor:suite-field-gap"
          end
        end

        def label_section_classes
          if label_left?
            "decor:sm:w-[180px] decor:sm:shrink-0 decor:mt-1"
          elsif label_inline?
            "decor:sm:w-[180px] decor:sm:shrink-0"
          else
            ""
          end
        end

        def input_section_classes
          (label_left? || label_inline?) ? "decor:sm:flex-1 decor:sm:min-w-0 decor:mt-1 decor:sm:mt-0" : ""
        end

        # ── label / description ─────────────────────────────────────────────

        def render_label
          label(
            for: "#{id}-control",
            class: label_classes,
            data: form_field_target_data(:label)
          ) { plain label_with_required }
        end

        # `data-{id}-target` payload for the FormField JS controller. The
        # `stimulus_target` helper on the root element returns a hash whose
        # keys are the controller-scoped data-target attribute names; we
        # promote them onto sibling elements so the same controller can
        # find them at validate() time.
        def form_field_target_data(target_name)
          stimulus_target(target_name).to_h
        end

        def label_classes
          [
            "decor:block decor:suite-field-label",
            label_left? ? "decor:font-semibold" : nil,
            disabled? ? "decor:text-gray-400" : "decor:text-gray-900",
            errors? ? "decor:text-suite-danger-700" : nil
          ].compact.join(" ")
        end

        def render_description
          p(class: description_classes) { plain @description }
        end

        def description_classes
          [
            "decor:suite-field-help decor:text-gray-500",
            label_left? ? "decor:mb-2" : nil
          ].compact.join(" ")
        end

        # ── input + add-ons ─────────────────────────────────────────────────

        def render_input_block(el)
          div(class: input_container_classes) do
            # Leading boxed add-on
            if has_leading_add_on? && add_on_boxed?
              div(class: boxed_addon_classes(:leading)) do
                render_addon_content(:leading, el, boxed: true)
              end
            end

            # Leading icon (absolute, non-boxed)
            if has_leading_add_on? && !add_on_boxed?
              div(class: "decor:absolute decor:inset-y-0 decor:left-0 decor:pl-2.5 decor:flex decor:items-center decor:pointer-events-none decor:z-10") do
                render_addon_content(:leading, el, boxed: false)
              end
            end

            input(
              **html_attributes,
              data_hj_whitelist: true,
              class: input_classes_str,
              style: input_inline_style,
              data: {
                **el.stimulus_target(:input),
                **(control_actions? ? el.stimulus_action(*@control_actions) : {}),
                **(control_targets? ? el.stimulus_target(*@control_targets) : {}),
                **(control_data_attributes || {})
              }
            )

            # Trailing icon (absolute, non-boxed)
            if has_trailing_add_on? && !add_on_boxed?
              div(class: "decor:absolute decor:inset-y-0 decor:right-0 decor:pr-2.5 decor:flex decor:items-center decor:pointer-events-none decor:z-10") do
                render_addon_content(:trailing, el, boxed: false)
              end
            end

            # Trailing boxed add-on
            if has_trailing_add_on? && add_on_boxed?
              div(class: boxed_addon_classes(:trailing)) do
                render_addon_content(:trailing, el, boxed: true)
              end
            end

            # Error icon (absolute, inside-right). Hidden when no errors.
            unless silent_helper_and_error_text?
              div(class: error_icon_wrapper_classes) do
                render ::Decor::Icon.new(
                  name: "exclamation-circle",
                  style: :solid,
                  html_options: {class: "decor:h-5 decor:w-5 decor:text-suite-danger-500"}
                )
              end
            end
          end
        end

        def render_addon_content(side, el, boxed:)
          slot = (side == :leading) ? @leading_add_on : @trailing_add_on
          icon_name = (side == :leading) ? @leading_icon_name : @trailing_icon_name
          text = (side == :leading) ? @leading_text_add_on : @trailing_text_add_on
          target_name = :"#{side}_text_add_on"

          if slot.present?
            if boxed
              render slot
            else
              span(class: "decor:text-gray-400") { render slot }
            end
          elsif icon_name.present?
            render ::Decor::Icon.new(
              name: icon_name,
              html_options: {class: "decor:h-4 decor:w-4 decor:text-gray-400"}
            )
          elsif text.present?
            if boxed
              span(data: {**el.stimulus_target(target_name)}) { plain text.to_s }
            else
              span(
                class: "decor:text-gray-400 decor:suite-body",
                data: {**el.stimulus_target(target_name)}
              ) { plain text.to_s }
            end
          end
        end

        # ── chrome / state classes ──────────────────────────────────────────

        def input_container_classes
          shell_owns_chrome? ? shell_chrome_classes : "decor:relative decor:flex decor:items-stretch"
        end

        def shell_chrome_classes
          # `group` marker enables boxed add-ons to light up via
          # `group-focus-within:*` when the input inside the shell is focused.
          base = "decor:group decor:relative decor:flex decor:items-stretch decor:bg-white decor:rounded-suite-control decor:border decor:transition-[border-color,box-shadow] decor:duration-suite-fast decor:ease-out "
          state =
            if disabled?
              "decor:bg-gray-50 decor:border-suite-hairline decor:cursor-not-allowed"
            elsif errors?
              "decor:border-suite-danger-500 decor:bg-suite-danger-50 decor:focus-within:border-suite-danger-500 decor:focus-within:shadow-[0_0_0_3px_var(--color-suite-danger-100)]"
            else
              "decor:border-suite-hairline-strong decor:hover:border-gray-400 decor:focus-within:border-suite-primary-500 decor:focus-within:shadow-[0_0_0_3px_var(--color-suite-primary-100)]"
            end
          base + state
        end

        # Boxed leading / trailing cell. Focus-within highlight (suite-primary)
        # is suppressed when the field is in error so the red border owns the
        # user's eye.
        def boxed_addon_classes(side)
          base = "decor:flex decor:items-center decor:px-3 decor:bg-suite-gray-25 decor:text-gray-500 decor:font-medium decor:whitespace-nowrap decor:suite-body decor:transition-[background-color,color,border-color] decor:duration-suite-base decor:ease-out "
          edges =
            if side == :leading
              "decor:border-r decor:border-suite-hairline-strong decor:rounded-l-suite-control"
            else
              "decor:border-l decor:border-suite-hairline-strong decor:rounded-r-suite-control"
            end
          highlight =
            if errors?
              ""
            else
              " decor:group-focus-within:bg-suite-primary-500 decor:group-focus-within:text-white decor:group-focus-within:border-suite-primary-500"
            end
          base + edges + highlight
        end

        def input_classes_str
          [
            (@html_size.nil? ? "decor:w-full" : nil),
            "decor:block decor:relative decor:outline-hidden decor:placeholder:text-gray-400",
            "decor:transition-[border-color,box-shadow] decor:duration-suite-fast decor:ease-out",
            "decor:suite-input-base",
            input_chrome_classes,
            input_state_classes,
            input_classes
          ].compact.reject { |c| c == false }.join(" ")
        end

        def input_chrome_classes
          if shell_owns_chrome?
            "decor:bg-transparent decor:border-0 decor:text-gray-900 decor:focus:outline-hidden decor:focus:shadow-none"
          else
            "decor:bg-white decor:border decor:border-suite-hairline-strong decor:rounded-suite-control decor:text-gray-900 " \
            "decor:hover:border-gray-400 " \
            "decor:focus:border-suite-primary-500 decor:focus:shadow-[0_0_0_3px_var(--color-suite-primary-100)] " \
            "decor:disabled:bg-gray-50 decor:disabled:text-gray-400 decor:disabled:border-suite-hairline decor:disabled:cursor-not-allowed"
          end
        end

        def input_state_classes
          [
            (errors? && !shell_owns_chrome?) ? "decor:border-suite-danger-500 decor:bg-suite-danger-50 decor:focus:shadow-[0_0_0_3px_var(--color-suite-danger-100)]" : nil,
            (disabled? && !shell_owns_chrome?) ? "decor:bg-gray-50 decor:text-gray-400 decor:border-suite-hairline decor:cursor-not-allowed" : nil,
            (disabled? && shell_owns_chrome?) ? "decor:text-gray-400 decor:cursor-not-allowed" : nil,
            label_inside? ? "decor:pt-[19px] decor:pb-[5px]" : nil,
            (!shell_owns_chrome? && add_on_boxed? && has_leading_add_on?) ? "decor:rounded-l-none" : nil,
            (!shell_owns_chrome? && add_on_boxed? && has_trailing_add_on?) ? "decor:rounded-r-none" : nil,
            shell_owns_chrome? ? "decor:flex-1 decor:min-w-0" : nil
          ].compact.join(" ")
        end

        # Inline style: per-side padding override accommodates leading/
        # trailing icons (non-boxed) which sit absolutely positioned over
        # the input. Vertical padding is owned by suite-input-base; we
        # only emit horizontal overrides when an icon needs the room.
        def input_inline_style
          parts = []
          if has_leading_add_on? && !add_on_boxed?
            parts << "padding-left: 2rem"
          end
          if has_trailing_add_on? && !add_on_boxed?
            parts << "padding-right: 2rem"
          end
          parts.empty? ? nil : (parts.join("; ") + ";")
        end

        def error_icon_wrapper_classes
          [
            "decor:absolute decor:inset-y-1 decor:flex decor:items-center decor:pointer-events-none",
            errors? ? nil : "decor:hidden",
            number_field? ? "decor:right-7" : "decor:right-3"
          ].compact.join(" ")
        end

        # ── helper / error caption below the field ──────────────────────────
        #
        # Both paragraphs are always rendered so the FormField JS controller
        # has its `helperText` / `errorText` targets in scope — the JS swaps
        # `decor:hidden` on/off based on validation state. Initial visibility
        # mirrors the server-rendered state so non-JS pageloads still show
        # the right caption.

        def render_helper_or_error_text
          # Wrap in a min-height-1lh container so the caption area reserves
          # vertical space even when both paragraphs are hidden — without
          # this the layout shifts whenever the JS controller toggles
          # error visibility (matches ConfinusUI's `min-h-lh` wrapper).
          # `collapsing_helper_text` opts out for tight stacks where
          # caller wants the area to genuinely collapse when empty.
          div(class: helper_text_section_classes) do
            p(
              class: [helper_text_classes, (errors? || @helper_text.blank?) ? "decor:hidden" : nil].compact.join(" "),
              data: form_field_target_data(:helperText)
            ) { plain @helper_text.to_s }

            p(
              class: [error_text_classes, errors? ? nil : "decor:hidden"].compact.join(" "),
              data: form_field_target_data(:errorText)
            ) { plain errors? ? error_text : "" }
          end
        end

        def helper_text_section_classes
          @collapsing_helper_text ? "decor:mt-1" : "decor:mt-1 decor:min-h-[1lh]"
        end

        def helper_text_classes
          [
            "decor:suite-field-help",
            # suite-field-help sets margin-top: 2px; collapsing variant
            # forces it back to 0 to preserve the tight-stack behavior.
            @collapsing_helper_text ? "decor:m-0" : "decor:mx-0 decor:mb-0",
            disabled? ? "decor:text-gray-400" : "decor:text-gray-500"
          ].compact.join(" ")
        end

        def error_text_classes
          [
            "decor:suite-field-help decor:text-suite-danger-500",
            @collapsing_helper_text ? "decor:m-0" : "decor:mx-0 decor:mb-0"
          ].compact.join(" ")
        end

        # ── add-on derived predicates ───────────────────────────────────────

        def shell_owns_chrome?
          add_on_boxed? && has_any_add_on?
        end

        def add_on_boxed?
          @add_on_style == :boxed
        end
      end
    end
  end
end
