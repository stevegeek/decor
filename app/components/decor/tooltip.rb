# frozen_string_literal: true

module Decor
  # A standard 'tooltip' or popover component
  class Tooltip < PhlexComponent
    no_stimulus_controller

    prop :position, _Union(:top, :bottom, :left, :right), default: :top
    prop :tip_text, _Nilable(String)

    # Size of the tooltip
    prop :size, _Union(:xs, :sm, :md, :lg, :xl), default: :md

    # Color scheme using DaisyUI semantic colors
    prop :color, _Union(:base, :primary, :secondary, :accent, :success, :error, :warning, :info, :neutral), default: :base

    # Visual variant
    prop :variant, _Union(:filled, :outlined, :ghost), default: :filled

    # Offset customization
    prop :offset_percent_x, Integer, default: 0
    prop :offset_percent_y, Integer, default: 0

    # Backward compatibility method for old slots usage
    def tip_content(&block)
      @tip_content = block
    end

    def with_tip_content(&block)
      @tip_content = block
      self
    end

    def translate_x
      "#{@offset_percent_x}%"
    end

    def translate_y
      "#{@offset_percent_y - 190}%"
    end

    def view_template(&)
      @content = capture(&) if block_given?

      root_element do
        raw @content.html_safe if @content.present?
      end
    end

    private

    def element_classes
      classes = ["tooltip"]
      classes << position_class
      classes << size_classes
      classes << color_classes
      classes << variant_classes
      classes.compact.join(" ")
    end

    def position_class
      case @position
      when :top then "tooltip-top"
      when :bottom then "tooltip-bottom"
      when :left then "tooltip-left"
      when :right then "tooltip-right"
      end
    end

    def size_classes
      case @size
      when :xs then "tooltip-xs"
      when :sm then "tooltip-sm"
      when :lg then "tooltip-lg"
      when :xl then "tooltip-xl"
      else nil # md is default, no class needed
      end
    end

    def color_classes
      case @color
      when :primary then "tooltip-primary"
      when :secondary then "tooltip-secondary"
      when :accent then "tooltip-accent"
      when :success then "tooltip-success"
      when :error then "tooltip-error"
      when :warning then "tooltip-warning"
      when :info then "tooltip-info"
      when :neutral then "tooltip-neutral"
      else nil # base is default
      end
    end

    def variant_classes
      case @variant
      when :outlined then "tooltip-outline"
      when :ghost then "tooltip-ghost"
      else nil # filled is default
      end
    end

    def root_element_attributes
      {
        element_tag: :div,
        html_options: {
          data: {
            tip: rendered_tip_content
          }
        }
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
