# frozen_string_literal: true

module Decor
  # A standard 'tooltip' or popover component
  class Tooltip < PhlexComponent
    no_stimulus_controller

    attribute :position, Symbol, in: [:top, :bottom, :left, :right], default: :top
    attribute :tip_text, String
    
    # Size of the tooltip
    attribute :size, Symbol, default: :md, in: [:xs, :sm, :md, :lg, :xl]
    
    # Color scheme using DaisyUI semantic colors
    attribute :color, Symbol, default: :base, in: [:base, :primary, :secondary, :accent, :success, :error, :warning, :info, :neutral]
    
    # Visual variant
    attribute :variant, Symbol, default: :filled, in: [:filled, :outlined, :ghost]

    # Backward compatibility method for old slots usage
    def tip_content(&block)
      @tip_content = block
    end

    def view_template(&)
      @content = capture(&) if block_given?

      render parent_element do |tip|
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
            tip: @tip_text || @tip_content
          }
        }
      }
    end

    def tooltip_content_classes
      "tooltip-content"
    end
  end
end
