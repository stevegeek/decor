# frozen_string_literal: true

module Decor
  module Suite
    class Button < ::Decor::Components::Button
      default_style :filled
      default_color :primary
      default_size :md

      redefine_styles :filled, :outlined, :ghost

      redefine_colors :base, :primary, :error, :warning

      redefine_sizes :xs, :sm, :md, :lg, :xl, :wide, :link

      private

      def view_template(&block)
        @content = capture(&block).html_safe if block_given?
        root_element do
          render_spinner if @loading
          span(class: label_wrapper_classes) do
            render @before_label if @before_label.present?
            if @icon
              render ::Decor::Icon.new(
                name: @icon,
                style: @icon_variant || :solid,
                html_options: {class: icon_classes}
              )
            end
            span(class: @icon_only_on_mobile ? "decor:hidden decor:md:inline" : "") do
              if @content
                raw @content
              elsif @label.present?
                plain @label
              end
            end
            render @after_label if @after_label.present?
          end
        end
      end

      def root_element_attributes
        {
          element_tag: :button,
          html_options: {
            disabled: (@disabled || @loading) ? "disabled" : nil
          }
        }
      end

      def root_element_classes
        [
          "decor:inline-flex decor:items-center decor:justify-center decor:gap-1.5",
          "decor:font-medium decor:whitespace-nowrap decor:no-underline decor:hover:no-underline",
          "decor:transition-all decor:duration-suite-fast decor:ease-out",
          "decor:focus-visible:outline-hidden decor:focus-visible:shadow-[0_0_0_3px_var(--color-suite-primary-100)]",
          "decor:disabled:opacity-50 decor:disabled:cursor-not-allowed",
          *style_color_classes,
          *suite_size_classes,
          *modifier_classes,
          @loading ? "decor:relative decor:text-transparent" : nil
        ].compact.join(" ")
      end

      def label_wrapper_classes
        base = "decor:flex decor:items-center decor:gap-1.5"
        @loading ? "#{base} decor:invisible" : base
      end

      def render_spinner
        spinner_color = (@style == :filled && @color != :warning) ? "decor:text-white" : "decor:text-gray-600"
        span(aria_hidden: "true", class: "decor:absolute decor:inset-0 decor:flex decor:items-center decor:justify-center") do
          raw safe(<<~SVG)
            <svg class="decor:animate-spin #{spinner_color} decor:h-4 decor:w-4" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
              <circle class="decor:opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="3"></circle>
              <path class="decor:opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
            </svg>
          SVG
        end
      end

      def suite_size_classes
        normalized = normalize_size(@size)
        [size_padding_class(normalized)]
      end

      def size_padding_class(size)
        case size
        when :lg, :xl
          "decor:px-[18px] decor:py-[9px] decor:text-sm decor:h-[38px] decor:rounded-suite-control"
        when :md
          "decor:px-3.5 decor:py-[7px] decor:text-[13px] decor:leading-[1.2] decor:rounded-suite-control"
        when :sm
          "decor:px-[11px] decor:py-[5px] decor:text-xs decor:leading-[1.2] decor:rounded-suite-control"
        when :xs
          "decor:px-[9px] decor:py-1 decor:text-[11px] decor:leading-[1.2] decor:rounded-suite-control"
        when :wide
          "decor:px-16 decor:py-[7px] decor:text-[13px] decor:leading-[1.2] decor:rounded-suite-control"
        when :link
          "decor:px-0 decor:py-0 decor:text-[13px] decor:underline decor:rounded-none"
        else
          "decor:px-3.5 decor:py-[7px] decor:text-[13px] decor:leading-[1.2] decor:rounded-suite-control"
        end
      end

      def icon_classes
        normalized = normalize_size(@size)
        sized =
          case normalized
          when :lg, :xl then "decor:h-[15px] decor:w-[15px]"
          when :md, :wide then "decor:h-[13px] decor:w-[13px]"
          when :sm then "decor:h-3 decor:w-3"
          when :xs, :link then "decor:h-[11px] decor:w-[11px]"
          else "decor:h-[13px] decor:w-[13px]"
          end
        "decor:inline-block decor:shrink-0 #{sized}"
      end

      def modifier_classes
        [@full_width ? "decor:w-full decor:justify-center" : nil]
      end

      def style_color_classes
        case @style
        when :outlined then [outlined_classes]
        when :ghost then [ghost_classes]
        else [filled_classes]
        end
      end

      def filled_classes
        case @color
        when :primary
          "decor:bg-suite-primary-600 decor:text-white decor:border decor:border-transparent " \
            "decor:shadow-[inset_0_1px_0_rgba(255,255,255,0.14),inset_0_0_0_1px_rgba(20,24,31,0.08),0_2px_5px_0_rgba(20,24,31,0.08),0_1px_1px_0_rgba(0,0,0,0.05)] " \
            "decor:hover:shadow-[inset_0_1px_0_rgba(255,255,255,0.14),inset_0_0_0_1px_rgba(20,24,31,0.08),0_4px_10px_0_rgba(20,24,31,0.12),0_1px_2px_0_rgba(0,0,0,0.07)] " \
            "decor:active:shadow-[inset_0_1px_3px_0_rgba(20,24,31,0.12),inset_0_0_0_1px_rgba(20,24,31,0.1)] " \
            "decor:hover:bg-suite-primary-700 decor:active:bg-suite-primary-800"
        when :error
          "decor:bg-suite-danger-600 decor:text-white decor:border decor:border-transparent " \
            "decor:shadow-[inset_0_1px_0_rgba(255,255,255,0.14),inset_0_0_0_1px_rgba(20,24,31,0.08),0_2px_5px_0_rgba(20,24,31,0.08),0_1px_1px_0_rgba(0,0,0,0.05)] " \
            "decor:hover:shadow-[inset_0_1px_0_rgba(255,255,255,0.14),inset_0_0_0_1px_rgba(20,24,31,0.08),0_4px_10px_0_rgba(20,24,31,0.12),0_1px_2px_0_rgba(0,0,0,0.07)] " \
            "decor:active:shadow-[inset_0_1px_3px_0_rgba(20,24,31,0.12),inset_0_0_0_1px_rgba(20,24,31,0.1)] " \
            "decor:hover:bg-suite-danger-700"
        when :warning
          "decor:bg-suite-warning-50 decor:text-suite-warning-700 decor:border decor:border-transparent " \
            "decor:shadow-[inset_0_1px_0_rgba(255,255,255,0.14),inset_0_0_0_1px_rgba(20,24,31,0.08),0_2px_5px_0_rgba(20,24,31,0.08),0_1px_1px_0_rgba(0,0,0,0.05)] " \
            "decor:hover:shadow-[inset_0_1px_0_rgba(255,255,255,0.14),inset_0_0_0_1px_rgba(20,24,31,0.08),0_4px_10px_0_rgba(20,24,31,0.12),0_1px_2px_0_rgba(0,0,0,0.07)] " \
            "decor:active:shadow-[inset_0_1px_3px_0_rgba(20,24,31,0.12),inset_0_0_0_1px_rgba(20,24,31,0.1)] " \
            "decor:hover:bg-suite-warning-100"
        else # :base
          "decor:bg-white decor:text-gray-700 decor:border decor:border-suite-hairline-strong " \
            "decor:hover:bg-gray-50 decor:hover:border-suite-hairline-strong"
        end
      end

      def outlined_classes
        case @color
        when :error
          "decor:bg-white decor:text-suite-danger-700 decor:border decor:border-suite-danger-100 " \
            "decor:hover:bg-suite-danger-50 decor:hover:border-suite-danger-500"
        when :primary
          "decor:bg-white decor:text-suite-primary-700 decor:border decor:border-suite-primary-200 " \
            "decor:hover:bg-suite-primary-50 decor:hover:border-suite-primary-500"
        when :warning
          "decor:bg-white decor:text-suite-warning-700 decor:border decor:border-suite-warning-100 " \
            "decor:hover:bg-suite-warning-50 decor:hover:border-suite-warning-500"
        else # :base
          "decor:bg-white decor:text-gray-700 decor:border decor:border-suite-hairline-strong " \
            "decor:hover:bg-gray-50 decor:hover:border-suite-hairline-strong"
        end
      end

      def ghost_classes
        case @color
        when :primary
          "decor:bg-transparent decor:text-suite-primary-600 decor:border decor:border-transparent " \
            "decor:hover:bg-gray-100 decor:hover:text-suite-primary-700"
        when :error
          "decor:bg-transparent decor:text-suite-danger-700 decor:border decor:border-transparent " \
            "decor:hover:bg-gray-100 decor:hover:text-suite-danger-700"
        when :warning
          "decor:bg-transparent decor:text-suite-warning-700 decor:border decor:border-transparent " \
            "decor:hover:bg-gray-100 decor:hover:text-suite-warning-700"
        else # :base
          "decor:bg-transparent decor:text-gray-600 decor:border decor:border-transparent " \
            "decor:hover:bg-gray-100 decor:hover:text-gray-800"
        end
      end
    end
  end
end
