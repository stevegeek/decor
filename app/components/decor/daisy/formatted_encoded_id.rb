# frozen_string_literal: true

module Decor
  module Daisy
    class FormattedEncodedId < ::Decor::Components::FormattedEncodedId
      def view_template(&)
        # wrap the prefix in a span so we can style it separately
        root_element do
          span(class: "decor:text-base-500 decor:font-extralight decor:mr-0.5") { prefix_combined } if prefix_combined
          span(class: "decor:text-primary decor:font-medium decor:tracking-wide") { cleaned_encoded_id }
        end
      end

      private

      def root_element_classes
        "decor:inline-flex decor:items-center"
      end

      def root_element_attributes
        {
          element_tag: :p
        }
      end
    end
  end
end
