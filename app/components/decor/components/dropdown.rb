# frozen_string_literal: true

module Decor
  module Components
    class Dropdown < ::Decor::PhlexComponent
      default_size :md
      default_color :base
      default_style :filled

      prop :position, _Union(:left, :right, :top, :bottom, :end, :center, :start), default: :left
      prop :trigger, _Union(:click, :hover, :focus), default: :click
      prop :force_open, _Union(:auto, :open, :closed), default: :auto

      prop :button_classes, _Array(String), default: -> { [] }
      prop :button_active_classes, _Array(String), default: -> { [] }
      prop :menu_classes, _Array(String), default: -> { [] }

      # Optional fixed-size override for the menu surface. When nil the skin
      # picks a default (Daisy uses size-mapped widths; Suite uses w-auto).
      prop :dropdown_size_classes, _Nilable(_Array(String))

      # Lazy-load support. When `content_href` is set the menu fetches HTML on
      # first open and swaps it in; `placeholder` is shown while the fetch is
      # in flight.
      prop :content_href, _Nilable(String)
      prop :placeholder, _Nilable(String)

      # CSS anchor-positioning name override (Suite skin). When set, the
      # consumer is responsible for placing `style: "anchor-name: <value>;"`
      # on the element that should act as the visible anchor. When unset the
      # Suite skin auto-generates one and applies it to the internal trigger.
      prop :anchor_name, _Nilable(String)

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
