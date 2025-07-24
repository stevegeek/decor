# frozen_string_literal: true

module Decor
  # A standard 'tooltip' or popover component
  class Tooltip < PhlexComponent
    no_stimulus_controller

    prop :position, _Nilable(_Union(:top, :bottom, :left, :right)), default: :top
    prop :tip_text, _Nilable(String)

    default_size :md
    default_color :base
    default_style :filled

    # Offset customization
    prop :offset_percent_x, Integer, default: 0
    prop :offset_percent_y, Integer, default: 0

    def with_tip_content(&block)
      @tip_content = block
    end

    def translate_x
      "#{@offset_percent_x}%"
    end

    def translate_y
      "#{@offset_percent_y - 190}%"
    end

    def view_template(&)
      @content = capture(&).html_safe if block_given?

      root_element(
        data: {
          tip: rendered_tip_content # This is set after the capture
        }
      ) do
        raw @content if @content.present?
      end
    end

    private

    def root_element_classes
      classes = ["tooltip"]
      classes << position_class
      classes << size_classes
      classes << color_classes
      classes << style_classes
      classes.compact.join(" ")
    end

    def position_class
      case @position
      when :top, nil then "tooltip-top"
      when :bottom then "tooltip-bottom"
      when :left then "tooltip-left"
      when :right then "tooltip-right"
      else "tooltip-top"
      end
    end

    def component_size_classes(size)
      # DaisyUI tooltip sizes
      case size
      when :xs then "tooltip-xs"
      when :sm then "tooltip-sm"
      when :md then nil # default
      when :lg then "tooltip-lg"
      when :xl then "tooltip-xl"
      end
    end

    def component_color_classes(color)
      case color
      when :base then nil # default
      when :primary then "tooltip-primary"
      when :secondary then "tooltip-secondary"
      when :accent then "tooltip-accent"
      when :success then "tooltip-success"
      when :error then "tooltip-error"
      when :warning then "tooltip-warning"
      when :info then "tooltip-info"
      when :neutral then "tooltip-neutral"
      end
    end

    def component_style_classes(style)
      case style
      when :filled then nil # default
      when :outlined then "tooltip-outline"
      when :ghost then "tooltip-ghost"
      end
    end

    def root_element_attributes
      {
        element_tag: :div
      }
    end

    def rendered_tip_content
      return @tip_text if @tip_text.present?
      return nil unless @tip_content
      # Render the block content to a string
      capture(&@tip_content)
    end

    def tooltip_content_classes
      "tooltip-content"
    end
  end
end
