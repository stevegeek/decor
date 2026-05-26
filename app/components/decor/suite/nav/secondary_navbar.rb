# frozen_string_literal: true

module Decor
  module Suite
    module Nav
      class SecondaryNavbar < ::Decor::Components::Nav::SecondaryNavbar
        def view_template(&)
          vanish(&)
          root_element do
            div(class: "decor:flex-1 decor:flex decor:items-center") do
              instance_eval(&@left_block) if @left_block
            end

            if @center_block
              div(class: "decor:flex-1 decor:flex decor:items-center decor:justify-center") do
                instance_eval(&@center_block)
              end
            end

            if @right_block
              div(class: "decor:ml-auto decor:flex decor:items-center") do
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
            "decor:bg-white",
            "decor:px-6",
            "decor:flex",
            "decor:items-center",
            "decor:gap-6",
            *component_style_classes(@style),
            @bottom_border ? "decor:border-b decor:border-suite-hairline" : nil
          ].compact.join(" ")
        end

        def component_style_classes(style)
          case style
          when :wide
            ["decor:min-h-[68px]"]
          when :narrow
            ["decor:min-h-12"]
          else
            []
          end
        end
      end
    end
  end
end
