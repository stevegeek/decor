# frozen_string_literal: true

module Decor
  module Components
    # Abstract base for PanelGroup. Owns the prop API + slot helpers + lifecycle.
    # Concrete skins (Daisy, Suite) inherit and provide `view_template`
    # plus class-builder overrides for their visual language.
    class PanelGroup < ::Decor::PhlexComponent
      no_stimulus_controller

      prop :title, String
      prop :description, _Nilable(String)

      default_size :md
      default_color :base
      default_style :filled

      def after_component_initialize
        @panel_rows = []
      end

      def with_panel_row(&block)
        return unless block_given?

        @panel_rows << block
      end

      def cta(&block)
        @cta_content = block
      end
    end
  end
end
