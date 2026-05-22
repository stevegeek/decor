# frozen_string_literal: true

module Decor
  module Concerns
    module StyleClasses
      module ClassMethods
        def styles
          config.styles || [:filled, :outlined, :ghost]
        end

        def default_style(style = nil)
          return config.default_style unless style
          config.default_style = style
        end

        def redefine_styles(*new_styles)
          config.styles = new_styles
          prop :style, _Nilable(_Union(*new_styles)), default: -> { config.default_style }
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
        base.class_eval do
          prop :style, _Nilable(_Union(*styles)), default: -> { config.default_style }
        end
      end

      def style_classes(style = @style)
        return nil unless style

        return nil unless valid_style?(style)

        component_style_classes(style)
      end

      # Override to provide component-specific style classes.
      def component_style_classes(style)
      end

      def valid_style?(style)
        self.class.styles.include?(style)
      end
    end
  end
end
