# frozen_string_literal: true

module Decor
  module Suite
    module Forms
      class HelperTextSection < ::Decor::Components::Forms::HelperTextSection
        def view_template
          root_element do |el|
            p(
              class: helper_classes,
              data: helper_text_target_data(el)
            ) do
              plain @helper_text if @helper_text.present?
            end

            if @error_section
              p(
                class: error_classes,
                data: error_text_target_data(el)
              ) do
                plain @error_text if @error_text.present?
              end
            end
          end
        end

        private

        def helper_classes
          [
            "decor:suite-field-help",
            (@helper_text.present? && @error_text.blank?) ? nil : "decor:hidden",
            @collapsing_helper_text ? nil : "decor:mt-2",
            @disabled ? "decor:text-gray-400" : "decor:text-gray-500"
          ].compact.join(" ")
        end

        def error_classes
          [
            "decor:suite-field-help decor:text-suite-danger-500",
            @error_text.present? ? nil : "decor:hidden",
            @collapsing_helper_text ? nil : "decor:mt-2"
          ].compact.join(" ")
        end

        def helper_text_target_data(el)
          el.stimulus_target(:helper_text).to_h
        end

        def error_text_target_data(el)
          el.stimulus_target(:error_text).to_h
        end

        def root_element_classes
          @collapsing_helper_text ? "decor:relative" : "decor:relative decor:mt-1"
        end
      end
    end
  end
end
