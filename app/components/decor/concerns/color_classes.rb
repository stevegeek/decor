# frozen_string_literal: true

module Decor
  module Concerns
    module ColorClasses
      SEMANTIC_COLORS = %i[base primary secondary accent neutral success error warning info].freeze

      module ClassMethods
        def colors
          self.config.colors || SEMANTIC_COLORS
        end

        def default_color(color = nil)
          return self.config.default_color unless color
          self.config.default_color = color
        end

        # DSL method to redefine colors for a component
        def redefine_colors(*new_colors)
          self.config.colors = new_colors
          # Redefine the color prop with the new colors
          prop :color, _Nilable(_Union(*new_colors)), default: -> { self.config.default_color }
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
        base.class_eval do
          prop :color, _Nilable(_Union(*colors)), default: -> { self.config.default_color }
        end
      end

      # Main method that handles common color logic and delegates to component-specific implementation
      def color_classes(color = @color)
        return nil unless color
        return nil unless valid_color?(color)
        
        # Delegate to component-specific implementation
        component_color_classes(color)
      end

      # Components should override this method to provide their specific color classes
      def component_color_classes(color)
      end

      # Check if color is valid
      def valid_color?(color)
        self.class.colors.include?(color)
      end

      def text_color_classes(color = @color)
        return nil unless valid_color?(color)
        
        case color
        when :base then "text-base-content"
        when :primary then "text-primary"
        when :secondary then "text-secondary"
        when :accent then "text-accent"
        when :success then "text-success"
        when :error then "text-error"
        when :warning then "text-warning"
        when :info then "text-info"
        when :neutral then "text-neutral"
        else nil
        end
      end

      def background_color_classes(color = @color)
        return nil unless valid_color?(color)
        
        case color
        when :base then "bg-base-100"
        when :primary then "bg-primary"
        when :secondary then "bg-secondary"
        when :accent then "bg-accent"
        when :success then "bg-success"
        when :error then "bg-error"
        when :warning then "bg-warning"
        when :info then "bg-info"
        when :neutral then "bg-neutral"
        else nil
        end
      end

      def border_color_classes(color = @color)
        return nil unless valid_color?(color)
        
        case color
        when :base then "border-base-300"
        when :primary then "border-primary"
        when :secondary then "border-secondary"
        when :accent then "border-accent"
        when :success then "border-success"
        when :error then "border-error"
        when :warning then "border-warning"
        when :info then "border-info"
        when :neutral then "border-neutral"
        else nil
        end
      end
    end
  end
end