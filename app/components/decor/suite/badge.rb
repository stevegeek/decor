# frozen_string_literal: true

module Decor
  module Suite
    # Suite Badge — pill-shaped status/classification chip with a muted palette
    # and an optional animated halo dot.
    #
    # Visual chrome:
    # - `inline-flex` pill with rounded-full corners; size knob drives padding +
    #   text-size only (no shape change).
    # - Default ("filled") visual = muted `bg-{color}/10 text-{color}` — same
    #   pattern as Suite::Tag/Banner/Flash; reads as a low-noise indicator.
    # - `style: :outlined` swaps to `bg-base-100 border border-{color}/30`.
    # - `dot: true` prefixes the label with a saturated colored dot wrapped in
    #   a `shadow-{color}/20` halo (Tailwind v4 alpha-from-color resolves the
    #   semantic var). Falls back to a plain dot if the halo doesn't render.
    # - `icon:` renders a Decor::Icon prefix; suppressed when `dot:` is set.
    class Badge < ::Decor::Components::Badge
      # Suite default is muted-filled; base Components::Badge defaults to :outlined.
      default_style :filled

      # Show an animated halo indicator dot before the label (suppressed when
      # an icon is set).
      prop :dot, _Boolean, default: false

      def view_template(&block)
        root_element do
          if @dot
            span(class: "decor:shrink-0 decor:w-[6px] decor:h-[6px] decor:rounded-full #{dot_color_classes}")
          elsif @icon.present?
            render ::Decor::Icon.new(
              name: @icon,
              style: :solid,
              html_options: {class: "decor:shrink-0 #{icon_size_classes} #{icon_color_classes}"}
            )
          end

          if block
            yield
          else
            plain(@label)
          end
        end
      end

      private

      def root_element_attributes
        {element_tag: :span}
      end

      def root_element_classes
        [
          "decor:inline-flex decor:items-center decor:rounded-full",
          "decor:font-medium decor:leading-[1.4] decor:whitespace-nowrap",
          gap_class,
          size_padding_classes,
          variant_color_classes
        ].join(" ")
      end

      # ── sizing ────────────────────────────────────────────────────────────

      # Gap + paddings + icon sizes mirror the historical ConfinusUI::Badge
      # measurements so visual parity holds when callers migrate to the Suite
      # skin. `:md` (default) maps to ConfinusUI's `small`; `:lg`+ maps to
      # ConfinusUI's `large`.
      def gap_class
        case @size
        when :lg, :xl then "decor:gap-1.5"
        else "decor:gap-[5px]" # xs/sm/md
        end
      end

      def size_padding_classes
        case @size
        when :lg, :xl then "decor:px-2.5 decor:py-[3px] decor:text-xs"
        else "decor:px-2 decor:py-[2px] decor:text-xs" # xs/sm/md
        end
      end

      def icon_size_classes
        case @size
        when :lg, :xl then "decor:w-3 decor:h-3"
        else "decor:w-[10px] decor:h-[10px]" # xs/sm/md
        end
      end

      # ── colors ────────────────────────────────────────────────────────────

      def variant_color_classes
        case @style
        when :outlined then outlined_color_classes
        else filled_muted_color_classes
        end
      end

      def filled_muted_color_classes
        case @color
        when :primary, :info then "decor:bg-info/10 decor:text-info"
        when :success then "decor:bg-success/10 decor:text-success"
        when :warning then "decor:bg-warning/10 decor:text-warning"
        when :error then "decor:bg-error/10 decor:text-error"
        when :secondary then "decor:bg-secondary/10 decor:text-secondary"
        when :accent then "decor:bg-accent/10 decor:text-accent"
        else "decor:bg-base-200 decor:text-base-content"
        end
      end

      def outlined_color_classes
        case @color
        when :primary, :info then "decor:bg-base-100 decor:border decor:border-info/30 decor:text-info"
        when :success then "decor:bg-base-100 decor:border decor:border-success/30 decor:text-success"
        when :warning then "decor:bg-base-100 decor:border decor:border-warning/30 decor:text-warning"
        when :error then "decor:bg-base-100 decor:border decor:border-error/30 decor:text-error"
        when :secondary then "decor:bg-base-100 decor:border decor:border-secondary/30 decor:text-secondary"
        when :accent then "decor:bg-base-100 decor:border decor:border-accent/30 decor:text-accent"
        else "decor:bg-base-100 decor:border decor:border-black/15 decor:text-base-content"
        end
      end

      # Saturated dot + halo. Halo uses `shadow-{color}/20` — Tailwind v4
      # alpha-from-color, same two-utility pattern as Suite::Tag's LED.
      def dot_color_classes
        case @color
        when :primary, :info then "decor:bg-info decor:shadow-[0_0_0_2px] decor:shadow-info/20"
        when :success then "decor:bg-success decor:shadow-[0_0_0_2px] decor:shadow-success/20"
        when :warning then "decor:bg-warning decor:shadow-[0_0_0_2px] decor:shadow-warning/20"
        when :error then "decor:bg-error decor:shadow-[0_0_0_2px] decor:shadow-error/20"
        when :secondary then "decor:bg-secondary decor:shadow-[0_0_0_2px] decor:shadow-secondary/20"
        when :accent then "decor:bg-accent decor:shadow-[0_0_0_2px] decor:shadow-accent/20"
        else "decor:bg-base-content/40"
        end
      end

      def icon_color_classes
        case @color
        when :primary, :info then "decor:text-info"
        when :success then "decor:text-success"
        when :warning then "decor:text-warning"
        when :error then "decor:text-error"
        when :secondary then "decor:text-secondary"
        when :accent then "decor:text-accent"
        else "decor:text-base-content"
        end
      end
    end
  end
end
