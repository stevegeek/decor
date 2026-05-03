# frozen_string_literal: true

module Decor
  module Components
    # Abstract base for Card. Owns the prop API + defaults + slot helpers.
    # Concrete skins (Daisy, Suite) inherit and provide `view_template`
    # plus class-builder overrides for their visual language.
    class Card < ::Decor::PhlexComponent
      include Decor::Concerns::StyleColorClasses

      no_stimulus_controller

      prop :title, _Nilable(String)
      prop :image_url, _Nilable(String)
      prop :image_position, _Union(:top, :bottom, :left, :right), default: :top
      prop :image_alt, String, default: ""

      default_size :md
      default_color :base
      default_style :filled

      def card_header(&block)
        @card_header = block
      end

      # Alias for backward compatibility
      alias_method :with_header, :card_header

      def image_position_horizontal?
        [:left, :right].include?(@image_position)
      end
    end
  end
end
