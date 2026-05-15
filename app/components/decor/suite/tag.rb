# frozen_string_literal: true

module Decor
  module Suite
    # Suite Tag — pointed-nose silhouette tag with optional animated LED dot.
    #
    # Visual chrome:
    # - Body has right-side rounding (`rounded-r-suite-control`); the nose
    #   covers the left.
    # - `::before` pseudo paints the triangular nose via clip-path.
    # - `::after` pseudo paints a small circular "hole" near the nose-body seam.
    # - When `@led && @icon.nil?`, a saturated colored dot leads the label.
    # - When `@icon.present?`, the icon takes precedence over the LED.
    # - When `@removable`, drops the nose+hole entirely and uses a pill+close-X.
    class Tag < ::Decor::Components::Tag
      # Suite defaults match ConfinusUI::Tag (size :small).
      default_size :sm

      # Show animated LED indicator dot (suppressed when icon is set).
      prop :led, _Boolean, default: true

      # data / action attributes for the remove button (e.g. { data: { action: "click->foo#remove" } }).
      prop :remove_options, Hash, default: -> { {} }

      def view_template(&block)
        root_element do
          if @removable
            render_removable_body(&block)
          else
            render_nose_svg
            render_standard_body(&block)
          end
        end
      end

      private

      def root_element_attributes
        {element_tag: :span}
      end

      def root_element_classes
        return removable_root_classes if @removable

        [
          "decor:relative decor:inline-flex decor:items-center decor:gap-[6px]",
          size_padding_classes,
          "decor:rounded-r-suite-control decor:font-medium decor:leading-[1.4] decor:whitespace-nowrap",
          tag_spacing_class,
          variant_color_classes,
          hole_classes
        ].compact.join(" ")
      end

      # ── standard (nose+hole) body ───────────────────────────────────────────

      def render_standard_body(&block)
        if @icon.present?
          render ::Decor::Icon.new(
            name: @icon,
            style: :solid,
            html_options: {class: "decor:shrink-0 decor:opacity-70 #{icon_size_classes}"}
          )
        elsif @led
          span(class: "decor:shrink-0 decor:rounded-full #{led_size_classes} #{led_color_classes}")
        end

        if block
          yield
        else
          plain(@label)
        end
      end

      # ── removable variant ───────────────────────────────────────────────────

      def render_removable_body(&block)
        if @icon.present?
          render ::Decor::Icon.new(
            name: @icon,
            style: :solid,
            html_options: {class: "decor:shrink-0 decor:opacity-70 #{icon_size_classes}"}
          )
        elsif @led
          span(class: "decor:shrink-0 decor:rounded-full #{led_size_classes} #{led_color_classes}")
        end

        if block
          yield
        else
          plain(@label)
        end

        button(
          type: "button",
          class: "decor:inline-flex decor:items-center decor:justify-center decor:w-[14px] decor:h-[14px] decor:rounded-suite-control decor:cursor-pointer decor:opacity-70 decor:hover:opacity-100 decor:hover:bg-black/5 decor:duration-suite-fast",
          **@remove_options
        ) do
          render ::Decor::Icon.new(
            name: "x",
            style: :outline,
            html_options: {class: "decor:w-3 decor:h-3"}
          )
        end
      end

      def removable_root_classes
        "decor:inline-flex decor:items-center decor:gap-[3px] decor:px-[9px] decor:pr-[4px] decor:py-[3px] decor:rounded-suite-control decor:suite-description decor:font-medium decor:leading-[1.4] decor:whitespace-nowrap decor:bg-suite-primary-50 decor:border decor:border-suite-primary-200 decor:text-suite-primary-800"
      end

      # ── sizing ──────────────────────────────────────────────────────────────

      def size_padding_classes
        case @size
        when :xs, :sm then "decor:px-[9px] decor:py-[3px] decor:suite-description"
        when :lg, :xl then "decor:px-3.5 decor:py-1 decor:text-sm"
        else "decor:px-3 decor:py-1 decor:text-xs" # :md
        end
      end

      # Left margin to reserve space for the nose protrusion.
      def tag_spacing_class
        case @size
        when :xs, :sm then "decor:ml-[11px]"
        when :lg, :xl then "decor:ml-[15px]"
        else "decor:ml-[13px]" # :md
        end
      end

      def led_size_classes
        case @size
        when :xs, :sm then "decor:w-[6px] decor:h-[6px]"
        when :lg, :xl then "decor:w-2 decor:h-2"
        else "decor:w-[7px] decor:h-[7px]" # :md
        end
      end

      def icon_size_classes
        case @size
        when :xs, :sm then "decor:w-[11px] decor:h-[11px]"
        when :lg, :xl then "decor:w-3.5 decor:h-3.5"
        else "decor:w-3 decor:h-3" # :md
        end
      end

      # ── colors ──────────────────────────────────────────────────────────────

      def variant_color_classes
        case @style
        when :outlined then outlined_color_classes
        else filled_color_classes
        end
      end

      # Filled: pale-50 bg + dark-700 text (Suite palette). `:info` aliases to
      # primary in the Suite palette.
      def filled_color_classes
        case @color
        when :primary then "decor:bg-suite-primary-50 decor:text-suite-primary-700"
        when :success then "decor:bg-suite-success-50 decor:text-suite-success-700"
        when :warning then "decor:bg-suite-warning-50 decor:text-suite-warning-700"
        when :error then "decor:bg-suite-danger-50 decor:text-suite-danger-700"
        when :info then "decor:bg-suite-primary-50 decor:text-suite-primary-700"
        else "decor:bg-gray-100 decor:text-gray-700"
        end
      end

      # Outlined drops the left border so the nose's diagonal edges sit flush
      # with the body — the nose itself is borderless.
      def outlined_color_classes
        case @color
        when :primary then "decor:bg-white decor:border-y decor:border-r decor:border-suite-primary-200 decor:text-suite-primary-700"
        when :success then "decor:bg-white decor:border-y decor:border-r decor:border-suite-success-100 decor:text-suite-success-700"
        when :warning then "decor:bg-white decor:border-y decor:border-r decor:border-suite-warning-100 decor:text-suite-warning-700"
        when :error then "decor:bg-white decor:border-y decor:border-r decor:border-suite-danger-100 decor:text-suite-danger-700"
        when :info then "decor:bg-white decor:border-y decor:border-r decor:border-suite-primary-200 decor:text-suite-primary-700"
        else "decor:bg-white decor:border-y decor:border-r decor:border-suite-hairline-strong decor:text-gray-700"
        end
      end

      # Saturated dot + halo (shadow at low alpha) for the active "indicator"
      # feel. Neutral/default gets a plain gray dot with no halo.
      def led_color_classes
        case @color
        when :primary then "decor:bg-suite-primary-500 decor:shadow-[0_0_0_2px] decor:shadow-suite-primary-500/20"
        when :success then "decor:bg-suite-success-500 decor:shadow-[0_0_0_2px] decor:shadow-suite-success-500/20"
        when :warning then "decor:bg-suite-warning-500 decor:shadow-[0_0_0_2px] decor:shadow-suite-warning-500/20"
        when :error then "decor:bg-suite-danger-500 decor:shadow-[0_0_0_2px] decor:shadow-suite-danger-500/20"
        when :info then "decor:bg-suite-primary-500 decor:shadow-[0_0_0_2px] decor:shadow-suite-primary-500/20"
        else "decor:bg-gray-400"
        end
      end

      # ── nose + hole pseudo-elements ─────────────────────────────────────────

      # Inline SVG nose. Renders a leftward-pointing triangle absolutely
      # positioned to the left of the body. Uses `vector-effect: non-scaling-
      # stroke` so the 1px outline holds at any tag height. The closing-Z of
      # the path produces a vertical line at the nose's right edge — that line
      # visually completes the body's left side (body itself has only
      # border-y/border-r). For filled variant the stroke is hidden via
      # `stroke-transparent`; for outlined it carries the matching `{color}-
      # 100/-200` shade so the tag reads as a complete bordered shape.
      def render_nose_svg
        w = nose_width_px
        raw safe(<<~SVG)
          <svg xmlns="http://www.w3.org/2000/svg"
               viewBox="0 0 #{w} 100"
               preserveAspectRatio="none"
               aria-hidden="true"
               class="decor:absolute decor:top-0 decor:h-full decor:left-[-#{w}px] decor:w-[#{w}px] decor:pointer-events-none #{nose_svg_color_classes}">
            <path d="M#{w} 0 L0 50 L#{w} 100 Z" vector-effect="non-scaling-stroke" stroke-width="1"/>
          </svg>
        SVG
      end

      def nose_width_px
        case @size
        when :xs, :sm then 11
        when :lg, :xl then 15
        else 13
        end
      end

      def nose_svg_color_classes
        if @style == :outlined
          case @color
          when :primary, :info then "decor:fill-white decor:stroke-suite-primary-200"
          when :success then "decor:fill-white decor:stroke-suite-success-100"
          when :warning then "decor:fill-white decor:stroke-suite-warning-100"
          when :error then "decor:fill-white decor:stroke-suite-danger-100"
          else "decor:fill-white decor:stroke-suite-hairline-strong"
          end
        else
          case @color
          when :primary, :info then "decor:fill-suite-primary-50 decor:stroke-transparent"
          when :success then "decor:fill-suite-success-50 decor:stroke-transparent"
          when :warning then "decor:fill-suite-warning-50 decor:stroke-transparent"
          when :error then "decor:fill-suite-danger-50 decor:stroke-transparent"
          else "decor:fill-gray-100 decor:stroke-transparent"
          end
        end
      end

      def hole_classes
        base = "decor:after:content-[''] decor:after:absolute decor:after:top-1/2 decor:after:-translate-y-1/2 decor:after:rounded-full decor:after:bg-white decor:after:border decor:after:border-suite-hairline"
        size = case @size
        when :xs, :sm then "decor:after:left-[-2px] decor:after:w-[4px] decor:after:h-[4px]"
        else "decor:after:left-[-3px] decor:after:w-[5px] decor:after:h-[5px]"
        end
        "#{base} #{size}"
      end
    end
  end
end
