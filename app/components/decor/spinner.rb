# frozen_string_literal: true

module Decor
  class Spinner < PhlexComponent
    no_stimulus_controller

    prop :size, _Union(:xs, :sm, :md, :lg), default: :md
    prop :color, _Nilable(_Union(:white, :black, :primary, :secondary, :accent, :neutral, :info, :success, :warning, :error))

    def view_template
      root_element
    end

    private

    def element_classes
      [
        "loading",
        "loading-spinner",
        size_class,
        color_class
      ].compact.join(" ")
    end

    def size_class
      case @size
      when :xs then "loading-xs"
      when :sm then "loading-sm"
      when :md then "loading-md"
      when :lg then "loading-lg"
      end
    end

    def color_class
      case @color
      when :white then "text-white"
      when :black then "text-black"
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
