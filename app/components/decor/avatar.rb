# frozen_string_literal: true

module Decor
  class Avatar < PhlexComponent
    include Decor::Concerns::StyleColorClasses

    no_stimulus_controller

    with_cache_key :attributes # FIXME: attributes is from vident but a opaque, lets change to to_h ?
    # Also consider that as a defualt key method if cache key is added to component?

    prop :url, _Nilable(_String(&:present?))
    prop :initials, _Nilable(_String(&:present?))

    prop :shape, _Union(:circle, :square), default: :circle

    prop :ring, _Boolean, default: false

    default_style :filled
    default_color :neutral

    private


    # TODO: a DSL way of definig defaults
    #
    # TODO: should size_classes be automatically included in classes given its defined on component
    # or responds to component_size_classes
    def element_classes
      classes = []
      classes << shape_class
      classes.join(" ")
    end


    def view_template
      root_element do
        if @url
          div(class: "avatar") do
            div(class: "#{size_classes} #{shape_class} #{avatar_ring_classes}") do
              image_tag @url, alt: t(".image")
            end
          end
        else
          div(class: "avatar avatar-placeholder") do
            div(class: "#{color_classes} #{style_classes} #{size_classes} #{shape_class} #{avatar_ring_classes}") do
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
      when :xs then "w-6"
      when :sm then "w-8"
      when :md then "w-10"
      when :lg then "w-16"
      when :xl then "w-24"
      else "w-10"
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
