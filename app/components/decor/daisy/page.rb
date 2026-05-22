# frozen_string_literal: true

module Decor
  module Daisy
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
          "decor:w-full",
          (@full_height ? "decor:min-h-screen" : nil),
          padding_classes,
          "decor:space-y-4",
          ((@background != :default) ? background_classes : nil)
        ].compact.join(" ")
      end

      def tabs_wrapper_classes
        case @spacing
        when :none then ""
        when :sm then "decor:pb-2"
        when :md then "decor:pb-4"
        when :lg then "decor:pb-6"
        when :xl then "decor:pb-8"
        end
      end

      def content_area_classes
        case @spacing
        when :none then "decor:space-y-4"
        when :sm then "decor:space-y-6"
        when :md then "decor:space-y-8"
        when :lg then "decor:space-y-10"
        when :xl then "decor:space-y-12"
        end
      end

      def padding_classes
        case @padding
        when :none then ""
        when :sm then "decor:py-4"
        when :md then "decor:py-8"
        when :lg then "decor:py-12"
        when :xl then "decor:py-16"
        end
      end

      def background_classes
        case @background
        when :primary then "decor:bg-primary/10"
        when :secondary then "decor:bg-secondary/10"
        when :hero then "decor:bg-base-200"
        when :neutral then "decor:bg-neutral/10"
        end
      end

      def render_hero
        if @background != :default
          div(class: "decor:mx-[-1.5rem] decor:mt-[-2rem] decor:mb-4 decor:px-6 decor:py-8 #{background_classes}") do
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
