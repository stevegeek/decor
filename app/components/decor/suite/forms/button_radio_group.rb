# frozen_string_literal: true

module Decor
  module Suite
    module Forms
      # Suite skin of the ButtonRadioGroup form field.
      #
      # Renders a single-row segmented control: a soft gray pill container
      # with one rounded "segment" per choice. The selected segment lifts
      # onto a white surface with a hairline-strong outline shadow; the
      # others sit in muted gray text. Each segment owns a visually-hidden
      # native radio input, so `has-[input:checked]:*` selectors drive the
      # selected look without JS — the same pattern as the Confinus
      # ConfinusUI::Forms::ButtonRadioGroup.
      #
      # Self-contained chrome: emits label / helper-text / error captions
      # with suite-* tokens directly. Does not depend on a separate Suite
      # FormFieldLayout (matches the Checkbox/Radio/Switch precedent so the
      # Suite form-layout primitives can evolve independently).
      class ButtonRadioGroup < ::Decor::Components::Forms::ButtonRadioGroup
        def view_template
          root_element do |el|
            if @label.present? && show_label?
              render_label
            end

            div(class: segmented_container_classes) do
              @choices.each_with_index do |(value, choice_label), idx|
                div(class: segment_classes) do
                  child_element(
                    :input,
                    **input_html_attributes(idx, value),
                    stimulus_actions: @control_actions,
                    stimulus_targets: ([:input] + @control_targets).uniq
                  )
                  label(
                    **label_html_attributes(idx),
                    class: segment_label_classes
                  ) do
                    plain choice_label.to_s.strip
                  end
                end
              end
            end

            render_helper_or_error_text unless silent_helper_and_error_text?
          end
        end

        private

        def root_element_classes
          [
            "decor--suite--forms--button-radio-group",
            "decor:relative decor:w-full",
            disabled? ? "decor:disabled" : nil,
            *grid_span_class
          ].compact.join(" ")
        end

        # ── label above the control ────────────────────────────────────────

        def render_label
          label(
            for: "#{id}-input-1",
            class: label_classes
          ) { plain label_with_required }
        end

        def label_classes
          [
            "decor:block decor:suite-field-label decor:mb-1",
            disabled? ? "decor:text-gray-400" : "decor:text-gray-900",
            errors? ? "decor:text-suite-danger-700" : nil
          ].compact.join(" ")
        end

        # ── segmented control container + segments ─────────────────────────

        # The pill that wraps every segment. 3px inner padding gives selected
        # segments room to "lift" onto a white surface without overlapping
        # the container edge.
        def segmented_container_classes
          [
            "decor:inline-flex decor:bg-gray-100 decor:p-[3px] decor:rounded-suite-control decor:gap-0.5",
            errors? ? "decor:ring-1 decor:ring-suite-danger-500" : nil
          ].compact.join(" ")
        end

        # A single segment. Uses `has-[input:checked]:*` so the visual state
        # follows the native radio without any JS. Selected → white surface +
        # hairline-strong outline halo + primary text colour.
        def segment_classes
          [
            "decor:rounded-suite-control",
            "decor:bg-transparent decor:text-gray-600",
            "decor:hover:text-gray-800",
            "decor:has-[input:checked]:bg-white",
            "decor:has-[input:checked]:text-suite-primary-500",
            "decor:has-[input:checked]:shadow-[0_1px_2px_rgba(20,24,31,0.08),0_0_0_1px_var(--color-suite-hairline-strong)]",
            "decor:transition-[background-color,color,box-shadow] decor:duration-suite-fast decor:ease-out"
          ].join(" ")
        end

        def segment_label_classes
          [
            "decor:block decor:px-[13px] decor:py-[5px]",
            "decor:suite-field-label decor:font-medium decor:leading-[1.2]",
            "decor:select-none decor:whitespace-nowrap",
            disabled? ? "decor:cursor-not-allowed decor:opacity-50" : "decor:cursor-pointer"
          ].compact.join(" ")
        end

        # ── helper / error caption ─────────────────────────────────────────

        def render_helper_or_error_text
          if @helper_text.present? && !errors?
            p(class: "decor:suite-field-help #{disabled? ? "decor:text-gray-400" : "decor:text-gray-500"}") do
              plain @helper_text
            end
          end

          if !floating_error_text? && errors?
            p(class: "decor:suite-field-help decor:text-suite-danger-700") do
              plain error_text
            end
          end
        end

        def silent_helper_and_error_text?
          @helper_text.blank? && !errors?
        end

        def show_label?
          @show_label
        end

        # Override the abstract base's builder: it sets `required`/`disabled`
        # to literal `nil`, which `child_element` drops on the floor rather
        # than emitting as boolean HTML attributes. `true` round-trips through
        # Phlex correctly.
        def input_html_attributes(idx, value)
          attrs = {
            id: "#{id}-input-#{idx + 1}",
            type: "radio",
            name: @name,
            value: value,
            class: "decor:sr-only"
          }
          attrs[:checked] = true if @selected_choice == value
          attrs[:required] = true if @required
          attrs[:disabled] = true if @disabled
          attrs
        end

        def label_html_attributes(idx)
          attrs = {for: "#{id}-input-#{idx + 1}"}
          attrs[:disabled] = true if @disabled
          attrs
        end
      end
    end
  end
end
