# frozen_string_literal: true

module Decor
  class Link < Button
    include Decor::Concerns::ActsAsLink

    private

    def element_classes
      [
        "btn btn-link",
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
