# frozen_string_literal: true

module Decor
  module Daisy
    # Page A page component that provides a structured layout with header,
    # content sections, and customizable spacing, padding, and background options.
    class Page < ::Decor::Components::Page
      def view_template
        content = capture { yield(self) } if block_given?
        root_element do
          render_hero if @hero

          if @header
            result = @header.call
            if result.is_a?(::Decor::PhlexComponent)
              render result
            else
              plain result
            end
          end

          if @tabs
            div(class: tabs_wrapper_classes) do
              render @tabs
            end
          end

          div(class: content_area_classes) do
            if @include_flash
              render ::Decor::Daisy::Flash.new(collapse_if_empty: true, flash_data:)
            end
            raw content if content
          end
        end
      end

      private

      def root_element_classes
        [
          "w-full",
          (@full_height ? "min-h-screen" : nil),
          padding_classes,
          "space-y-4",
          ((@background != :default) ? background_classes : nil)
        ].compact.join(" ")
      end

      def tabs_wrapper_classes
        case @spacing
        when :none then ""
        when :sm then "pb-2"
        when :md then "pb-4"
        when :lg then "pb-6"
        when :xl then "pb-8"
        end
      end

      def content_area_classes
        case @spacing
        when :none then "space-y-4"
        when :sm then "space-y-6"
        when :md then "space-y-8"
        when :lg then "space-y-10"
        when :xl then "space-y-12"
        end
      end

      def padding_classes
        case @padding
        when :none then ""
        when :sm then "py-4"
        when :md then "py-8"
        when :lg then "py-12"
        when :xl then "py-16"
        end
      end

      def background_classes
        case @background
        when :primary then "bg-primary/10"
        when :secondary then "bg-secondary/10"
        when :hero then "bg-base-200"
        when :neutral then "bg-neutral/10"
        end
      end

      def render_hero
        if @background != :default
          div(class: "mx-[-1.5rem] mt-[-2rem] mb-4 px-6 py-8 #{background_classes}") do
            result = capture { @hero.call }
            plain result
          end
        else
          result = capture { @hero.call }
          plain result
        end
      end
    end
  end
end
