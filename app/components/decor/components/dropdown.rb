# frozen_string_literal: true

module Decor
  module Components
    # Abstract base for Dropdown. Owns the prop API + stimulus block + slot helpers.
    # Concrete skins (Daisy, Suite) inherit and provide `view_template`
    # plus their visual-language overrides.
    class Dropdown < ::Decor::PhlexComponent
      stimulus do
        actions [:click, :toggle], ["click@window", :hide_on_click_outside]
        classes active: -> { @button_active_classes }
        values active_target: -> { "##{id}-menu-button" }, enter_timeout: 100, leave_timeout: 75
      end

      default_size :md
      default_color :base
      default_style :filled

      prop :position, _Union(:left, :right, :top, :bottom, :end, :center, :start), default: :left
      prop :trigger, _Union(:click, :hover, :focus), default: :click
      prop :force_open, _Union(:auto, :open, :closed), default: :auto

      prop :button_classes, _Array(String), default: -> { [] }
      prop :button_active_classes, _Array(String), default: -> { [] }

      def trigger_button(&block)
        @trigger_button = block
      end

      def trigger_button_content(&block)
        @trigger_button_content = block
      end

      def menu_header(&block)
        @menu_header = block
      end

      def menu_content(&block)
        @menu_content = block
      end

      # @deprecated
      def menu_item(item = nil, &block)
        @menu_items ||= []
        @menu_items << (block_given? ? block : item)
      end

      def with_menu_item(&block)
        @menu_items ||= []
        @menu_items << block
      end

      def card_content(&block)
        @card_content = block
      end

      def custom_content(&block)
        @custom_content = block
      end
    end
  end
end
