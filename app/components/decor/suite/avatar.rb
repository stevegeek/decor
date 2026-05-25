# frozen_string_literal: true

module Decor
  module Suite
    class Avatar < ::Decor::Components::Avatar
      ALT_COLORS = %i[alt1 alt2 alt3 alt4 alt5].freeze
      redefine_colors(
        *ALT_COLORS,
        *::Decor::Concerns::ColorClasses::SEMANTIC_COLORS
      )

      default_color :primary

      prop :border, _Boolean, default: true

      def view_template
        root_element do
          if @url
            img(
              src: @url,
              alt: @alt.presence || @initials.presence || "",
              class: "decor:w-full decor:h-full decor:object-cover"
            )
          elsif @initials
            plain @initials
          end
          status_dot if @status
          yield if block_given?
        end
      end

      private

      def root_element_attributes
        {element_tag: :span}
      end

      def root_element_classes
        base = "decor--suite--avatar decor:inline-flex decor:items-center decor:justify-center " \
               "decor:shrink-0 decor:relative #{size_classes} #{shape_class} #{border_classes}"
        if @url
          "#{base} decor:overflow-hidden"
        else
          "#{base} decor:text-white decor:font-semibold decor:tracking-[-0.01em] " \
            "decor:leading-none #{text_size_class} #{gradient_classes}"
        end
      end

      def shape_class
        case @shape
        when :square then "decor:rounded-card"
        else "decor:rounded-full"
        end
      end

      def size_classes
        case @size
        when :xs then "decor:w-5 decor:h-5"
        when :sm then "decor:w-7 decor:h-7"
        when :lg then "decor:w-12 decor:h-12"
        when :xl then "decor:w-14 decor:h-14"
        else "decor:w-9 decor:h-9"
        end
      end

      def text_size_class
        case @size
        when :xs then "decor:text-[9px]"
        when :sm then "decor:text-[11px]"
        when :lg then "decor:text-[15px]"
        when :xl then "decor:text-[18px]"
        else "decor:text-[13px]"
        end
      end

      def border_classes
        @border ? "decor:border decor:border-suite-hairline" : ""
      end

      def gradient_classes
        case @color
        when :alt1 then "decor:bg-linear-to-br decor:from-[#f5a623] decor:to-[#e6710b]"
        when :alt2 then "decor:bg-linear-to-br decor:from-[#11a87a] decor:to-[#0a6d50]"
        when :alt3 then "decor:bg-linear-to-br decor:from-[#d94747] decor:to-[#9f2c2c]"
        when :alt4 then "decor:bg-linear-to-br decor:from-[#9b6dd4] decor:to-[#5a2e8f]"
        when :alt5 then "decor:bg-linear-to-br decor:from-[#2e74bd] decor:to-[#143f6f]"
        # daisyUI v5 has no numeric Tailwind shades; fall back to the alt5 gradient.
        else "decor:bg-linear-to-br decor:from-[#2e74bd] decor:to-[#143f6f]"
        end
      end

      def status_dot
        span(
          class: "decor:absolute decor:-bottom-px decor:-right-px decor:w-[10px] decor:h-[10px] " \
                 "decor:rounded-full decor:border-2 decor:border-white #{status_dot_color}",
          aria: {label: @status.to_s}
        )
      end

      def status_dot_color
        case @status
        when :online then "decor:bg-suite-success-500"
        when :away then "decor:bg-suite-warning-500"
        when :offline then "decor:bg-gray-400"
        end
      end
    end
  end
end
