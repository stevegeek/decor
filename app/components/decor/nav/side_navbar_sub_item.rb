# frozen_string_literal: true

module Decor
  module Nav
    class SideNavbarSubItem < PhlexComponent
      include Phlex::Rails::Helpers::LinkTo

      prop :title, _String(_Predicate("present", &:present?))
      prop :icon, _Nilable(String)
      prop :path, String, default: "#"
      prop :selected, _Boolean, default: false
      prop :counter, _Nilable(Integer)

      stimulus do
        classes shown: "", filtered: "hidden"
      end

      def view_template
        root_element do |el|
          render ::Decor::Link.new(
            href: @path,
            html_options: {class: "#{component_name}-link #{@selected ? "active bg-primary text-primary-content" : "text-base-content hover:bg-base-200 hover:text-primary"} group flex items-center px-2 py-2 text-sm font-medium rounded-md"}
          ) do
            if @counter.present?
              el.tag(:span, stimulus_target: :counter, class: "badge badge-primary badge-sm mr-2") { @counter }
            end
            if @icon.present?
              render(::Decor::Icon.new(
                name: @icon,
                html_options: {
                  class: "#{@selected ? "text-primary-content" : "text-base-content/70 group-hover:text-primary"} mr-3 flex-shrink-0 h-6 w-6"
                }
              ))
            end

            span(class: "#{component_name}-text") do
              el.tag(:p, stimulus_target: :title) { @title }
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
