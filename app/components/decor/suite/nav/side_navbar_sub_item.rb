# frozen_string_literal: true

module Decor
  module Suite
    module Nav
      class SideNavbarSubItem < ::Decor::Components::Nav::SideNavbarSubItem
        def view_template
          root_element do |el|
            a(
              href: @path,
              class: "#{component_name}-link decor:group decor:flex decor:items-center decor:gap-2 decor:px-3 decor:py-1.5 decor:my-px decor:no-underline decor:suite-description decor:font-medium decor:rounded-suite-control decor:duration-suite-fast decor:ease-out #{state_classes}"
            ) do
              if @counter.present?
                child_element(:span, stimulus_target: :counter, class: "decor:inline-flex decor:items-center decor:px-2 decor:py-0.5 decor:rounded-full decor:suite-caption decor:font-medium decor:bg-gray-100 decor:text-gray-600 decor:mr-2") { @counter.to_s }
              end
              if @icon.present?
                render(::Decor::Icon.new(
                  name: @icon,
                  html_options: {
                    class: "#{component_name}-icon #{@selected ? "decor:text-suite-primary-700" : "decor:text-gray-400 decor:group-hover:text-gray-700"} decor:shrink-0 decor:h-4 decor:w-4"
                  }
                ))
              end

              span(class: "#{component_name}-text") do
                child_element(:p, stimulus_target: :title, class: "decor:shrink-0") { @title }
              end
            end
          end
        end

        private

        def state_classes
          if @selected
            "decor:bg-suite-primary-50 decor:text-suite-primary-700 decor:font-semibold"
          else
            "decor:text-gray-600 decor:hover:bg-gray-50 decor:hover:text-gray-900"
          end
        end

        def root_element_attributes
          {
            element_tag: :li
          }
        end
      end
    end
  end
end
