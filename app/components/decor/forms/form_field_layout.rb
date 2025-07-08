# frozen_string_literal: true

module Decor
  module Forms
    class FormFieldLayout < FormChild
      prop :input_container_classes, _Nilable(String), default: "", reader: :private

      prop :form_field_element, _Any

      # The HTML ID of the form field.
      prop :field_id, _String(&:present?)

      # If the label is not set, no label will be rendered
      prop :label, _Nilable(String)

      # Renders under the label
      prop :description, _Nilable(String)

      # If the field is disabled
      prop :disabled, _Boolean, default: false

      def inline_label(&block)
        @inline_label = block
      end

      def helper_text_section(&block)
        @helper_text_section = block
      end

      def view_template(&)
        @content = capture(&) if block_given?

        root_element do
          div(class: container_classes, data: {**@form_field_element.stimulus_target(:container)}) do
            div(class: label_section_layout_classes) do
              if @label.present? && (label_left? || label_top?)
                label(
                  for: "#{@field_id}-control",
                  data: {**stimulus_target(:label)},
                  class: "label #{label_element_classes}"
                ) do
                  span(class: "label-text") { @label }
                end
                if @description.present?
                  div(class: "label-text-alt mt-1 #{label_left? ? "mb-2" : nil}") do
                    @description
                  end
                end
              end
            end

            div(class: input_section_layout_classes) do
              div(class: input_container_classes + (label_right? ? "flex flex-row items-center" : "")) do
                raw @content.html_safe if @content.present?
                if label_inline? || label_right?
                  div(class: "ml-4") do
                    label(
                      for: "#{@field_id}-control",
                      data: {**@form_field_element.stimulus_target(:label)},
                      class: "label #{label_element_classes}"
                    ) do
                      span(class: "label-text") { @label }
                    end
                    if @description.present?
                      div(class: "label-text-alt mt-1") do
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
            ::Decor::Forms::HelperTextSection.stimulus_identifier,
            ::Decor::Forms::ErrorIconSection.stimulus_identifier
          ]
        }
      end

      def container_classes
        produce_style_classes(layout_classes || [])
      end

      def layout_classes
        if label_left? || label_inline?
          ["sm:pt-5", "sm:grid", "sm:grid-cols-9", "sm:gap-4", "sm:items-start"]
        end
      end

      def label_section_layout_classes
        if label_left?
          "sm:col-span-3 mt-1"
        elsif label_inline?
          "sm:col-span-3"
        else
          ""
        end
      end

      def input_section_layout_classes
        produce_style_classes(
          grid_span_class + (label_left? ? ["mt-1", "sm:mt-0"] : [])
        )
      end

      def render_helper_text_section
        if @helper_text_section.present?
          render @helper_text_section
        end
      end

      def label_element_classes
        color = class_list_for_stimulus_classes(:valid_label)
        "#{label_left? ? "font-medium" : ""} #{color}"
      end
    end
  end
end
