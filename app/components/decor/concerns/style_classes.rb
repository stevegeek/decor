# frozen_string_literal: true

module Decor
  module Concerns
    module StyleClasses
      module ClassMethods
        def styles
          _configured_styles || [:filled, :outlined, :ghost]
        end

        def default_style(style = nil)
          return _configured_default_style unless style
          self._configured_default_style = style
        end

        def redefine_styles(*new_styles)
          self._configured_styles = new_styles
          prop :style, _Nilable(_Union(*new_styles)), default: -> { self.class._configured_default_style }
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
        base.class_attribute :_configured_styles, instance_accessor: false
        base.class_attribute :_configured_default_style, instance_accessor: false
        base.class_eval do
          prop :style, _Nilable(_Union(*styles)), default: -> { self.class._configured_default_style }
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
