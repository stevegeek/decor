# frozen_string_literal: true

module Decor
  module Daisy
    # SwitchingBox A switching box is a Box which shows content and contains a
    # form and switch rendered on the right which submits on change. Used for
    # switching things on and off outside of a form. Perfect for feature toggles,
    # settings, and preferences.
    class SwitchingBox < ::Decor::Components::SwitchingBox
      include ::Decor::Daisy::BoxTemplate
    end
  end
end
