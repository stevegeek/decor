# frozen_string_literal: true

module Decor
  class DropdownItem < PhlexComponent
    no_stimulus_controller

    prop :separator, _Boolean, default: false

    prop :text, _Nilable(String)
    prop :href, String, default: "#"
    prop :http_method, _Nilable(_Union(:get, :post, :patch, :delete))
    prop :tabindex, Integer, default: -1

    # Set to a blank string if you want to hide the icon. If nil the
    # icon is not rendered at all and the menu item is left aligned.
    prop :icon_name, _Nilable(String)

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

    def root_element_classes
      # DaisyUI menu handles styling automatically
      nil
    end
  end
end
