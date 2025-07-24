# frozen_string_literal: true

module Decor
  class Link < Button
    include Decor::Concerns::ActsAsLink

    default_style :ghost

    private

    def root_element_classes
      [
        "btn btn-link",
        *color_classes,
        *size_classes,
        *style_classes,
        *modifier_classes
      ].compact.join(" ")
    end

    def component_color_classes(color)
      return [] unless color

      case color
      when :primary
        ["link-primary"]
      when :secondary
        ["link-secondary"]
      when :error
        ["link-error"]
      when :warning
        ["link-warning"]
      when :neutral
        ["link-neutral"]
      when :success
        ["link-success"]
      when :info
        ["link-info"]
      when :accent
        ["link-accent"]
      else
        ["link-primary"]
      end
    end

    def component_size_classes(size)
      case size
      when :xs
        ["text-xs"]
      when :sm
        ["text-sm"]
      when :lg
        ["text-lg"]
      when :xl
        ["text-xl"]
      else
        ["text-base"] # Default for md
      end
    end

    def modifier_classes
      classes = []
      if @disabled
        classes << "text-gray-400"
        classes << "cursor-not-allowed"
        classes << "no-underline"
      end
      classes
    end
  end
end
