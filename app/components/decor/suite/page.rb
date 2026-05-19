# frozen_string_literal: true

module Decor
  module Suite
    # Suite Page — top-level layout wrapper. Visual identity:
    # - white surface with optional muted gray-25 hero strip,
    # - suite-hairline divider between tabs and content,
    # - suite-section-pad / suite-section-gap-derived rhythm,
    # - rounded-suite-card hero on tinted backgrounds.
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
              render ::Decor::Suite::Flash.new(collapse_if_empty: true, flash_data:)
            end
            raw content if content
          end
        end
      end

      private

      def root_element_classes
        [
          "decor:w-full decor:text-gray-800",
          (@full_height ? "decor:min-h-screen" : nil),
          padding_classes,
          "decor:space-y-4",
          ((@background != :default) ? background_classes : nil)
        ].compact.join(" ")
      end

      def tabs_wrapper_classes
        base = "decor:border-b decor:border-suite-hairline"
        spacing = case @spacing
        when :none then nil
        when :sm then "decor:pb-2 decor:mb-2"
        when :md then "decor:pb-3 decor:mb-3"
        when :lg then "decor:pb-4 decor:mb-4"
        when :xl then "decor:pb-5 decor:mb-5"
        end
        [base, spacing].compact.join(" ")
      end

      def content_area_classes
        case @spacing
        when :none then "decor:space-y-4"
        when :sm then "decor:space-y-5"
        when :md then "decor:space-y-6"
        when :lg then "decor:space-y-8"
        when :xl then "decor:space-y-10"
        end
      end

      def padding_classes
        case @padding
        when :none then ""
        when :sm then "decor:py-4"
        when :md then "decor:py-6"
        when :lg then "decor:py-10"
        when :xl then "decor:py-14"
        end
      end

      def background_classes
        case @background
        when :primary then "decor:bg-suite-primary-50"
        when :secondary then "decor:bg-suite-gray-25"
        when :hero then "decor:bg-suite-gray-25"
        when :neutral then "decor:bg-suite-gray-25"
        end
      end

      def hero_classes
        base = "decor:mx-[-1.5rem] decor:mt-[-1.5rem] decor:mb-4 decor:px-6 decor:py-8 decor:border decor:border-suite-hairline decor:rounded-suite-card"
        tint = case @background
        when :primary then "decor:bg-suite-primary-50"
        when :secondary then "decor:bg-suite-gray-25"
        when :hero then "decor:bg-suite-gray-25"
        when :neutral then "decor:bg-suite-gray-25"
        else "decor:bg-suite-gray-25"
        end
        "#{base} #{tint}"
      end

      def render_hero
        if @background != :default
          div(class: hero_classes) do
            plain capture { @hero.call }
          end
        else
          plain capture { @hero.call }
        end
      end
    end
  end
end
