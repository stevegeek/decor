# frozen_string_literal: true

module Decor
  module Daisy
    class Carousel < ::Decor::Components::Carousel
      private

      def view_template(&)
        @content = capture(&) if block_given?

        root_element do |s|
          div(class: "decor:d-carousel decor:w-full") do
            # Render items from with_items slot
            if @items.present?
              render @items
            end

            @slides&.each_with_index do |slide, index|
              div(class: "decor:d-carousel-item decor:w-full", id: "slide#{index + 1}") do
                render slide
              end
            end

            @images&.each_with_index do |slide, idx|
              div(class: "decor:d-carousel-item decor:w-full", id: "slide#{(@slides&.length || 0) + idx + 1}") do
                image_tag(
                  slide[:url] || slide[:path],
                  alt: "#{slide[:alt]} image #{idx}",
                  class: image_classes,
                  style: @max_height.nil? ? "" : "max-height: #{@max_height}px;"
                )
              end
            end
          end

          # Navigation controls
          div(class: "decor:flex decor:justify-center decor:w-full decor:py-2 decor:gap-2") do
            total_slides = (@slides&.length || 0) + (@images&.length || 0)
            (1..total_slides).each do |i|
              a(href: "#slide#{i}", class: "decor:d-btn decor:d-btn-xs") { i.to_s }
            end
          end

          render @content if @content
        end
      end

      def root_element_classes
        "decor:relative"
      end

      def image_classes
        if @max_height.nil?
          "decor:w-full"
        else
          "decor:w-auto decor:mx-auto"
        end
      end
    end
  end
end
