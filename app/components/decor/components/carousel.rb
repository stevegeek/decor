# frozen_string_literal: true

module Decor
  module Components
    # Abstract base for Carousel. Owns the prop API + stimulus block + slot helpers.
    # Concrete skins (Daisy, Suite) inherit and provide `view_template`
    # plus their visual-language overrides.
    class Carousel < ::Decor::PhlexComponent
      prop :images, _Nilable(_Array(Hash))
      prop :slides_per_view, _Nilable(Integer)
      prop :max_height, _Nilable(Integer)

      stimulus do
        values_from_props :slides_per_view
      end

      def with_slide(&block)
        @slides ||= []
        @slides << block
      end

      def with_items(&block)
        @items = block
        self
      end
    end
  end
end
