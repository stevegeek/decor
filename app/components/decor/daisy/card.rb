# frozen_string_literal: true

module Decor
  module Daisy
    class Card < ::Decor::Components::Card
      private

      def view_template(&)
        @content = capture(&) if block_given?

        root_element do
          if @image_url.present? && (@image_position == :left || @image_position == :top)
            image_element
          end

          if image_position_horizontal?
            div(class: card_content_classes) do
              render_header_and_body
            end
          else
            render_header_and_body
          end

          if @image_url.present? && (@image_position == :right || @image_position == :bottom)
            image_element
          end
        end
      end

      def root_element_classes
        classes = ["decor:d-card"]
        classes << size_classes
        classes << style_classes
        classes << "decor:flex-row" if image_position_horizontal?
        classes.compact.join(" ")
      end

      def card_content_classes
        return "" unless image_position_horizontal?

        bg_class = get_background_class_for_content
        case @image_position
        when :left
          "decor:flex decor:flex-col #{bg_class} decor:rounded-r-box decor:flex-1"
        when :right
          "decor:flex decor:flex-col #{bg_class} decor:rounded-l-box decor:flex-1"
        end
      end

      def get_background_class_for_content
        # For horizontal image cards, we need to apply the background to the content area
        case @style
        when :ghost
          ""
        when :outlined
          "decor:bg-base-100"
        else
          # Filled style
          filled_color_classes(@color)
        end
      end

      def render_header_and_body
        div(class: "decor:d-card-body") do
          if @card_header.present?
            render @card_header
          end
          if @title.present?
            span(class: "decor:d-card-title") { @title }
          end
          raw @content.html_safe if @content.present?
        end
      end

      def image_element
        div(class: image_classes, style: image_background_style)
      end

      def image_classes
        base_classes = "decor:bg-center decor:bg-cover"

        case @image_position
        when :top
          "#{base_classes} decor:rounded-t-box decor:w-full decor:h-60"
        when :bottom
          "#{base_classes} decor:rounded-b-box decor:w-full decor:h-60"
        when :left
          "#{base_classes} decor:rounded-l-box decor:w-48"
        when :right
          "#{base_classes} decor:rounded-r-box decor:w-48"
        end
      end

      def image_background_style
        "background-image: url('#{@image_url}')" if @image_url.present?
      end

      def component_size_classes(size)
        case size
        when :xs then "decor:d-card-xs"
        when :sm then "decor:d-card-sm"
        when :md then "decor:d-card-md"
        when :lg then "decor:d-card-lg"
        when :xl then "decor:d-card-xl"
        else
          ""
        end
      end

      def component_style_classes(style)
        # Override the base implementation to add card-specific shadow classes
        case style
        when :filled
          "#{filled_color_classes(@color)} decor:shadow-sm"
        when :outlined
          "#{outline_color_classes(@color)} decor:bg-base-100"
        when :ghost
          "#{ghost_color_classes(@color)} decor:shadow-none"
        else
          ""
        end
      end
    end
  end
end
