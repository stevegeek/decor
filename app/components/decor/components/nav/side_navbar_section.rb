# frozen_string_literal: true

module Decor
  module Components
    module Nav
      class SideNavbarSection < ::Decor::PhlexComponent
        prop :title, _Nilable(String)

        stimulus do
          classes shown: "", filtered: "hidden"
          outlets({::Decor::Daisy::Nav::SideNavbarItem => nil})
        end

        def with_item(**attributes, &block)
          @items ||= []
          item = ::Decor::Daisy::Nav::SideNavbarItem.new(**attributes)
          @items << item
          yield(item) if block_given?
          item
        end

        def items
          @items ||= []
        end
      end
    end
  end
end
