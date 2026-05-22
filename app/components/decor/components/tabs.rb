# frozen_string_literal: true

module Decor
  module Components
    class Tabs < ::Decor::PhlexComponent
      class TabInfo < ::Literal::Data
        prop :active, _Boolean, default: false, predicate: :public
        prop :disabled, _Boolean, default: false, predicate: :public

        prop :title, _Nilable(String)
        prop :href, _Nilable(String)

        prop :icon, _Nilable(String)
        prop :icon_position, _Union(:before, :after, :only), default: :before

        prop :badge_text, _Nilable(String)
        prop :badge_color, _Union(:standard, :warning, :info, :error, :success, :primary, :secondary, :accent), default: :standard
      end

      prop :links, _Nilable(_Array(TabInfo)), default: -> { [] } do |attrs|
        attrs.map { |link| link.is_a?(TabInfo) ? link : TabInfo.new(**link) }
      end

      prop :status, _Nilable(String)

      default_size :md
      default_color :base
      default_style :bordered

      redefine_styles :ghost, :bordered, :lifted, :boxed

      def tab_buttons(&block)
        @tab_buttons = block
      end

      def with_tab_buttons(&block)
        @tab_buttons = block
        self
      end

      def with_tab_content(&block)
        @tab_content = block
        self
      end

      private

      def select_on_mobile?
        @links&.size.to_i > 3
      end

      def use_slot_api?
        @tab_buttons.present? || @tab_content.present? || @links.blank?
      end
    end
  end
end
