# frozen_string_literal: true

module Decor
  module Forms
    class HelperTextSection < PhlexComponent
      prop :helper_text, _Nilable(String)
      prop :error_text, _Nilable(String)

      prop :disabled, _Boolean, default: false
      prop :error_section, _Boolean, default: true
      prop :collapsing_helper_text, _Boolean, default: false

      def view_template
        root_element do |el|
          if @helper_text.present? && @error_text.blank?
            div(
              class: "validator-hint #{@disabled ? "opacity-50" : ""}",
              data: {**target_data_attributes(el, :helper_text)}
            ) do
              @helper_text
            end
          end

          if @error_section && @error_text.present?
            div(
              class: "validator-hint text-error",
              data: {**target_data_attributes(el, :error_text)}
            ) do
              @error_text
            end
          end
        end
      end

      private

      def element_classes
        @collapsing_helper_text ? "" : "mt-1"
      end
    end
  end
end
