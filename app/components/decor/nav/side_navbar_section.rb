# frozen_string_literal: true

module Decor
  module Nav
    class SideNavbarSection < PhlexComponent
      prop :title, _Nilable(String)

      stimulus do
        classes shown: "", filtered: "hidden"
        outlets item: ::Decor::Nav::SideNavbarItem.stimulus_identifier
      end

      def with_item(**attributes, &block)
        @items ||= []
        item = SideNavbarItem.new(**attributes)
        @items << item
        yield(item) if block_given?
        item
      end

      def items
        @items ||= []
      end

      def view_template(&)
        vanish(&)
        root_element do |el|
          if @title.present?
            el.tag(:li, stimulus_target: :title, class: "#{component_name}-title menu-title text-base-content/70 uppercase") do
              @title
            end
          end
          items.each do |item|
            render item
          end
        end
      end

      def element_classes
        "menu menu-vertical w-full"
      end

      def root_element_attributes
        {
          element_tag: :ul
        }
      end
    end
  end
end
