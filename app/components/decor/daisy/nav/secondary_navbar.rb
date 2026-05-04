# frozen_string_literal: true

module Decor
  module Daisy
    module Nav
      # SecondaryNavbar A lightweight horizontal bar typically rendered under
      # the primary TopNavbar. Three content slots (left/center/right) and
      # two height styles (:wide / :narrow).
      class SecondaryNavbar < ::Decor::Components::Nav::SecondaryNavbar
        def view_template(&)
          vanish(&)
          root_element do
            div(class: "flex-1 flex items-center") do
              instance_eval(&@left_block) if @left_block
            end

            if @center_block
              div(class: "flex-1 flex items-center") do
                instance_eval(&@center_block)
              end
            end

            if @right_block
              div(class: "ml-auto flex items-center") do
                instance_eval(&@right_block)
              end
            end
          end
        end

        private

        def root_element_attributes
          {
            element_tag: :header,
            html_options: {
              "aria-label" => "Secondary Navigation"
            }
          }
        end

        def root_element_classes
          [
            "navbar",
            "bg-base-100",
            *component_style_classes(@style),
            @bottom_border ? "border-b border-base-300" : nil
          ].compact.join(" ")
        end

        def component_style_classes(style)
          case style
          when :wide
            ["min-h-[68px]"]
          when :narrow
            ["min-h-12"]
          else
            []
          end
        end
      end
    end
  end
end
