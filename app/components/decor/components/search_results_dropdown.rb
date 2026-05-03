# frozen_string_literal: true

module Decor
  module Components
    # Abstract base for SearchResultsDropdown. Owns the prop API.
    # Concrete skins (Daisy, Suite) inherit and provide `view_template`
    # plus class-builder overrides for their visual language.
    class SearchResultsDropdown < ::Decor::PhlexComponent
      prop :nav_element, Vident::Component
    end
  end
end
