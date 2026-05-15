# frozen_string_literal: true

module Decor
  module Components
    # Abstract base for Carousel. Owns the prop API + stimulus block + slot helpers.
    # Concrete skins (Daisy, Suite) inherit and provide `view_template`
    # plus their visual-language overrides.
    #
    # `slides_per_view` accepts either an Integer (fixed count at all widths) or a
    # Hash of Tailwind breakpoint keys → counts, e.g. `{base: 1.25, sm: 2, md: 3}`.
    # Skins that integrate with a JS slider library (Suite uses Swiper) translate
    # the Hash into breakpoint config.
    class Carousel < ::Decor::PhlexComponent
      prop :images, _Nilable(_Array(Hash))
      prop :slides_per_view, _Nilable(_Any)
      prop :max_height, _Nilable(Integer)
      prop :space_between, Integer, default: 16
      prop :loop, _Boolean, default: false
      prop :autoplay_delay, _Nilable(Integer)
      prop :show_arrows, _Boolean, default: true
      prop :show_pagination, _Boolean, default: true
      # Accessible label for the carousel region. Keep it descriptive — screen
      # readers announce this alongside the "carousel" role description.
      prop :aria_label, String, default: "Image carousel"

      stimulus do
        values_from_props :space_between, :loop, :show_pagination, :show_arrows, :autoplay_delay
        # Normalise `slides_per_view` so JS always receives the same shape (an
        # Object). An Integer becomes `{base: N}`; nil becomes `{}`.
        values slides_per_view: -> { normalized_slides_per_view }
      end

      def with_slide(&block)
        @slides ||= []
        @slides << block
      end

      def with_items(&block)
        @items = block
        self
      end

      private

      def normalized_slides_per_view
        case @slides_per_view
        when Hash then @slides_per_view
        when Numeric then {base: @slides_per_view}
        else {}
        end
      end
    end
  end
end
