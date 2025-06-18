# frozen_string_literal: true

module Decor
  module Concerns
    module VariantClassHelper
      COMMON_VARIANTS = %i[filled outlined ghost].freeze
      BUTTON_VARIANTS = %i[contained outlined text ghost].freeze
      BADGE_VARIANTS = %i[filled outlined].freeze
      TAB_VARIANTS = %i[ghost bordered lifted boxed].freeze

      def variant_color_classes(variant = @variant, color = @color)
        return nil unless variant

        case variant
        when :filled, :contained
          filled_color_classes(color)
        when :outlined, :outline
          outline_color_classes(color)
        when :ghost, :text
          ghost_color_classes(color)
        else
          nil
        end
      end

      def button_variant_classes(variant = @variant)
        return [] unless variant

        case variant
        when :outlined, :outline
          ["btn-outline"]
        when :ghost, :text
          ["btn-ghost"]
        when :link
          ["btn-link"]
        else
          []
        end
      end

      def tab_variant_classes(variant = @variant)
        return nil unless variant

        case variant
        when :ghost then "tabs-ghost"
        when :bordered then "tabs-bordered"
        when :lifted then "tabs-lifted"
        when :boxed then "tabs-boxed"
        else nil
        end
      end

      def card_variant_classes(variant = @variant)
        return nil unless variant

        case variant
        when :outlined then "card-bordered"
        when :compact then "card-compact"
        when :normal then "card-normal"
        when :side then "card-side"
        else nil
        end
      end

      def validate_variant(variant, allowed_variants = COMMON_VARIANTS)
        return nil if variant.nil?
        
        allowed_variants.include?(variant) ? variant : nil
      end

      def normalize_variant(variant)
        case variant
        when :outline then :outlined
        when :text then :ghost
        when :contained then :filled
        else variant
        end
      end

      def variant_supports_color?(variant)
        %i[filled outlined ghost contained text].include?(variant)
      end
    end
  end
end