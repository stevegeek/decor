# frozen_string_literal: true

module Decor
  module Nav
    class SideNavbarSubItem < PhlexComponent
      include Phlex::Rails::Helpers::LinkTo

      attribute :title, String, allow_blank: false
      attribute :icon, String
      attribute :path, String, default: "#"
      attribute :selected, :boolean, default: false

      def view_template
        render parent_element do |el|
          raw(
            link_to(
              @path,
              class: "#{component_class_name}-link #{@selected ? "active bg-primary text-primary-content" : "text-base-content hover:bg-base-200 hover:text-primary"} group flex items-center px-2 py-2 text-sm font-medium rounded-md"
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

              content += "<span class=\"#{component_class_name}-text\">"
              content += el.target_tag(:p, :title) { @title }.to_s
              content += "</span>"
              content.html_safe
            end
          )
        end
      end

      private

      def root_element_attributes
        {
          element_tag: :li,
          named_classes: {
            shown: "",
            filtered: "hidden"
          }
        }
      end
    end
  end
end
