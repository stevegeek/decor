# frozen_string_literal: true

module Decor
  module Components
    # Abstract base for Tooltip. Owns the prop API + defaults.
    # Concrete skins (Daisy, Suite) inherit and provide `view_template`
    # plus `component_size_classes` / `component_color_classes` /
    # `component_style_classes` / `position_class` overrides for their
    # visual language.
    #
    # Daisy uses CSS-only positioning (data-tip attribute, 4 cardinal sides).
    # Suite uses JS-driven floating-element positioning (12 placements
    # including -start/-end variants, pixel offset, optional arrow).
    class Tooltip < ::Decor::PhlexComponent
      no_stimulus_controller

      PLACEMENTS = %i[
        top bottom left right
        top-start top-end
        bottom-start bottom-end
        left-start left-end
        right-start right-end
      ].freeze

      prop :position, _Nilable(_Union(*PLACEMENTS)), default: :top
      prop :tip_text, _Nilable(String)

      default_size :md
      default_color :base
      default_style :filled

      # Daisy: percent-based offsets used for CSS translate.
      prop :offset_percent_x, Integer, default: 0
      prop :offset_percent_y, Integer, default: 0

      # Suite: pixel offset between anchor and tooltip body, plus an arrow toggle.
      # Ignored by Daisy (which uses pure CSS positioning).
      prop :offset, _Nilable(Integer)
      prop :arrow, _Boolean, default: true, predicate: :public

      def with_tip_content(&block)
        @tip_content = block
      end

      def translate_x
        "#{@offset_percent_x}%"
      end

      def translate_y
        "#{@offset_percent_y - 190}%"
      end
    end
  end
end
