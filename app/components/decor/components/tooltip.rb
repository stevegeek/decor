# frozen_string_literal: true

module Decor
  module Components
    # Abstract base for Tooltip. Owns the prop API + defaults.
    # Concrete skins (Daisy, Suite) inherit and provide `view_template`
    # plus `component_size_classes` / `component_color_classes` /
    # `component_style_classes` / `position_class` overrides for their
    # visual language.
    class Tooltip < ::Decor::PhlexComponent
      no_stimulus_controller

      prop :position, _Nilable(_Union(:top, :bottom, :left, :right)), default: :top
      prop :tip_text, _Nilable(String)

      default_size :md
      default_color :base
      default_style :filled

      # Offset customization
      prop :offset_percent_x, Integer, default: 0
      prop :offset_percent_y, Integer, default: 0

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
