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
        def sizes
          config.sizes || STANDARD_SIZES
        end

        def size_aliases
          config.size_aliases || SIZE_ALIASES
        end

        def default_size(size = nil)
          return config.default_size unless size
          config.default_size = size
        end

        def redefine_sizes(*new_sizes)
          config.sizes = new_sizes
          prop :size, _Nilable(_Union(*(size_aliases.keys + new_sizes))), default: -> { config.default_size }
        end

        def redefine_size_aliases(new_aliases)
          config.size_aliases = new_aliases
          prop :size, _Nilable(_Union(*(new_aliases.keys + sizes))), default: -> { config.default_size }
        end
      end

      def self.included(base)
        base.extend(ClassMethods)
        base.class_eval do
          prop :size, _Nilable(_Union(*(size_aliases.keys + sizes))), default: -> { config.default_size }
        end
      end

      def size_classes(size = @size)
        return nil unless size

        normalized_size = normalize_size(size)
        return nil unless valid_size?(normalized_size)

        component_size_classes(normalized_size)
      end

      # Override to provide component-specific size classes.
      def component_size_classes(size)
      end

      def default_size
      end

      def normalize_size(size)
        self.class.size_aliases[size] || size
      end

      def valid_size?(size)
        self.class.sizes.include?(size)
      end

      def icon_size_pixels(size = @size)
        normalized_size = normalize_size(size)

        case normalized_size
        when :xs then 10
        when :sm then 12
        when :md then 14
        when :lg then 16
        else 20
        end
      end

      def text_size_class(size = @size)
        return nil unless size

        normalized_size = normalize_size(size)
        return nil unless valid_size?(normalized_size)

        case normalized_size
        when :xs
          "decor:text-xs"
        when :sm
          "decor:text-sm"
        when :md
          "decor:text-base"
        when :lg
          "decor:text-xl"
        when :xl
          "decor:text-2xl"
        else
          "decor:text-base"
        end
      end
    end
  end
end
