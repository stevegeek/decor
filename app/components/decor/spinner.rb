# frozen_string_literal: true

module Decor
  class Spinner < PhlexComponent
    no_stimulus_controller

    default_size :md
    default_color :neutral
    default_style :spinner

    redefine_styles :spinner, :dots, :ring, :ball, :bars, :infinity

    def view_template
      root_element
    end

    private

    def root_element_classes
      [
        "loading",
        style_classes,
        size_classes,
        color_classes
      ].compact.join(" ")
    end

    def component_style_classes(style)
      case style
      when :spinner then "loading-spinner"
      when :dots then "loading-dots"
      when :ring then "loading-ring"
      when :ball then "loading-ball"
      when :bars then "loading-bars"
      when :infinity then "loading-infinity"
      end
    end

    def component_size_classes(size)
      case size
      when :xs then "loading-xs"
      when :sm then "loading-sm"
      when :md then "loading-md"
      when :lg then "loading-lg"
      when :xl then "loading-xl"
      end
    end

    def component_color_classes(color)
      case color
      when :base then "text-base-content"
      when :primary then "text-primary"
      when :secondary then "text-secondary"
      when :accent then "text-accent"
      when :neutral then "text-neutral"
      when :info then "text-info"
      when :success then "text-success"
      when :warning then "text-warning"
      when :error then "text-error"
      end
    end
  end
end
