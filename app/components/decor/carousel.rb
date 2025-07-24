# frozen_string_literal: true

module Decor
  class Carousel < PhlexComponent
    prop :images, _Nilable(_Array(Hash))
    prop :slides_per_view, _Nilable(Integer)
    prop :max_height, _Nilable(Integer)

    stimulus do
      values_from_props :slides_per_view
    end

    def with_slide(&block)
      @slides ||= []
      @slides << block
    end

    def with_items(&block)
      @items = block
      self
    end

    private

    def view_template(&)
      @content = capture(&) if block_given?

      root_element do |s|
        div(class: "carousel w-full") do
          # Render items from with_items slot
          if @items.present?
            render @items
          end

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

    def root_element_classes
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
