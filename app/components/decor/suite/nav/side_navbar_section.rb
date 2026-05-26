# frozen_string_literal: true

module Decor
  module Suite
    module Nav
      class SideNavbarSection < ::Decor::Components::Nav::SideNavbarSection
        def view_template(&)
          vanish(&)
          root_element do |el|
            if @title.present?
              child_element(:p, stimulus_target: :title, class: "#{component_name}-title decor:suite-caption decor:font-semibold decor:text-gray-500 decor:uppercase decor:tracking-[0.06em] decor:px-3 decor:pt-3 decor:pb-1 decor:whitespace-nowrap") do
                @title
              end
            end
            items.each do |item|
              render item
            end
          end
        end

        # Override the slot factory so the section nests Suite items (the
        # abstract base hard-codes the Daisy item class).
        def with_item(**attributes, &block)
          @items ||= []
          item = ::Decor::Suite::Nav::SideNavbarItem.new(**attributes)
          @items << item
          yield(item) if block_given?
          item
        end

        def root_element_classes
          "decor:w-full decor:py-1"
        end

        def root_element_attributes
          {
            element_tag: :ul
          }
        end
      end
    end
  end
end
