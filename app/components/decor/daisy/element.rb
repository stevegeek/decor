# frozen_string_literal: true

module Decor
  module Daisy
    class Element < ::Decor::Components::Element
      def view_template
        root_element do
          yield if block_given?
        end
      end
    end
  end
end
