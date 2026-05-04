# frozen_string_literal: true

module Decor
  module Components
    # Abstract base for DropdownItem. Owns the prop API.
    # Concrete skins (Daisy, Suite) inherit and provide `view_template`
    # plus their visual-language overrides.
    class DropdownItem < ::Decor::PhlexComponent
      no_stimulus_controller

      prop :separator, _Boolean, default: false

      prop :text, _Nilable(String)
      prop :href, String, default: "#"
      prop :http_method, _Nilable(_Union(:get, :post, :patch, :delete))
      prop :tabindex, Integer, default: -1

      # Set to a blank string if you want to hide the icon. If nil the
      # icon is not rendered at all and the menu item is left aligned.
      prop :icon_name, _Nilable(String)
    end
  end
end
