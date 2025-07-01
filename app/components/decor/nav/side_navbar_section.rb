# frozen_string_literal: true

module Decor
  module Nav
    class SideNavbarSection < PhlexComponent
      attribute :title, String

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

      def view_template
        render parent_element do |el|
          if @title.present?
            el.target_tag(:li, :title, class: "#{component_class_name}-title menu-title text-base-content/70 uppercase") do
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
          element_tag: :ul,
          named_classes: {shown: "", filtered: "hidden"},
          outlets: [::Decor::Nav::SideNavbarItem.stimulus_identifier]
        }
      end
    end
  end
end
