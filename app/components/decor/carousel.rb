# frozen_string_literal: true

module Decor
  class Carousel < PhlexComponent
    attribute :images, type: Array, sub_type: Hash
    attribute :slides_per_view, Integer

    attribute :max_height, Integer

    def slide(&block)
      @slides ||= []
      @slides << block
    end

    private

    def view_template(&)
      @content = capture(&) if block_given?

      render parent_element do |s|
        div(class: "carousel w-full") do
          @slides&.each_with_index do |slide, index|
            div(class: "carousel-item w-full", id: "slide#{index + 1}") do
              render slide
            end
          end

          @images&.each_with_index do |slide, idx|
            div(class: "carousel-item w-full", id: "slide#{(@slides&.length || 0) + idx + 1}") do
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
        div(class: "flex justify-center w-full py-2 gap-2") do
          total_slides = (@slides&.length || 0) + (@images&.length || 0)
          (1..total_slides).each do |i|
            a(href: "#slide#{i}", class: "btn btn-xs") { i.to_s }
          end
        end

        render @content if @content
      end
    end

    def root_element_attributes
      {
        values: [{slides_per_view: @slides_per_view}]
      }
    end

    def element_classes
      "relative"
    end

    def image_classes
      if @max_height.nil?
        "w-full"
      else
        "w-auto mx-auto"
      end
    end
  end
end
