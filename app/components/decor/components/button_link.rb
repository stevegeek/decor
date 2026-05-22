# frozen_string_literal: true

module Decor
  module Components
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
