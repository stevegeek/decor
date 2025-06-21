# frozen_string_literal: true

module Decor
  module Forms
    class HelperTextSection < PhlexComponent
      attribute :helper_text, String
      attribute :error_text, String

      attribute :disabled, :boolean, default: false
      attribute :error_section, :boolean, default: true
      attribute :collapsing_helper_text, :boolean, default: false

      def view_template
        render parent_element do |el|
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
