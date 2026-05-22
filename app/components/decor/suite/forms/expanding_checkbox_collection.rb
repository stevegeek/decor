# frozen_string_literal: true

module Decor
  module Suite
    module Forms
      class ExpandingCheckboxCollection < ::Decor::Components::Forms::ExpandingCheckboxCollection
        def view_template
          root_element do |el|
            if @label.present?
              p(class: label_classes) { plain label_with_required }
            end

            div(class: list_container_classes) do
              raw safe(@checkboxes) if @checkboxes.present?
            end

            if show_toggle?
              div(class: "decor:mt-3") do
                render ::Decor::Suite::Button.new(
                  label: "Show more...",
                  style: :ghost,
                  color: :primary,
                  size: :sm,
                  html_options: {
                    type: "button",
                    data: {
                      **el.stimulus_action(:show_more),
                      **el.stimulus_target(:show_more_link)
                    }
                  }
                )
              end
            end

            render_helper_and_error_section
          end
        end

        private

        def show_toggle?
          @hide_after_showing.present? && @size.present? && @size > @hide_after_showing
        end

        def root_element_classes
          [
            "decor--suite--forms--expanding-checkbox-collection",
            "decor:relative decor:w-full decor:flex decor:flex-col decor:suite-field-gap",
            disabled? ? "decor:disabled" : nil,
            *grid_span_class
          ].compact.join(" ")
        end

        def label_classes
          [
            "decor:suite-field-label decor:m-0",
            disabled? ? "decor:text-disabled" : "decor:text-gray-900",
            errors? ? "decor:text-suite-danger-700" : nil
          ].compact.join(" ")
        end

        def list_container_classes
          "decor:flex decor:flex-col decor:gap-2"
        end

        def render_helper_and_error_section
          if @helper_text.present? && !errors?
            color = disabled? ? "decor:text-disabled" : "decor:text-gray-500"
            p(class: "decor:suite-field-help #{color}") { plain @helper_text }
          end

          if !floating_error_text? && errors?
            p(class: "decor:suite-field-help decor:text-suite-danger-500") { plain error_text }
          end
        end
      end
    end
  end
end
