# frozen_string_literal: true

module Decor
  module Daisy
    class Property < ::Decor::Components::Property
      def view_template(&block)
        @content = capture(&block) if block_given?

        root_element do
          case @layout
          when :stack
            render_stack
          when :row
            render_row
          end
        end
      end

      private

      def render_stack
        div(class: "decor:flex decor:flex-col decor:gap-1") do
          if @icon
            div(class: "decor:flex decor:items-center decor:gap-1.5") do
              render ::Decor::Icon.new(name: @icon, classes: "decor:h-3.5 decor:w-3.5 decor:text-base-content/60")
              span(class: "decor:text-xs decor:text-base-content/60") { @label }
            end
          else
            span(class: "decor:text-xs decor:text-base-content/60") { @label }
          end

          if @content || @value
            span(class: "decor:text-sm decor:font-medium decor:tabular-nums decor:text-base-content") do
              render_value
            end
          end

          if @meta
            span(class: "decor:text-xs decor:text-base-content/60") { @meta }
          end
        end
      end

      def render_row
        div(class: "decor:grid decor:grid-cols-[10rem_1fr] decor:gap-4 decor:py-2 decor:items-baseline") do
          span(class: "decor:text-sm decor:text-base-content/60") { @label }
          if @content || @value || @meta
            span(class: "decor:text-sm decor:font-medium decor:tabular-nums decor:text-base-content") do
              render_value
              span(class: "decor:text-xs decor:text-base-content/60 decor:block decor:mt-1") { @meta } if @meta
            end
          end
        end
      end

      def render_value
        if @content
          raw safe(@content)
        elsif @value
          plain @value.to_s
        end
      end
    end
  end
end
