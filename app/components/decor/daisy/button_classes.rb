# frozen_string_literal: true

module Decor
  module Daisy
    # Shared daisyUI btn-* class composition for Button and ButtonLink.
    # Link doesn't include this — it has its own link-* class scheme.
    module ButtonClasses
      private

      def root_element_classes
        [
          "decor:d-btn",
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
          ["decor:d-btn-primary"]
        when :secondary
          ["decor:d-btn-secondary"]
        when :error
          ["decor:d-btn-error"]
        when :warning
          ["decor:d-btn-warning"]
        when :neutral
          ["decor:d-btn-neutral"]
        when :success
          ["decor:d-btn-success"]
        when :info
          ["decor:d-btn-info"]
        when :accent
          ["decor:d-btn-accent"]
        else
          []
        end
      end

      def style_classes
        classes = component_style_classes(@style) || []
        classes << "decor:bg-base-100" if @style == :outlined
        classes
      end

      def component_style_classes(style)
        case style
        when :soft
          ["decor:d-btn-soft"]
        when :filled
          [] # Default for buttons, no special class needed
        when :outlined
          ["decor:d-btn-outline"]
        when :ghost
          ["decor:d-btn-ghost"]
        else
          []
        end
      end

      def component_size_classes(size)
        case size
        when :xs
          ["decor:d-btn-xs"]
        when :sm
          ["decor:d-btn-sm"]
        when :lg
          ["decor:d-btn-lg"]
        when :xl
          ["decor:d-btn-xl"]
        else
          [] # medium is default, no class needed
        end
      end

      def modifier_classes
        classes = []
        classes << "decor:d-btn-block" if @full_width
        classes
      end
    end
  end
end
