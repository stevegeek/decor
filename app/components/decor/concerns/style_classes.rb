# frozen_string_literal: true

module Decor
  module Concerns
    module StyleClasses
      module ClassMethods
        def styles
          self.config.styles || [:filled, :outlined, :ghost]
        end

        def default_style(style = nil)
          return self.config.default_style unless style
          self.config.default_style = style
        end

        # DSL method to redefine styles for a component
        def redefine_styles(*new_styles)
          self.config.styles = new_styles
          # Redefine the style prop with the new styles
          prop :style, _Nilable(_Union(*new_styles)), default: -> { self.config.default_style }
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
        base.class_eval do
          prop :style, _Nilable(_Union(*styles)), default: -> { self.config.default_style }
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
      end

      # Check if style is valid
      def valid_style?(style)
        self.class.styles.include?(style)
      end
    end
  end
end