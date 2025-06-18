# frozen_string_literal: true

module Decor
  module Concerns
    module ColorClassHelper
      SEMANTIC_COLORS = %i[primary secondary accent neutral success error warning info].freeze
      BASE_COLORS = %i[base primary secondary accent success error warning info neutral].freeze
      
      def daisy_ui_color_classes(component_prefix, color = @color)
        return nil unless color && SEMANTIC_COLORS.include?(color)
        
        "#{component_prefix}-#{color}"
      end

      def button_color_classes(color = @color)
        return [] unless color && SEMANTIC_COLORS.include?(color)
        
        ["btn-#{color}"]
      end

      def filled_color_classes(color = @color)
        return nil unless color
        
        case color
        when :primary then "bg-primary text-primary-content"
        when :secondary then "bg-secondary text-secondary-content"
        when :accent then "bg-accent text-accent-content"
        when :success then "bg-success text-success-content"
        when :error then "bg-error text-error-content"
        when :warning then "bg-warning text-warning-content"
        when :info then "bg-info text-info-content"
        when :neutral then "bg-neutral text-neutral-content"
        when :base then "bg-base-100 text-base-content"
        else nil
        end
      end

      def outline_color_classes(color = @color)
        return nil unless color
        
        case color
        when :primary then "border border-primary text-primary"
        when :secondary then "border border-secondary text-secondary"
        when :accent then "border border-accent text-accent"
        when :success then "border border-success text-success"
        when :error then "border border-error text-error"
        when :warning then "border border-warning text-warning"
        when :info then "border border-info text-info"
        when :neutral then "border border-neutral text-neutral"
        when :base then "border border-base-300 text-base-content"
        else nil
        end
      end

      def ghost_color_classes(color = @color)
        return nil unless color
        
        case color
        when :primary then "text-primary hover:bg-primary/10"
        when :secondary then "text-secondary hover:bg-secondary/10"
        when :accent then "text-accent hover:bg-accent/10"
        when :success then "text-success hover:bg-success/10"
        when :error then "text-error hover:bg-error/10"
        when :warning then "text-warning hover:bg-warning/10"
        when :info then "text-info hover:bg-info/10"
        when :neutral then "text-neutral hover:bg-neutral/10"
        when :base then "text-base-content hover:bg-base-200"
        else nil
        end
      end

      def text_color_classes(color = @color)
        return nil unless color
        
        case color
        when :primary then "text-primary"
        when :secondary then "text-secondary"
        when :accent then "text-accent"
        when :success then "text-success"
        when :error then "text-error"
        when :warning then "text-warning"
        when :info then "text-info"
        when :neutral then "text-neutral"
        when :base then "text-base-content"
        else nil
        end
      end

      def background_color_classes(color = @color)
        return nil unless color
        
        case color
        when :primary then "bg-primary"
        when :secondary then "bg-secondary"
        when :accent then "bg-accent"
        when :success then "bg-success"
        when :error then "bg-error"
        when :warning then "bg-warning"
        when :info then "bg-info"
        when :neutral then "bg-neutral"
        when :base then "bg-base-100"
        else nil
        end
      end

      def border_color_classes(color = @color)
        return nil unless color
        
        case color
        when :primary then "border-primary"
        when :secondary then "border-secondary"
        when :accent then "border-accent"
        when :success then "border-success"
        when :error then "border-error"
        when :warning then "border-warning"
        when :info then "border-info"
        when :neutral then "border-neutral"
        when :base then "border-base-300"
        else nil
        end
      end

      def validate_color(color, allowed_colors = SEMANTIC_COLORS)
        return nil if color.nil?
        
        allowed_colors.include?(color) ? color : nil
      end

      def semantic_color?(color)
        SEMANTIC_COLORS.include?(color)
      end
    end
  end
end