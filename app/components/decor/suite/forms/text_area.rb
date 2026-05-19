# frozen_string_literal: true

module Decor
  module Suite
    module Forms
      # Suite TextArea — multi-line text input with optional label, helper /
      # error text, and (when `maximum_length` is set) a character counter.
      #
      # Mirrors the chrome of `Decor::Suite::Forms::TextField` (suite-input-base
      # padding, suite-hairline-strong border, focus halo via suite-primary-100
      # shadow ring, suite-danger error state). Vertical resize only.
      class TextArea < ::Decor::Components::Forms::TextArea
        prop :silent_helper_and_error_text, _Boolean, default: false

        def view_template
          root_element do |el|
            div(class: outer_layout_classes, data: form_field_target_data(:container)) do
              if @label.present? && (label_top? || label_left?)
                div(class: label_section_classes) do
                  render_label
                  render_description if @description.present?
                end
              end

              div(class: input_section_classes) do
                render_input_block(el)

                if @label.present? && (label_right? || label_inline?)
                  div(class: "decor:ml-4") do
                    render_label
                    render_description if @description.present?
                  end
                end

                render_character_counter if show_character_counter?
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
            "decor--suite--forms--text-area",
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

        # ── textarea control ────────────────────────────────────────────────

        def render_input_block(el)
          div(class: input_container_classes) do
            child_element(
              :textarea,
              **html_attributes,
              data_hj_whitelist: true,
              class: textarea_classes_str,
              style: textarea_inline_style,
              data: control_data_attributes,
              stimulus_actions: @control_actions,
              stimulus_targets: ([:input] + @control_targets).uniq
            ) { plain(@value.to_s) if @value }

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

        def input_container_classes
          "decor:relative"
        end

        def textarea_classes_str
          [
            "decor:w-full decor:block decor:resize-y",
            "decor:outline-hidden decor:placeholder:text-gray-400",
            "decor:transition-[border-color,box-shadow] decor:duration-suite-fast decor:ease-out",
            "decor:suite-input-base",
            "decor:bg-white decor:text-gray-900",
            "decor:border decor:border-suite-hairline-strong decor:rounded-suite-control",
            "decor:hover:border-gray-400",
            "decor:focus:border-suite-primary-500 decor:focus:shadow-[0_0_0_3px_var(--color-suite-primary-100)]",
            "decor:disabled:bg-gray-50 decor:disabled:text-gray-400 decor:disabled:border-suite-hairline decor:disabled:cursor-not-allowed",
            textarea_state_classes,
            textarea_min_height_class,
            input_classes
          ].compact.reject { |c| c == false }.join(" ")
        end

        def textarea_state_classes
          [
            errors? ? "decor:border-suite-danger-500 decor:bg-suite-danger-50 decor:focus:shadow-[0_0_0_3px_var(--color-suite-danger-100)]" : nil,
            disabled? ? "decor:bg-gray-50 decor:text-gray-400 decor:border-suite-hairline decor:cursor-not-allowed" : nil
          ].compact.join(" ")
        end

        def textarea_min_height_class
          "decor:min-h-[84px]"
        end

        # Inline style mirrors the `style="line-height: relaxed"` reading from
        # the Confinus reference. suite-input-base owns vertical/horizontal
        # padding + font-size; we only need to relax line-height for prose.
        def textarea_inline_style
          "line-height: 1.625;"
        end

        def error_icon_wrapper_classes
          [
            "decor:absolute decor:top-2 decor:right-3 decor:flex decor:items-center decor:pointer-events-none",
            errors? ? nil : "decor:hidden"
          ].compact.join(" ")
        end

        # ── character counter ───────────────────────────────────────────────

        def show_character_counter?
          @maximum_length.present?
        end

        def render_character_counter
          div(
            class: "decor:flex decor:justify-end decor:mt-1 decor:suite-field-help decor:text-gray-500",
            data: {character_counter: true}
          ) do
            span do
              span(class: "character-count") { plain "0" }
              plain " / #{@maximum_length}"
            end
          end
        end

        # ── helper / error caption below the field ──────────────────────────
        # See TextField#render_helper_or_error_text for the dual-paragraph
        # rationale.

        def render_helper_or_error_text
          # Wrap in min-h-1lh container so the caption area reserves vertical
          # space even when both paragraphs are hidden — avoids layout shift
          # when the JS controller toggles error visibility on blur/submit.
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
            @collapsing_helper_text ? "decor:m-0" : "decor:mx-0 decor:mb-0",
            disabled? ? "decor:text-gray-400" : "decor:text-gray-500"
          ].compact.join(" ")
        end

        def error_text_classes
          [
            # Error MESSAGE uses suite-danger-500 (vibrant #d94747) to match
            # Confinus's `text-error` for the helper-text caption. The label
            # itself still uses suite-danger-700 (burgundy #9f2c2c, matching
            # Confinus's `text-error-dark`) — same dual-shade pattern.
            "decor:suite-field-help decor:text-suite-danger-500",
            @collapsing_helper_text ? "decor:m-0" : "decor:mx-0 decor:mb-0"
          ].compact.join(" ")
        end

        def form_field_target_data(target_name)
          stimulus_target(target_name).to_h
        end
      end
    end
  end
end
