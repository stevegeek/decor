# frozen_string_literal: true

module Decor
  module Daisy
    module Forms
      class FormFieldLayout < ::Decor::Components::Forms::FormFieldLayout
        def view_template(&)
          @content = capture(&) if block_given?

          root_element do
            div(class: container_classes, data: {**@form_field_element.stimulus_target(:container)}) do
              div(class: label_section_layout_classes) do
                if @label.present? && (label_left? || label_top?)
                  label(
                    for: "#{@field_id}-control",
                    data: {**stimulus_target(:label)},
                    class: "decor:d-label #{label_element_classes}"
                  ) do
                    span(class: "decor:d-label-text") { @label }
                  end
                  if @description.present?
                    div(class: "decor:d-label-text-alt decor:mt-1 #{"decor:mb-2" if label_left?}") do
                      @description
                    end
                  end
                end
              end

              div(class: input_section_layout_classes) do
                div(class: input_container_classes + (label_right? ? "decor:flex decor:flex-row decor:items-center" : "")) do
                  raw @content.html_safe if @content.present?
                  if label_inline? || label_right?
                    div(class: "decor:ml-4") do
                      label(
                        for: "#{@field_id}-control",
                        data: {**@form_field_element.stimulus_target(:label)},
                        class: "decor:d-label #{label_element_classes}"
                      ) do
                        span(class: "decor:d-label-text") { @label }
                      end
                      if @description.present?
                        div(class: "decor:d-label-text-alt decor:mt-1") do
                          @description
                        end
                      end
                    end
                  end
                end
                render_helper_text_section if @helper_text_section.present?
              end
            end
          end
        end

        def root_element_attributes
          {
            outlets: [
              ::Decor::Daisy::Forms::HelperTextSection,
              ::Decor::Daisy::Forms::ErrorIconSection
            ]
          }
        end

        def container_classes
          (layout_classes || []).compact.join(" ")
        end

        def layout_classes
          if label_left? || label_inline?
            ["decor:sm:pt-5", "decor:sm:grid", "decor:sm:grid-cols-9", "decor:sm:gap-4", "decor:sm:items-start"]
          end
        end

        def label_section_layout_classes
          if label_left?
            "decor:sm:col-span-3 decor:mt-1"
          elsif label_inline?
            "decor:sm:col-span-3"
          else
            ""
          end
        end

        def input_section_layout_classes
          (
            grid_span_class + (label_left? ? ["decor:mt-1", "decor:sm:mt-0"] : [])
          ).compact.join(" ")
        end

        def render_helper_text_section
          if @helper_text_section.present?
            render @helper_text_section
          end
        end

        def label_element_classes
          color = class_list_for_stimulus_classes(:valid_label)
          "#{"decor:font-medium" if label_left?} #{color}"
        end
      end
    end
  end
end
