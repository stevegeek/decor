# frozen_string_literal: true

module Decor
  module Components
    # Abstract base for Toggle. Owns the prop API + defaults.
    # Concrete skins inherit and provide `view_template`.
    class Toggle < ::Decor::PhlexComponent
      no_stimulus_controller

      prop :switch_options, Hash, default: -> { {} }
      prop :checked_value, String, default: "true"
      prop :unchecked_value, String, default: "false"

      # The property to toggle - or use the content block to create the toggle
      prop :property_name, _Nilable(_Interface(:to_s))
      prop :model, _Nilable(Object)
      prop :url, _Nilable(_Interface(:to_s))
      prop :http_method, Symbol, default: :patch
    end
  end
end
