# frozen_string_literal: true

# An element is simply a generic container that can be used to wrap other components.
# Useful to add custom Stimulus controllers/attributes around other components.
module Decor
  module Components
    # Abstract base for Element. Owns the prop API + defaults.
    # Concrete skins (Daisy, Suite) inherit and provide `view_template`.
    class Element < ::Decor::PhlexComponent
      no_stimulus_controller

      prop :root_element_attributes, Hash, default: -> { {} }, reader: :private
    end
  end
end
