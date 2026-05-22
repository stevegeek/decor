# frozen_string_literal: true

module Decor
  module Suite
    class Tag < ::Decor::Components::Tag
      default_size :sm

      prop :led, _Boolean, default: true

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
          "decor:rounded-r-suite-control decor:font-medium decor:leading-[1.4] decor:whitespace-nowrap",
          tag_spacing_class,
          variant_color_classes,
          nose_classes,
          hole_classes
        ].compact.join(" ")
      end

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

      def variant_color_classes
        case @style
        when :outlined then outlined_color_classes
        else filled_color_classes
        end
      end

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

      # Drop the left border so the nose's diagonal edges sit flush with the body.
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

      # CSS borders don't follow clip-path, so the outlined nose stays borderless
      # by design; `bg-inherit` picks up the body bg seamlessly.
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
