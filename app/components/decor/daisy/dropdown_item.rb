# frozen_string_literal: true

module Decor
  module Daisy
    class DropdownItem < ::Decor::Components::DropdownItem
      def view_template
        if @separator
          root_element do
            hr(class: "decor:d-menu-divider")
          end
        else
          root_element do
            a(
              href: @href,
              role: "menuitem",
              tabindex: @tabindex,
              data: @http_method ? {method: @http_method} : {}
            ) do
              if @icon_name.present?
                render ::Decor::Icon.new(name: @icon_name, html_options: {class: "decor:mr-2 decor:h-4 decor:w-4"})
              end
              plain(@text) if @text.present?
              yield if block_given? && @text.blank?
            end
          end
        end
      end

      private

      def root_element_attributes
        {
          element_tag: :li,
          html_options: {}
        }
      end

      def root_element_classes
        nil
      end
    end
  end
end
