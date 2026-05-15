# frozen_string_literal: true

module Decor
  module Suite
    # Suite Badge — pill-shaped status/classification chip with a muted palette
    # and an optional animated halo dot.
    #
    # Visual chrome:
    # - `inline-flex` pill with rounded-full corners; size knob drives padding +
    #   gap only (no shape change). Default typography comes from
    #   `suite-description` on the root.
    # - Default ("filled") visual = pale-50 bg + dark-700 text from the Suite
    #   palette.
    # - `style: :outlined` swaps to `bg-white border` with a `suite-{color}-100`
    #   (or `-200` for primary) border.
    # - `dot: true` prefixes the label with a saturated colored dot wrapped in
    #   a low-alpha halo (`shadow-suite-{color}-500/20`).
    # - `icon:` renders a Decor::Icon prefix; suppressed when `dot:` is set.
    class Badge < ::Decor::Components::Badge
      # Suite default is muted-filled; base Components::Badge defaults to :outlined.
      default_style :filled

      # Suite default size matches ConfinusUI::Badge's :small.
      default_size :sm

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
          "decor:suite-description",
          gap_class,
          size_padding_classes,
          variant_color_classes
        ].join(" ")
      end

      # ── sizing ────────────────────────────────────────────────────────────

      # Gap + paddings + icon sizes mirror the historical ConfinusUI::Badge
      # measurements so visual parity holds when callers migrate to the Suite
      # skin. `:sm` (default) maps to ConfinusUI's `small`; `:lg`+ maps to
      # ConfinusUI's `large`.
      def gap_class
        case @size
        when :lg, :xl then "decor:gap-1.5"
        else "decor:gap-[5px]" # xs/sm/md
        end
      end

      def size_padding_classes
        case @size
        when :lg, :xl then "decor:px-2.5 decor:py-[3px]"
        else "decor:px-2 decor:py-[2px]" # xs/sm/md
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

      # Filled: pale-50 bg + dark-700 text from the Suite palette.
      def filled_muted_color_classes
        case @color
        when :primary, :info then "decor:bg-suite-primary-50 decor:text-suite-primary-700"
        when :success then "decor:bg-suite-success-50 decor:text-suite-success-700"
        when :warning then "decor:bg-suite-warning-50 decor:text-suite-warning-700"
        when :error then "decor:bg-suite-danger-50 decor:text-suite-danger-700"
        else "decor:bg-gray-100 decor:text-gray-700"
        end
      end

      # Outlined: white bg + numbered-100 border (200 for primary) + dark-700 text.
      # Neutral falls back to the hairline-strong token + gray-700 text.
      def outlined_color_classes
        case @color
        when :primary, :info then "decor:bg-white decor:border decor:border-suite-primary-200 decor:text-suite-primary-700"
        when :success then "decor:bg-white decor:border decor:border-suite-success-100 decor:text-suite-success-700"
        when :warning then "decor:bg-white decor:border decor:border-suite-warning-100 decor:text-suite-warning-700"
        when :error then "decor:bg-white decor:border decor:border-suite-danger-100 decor:text-suite-danger-700"
        else "decor:bg-white decor:border decor:border-suite-hairline-strong decor:text-gray-700"
        end
      end

      # Saturated dot + halo. Neutral/default gets a plain gray dot with no halo.
      def dot_color_classes
        case @color
        when :primary, :info then "decor:bg-suite-primary-500 decor:shadow-[0_0_0_2px] decor:shadow-suite-primary-500/20"
        when :success then "decor:bg-suite-success-500 decor:shadow-[0_0_0_2px] decor:shadow-suite-success-500/20"
        when :warning then "decor:bg-suite-warning-500 decor:shadow-[0_0_0_2px] decor:shadow-suite-warning-500/20"
        when :error then "decor:bg-suite-danger-500 decor:shadow-[0_0_0_2px] decor:shadow-suite-danger-500/20"
        else "decor:bg-gray-400"
        end
      end

      # Icon: one shade lighter than body text (Confinus convention).
      def icon_color_classes
        case @color
        when :primary, :info then "decor:text-suite-primary-600"
        when :success then "decor:text-suite-success-600"
        when :warning then "decor:text-suite-warning-600"
        when :error then "decor:text-suite-danger-600"
        else "decor:text-gray-500"
        end
      end
    end
  end
end
