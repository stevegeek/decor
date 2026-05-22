# frozen_string_literal: true

module Decor
  module Daisy
    module Forms
      class HelperTextSection < ::Decor::Components::Forms::HelperTextSection
        def view_template
          root_element do |el|
            if @helper_text.present? && @error_text.blank?
              div(
                class: "decor:d-validator-hint #{@disabled ? "decor:opacity-50" : ""}",
                data: {**el.stimulus_target(:helper_text)}
              ) do
                @helper_text
              end
            end

            if @error_section && @error_text.present?
              div(
                class: "decor:d-validator-hint decor:text-error",
                data: {**el.stimulus_target(:error_text)}
              ) do
                @error_text
              end
            end
          end
        end

        private

        def root_element_classes
          @collapsing_helper_text ? "" : "decor:mt-1"
        end
      end
    end
  end
end
