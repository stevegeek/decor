# frozen_string_literal: true

module Decor
  module Daisy
    class LoadingBar < ::Decor::Components::LoadingBar
      def view_template
        root_element do
          if @label
            span(class: "decor:block decor:text-xs decor:font-medium decor:mb-1 #{label_color_class}") { @label }
          end
          if determinate?
            progress(
              class: "decor:d-progress decor:w-full #{progress_color_class} #{progress_size_class}",
              value: clamped_progress,
              max: 100,
              aria_label: "Progress: #{clamped_progress}% complete"
            )
          else
            div(class: "decor:relative decor:w-full decor:bg-base-200 decor:rounded-full decor:overflow-hidden #{track_height}") do
              div(
                class: "decor:absolute #{track_height} decor:rounded-full #{fill_color_class}",
                style: "animation: decor-daisy-loading-bar 1.8s cubic-bezier(0.65, 0, 0.35, 1) infinite;"
              )
            end
            style do
              safe "@keyframes decor-daisy-loading-bar{" \
                "0%{left:-40%;width:40%}" \
                "50%{left:30%;width:50%}" \
                "100%{left:100%;width:40%}" \
                "}"
            end
          end
        end
      end

      private

      def root_element_classes
        "decor:w-full"
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

      def progress_size_class
        case @size
        when :xs then "decor:d-progress-xs"
        when :sm then "decor:d-progress-sm"
        when :lg then "decor:d-progress-lg"
        else nil
        end
      end

      def progress_color_class
        case @color
        when :secondary then "decor:d-progress-secondary"
        when :accent then "decor:d-progress-accent"
        when :success then "decor:d-progress-success"
        when :warning then "decor:d-progress-warning"
        when :error then "decor:d-progress-error"
        when :info then "decor:d-progress-info"
        when :neutral, :base then "decor:d-progress-neutral"
        else "decor:d-progress-primary"
        end
      end

      def fill_color_class
        case @color
        when :secondary then "decor:bg-secondary"
        when :accent then "decor:bg-accent"
        when :success then "decor:bg-success"
        when :warning then "decor:bg-warning"
        when :error then "decor:bg-error"
        when :info then "decor:bg-info"
        when :neutral then "decor:bg-neutral"
        when :base then "decor:bg-base-content"
        else "decor:bg-primary"
        end
      end

      def label_color_class
        case @color
        when :secondary then "decor:text-secondary"
        when :accent then "decor:text-accent"
        when :success then "decor:text-success"
        when :warning then "decor:text-warning"
        when :error then "decor:text-error"
        when :info then "decor:text-info"
        when :neutral then "decor:text-neutral"
        when :base then "decor:text-base-content"
        else "decor:text-primary"
        end
      end
    end
  end
end
