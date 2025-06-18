# frozen_string_literal: true

module Decor
  module Concerns
    module SizeClassHelper
      STANDARD_SIZES = %i[xs sm md lg xl].freeze
      LEGACY_SIZES = %i[small medium large].freeze
      BUTTON_SIZES = %i[large medium wide small micro xs lg md sm].freeze

      def daisy_ui_size_classes(component_prefix, size = @size)
        return nil unless size
        return nil if size == :md # md is typically the default

        case size
        when :xs then "#{component_prefix}-xs"
        when :sm then "#{component_prefix}-sm"
        when :lg then "#{component_prefix}-lg"
        when :xl then "#{component_prefix}-xl"
        else nil
        end
      end

      def button_size_classes(size = @size)
        return [] unless size

        case size
        when :large, :lg
          ["btn-lg"]
        when :small, :sm
          ["btn-sm"]
        when :micro, :xs
          ["btn-xs"]
        when :wide
          ["btn-wide"]
        else
          []
        end
      end

      def avatar_size_classes(size = @size)
        case size
        when :xs then "w-6"
        when :sm then "w-8"
        when :md then "w-10"
        when :lg then "w-16"
        when :xl then "w-24"
        else "w-10"
        end
      end

      def tag_size_classes(size = @size)
        case size
        when :xs then "px-2 py-0.5 text-xs"
        when :sm then "px-2.5 py-0.5 text-sm"
        when :md then "px-2.5 py-0.5 text-sm"
        when :lg then "px-3 py-1 text-base"
        when :xl then "px-4 py-1.5 text-lg"
        else "px-2.5 py-0.5 text-sm"
        end
      end

      def icon_size_pixels(size = @size)
        case size
        when :xs then 16
        when :sm then 20
        when :md then 24
        when :lg then 28
        when :xl then 32
        else 24
        end
      end

      def title_icon_size_pixels(size = @size)
        case size
        when :xs then 12
        when :sm then 14
        when :md then 16
        when :lg then 20
        when :xl then 24
        else 16
        end
      end

      def normalize_size(size)
        case size
        when :small then :sm
        when :medium then :md
        when :large then :lg
        else size
        end
      end

      def validate_size(size, allowed_sizes = STANDARD_SIZES)
        return :md if size.nil?
        
        normalized = normalize_size(size)
        allowed_sizes.include?(normalized) ? normalized : :md
      end
    end
  end
end