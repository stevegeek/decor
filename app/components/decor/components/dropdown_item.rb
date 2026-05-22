# frozen_string_literal: true

module Decor
  module Components
    class DropdownItem < ::Decor::PhlexComponent
      no_stimulus_controller

      # When true, render a thin horizontal divider instead of an item row.
      prop :separator, _Boolean, default: false

      # When true, render as a non-interactive section label (uppercase caption).
      prop :section_label, _Boolean, default: false

      # When true, style the item using the danger color tokens.
      prop :danger, _Boolean, default: false

      prop :text, _Nilable(String)
      prop :href, String, default: "#"
      prop :http_method, _Nilable(_Union(:get, :post, :patch, :delete))
      prop :tabindex, Integer, default: -1

      # Extra data-* attributes to spread onto the rendered anchor.
      prop :data, Hash, default: -> { {} }

      # Set to a blank string if you want to hide the icon. If nil the
      # icon is not rendered at all and the menu item is left aligned.
      prop :icon_name, _Nilable(String)

      # Optional keyboard shortcut label rendered on the right edge.
      prop :shortcut, _Nilable(String)
    end
  end
end
