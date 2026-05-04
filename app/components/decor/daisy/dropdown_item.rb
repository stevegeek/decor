# frozen_string_literal: true

module Decor
  module Daisy
    class DropdownItem < ::Decor::Components::DropdownItem
      def view_template
        if @separator
          root_element do
            hr(class: "menu-divider")
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
                render ::Decor::Daisy::Icon.new(name: @icon_name, html_options: {class: "mr-2 h-4 w-4"})
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
        # DaisyUI menu handles styling automatically
        nil
      end
    end
  end
end
