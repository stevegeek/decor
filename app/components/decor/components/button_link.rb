# frozen_string_literal: true

module Decor
  module Components
    # Abstract base for ButtonLink. Inherits from Components::Button (gets the
    # full prop API + slot helpers) and adds the link concern. Concrete skins
    # (Daisy, Suite) inherit and provide the visual-language overrides.
    #
    # link_element_tag is purely semantic (button vs anchor based on disabled
    # state) — no daisy classes — so it lives on the abstract base.
    class ButtonLink < ::Decor::Components::Button
      include Decor::Concerns::ActsAsLink

      no_stimulus_controller

      private

      # Renders as :button when disabled, :a otherwise (preserves the original
      # ButtonLink behavior).
      def link_element_tag
        @disabled ? :button : :a
      end
    end
  end
end
