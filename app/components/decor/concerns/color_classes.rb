# frozen_string_literal: true

module Decor
  module Concerns
    module ColorClasses
      SEMANTIC_COLORS = %i[base primary secondary accent neutral success error warning info].freeze

      module ClassMethods
        def colors
          _configured_colors || SEMANTIC_COLORS
        end

        def default_color(color = nil)
          return _configured_default_color unless color
          self._configured_default_color = color
        end

        def redefine_colors(*new_colors)
          self._configured_colors = new_colors
          prop :color, _Nilable(_Union(*new_colors)), default: -> { self.class._configured_default_color }
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
        base.class_attribute :_configured_colors, instance_accessor: false
        base.class_attribute :_configured_default_color, instance_accessor: false
        base.class_eval do
          prop :color, _Nilable(_Union(*colors)), default: -> { self.class._configured_default_color }
        end
      end

      def color_classes(color = @color)
        return nil unless color
        return nil unless valid_color?(color)

        component_color_classes(color)
      end

      # Override to provide component-specific color classes.
      def component_color_classes(color)
      end

      def valid_color?(color)
        self.class.colors.include?(color)
      end

      def text_color_classes(color = @color)
        return nil unless valid_color?(color)

        case color
        when :base then "decor:text-base-content"
        when :primary then "decor:text-primary"
        when :secondary then "decor:text-secondary"
        when :accent then "decor:text-accent"
        when :success then "decor:text-success"
        when :error then "decor:text-error"
        when :warning then "decor:text-warning"
        when :info then "decor:text-info"
        when :neutral then "decor:text-neutral"
        end
      end

      def background_color_classes(color = @color)
        return nil unless valid_color?(color)

        case color
        when :base then "decor:bg-base-100"
        when :primary then "decor:bg-primary"
        when :secondary then "decor:bg-secondary"
        when :accent then "decor:bg-accent"
        when :success then "decor:bg-success"
        when :error then "decor:bg-error"
        when :warning then "decor:bg-warning"
        when :info then "decor:bg-info"
        when :neutral then "decor:bg-neutral"
        end
      end

      def border_color_classes(color = @color)
        return nil unless valid_color?(color)

        case color
        when :base then "decor:border-base-300"
        when :primary then "decor:border-primary"
        when :secondary then "decor:border-secondary"
        when :accent then "decor:border-accent"
        when :success then "decor:border-success"
        when :error then "decor:border-error"
        when :warning then "decor:border-warning"
        when :info then "decor:border-info"
        when :neutral then "decor:border-neutral"
        end
      end
    end
  end
end
