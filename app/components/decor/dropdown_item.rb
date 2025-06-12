# frozen_string_literal: true

module Decor
  class DropdownItem < PhlexComponent
    no_stimulus_controller

    attribute :separator, :boolean, default: false

    attribute :text, String
    attribute :href, String, default: "#"
    attribute :http_method, Symbol, in: [:get, :post, :patch, :delete]
    attribute :tabindex, Integer, default: -1

    # Set to a blank string if you want to hide the icon. If nil the
    # icon is not rendered at all and the menu item is left aligned.
    attribute :icon_name, String

    def view_template
      if @separator
        render parent_element do
          hr(class: "menu-divider")
        end
      else
        render parent_element do
          a(
            href: @href,
            role: "menuitem",
            tabindex: @tabindex,
            data: @http_method ? {method: @http_method} : {}
          ) do
            if @icon_name.present?
              render ::Decor::Icon.new(name: @icon_name, html_options: {class: "mr-2 h-4 w-4"})
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

    def element_classes
      # DaisyUI menu handles styling automatically
      nil
    end
  end
end
