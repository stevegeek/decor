# frozen_string_literal: true

module Decor
  module Concerns
    module StyleClassHelper
      module ClassMethods
        def styles
          [:filled, :outlined, :ghost]
        end

        # Default style - components can override
        def default_style
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
        base.class_eval do
          prop :style, _Nilable(_Union(*styles)), default: default_style.freeze
        end
      end

      # Main method that handles common style logic and delegates to component-specific implementation
      def style_classes(style = @style)
        return nil unless style
        
        return nil unless valid_style?(style)

        # Delegate to component-specific implementation
        component_style_classes(style)
      end

      # Components should override this method to provide their specific style classes
      def component_style_classes(style)
        raise NotImplementedError, "Components must implement #component_style_classes"
      end

      # Check if style is valid
      def valid_style?(style)
        self.class.styles.include?(style)
      end

      # Helper method to get style-specific color classes
      def style_color_classes(style = @style, color = @color)
        return nil unless style && color
        
        case style
        when :filled
          filled_color_classes(color)
        when :outlined
          outline_color_classes(color)
        when :ghost
          ghost_color_classes(color)
        else
          nil
        end
      end
    end
  end
end