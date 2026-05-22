# frozen_string_literal: true

module Decor
  module Suite
    class LoadingBar < ::Decor::Components::LoadingBar
      def view_template
        root_element do
          if @label
            span(class: "decor:block decor:suite-label decor:mb-1 #{label_color_class}") { @label }
          end
          div(class: "decor:relative #{track_classes}") do
            div(class: fill_classes, style: fill_style) do
              if animated? && determinate? && clamped_progress > 0
                span(
                  class: "decor:absolute decor:inset-0 #{track_radius} decor:overflow-hidden",
                  style: "background: repeating-linear-gradient(" \
                    "-45deg, transparent, transparent #{hatch_spacing}, rgba(255,255,255,0.2) #{hatch_spacing}, rgba(255,255,255,0.2) #{hatch_band}" \
                    "); background-size: #{hatch_tile} 100%; animation: decor-suite-bar-hatch 0.8s linear infinite;"
                )
              end
              if @show_percentage && determinate? && clamped_progress > 0
                span(class: "decor:absolute decor:inset-0 decor:flex decor:items-center decor:justify-center decor:text-white decor:font-semibold decor:drop-shadow-xs #{percentage_text_size}") do
                  plain "#{clamped_progress}%"
                end
              end
            end
          end
          if indeterminate?
            style do
              safe "@keyframes decor-suite-loading-bar{" \
                "0%{left:-40%;width:40%}" \
                "50%{left:30%;width:50%}" \
                "100%{left:100%;width:40%}" \
                "}"
            end
          end
          if animated? && determinate?
            style do
              safe "@keyframes decor-suite-bar-hatch{" \
                "0%{background-position:0 0}" \
                "100%{background-position:-#{hatch_tile} 0}" \
                "}"
            end
          end
        end
      end

      private

      def root_element_classes
        "decor:w-full"
      end

      def track_classes
        "decor:w-full decor:bg-gray-200 #{track_height} #{track_radius} decor:overflow-hidden"
      end

      def track_height
        case @size
        when :xs then "decor:h-1"
        when :sm then "decor:h-1.5"
        when :lg then "decor:h-3"
        when :xl then "decor:h-4"
        else "decor:h-2"
        end
      end

      def track_radius
        "decor:rounded-full"
      end

      def fill_classes
        base = "#{fill_color_class} #{track_height} #{track_radius}"
        if indeterminate?
          "decor:absolute #{base}"
        elsif animated?
          "decor:relative #{base} decor:overflow-hidden"
        else
          "decor:relative #{base}"
        end
      end

      def fill_style
        if indeterminate?
          "animation: decor-suite-loading-bar 1.8s cubic-bezier(0.65, 0, 0.35, 1) infinite;"
        else
          "width: #{clamped_progress}%; transition: width 500ms ease-out;"
        end
      end

      def fill_color_class
        case @color
        when :success then "decor:bg-suite-success-500"
        when :warning then "decor:bg-suite-warning-500"
        when :error then "decor:bg-suite-danger-500"
        when :neutral then "decor:bg-gray-600"
        when :base then "decor:bg-gray-900"
        else "decor:bg-suite-primary-500"
        end
      end

      def label_color_class
        case @color
        when :success then "decor:text-suite-success-700"
        when :warning then "decor:text-suite-warning-700"
        when :error then "decor:text-suite-danger-700"
        when :neutral then "decor:text-gray-700"
        when :base then "decor:text-gray-900"
        else "decor:text-suite-primary-700"
        end
      end

      def hatch_tile
        case @size
        when :xs, :sm then "12px"
        when :lg then "20px"
        when :xl then "24px"
        else "16px"
        end
      end

      def hatch_spacing
        case @size
        when :xs, :sm then "4px"
        when :lg then "8px"
        when :xl then "10px"
        else "6px"
        end
      end

      def hatch_band
        case @size
        when :xs, :sm then "8px"
        when :lg then "14px"
        when :xl then "17px"
        else "11px"
        end
      end

      def percentage_text_size
        case @size
        when :xs, :sm then "decor:text-[0px]"
        when :xl then "decor:suite-description"
        else "decor:text-[10px]"
        end
      end
    end
  end
end
