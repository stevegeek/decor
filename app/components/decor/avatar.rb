# frozen_string_literal: true

module Decor
  class Avatar < PhlexComponent
    include Decor::Concerns::StyleColorClasses

    no_stimulus_controller

    with_cache_key :to_h

    prop :url, _Nilable(_String(&:present?))
    prop :initials, _Nilable(_String(&:present?))

    prop :shape, _Union(:circle, :square), default: :circle

    prop :ring, _Boolean, default: false

    default_style :filled
    default_color :neutral
    default_size :md

    private

    def root_element_classes
      shape_class
    end

    def view_template
      root_element do
        classes = "#{color_classes} #{style_classes} #{size_classes} #{shape_class} #{avatar_ring_classes}"
        if @url
          div(class: "avatar") do
            div(class: classes) do
              image_tag @url, alt: t(".image")
            end
          end
        else
          div(class: "avatar avatar-placeholder") do
            div(class: classes) do
              span(class: text_size_class.to_s) { @initials }
            end
          end
        end

        yield if block_given?
      end
    end

    def shape_class
      (@shape == :circle) ? "rounded-full" : "rounded"
    end

    def component_size_classes(size)
      case size
      when :xs then "w-4"
      when :sm then "w-6"
      when :md then "w-8"
      when :lg then "w-16"
      when :xl then "w-24"
      else "w-10"
      end
    end

    def text_size_class(size = @size)
      text_size = super
      if text_size == "text-xs"
        "text-2xs"
      else
        text_size
      end
    end

    def avatar_ring_classes
      return "" unless @ring
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
  end
end
