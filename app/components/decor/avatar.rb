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

    SIZE_OPTIONS = %i[xs sm md lg xl].freeze
    attribute :size, Symbol, in: SIZE_OPTIONS, default: :md

    COLOR_OPTIONS = %i[base primary secondary accent success error warning info neutral].freeze
    attribute :color, Symbol, in: COLOR_OPTIONS, default: :neutral

    VARIANT_OPTIONS = %i[filled outlined ghost].freeze
    attribute :variant, Symbol, in: VARIANT_OPTIONS, default: :filled

    private

    def view_template
      render parent_element do
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
      case @size
      when :xs
        "w-6"
      when :sm
        "w-8"
      when :md
        "w-10"
      when :lg
        "w-16"
      when :xl
        "w-24"
      else
        "w-10"
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
      @border ? "ring-primary ring-offset-base-100 ring-2 ring-offset-2" : ""
    end

    def color_classes
      case @color
      when :base
        case @variant
        when :filled then "bg-base text-base-content"
        when :outlined then "text-base border-2 border-base"
        when :ghost then "text-base hover:bg-base/20 hover:border-2 hover:border-base"
        end
      when :primary
        case @variant
        when :filled then "bg-primary text-primary-content"
        when :outlined then "text-primary border-2 border-primary"
        when :ghost then "text-primary hover:bg-primary/20 hover:border-2 hover:border-primary"
        end
      when :secondary
        case @variant
        when :filled then "bg-secondary text-secondary-content"
        when :outlined then "text-secondary border-2 border-secondary"
        when :ghost then "text-secondary hover:bg-secondary/20 hover:border-2 hover:border-secondary"
        end
      when :accent
        case @variant
        when :filled then "bg-accent text-accent-content"
        when :outlined then "text-accent border-2 border-accent"
        when :ghost then "text-accent hover:bg-accent/20 hover:border-2 hover:border-accent"
        end
      when :success
        case @variant
        when :filled then "bg-success text-success-content"
        when :outlined then "text-success border-2 border-success"
        when :ghost then "text-success hover:bg-success/20 hover:border-2 hover:border-success"
        end
      when :error
        case @variant
        when :filled then "bg-error text-error-content"
        when :outlined then "text-error border-2 border-error"
        when :ghost then "text-error hover:bg-error/20 hover:border-2 hover:border-error"
        end
      when :warning
        case @variant
        when :filled then "bg-warning text-warning-content"
        when :outlined then "text-warning border-2 border-warning"
        when :ghost then "text-warning hover:bg-warning/20 hover:border-2 hover:border-warning"
        end
      when :info
        case @variant
        when :filled then "bg-info text-info-content"
        when :outlined then "text-info border-2 border-info"
        when :ghost then "text-info hover:bg-info/20 hover:border-2 hover:border-info"
        end
      when :neutral
        case @variant
        when :filled then "bg-neutral text-neutral-content"
        when :outlined then "text-neutral border-2 border-neutral"
        when :ghost then "text-neutral hover:bg-neutral/20 hover:border-2 hover:border-neutral"
        end
      end
    end
  end
end
