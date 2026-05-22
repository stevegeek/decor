# frozen_string_literal: true

module Decor
  module Concerns
    module StyleColorClasses
      # Components that use the standard styles and colors names can just include this module
      def component_color_classes(_color)
      end

      def component_style_classes(style = @style)
        return nil unless style

        case style
        when :filled
          filled_color_classes
        when :outlined
          outline_color_classes
        when :ghost
          ghost_color_classes
        end
      end

      def filled_color_classes(color = @color)
        return nil unless valid_color?(color)

        case color
        when :base then "decor:bg-base-100 decor:text-base-content"
        when :primary then "decor:bg-primary decor:text-primary-content"
        when :secondary then "decor:bg-secondary decor:text-secondary-content"
        when :accent then "decor:bg-accent decor:text-accent-content"
        when :success then "decor:bg-success decor:text-success-content"
        when :error then "decor:bg-error decor:text-error-content"
        when :warning then "decor:bg-warning decor:text-warning-content"
        when :info then "decor:bg-info decor:text-info-content"
        when :neutral then "decor:bg-neutral decor:text-neutral-content"
        end
      end

      def outline_color_classes(color = @color)
        return nil unless valid_color?(color)

        classes = "decor:border-2 decor:box-border"
        colors = case color
        when :base then "decor:border-base-300 decor:text-base-content"
        when :primary then "decor:border-primary decor:text-primary"
        when :secondary then "decor:border-secondary decor:text-secondary"
        when :accent then "decor:border-accent decor:text-accent"
        when :success then "decor:border-success decor:text-success"
        when :error then "decor:border-error decor:text-error"
        when :warning then "decor:border-warning decor:text-warning"
        when :info then "decor:border-info decor:text-info"
        when :neutral then "decor:border-neutral decor:text-neutral"
        end
        "#{classes} #{colors}"
      end

      def ghost_color_classes(color = @color)
        return nil unless valid_color?(color)

        case color
        when :base then "decor:text-base-content decor:hover:bg-base-200"
        when :primary then "decor:text-primary decor:hover:bg-primary/10"
        when :secondary then "decor:text-secondary decor:hover:bg-secondary/10"
        when :accent then "decor:text-accent decor:hover:bg-accent/10"
        when :success then "decor:text-success decor:hover:bg-success/10"
        when :error then "decor:text-error decor:hover:bg-error/10"
        when :warning then "decor:text-warning decor:hover:bg-warning/10"
        when :info then "decor:text-info decor:hover:bg-info/10"
        when :neutral then "decor:text-neutral decor:hover:bg-neutral/10"
        end
      end
    end
  end
end
