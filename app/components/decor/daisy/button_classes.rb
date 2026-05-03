# frozen_string_literal: true

module Decor
  module Daisy
    # Shared daisyUI btn-* class composition for Button and ButtonLink.
    # Link doesn't include this — it has its own link-* class scheme.
    module ButtonClasses
      private

      def root_element_classes
        [
          "btn",
          *color_classes,
          *style_classes,
          *size_classes,
          *modifier_classes
        ].compact.join(" ")
      end

      def component_color_classes(color)
        return [] unless color

        case color
        when :base
          [] # Base color has no specific btn- class in DaisyUI
        when :primary
          ["btn-primary"]
        when :secondary
          ["btn-secondary"]
        when :error
          ["btn-error"]
        when :warning
          ["btn-warning"]
        when :neutral
          ["btn-neutral"]
        when :success
          ["btn-success"]
        when :info
          ["btn-info"]
        when :accent
          ["btn-accent"]
        else
          []
        end
      end

      def style_classes
        classes = component_style_classes(@style) || []
        classes << "bg-base-100" if @style == :outlined
        classes
      end

      def component_style_classes(style)
        case style
        when :soft
          ["btn-soft"]
        when :filled
          [] # Default for buttons, no special class needed
        when :outlined
          ["btn-outline"]
        when :ghost
          ["btn-ghost"]
        else
          []
        end
      end

      def component_size_classes(size)
        case size
        when :xs
          ["btn-xs"]
        when :sm
          ["btn-sm"]
        when :lg
          ["btn-lg"]
        when :xl
          ["btn-xl"]
        else
          [] # medium is default, no class needed
        end
      end

      def modifier_classes
        classes = []
        classes << "btn-block" if @full_width
        classes
      end
    end
  end
end
