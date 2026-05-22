# frozen_string_literal: true

module Decor
  module Components
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

      alias_method :with_header, :card_header

      def card_title(&block)
        @card_title = block
      end
      alias_method :with_title, :card_title

      def card_footer(&block)
        @card_footer = block
      end
      alias_method :with_footer, :card_footer

      def image_position_horizontal?
        [:left, :right].include?(@image_position)
      end
    end
  end
end
