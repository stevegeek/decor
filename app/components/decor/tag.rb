# frozen_string_literal: true

module Decor
  # A modern rounded tag/badge component with DaisyUI semantic colors
  class Tag < PhlexComponent
    include Decor::Concerns::StyleColorClasses
    
    no_stimulus_controller

    prop :label, _Nilable(String)

    # Icon to display before the label
    prop :icon, _Nilable(String)
    
    default_size :md
    default_color :neutral
    default_style :filled

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

    def root_element_classes
      classes = ["inline-flex", "items-center", "justify-center", "rounded-full", "whitespace-nowrap"]
      classes << size_classes
      classes << style_classes
      classes << "gap-2" if @icon.present? || @removable
      classes.compact.join(" ")
    end

    def component_size_classes(size)
      case size
      when :xs then "px-2 py-0.5 text-xs"
      when :sm then "px-2.5 py-0.5 text-sm"
      when :md then "px-3 py-1 text-sm"
      when :lg then "px-4 py-1.5 text-base"
      when :xl then "px-5 py-2 text-lg"
      end
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
      "ml-1 btn btn-xs btn-circle btn-ghost #{remove_button_size_classes}"
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
