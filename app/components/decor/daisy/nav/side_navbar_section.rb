# frozen_string_literal: true

module Decor
  module Daisy
    module Nav
      class SideNavbarSection < ::Decor::Components::Nav::SideNavbarSection
        def view_template(&)
          vanish(&)
          root_element do |el|
            if @title.present?
              child_element(:li, stimulus_target: :title, class: "#{component_name}-title decor:d-menu-title decor:text-base-content/70 decor:uppercase") do
                @title
              end
            end
            items.each do |item|
              render item
            end
          end
        end

        def root_element_classes
          "decor:d-menu decor:d-menu-vertical decor:w-full"
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
