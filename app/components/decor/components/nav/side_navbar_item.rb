# frozen_string_literal: true

module Decor
  module Components
    module Nav
      class SideNavbarItem < ::Decor::PhlexComponent
        include Phlex::Rails::Helpers::LinkTo

        prop :title, _String(_Predicate("present", &:present?))
        prop :icon, _Nilable(String)
        prop :path, _Nilable(String)
        prop :counter, _Nilable(Integer)
        # Also means 'expanded' where the sub items exist
        prop :selected, _Boolean, default: false

        stimulus do
          classes shown: "shown",
            filtered: "filtered",
            arrow_up: "arrow_up",
            arrow_down: "arrow_down",
            open: "open",
            closed: "closed",
            entering: -> { sub_items.any? ? "rounded-md opacity-100 translate-y-0 sm:scale-100 ease-out duration-200 transform-gpu" : "" },
            leaving: -> { sub_items.any? ? "rounded-md opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95 ease-in duration-200 transform-gpu" : "" }
          values selected: -> { resolve_selected? }
        end

        def with_sub_item(**attributes, &block)
          @sub_items ||= []
          sub_item = ::Decor::Daisy::Nav::SideNavbarSubItem.new(**attributes)
          @sub_items << sub_item
          yield(sub_item) if block_given?
          sub_item
        end

        def sub_items
          @sub_items ||= []
        end

        def resolve_selected?
          @selected || sub_items.any? { |sub_item| sub_item.instance_variable_get(:@selected) }
        end
      end
    end
  end
end
