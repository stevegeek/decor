# frozen_string_literal: true

module Decor
  # A modern rounded tag/badge component with DaisyUI semantic colors
  class Tag < PhlexComponent
    no_stimulus_controller

    attribute :label, String, allow_nil: false

    # Icon to display before the label
    attribute :icon, String

    # Size of the tag
    attribute :size, Symbol, default: :md, choice: [:xs, :sm, :md, :lg]

    # Color scheme using DaisyUI semantic colors
    attribute :color, Symbol, default: :neutral, choice: [:primary, :secondary, :accent, :success, :error, :warning, :info, :neutral]

    # Visual variant
    attribute :variant, Symbol, default: :filled, choice: [:filled, :outlined]

    # Whether the tag can be removed with a close button
    attribute :removable, :boolean, default: false

    private

    def parent_element_attributes
      {
        element_tag: :span
      }
    end

    def view_template
      render parent_element do
        # Icon (if present)
        if @icon.present?
          render ::Decor::Icon.new(
            name: @icon,
            variant: :outlined,
            html_options: {
              class: icon_classes
            }
          )
        end

        # Label content
        if block_given?
          yield
        else
          span(class: "whitespace-nowrap") { plain(@label || @text) }
        end

        # Remove button (if removable)
        if @removable
          render_remove_button
        end
      end
    end

    def element_classes
      classes = ["inline-flex", "items-center", "justify-center", "rounded-full", "whitespace-nowrap"]
      classes << size_classes
      classes << color_classes
      classes << "gap-2" if @icon.present? || @removable
      classes.compact.join(" ")
    end

    def size_classes
      case @size
      when :xs then "px-2 py-0.5 text-xs"
      when :sm then "px-2.5 py-0.5 text-sm"
      when :md then "px-2.5 py-0.5 text-sm"
      when :lg then "px-3 py-1 text-base"
      end
    end

    def color_classes
      if @variant == :outlined
        outline_color_classes
      else
        filled_color_classes
      end
    end

    def filled_color_classes
      case @color
      when :primary then "bg-primary text-primary-content"
      when :secondary then "bg-secondary text-secondary-content"
      when :accent then "bg-accent text-accent-content"
      when :success then "bg-success text-success-content"
      when :error then "bg-error text-error-content"
      when :warning then "bg-warning text-warning-content"
      when :info then "bg-info text-info-content"
      when :neutral then "bg-neutral text-neutral-content"
      end
    end

    def outline_color_classes
      case @color
      when :primary then "border border-primary text-primary"
      when :secondary then "border border-secondary text-secondary"
      when :accent then "border border-accent text-accent"
      when :success then "border border-success text-success"
      when :error then "border border-error text-error"
      when :warning then "border border-warning text-warning"
      when :info then "border border-info text-info"
      when :neutral then "border border-neutral text-neutral"
      end
    end

    def icon_classes
      case @size
      when :xs then "w-3 h-3"
      when :sm then "w-3 h-3"
      when :md then "w-4 h-4"
      when :lg then "w-5 h-5"
      end
    end

    def render_remove_button
      button(
        class: remove_button_classes,
        type: "button"
      ) do
        span(class: "sr-only") { "Remove tag" }
        render ::Decor::Icon.new(
          name: "x-mark",
          variant: :outlined,
          html_options: {
            class: remove_icon_classes
          }
        )
      end
    end

    def remove_button_classes
      "ml-1 btn btn-xs btn-circle btn-ghost #{remove_button_border_classes} #{remove_button_size_classes}"
    end

    def remove_button_border_classes
      return "border-white/50" if @variant == :filled
      case @color
      when :primary then "border-primary"
      when :secondary then "border-secondary"
      when :accent then "border-accent"
      when :success then "border-success"
      when :error then "border-error"
      when :warning then "border-warning"
      when :info then "border-info"
      when :neutral then "border-neutral"
      end
    end

    def remove_button_size_classes
      case @size
      when :xs then "w-3 h-3"
      else "w-4 h-4"
      end
    end

    def remove_icon_classes
      case @size
      when :xs then "w-2 h-2"
      when :sm then "w-3 h-3"  
      when :md then "w-3 h-3"
      when :lg then "w-4 h-4"
      end
    end
  end
end