# frozen_string_literal: true

module Decor
  module Nav
    class SecondaryNavbar < PhlexComponent
      no_stimulus_controller

      attribute :bottom_border, :boolean, default: false
      attribute :variant, Symbol, in: [:wide, :narrow], default: :narrow

      def with_left(&block)
        @left_block = block
        self
      end

      def with_center(&block)
        @center_block = block
        self
      end

      def with_right(&block)
        @right_block = block
        self
      end

      def view_template(&)
        vanish(&)
        render parent_element do
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

      def element_classes
        [
          "navbar",
          "bg-base-100",
          (@variant == :wide) ? "min-h-[68px]" : "min-h-12",
          @bottom_border ? "border-b border-base-300" : nil
        ].compact.join(" ")
      end
    end
  end
end
