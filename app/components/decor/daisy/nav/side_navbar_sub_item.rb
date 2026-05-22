# frozen_string_literal: true

module Decor
  module Daisy
    module Nav
      class SideNavbarSubItem < ::Decor::Components::Nav::SideNavbarSubItem
        def view_template
          root_element do |el|
            render ::Decor::Daisy::Link.new(
              href: @path,
              html_options: {class: "#{component_name}-link #{@selected ? "decor:active decor:bg-primary decor:text-primary-content" : "decor:text-base-content decor:hover:bg-base-200 decor:hover:text-primary"} decor:group decor:flex decor:items-center decor:px-2 decor:py-2 decor:text-sm decor:font-medium decor:rounded-md"}
            ) do
              if @counter.present?
                child_element(:span, stimulus_target: :counter, class: "decor:d-badge decor:d-badge-primary decor:d-badge-sm decor:mr-2") { @counter }
              end
              if @icon.present?
                render(::Decor::Icon.new(
                  name: @icon,
                  html_options: {
                    class: "#{@selected ? "decor:text-primary-content" : "decor:text-base-content/70 decor:group-hover:text-primary"} decor:mr-3 decor:flex-shrink-0 decor:h-6 decor:w-6"
                  }
                ))
              end

              span(class: "#{component_name}-text") do
                child_element(:p, stimulus_target: :title) { @title }
              end
            end
          end
        end

        private

        def root_element_attributes
          {
            element_tag: :li
          }
        end
      end
    end
  end
end
