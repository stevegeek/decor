# frozen_string_literal: true

module Decor
  module Suite
    module Forms
      # Suite FormFieldLayout — the chrome that wraps every Suite form field:
      # a label + optional description on one side, the control plus a
      # helper / error caption on the other. Supports five label_position
      # values:
      #
      #   :top    — label above control (stacked, suite-field-gap)
      #   :left   — label in a fixed 180px gutter to the left
      #   :right  — label after the control, on the same row (checkbox-style)
      #   :inline — like :left but baseline-aligned in the gutter
      #   :inside — control owns the label (e.g. floating label inside an
      #             input); layout renders no label itself in that case.
      #
      # Slots:
      #   `with_helper_text_section(...)` — registers a HelperTextSection that
      #   renders the caption row beneath the control. Visibility of helper
      #   vs error text is owned by HelperTextSection itself.
      #
      # All typography uses density-aware suite-field-label / suite-field-help
      # so flipping `<body class="density-relaxed">` recomputes sizes + gaps
      # at runtime.
      class FormFieldLayout < ::Decor::Components::Forms::FormFieldLayout
        # Slot setter used by leaf form fields:
        #   render Suite::Forms::FormFieldLayout.new(...) do |layout|
        #     layout.with_helper_text_section(helper_text: "...", error_text: "...")
        #     ...input markup...
        #   end
        # Returns self so callers can chain in ERB-style templates.
        def with_helper_text_section(**attrs)
          @helper_text_section = ::Decor::Suite::Forms::HelperTextSection.new(**attrs)
          self
        end

        def helper_text_section?
          !@helper_text_section.nil?
        end

        def view_template(&)
          captured = capture(&) if block_given?

          root_element do
            div(class: container_classes, data: container_target_data) do
              div(class: label_section_layout_classes) do
                if @label.present? && (label_left? || label_top?)
                  render_label_tag
                  render_description if @description.present?
                end
              end

              div(class: input_section_layout_classes) do
                div(class: input_container_inner_classes) do
                  raw safe(captured) if captured.present?
                  if @label.present? && (label_inline? || label_right?)
                    div(class: "decor:ml-4") do
                      render_label_tag
                      render_description if @description.present?
                    end
                  end
                end
                render @helper_text_section if @helper_text_section
              end
            end
          end
        end

        private

        # ── stimulus target plumbing ───────────────────────────────────────

        def form_field_target_data(target_name)
          return {} unless @form_field_element
          @form_field_element.stimulus_target(target_name).to_h
        end

        def container_target_data
          form_field_target_data(:container)
        end

        # ── label / description ────────────────────────────────────────────

        def render_label_tag
          label(
            for: "#{@field_id}-control",
            class: label_element_classes,
            data: form_field_target_data(:label)
          ) { plain @label }
        end

        def render_description
          p(class: description_classes) { plain @description }
        end

        def label_element_classes
          [
            "decor:block decor:suite-field-label",
            label_left? ? "decor:font-semibold" : nil,
            @disabled ? "decor:text-gray-400" : "decor:text-gray-900"
          ].compact.join(" ")
        end

        def description_classes
          [
            "decor:suite-field-help decor:text-gray-500",
            label_left? ? "decor:mb-2" : nil
          ].compact.join(" ")
        end

        # ── outer / inner container shape ──────────────────────────────────

        def root_element_classes
          (grid_span_class + ["decor:w-full"]).compact.join(" ")
        end

        def container_classes
          (layout_classes || []).compact.join(" ")
        end

        def layout_classes
          if label_left? || label_inline?
            ["decor:flex", "decor:flex-col", "decor:sm:flex-row", "decor:sm:items-baseline", "decor:sm:gap-x-4"]
          elsif label_top?
            ["decor:flex", "decor:flex-col", "decor:suite-field-gap"]
          end
        end

        def label_section_layout_classes
          if label_left?
            "decor:sm:w-[180px] decor:sm:shrink-0 decor:mt-1"
          elsif label_inline?
            "decor:sm:w-[180px] decor:sm:shrink-0"
          else
            ""
          end
        end

        def input_section_layout_classes
          parts = []
          if label_left? || label_inline?
            parts << "decor:sm:flex-1 decor:sm:min-w-0"
          end
          if label_left?
            parts << "decor:mt-1 decor:sm:mt-0"
          end
          parts.compact.join(" ")
        end

        def input_container_inner_classes
          [@input_container_classes.to_s, label_right? ? "decor:flex decor:flex-row decor:items-center" : nil].compact.reject(&:empty?).join(" ")
        end
      end
    end
  end
end
