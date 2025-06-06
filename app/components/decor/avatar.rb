# frozen_string_literal: true

module Decor
  class Avatar < PhlexComponent
    no_stimulus_controller

    with_cache_key :attributes

    attribute :url, String, allow_nil: true, allow_blank: false
    attribute :initials, String, allow_blank: false, allow_nil: true

    SHAPE_OPTIONS = %i[circle square].freeze
    attribute :shape, Symbol, in: SHAPE_OPTIONS, default: :circle

    attribute :border, :boolean, default: false

    SIZE_OPTIONS = %i[tiny small normal medium large x_large xx_large].freeze
    attribute :size, Symbol, in: SIZE_OPTIONS, default: :normal

    private

    def view_template(&block)
      render parent_element do
        div(class: "avatar") do
          div(class: "#{size_classes} #{shape_class} #{border_classes}") do
            if @url
              image_tag @url, alt: t(".image")
            else
              div(class: "avatar-placeholder") do
                div(class: "bg-neutral text-neutral-content #{size_classes} #{shape_class}") do
                  span(class: "#{text_size_class}") { @initials }
                end
              end
            end
          end
        end
        
        yield if block_given?
      end
    end

    def element_classes
      size_classes
    end

    def shape_class
      (@shape == :circle) ? "rounded-full" : "rounded"
    end

    def size_classes
      case @size
      when :tiny
        "w-6"
      when :small
        "w-8"
      when :medium
        "w-12"
      when :large
        "w-16"
      when :x_large
        "w-24"
      when :xx_large
        "w-32"
      else
        "w-10"
      end
    end

    def text_size_class
      case @size
      when :tiny
        "text-xs"
      when :small
        "text-sm"
      when :medium
        "text-lg"
      when :large
        "text-xl"
      when :x_large
        "text-2xl"
      when :xx_large
        "text-3xl"
      else
        "text-base"
      end
    end

    def border_classes
      @border ? "ring-primary ring-offset-base-100 ring-2 ring-offset-2" : ""
    end
  end
end
