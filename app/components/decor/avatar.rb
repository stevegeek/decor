# frozen_string_literal: true

module Decor
  class Avatar < PhlexComponent
    no_stimulus_controller

    with_cache_key :attributes

    prop :url, _Nilable(_String(&:present?))
    prop :initials, _Nilable(_String(&:present?))

    SHAPE_OPTIONS = %i[circle square].freeze
    prop :shape, _Union(:circle, :square), default: :circle

    prop :border, _Boolean, default: false

    private

    def view_template
      root_element do
        if @url
          div(class: "avatar") do
            div(class: "#{size_classes} #{shape_class} #{border_classes}") do
              image_tag @url, alt: t(".image")
            end
          end
        else
          div(class: "avatar avatar-placeholder") do
            div(class: "#{color_classes} #{size_classes} #{shape_class} #{border_classes}") do
              span(class: text_size_class.to_s) { @initials }
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
      component_size_classes(@size)
    end

    def component_size_classes(size)
      case size
      when :xs then "w-6"
      when :sm then "w-8"
      when :md then "w-10"
      when :lg then "w-16"
      when :xl then "w-24"
      else "w-10"
      end
    end

    def text_size_class
      case @size
      when :xs
        "text-xs"
      when :sm
        "text-sm"
      when :md
        "text-base"
      when :lg
        "text-xl"
      when :xl
        "text-2xl"
      else
        "text-base"
      end
    end

    def border_classes
      return "" unless @border
      return "ring-offset-base-100 ring-2 ring-offset-2" unless @color

      ring_color = case @color
      when :base then "ring-base-300"
      when :primary then "ring-primary"
      when :secondary then "ring-secondary"
      when :accent then "ring-accent"
      when :success then "ring-success"
      when :error then "ring-error"
      when :warning then "ring-warning"
      when :info then "ring-info"
      when :neutral then "ring-neutral"
      else ""
      end

      "#{ring_color} ring-offset-base-100 ring-2 ring-offset-2"
    end

    def color_classes
      component_color_classes(@color)
    end

    def component_color_classes(color)
      # Avatar implements its own color logic using style_color_classes helper
      style_color_classes(@style, color)
    end

    def component_style_classes(style)
      # Avatar styles are handled through color classes
      []
    end
  end
end
