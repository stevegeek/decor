# frozen_string_literal: true

module Decor
  class Badge < PhlexComponent
    no_stimulus_controller

    attribute :label, String, allow_blank: false

    attribute :style, Symbol, in: %i[warning info error standard success], default: :standard
    attribute :size, Symbol, default: :medium, in: %i[small medium large]
    attribute :variant, Symbol, default: :outlined, in: %i[outlined filled]
    attribute :dashed, :boolean, default: false

    attribute :icon, String

    # Optional avatar
    attribute :url, String, allow_blank: false, allow_nil: true
    attribute :initials, String, allow_blank: false, allow_nil: true

    private

    def root_element_attributes
      {
        element_tag: :span
      }
    end

    def element_classes
      [
        "badge",
        style_classes,
        size_classes,
        variant_classes,
        dashed_classes
      ].compact.join(" ")
    end

    def view_template(&block)
      render parent_element do
        if @icon.present?
          render(
            ::Decor::Icon.new(
              name: @icon,
              variant: :solid,
              html_options: {class: "-ml-1 mr-1.5 #{icon_size_classes}"}
            )
          )
        end
        if @url || @initials
          render(
            ::Decor::Avatar.new(
              size: avatar_size,
              initials: @initials,
              url: @url,
              html_options: {style: "left: -11px", class: "mr-1 -mt-0.5"}
            )
          )
        end
        plain(@label, &block)
      end
    end

    def size_classes
      case @size
      when :small
        "badge-sm"
      when :large
        "badge-lg"
      end
    end

    def style_classes
      case @style
      when :success
        "badge-success"
      when :error
        "badge-error"
      when :warning
        "badge-warning"
      when :info
        "badge-info"
      when :standard
        "badge-neutral"
      else
        "badge-neutral"
      end
    end

    def variant_classes
      (@variant == :outlined) ? "badge-outline" : nil
    end

    def dashed_classes
      @dashed ? "border-dashed" : nil
    end

    def icon_size_classes
      case @size
      when :small
        "h-3 w-3"
      when :medium
        "h-3.5 w-3.5"
      when :large
        "h-4.5 w-4.5"
      end
    end

    def avatar_size
      case @size
      when :small
        :nano
      when :medium
        :micro
      else
        :tiny
      end
    end
  end
end
