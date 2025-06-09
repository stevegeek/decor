# frozen_string_literal: true

module Decor
  class Link < Button
    # Link href
    attribute :href, String, allow_nil: true, allow_blank: false

    # Link target
    attribute :target, String, allow_nil: true, allow_blank: false

    private

    def root_element_attributes
      {
        element_tag: :a,
        html_options: {
          href: @disabled ? nil : @href,
          target: @target,
          "aria-disabled": @disabled ? "true" : nil,
          role: @disabled ? "link" : nil,
          tabindex: @disabled ? "-1" : nil
        }.compact
      }
    end

    def element_classes
      [
        "btn-link",
        *theme_classes,
        *size_classes,
        *modifier_classes
      ].compact.join(" ")
    end

    def theme_classes
      if @disabled
        ["text-gray-400", "cursor-not-allowed"]
      else
        case @theme
        when :primary
          ["link-primary"]
        when :secondary
          ["link-secondary"]
        when :danger
          ["link-error"]
        when :warning
          ["link-warning"]
        when :neutral
          ["link-neutral"]
        else
          ["link-primary"]
        end
      end
    end

    def size_classes
      case @size
      when :large
        ["text-lg"]
      when :small
        ["text-sm"]
      when :micro
        ["text-xs"]
      else
        ["text-base"]
      end
    end

    def variant_classes
      # Links don't use button variants, return empty array
      []
    end

    def modifier_classes
      classes = []
      classes << "no-underline" if @disabled
      classes
    end
  end
end