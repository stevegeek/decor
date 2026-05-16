# frozen_string_literal: true

module Decor
  module Suite
    # Suite ButtonLink — button-styled anchor with Suite visual identity.
    #
    # Renders as `<a>` for navigation; falls back to `<button disabled>` when
    # disabled. Shares the prop API with Button (label, icon, size, color,
    # style, full_width, disabled) plus the link concerns from the abstract
    # base (href, target, http_method, data, turbo_*).
    #
    # Suite chrome:
    #   - rounded-suite-control corners, suite-tuned padding per size
    #   - filled/outlined/ghost/soft styles using numbered Suite color tokens
    #   - duration-suite-fast transitions, focus ring via primary-100
    class ButtonLink < ::Decor::Components::ButtonLink
      default_size :md
      default_color :base
      default_style :filled

      def view_template(&)
        @content = capture(&).html_safe if block_given?
        root_element do
          span(class: "decor:inline-flex decor:items-center decor:justify-center decor:gap-1.5 decor:whitespace-nowrap") do
            render @before_label if @before_label.present?
            if @icon
              icon_options = {name: @icon, html_options: {class: icon_classes}}
              icon_options[:variant] = @icon_variant if @icon_variant
              render ::Decor::Icon.new(**icon_options)
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

      private

      def root_element_classes
        [
          "decor:inline-flex decor:items-center decor:justify-center decor:gap-1.5",
          "decor:font-medium decor:whitespace-nowrap decor:no-underline",
          "decor:transition-all decor:duration-suite-fast decor:ease-out",
          "decor:focus-visible:outline-hidden decor:focus-visible:shadow-[0_0_0_3px_var(--color-suite-primary-100)]",
          "decor:disabled:opacity-50 decor:disabled:cursor-not-allowed",
          "decor:aria-disabled:opacity-50 decor:aria-disabled:cursor-not-allowed decor:aria-disabled:pointer-events-none",
          *size_classes,
          *variant_classes,
          *modifier_classes
        ].compact.join(" ")
      end

      def icon_classes
        sized =
          case normalize_size(@size)
          when :xl then "decor:size-5"
          when :lg then "decor:size-4.5"
          when :md then "decor:size-4"
          when :sm then "decor:size-3.5"
          when :xs then "decor:size-3"
          else "decor:size-3.5"
          end
        "decor:inline-block decor:shrink-0 #{sized}"
      end

      def component_size_classes(size)
        case size
        when :xl
          ["decor:px-5 decor:py-2.5 decor:text-sm decor:rounded-suite-control"]
        when :lg
          ["decor:px-[18px] decor:py-[9px] decor:text-sm decor:rounded-suite-control"]
        when :md
          ["decor:px-3.5 decor:py-[7px] decor:text-[13px] decor:leading-[1.2] decor:rounded-suite-control"]
        when :sm
          ["decor:px-[11px] decor:py-[5px] decor:text-xs decor:leading-[1.2] decor:rounded-suite-control"]
        when :xs
          ["decor:px-[9px] decor:py-1 decor:text-[11px] decor:leading-[1.2] decor:rounded-suite-control"]
        else
          ["decor:px-[11px] decor:py-[5px] decor:text-xs decor:leading-[1.2] decor:rounded-suite-control"]
        end
      end

      def variant_classes
        case @style
        when :filled then filled_classes
        when :outlined then outlined_classes
        when :ghost then ghost_classes
        when :soft then soft_classes
        else filled_classes
        end
      end

      def filled_classes
        case @color
        when :primary, :info
          ["decor:bg-suite-primary-500 decor:text-white decor:border decor:border-transparent",
            "decor:hover:bg-suite-primary-600 decor:active:bg-suite-primary-700"]
        when :error
          ["decor:bg-suite-danger-500 decor:text-white decor:border decor:border-transparent",
            "decor:hover:bg-suite-danger-600 decor:active:bg-suite-danger-700"]
        when :warning
          ["decor:bg-suite-warning-50 decor:text-suite-warning-700 decor:border decor:border-transparent",
            "decor:hover:bg-suite-warning-100"]
        when :success
          ["decor:bg-suite-success-500 decor:text-white decor:border decor:border-transparent",
            "decor:hover:bg-suite-success-600 decor:active:bg-suite-success-700"]
        else
          ["decor:bg-white decor:text-gray-700 decor:border decor:border-suite-hairline-strong",
            "decor:hover:bg-suite-gray-25"]
        end
      end

      def outlined_classes
        case @color
        when :error
          ["decor:bg-white decor:text-suite-danger-700 decor:border decor:border-suite-danger-100",
            "decor:hover:bg-suite-danger-50 decor:hover:border-suite-danger-500"]
        when :primary, :info
          ["decor:bg-white decor:text-suite-primary-700 decor:border decor:border-suite-primary-200",
            "decor:hover:bg-suite-primary-50 decor:hover:border-suite-primary-500"]
        else
          ["decor:bg-white decor:text-gray-700 decor:border decor:border-suite-hairline-strong",
            "decor:hover:bg-suite-gray-25"]
        end
      end

      def ghost_classes
        case @color
        when :primary, :info
          ["decor:bg-transparent decor:text-suite-primary-700 decor:border decor:border-transparent",
            "decor:hover:bg-suite-primary-50"]
        when :error
          ["decor:bg-transparent decor:text-suite-danger-700 decor:border decor:border-transparent",
            "decor:hover:bg-suite-danger-50"]
        else
          ["decor:bg-transparent decor:text-gray-600 decor:border decor:border-transparent",
            "decor:hover:bg-suite-gray-25 decor:hover:text-gray-800"]
        end
      end

      def soft_classes
        case @color
        when :primary, :info
          ["decor:bg-suite-primary-50 decor:text-suite-primary-700 decor:border decor:border-suite-primary-100",
            "decor:hover:bg-suite-primary-100"]
        when :error
          ["decor:bg-suite-danger-50 decor:text-suite-danger-700 decor:border decor:border-suite-danger-100",
            "decor:hover:bg-suite-danger-100"]
        when :warning
          ["decor:bg-suite-warning-50 decor:text-suite-warning-700 decor:border decor:border-suite-warning-100",
            "decor:hover:bg-suite-warning-100"]
        when :success
          ["decor:bg-suite-success-50 decor:text-suite-success-700 decor:border decor:border-suite-success-100",
            "decor:hover:bg-suite-success-100"]
        else
          ["decor:bg-suite-gray-25 decor:text-gray-700 decor:border decor:border-suite-hairline",
            "decor:hover:bg-white"]
        end
      end

      def modifier_classes
        @full_width ? ["decor:w-full"] : []
      end
    end
  end
end
