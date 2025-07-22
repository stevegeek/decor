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

      # Helper methods for common color patterns
      def filled_color_classes(color = @color)
        return nil unless valid_color?(color)

        case color
        when :base then "bg-base-100 text-base-content"
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

      def outline_color_classes(color = @color)
        return nil unless valid_color?(color)

        classes = "border-2 box-border"
        colors = case color
        when :base then "border-base-300 text-base-content"
        when :primary then "border-primary text-primary"
        when :secondary then "border-secondary text-secondary"
        when :accent then "border-accent text-accent"
        when :success then "border-success text-success"
        when :error then "border-error text-error"
        when :warning then "border-warning text-warning"
        when :info then "border-info text-info"
        when :neutral then "border-neutral text-neutral"
        end
        "#{classes} #{colors}"
      end

      def ghost_color_classes(color = @color)
        return nil unless valid_color?(color)

        case color
        when :base then "text-base-content hover:bg-base-200"
        when :primary then "text-primary hover:bg-primary/10"
        when :secondary then "text-secondary hover:bg-secondary/10"
        when :accent then "text-accent hover:bg-accent/10"
        when :success then "text-success hover:bg-success/10"
        when :error then "text-error hover:bg-error/10"
        when :warning then "text-warning hover:bg-warning/10"
        when :info then "text-info hover:bg-info/10"
        when :neutral then "text-neutral hover:bg-neutral/10"
        end
      end
    end
  end
end
