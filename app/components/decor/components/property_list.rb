# frozen_string_literal: true

module Decor
  module Components
    # Abstract base for PropertyList — a vertical-layout sibling to
    # PropertyStrip. Renders one or more sections of label/value pairs
    # (typically `Decor::*::Property` rows) inside a card surface with
    # an optional title row and CTA slot. Each section may carry an
    # optional kicker (small caption) above its rows, and sections are
    # separated by hairline dividers. Section bodies render as-is in
    # `:rows` layout or wrapped in a CSS grid in `:grid` layout.
    #
    # Concrete skins (Daisy, Suite) inherit and provide `view_template`.
    class PropertyList < ::Decor::PhlexComponent
      no_stimulus_controller

      prop :title, _Nilable(String)
      prop :layout, _Union(:rows, :grid), default: :rows
      prop :columns, _Union(2, 3, 4), default: 3

      def after_component_initialize
        @sections = []
        @cta_block = nil
      end

      # Append a section with an arbitrary content block. Callers usually
      # render `Decor::*::Property` components inside the block, but any
      # content is accepted.
      def with_section(kicker: nil, &block)
        @sections << {kicker: kicker, block: block}
        self
      end

      # Register a CTA block rendered in the title row, right-aligned.
      def with_cta(&block)
        @cta_block = block
        self
      end

      def cta? = @cta_block.present?

      def grid? = @layout == :grid
    end
  end
end
