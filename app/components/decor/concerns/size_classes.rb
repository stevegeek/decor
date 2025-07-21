# frozen_string_literal: true

module Decor
  module Concerns
    module SizeClasses
      STANDARD_SIZES = %i[xs sm md lg xl].freeze
      SIZE_ALIASES = {
        small: :sm,
        medium: :md,
        large: :lg,
        micro: :xs,
        extra_small: :xs,
        extra_large: :xl
      }.freeze

      module ClassMethods
        def default_size(size = nil)
          return self.config.default_size unless size
          self.default_size = size
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
        base.class_eval do
          prop :size, _Nilable(_Union(*(SIZE_ALIASES.keys + STANDARD_SIZES))), default: -> { self.config.default_size }
        end
      end

      # Main method that handles common size logic and delegates to component-specific implementation
      def size_classes(size = @size)
        return nil unless size
        
        normalized_size = normalize_size(size)
        return nil unless valid_size?(normalized_size)
        
        # Delegate to component-specific implementation
        component_size_classes(normalized_size)
      end

      # Components should override this method to provide their specific size classes
      def component_size_classes(size)
        raise NotImplementedError, "Components must implement #component_size_classes"
      end

      # Default size - components can override
      def default_size
      end

      # Normalize size aliases to standard sizes
      def normalize_size(size)
        SIZE_ALIASES[size] || size
      end

      # Check if size is valid
      def valid_size?(size)
        STANDARD_SIZES.include?(size)
      end

      # Helper methods for common size-related calculations
      def icon_size_pixels(size = @size)
        normalized_size = normalize_size(size)
        
        case normalized_size
        when :xs then 16
        when :sm then 20
        when :md then 24
        when :lg then 28
        when :xl then 32
        else 24
        end
      end

      # Helper methods for common size-related CSS classes
      def text_size_class(size = @size)
        return nil unless size

        normalized_size = normalize_size(size)
        return nil unless valid_size?(normalized_size)

        case normalized_size
        when :xs
          "text-xs"
        when :sm
          "text-sm"
        when :md
          "text-base"
        when :lg
          "text-xl"
        when :xl
          "text-2xl"
        else
          "text-base"
        end
      end
    end
  end
end