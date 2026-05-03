# frozen_string_literal: true

module Decor
  module Daisy
    module Nav
      # SideNavbarSection A grouping of related SideNavbarItems with an
      # optional uppercase section title. Renders as a vertical menu list.
      class SideNavbarSection < ::Decor::Components::Nav::SideNavbarSection
        def view_template(&)
          vanish(&)
          root_element do |el|
            if @title.present?
              child_element(:li, stimulus_target: :title, class: "#{component_name}-title menu-title text-base-content/70 uppercase") do
                @title
              end
            end
            items.each do |item|
              render item
            end
          end
        end

        def root_element_classes
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
end
