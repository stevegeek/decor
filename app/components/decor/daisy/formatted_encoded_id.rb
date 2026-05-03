# frozen_string_literal: true

module Decor
  module Daisy
    class FormattedEncodedId < ::Decor::Components::FormattedEncodedId
      def view_template(&)
        # wrap the prefix in a span so we can style it separately
        root_element do
          span(class: "text-base-500 font-extralight mr-0.5") { prefix_combined } if prefix_combined
          span(class: "text-primary font-medium tracking-wide") { cleaned_encoded_id }
        end
      end

      private

      def root_element_classes
        "inline-flex items-center"
      end

      def root_element_attributes
        {
          element_tag: :p
        }
      end
    end
  end
end
