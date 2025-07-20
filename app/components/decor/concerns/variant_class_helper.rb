# frozen_string_literal: true

module Decor
  module Concerns
    module VariantClassHelper
      module ClassMethods
        def variants
          [:filled, :outlined, :ghost]
        end

        # Default variant - components can override
        def default_variant
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
        base.class_eval do
          prop :variant, _Nilable(_Union(*variants)), default: default_variant.freeze
        end
      end

      # Main method that handles common variant logic and delegates to component-specific implementation
      def variant_classes(variant = @variant)
        return nil unless variant
        
        return nil unless valid_variant?(variant)

        # Delegate to component-specific implementation
        component_variant_classes(variant)
      end

      # Components should override this method to provide their specific variant classes
      def component_variant_classes(variant)
        raise NotImplementedError, "Components must implement #component_variant_classes"
      end

      # Check if variant is valid
      def valid_variant?(variant)
        self.class.variants.include?(variant)
      end

      # Helper method to get variant-specific color classes
      def variant_color_classes(variant = @variant, color = @color)
        return nil unless variant && color
        
        case variant
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