# frozen_string_literal: true

module Decor
  module Daisy
    # A generic container that can wrap other components and arbitrary content.
    class Element < ::Decor::Components::Element
      def view_template
        root_element do
          yield if block_given?
        end
      end
    end
  end
end
