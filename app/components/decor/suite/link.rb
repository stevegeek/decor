# frozen_string_literal: true

module Decor
  module Suite
    # Suite Link — styled inline text link.
    #
    # Renders as `<a>`. Unlike ButtonLink, this is a chrome-less inline link:
    # colored text + hover underline + focus halo, no padding, no background.
    #
    # Suite chrome:
    #   - suite-primary-700 text by default, hover suite-primary-800
    #   - underline on hover, with a smooth duration-suite-fast color
    #     transition
    #   - focus-visible halo via primary-100 (matches Button/ButtonLink)
    class Link < ::Decor::Components::Link
      redefine_colors :base, :primary, :error, :warning, :success
      redefine_sizes :xs, :sm, :md, :lg, :xl

      default_color :primary
      default_size :md
      default_style :ghost

      def view_template(&)
        @content = capture(&).html_safe if block_given?
        root_element do
          if @icon
            icon_options = {name: @icon, html_options: {class: icon_classes}}
            icon_options[:variant] = @icon_variant if @icon_variant
            render ::Decor::Icon.new(**icon_options)
          end
          if @content
            raw @content
          elsif @label.present?
            plain @label
          end
        end
      end

      private

      def root_element_classes
        [
          "decor:inline-flex decor:items-center decor:gap-1",
          "decor:font-medium decor:no-underline decor:hover:underline",
          "decor:transition-colors decor:duration-suite-fast decor:ease-out",
          "decor:focus-visible:outline-hidden decor:focus-visible:shadow-[0_0_0_3px_var(--color-suite-primary-100)] decor:focus-visible:rounded-suite-control",
          "decor:aria-disabled:opacity-50 decor:aria-disabled:cursor-not-allowed decor:aria-disabled:pointer-events-none decor:aria-disabled:no-underline",
          *size_classes,
          *color_text_classes,
          *modifier_classes
        ].compact.join(" ")
      end

      def color_text_classes
        case @color
        when :primary
          ["decor:text-suite-primary-700 decor:hover:text-suite-primary-800"]
        when :error
          ["decor:text-suite-danger-700 decor:hover:text-suite-danger-800"]
        when :warning
          ["decor:text-suite-warning-700 decor:hover:text-suite-warning-800"]
        when :success
          ["decor:text-suite-success-700 decor:hover:text-suite-success-800"]
        else # :base
          ["decor:text-gray-700 decor:hover:text-gray-900"]
        end
      end

      def component_size_classes(size)
        case size
        when :xl then ["decor:text-base"]
        when :lg then ["decor:text-sm"]
        when :md then ["decor:text-[13px] decor:leading-[1.2]"]
        when :sm then ["decor:text-xs decor:leading-[1.2]"]
        when :xs then ["decor:text-[11px] decor:leading-[1.2]"]
        else ["decor:text-[13px] decor:leading-[1.2]"]
        end
      end

      def icon_classes
        sized =
          case normalize_size(@size)
          when :xl then "decor:size-5"
          when :lg then "decor:size-4"
          when :md then "decor:size-3.5"
          when :sm then "decor:size-3"
          when :xs then "decor:size-[11px]"
          else "decor:size-3.5"
          end
        "decor:inline-block decor:shrink-0 #{sized}"
      end

      def modifier_classes
        @full_width ? ["decor:w-full"] : []
      end
    end
  end
end
