# frozen_string_literal: true

module Decor
  module Components
    module Nav
      # Abstract base for SideNavbarSection. Owns the prop API + stimulus block
      # plus the slot helper (with_item) and items accessor.
      # Concrete skins (Daisy, Suite) inherit and provide `view_template`
      # plus class-builder overrides for their visual language.
      class SideNavbarSection < ::Decor::PhlexComponent
        prop :title, _Nilable(String)

        stimulus do
          classes shown: "", filtered: "hidden"
          outlets item: ::Decor::Daisy::Nav::SideNavbarItem.stimulus_identifier
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
