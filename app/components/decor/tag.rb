# frozen_string_literal: true

module Decor
  # A modern rounded tag/badge component with DaisyUI semantic colors
  class Tag < PhlexComponent
    no_stimulus_controller

    prop :label, _Nilable(String)

    # Icon to display before the label
    prop :icon, _Nilable(String)

    # Size of the tag
    prop :size, _Union(:xs, :sm, :md, :lg, :xl), default: :md

    # Color scheme using DaisyUI semantic colors
    prop :color, _Union(:primary, :secondary, :accent, :success, :error, :warning, :info, :neutral), default: :neutral

    # Visual variant
    prop :variant, _Union(:filled, :outlined, :ghost), default: :filled

    # Whether the tag can be removed with a close button
    prop :removable, _Boolean, default: false

    private

    def root_element_attributes
      {
        element_tag: :span
      }
    end

    def view_template
      root_element do
        # Icon (if present)
        if @icon.present?
          render ::Decor::Icon.new(
            name: @icon,
            variant: :outline,
            html_options: {
              class: icon_classes
            }
          )
        end

        # Label content
        if block_given?
          yield
        else
          span(class: "whitespace-nowrap") { plain(@label) }
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
      tag_size_classes
    end

    def color_classes
      variant_color_classes
    end


    def icon_classes
      case @size
      when :xs then "w-3 h-3"
      when :sm then "w-3 h-3"
      when :md then "w-4 h-4"
      when :lg then "w-5 h-5"
      when :xl then "w-6 h-6"
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
          variant: :outline,
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
      when :xl then "w-5 h-5"
      end
    end
  end
end
