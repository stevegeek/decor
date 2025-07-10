# frozen_string_literal: true

module Decor
  module Nav
    class SideNavbarSubItem < PhlexComponent
      include Phlex::Rails::Helpers::LinkTo

      prop :title, _String(_Predicate("present", &:present?))
      prop :icon, _Nilable(String)
      prop :path, String, default: "#"
      prop :selected, _Boolean, default: false

      stimulus do
        classes shown: "", filtered: "hidden"
      end

      def view_template
        root_element do |el|
          raw(
            link_to(
              @path,
              class: "#{component_name}-link #{@selected ? "active bg-primary text-primary-content" : "text-base-content hover:bg-base-200 hover:text-primary"} group flex items-center px-2 py-2 text-sm font-medium rounded-md"
            ) do
              content = ""
              if @icon.present?
                content += render(::Decor::Icon.new(
                  name: @icon,
                  html_options: {
                    class: "#{@selected ? "text-primary-content" : "text-base-content/70 group-hover:text-primary"} mr-3 flex-shrink-0 h-6 w-6"
                  }
                )).to_s
              end

              content += "<span class=\"#{component_name}-text\">"
              content += el.tag(:p, stimulus_target: :title) { @title }.to_s
              content += "</span>"
              content.html_safe
            end
          )
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
