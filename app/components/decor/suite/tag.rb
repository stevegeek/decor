# frozen_string_literal: true

module Decor
  module Suite
    # Suite Tag — pointed-nose silhouette tag with optional animated LED dot.
    #
    # Visual chrome:
    # - Body has right-side rounding (`rounded-r-md`); the nose covers the left.
    # - `::before` pseudo paints the triangular nose via clip-path.
    # - `::after` pseudo paints a small circular "hole" near the nose-body seam.
    # - When `@led && @icon.nil?`, a saturated colored dot leads the label.
    # - When `@icon.present?`, the icon takes precedence over the LED.
    # - When `@removable`, drops the nose+hole entirely and uses a pill+close-X.
    class Tag < ::Decor::Components::Tag
      # Show animated LED indicator dot (suppressed when icon is set).
      prop :led, _Boolean, default: true

      # data / action attributes for the remove button (e.g. { data: { action: "click->foo#remove" } }).
      prop :remove_options, Hash, default: -> { {} }

      def view_template(&block)
        root_element do
          if @removable
            render_removable_body(&block)
          else
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
          "decor:rounded-r-md decor:font-medium decor:leading-[1.4] decor:whitespace-nowrap",
          tag_spacing_class,
          variant_color_classes,
          nose_classes,
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
        end

        if block
          yield
        else
          plain(@label)
        end

        button(
          type: "button",
          class: "decor:inline-flex decor:items-center decor:justify-center decor:w-[14px] decor:h-[14px] decor:rounded-md decor:cursor-pointer decor:opacity-70 decor:hover:opacity-100 decor:hover:bg-black/5",
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
        "decor:inline-flex decor:items-center decor:gap-[3px] decor:px-[9px] decor:pr-[4px] decor:py-[3px] decor:rounded-md decor:text-xs decor:font-medium decor:leading-[1.4] decor:whitespace-nowrap decor:bg-primary/10 decor:border decor:border-primary/30 decor:text-primary"
      end

      # ── sizing ──────────────────────────────────────────────────────────────

      def size_padding_classes
        case @size
        when :xs, :sm then "decor:px-[9px] decor:py-[3px] decor:text-xs"
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
        else filled_muted_color_classes
        end
      end

      def filled_muted_color_classes
        case @color
        when :primary then "decor:bg-primary/10 decor:text-primary"
        when :success then "decor:bg-success/10 decor:text-success"
        when :warning then "decor:bg-warning/10 decor:text-warning"
        when :error then "decor:bg-error/10 decor:text-error"
        when :info then "decor:bg-info/10 decor:text-info"
        when :secondary then "decor:bg-secondary/10 decor:text-secondary"
        when :accent then "decor:bg-accent/10 decor:text-accent"
        else "decor:bg-base-200 decor:text-base-content"
        end
      end

      def outlined_color_classes
        case @color
        when :primary then "decor:bg-base-100 decor:border-y decor:border-r decor:border-primary/40 decor:text-primary"
        when :success then "decor:bg-base-100 decor:border-y decor:border-r decor:border-success/40 decor:text-success"
        when :warning then "decor:bg-base-100 decor:border-y decor:border-r decor:border-warning/40 decor:text-warning"
        when :error then "decor:bg-base-100 decor:border-y decor:border-r decor:border-error/40 decor:text-error"
        when :info then "decor:bg-base-100 decor:border-y decor:border-r decor:border-info/40 decor:text-info"
        when :secondary then "decor:bg-base-100 decor:border-y decor:border-r decor:border-secondary/40 decor:text-secondary"
        when :accent then "decor:bg-base-100 decor:border-y decor:border-r decor:border-accent/40 decor:text-accent"
        else "decor:bg-base-100 decor:border-y decor:border-r decor:border-black/15 decor:text-base-content"
        end
      end

      def led_color_classes
        # Saturated dot + halo (shadow at low alpha) for the active "indicator" feel.
        # Halo uses `shadow-{color}/20` — the standard Tailwind alpha-from-color
        # utility, which v4 resolves against the semantic color CSS var.
        case @color
        when :primary then "decor:bg-primary decor:shadow-[0_0_0_2px] decor:shadow-primary/20"
        when :success then "decor:bg-success decor:shadow-[0_0_0_2px] decor:shadow-success/20"
        when :warning then "decor:bg-warning decor:shadow-[0_0_0_2px] decor:shadow-warning/20"
        when :error then "decor:bg-error decor:shadow-[0_0_0_2px] decor:shadow-error/20"
        when :info then "decor:bg-info decor:shadow-[0_0_0_2px] decor:shadow-info/20"
        when :secondary then "decor:bg-secondary decor:shadow-[0_0_0_2px] decor:shadow-secondary/20"
        when :accent then "decor:bg-accent decor:shadow-[0_0_0_2px] decor:shadow-accent/20"
        else "decor:bg-base-content/40"
        end
      end

      # ── nose + hole pseudo-elements ─────────────────────────────────────────

      def nose_classes
        base = "decor:before:content-[''] decor:before:absolute decor:before:top-0 decor:before:h-full decor:before:bg-inherit decor:before:[clip-path:polygon(0_50%,100%_0,100%_100%)]"
        size = case @size
        when :xs, :sm then "decor:before:left-[-11px] decor:before:w-[11px]"
        when :lg, :xl then "decor:before:left-[-15px] decor:before:w-[15px]"
        else "decor:before:left-[-13px] decor:before:w-[13px]"
        end
        "#{base} #{size}"
      end

      def hole_classes
        base = "decor:after:content-[''] decor:after:absolute decor:after:top-1/2 decor:after:-translate-y-1/2 decor:after:rounded-full decor:after:bg-base-100 decor:after:border decor:after:border-black/15"
        size = case @size
        when :xs, :sm then "decor:after:left-[-2px] decor:after:w-[4px] decor:after:h-[4px]"
        else "decor:after:left-[-3px] decor:after:w-[5px] decor:after:h-[5px]"
        end
        "#{base} #{size}"
      end
    end
  end
end
