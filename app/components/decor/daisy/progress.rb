# frozen_string_literal: true

module Decor
  module Daisy
    class Progress < ::Decor::Components::Progress
      def view_template(&)
        vanish(&)
        root_element do
          case @style
          when :progress
            render_progress_bar
          when :steps, nil
            render_steps_indicator
          when :both
            render_progress_bar
            div(class: "decor:d-divider")
            render_steps_indicator
          end
        end
      end

      private

      def render_progress_bar
        progress(
          class: progress_classes,
          value: progress_value,
          max: "100",
          aria_label: "Progress: #{progress_value}% complete",
          data: {
            **stimulus_target(:progress)
          }
        )
      end

      def render_steps_indicator
        ul(class: steps_classes) do
          if @step_slots.any?
            @step_slots.each_with_index do |step_slot, idx|
              li(class: step_classes(idx), data: {content: step_data_content(idx), **stimulus_target(:step)}) do
                render step_slot
              end
            end
          else
            # Use default steps rendering
            @steps.each_with_index do |step, idx|
              li(class: step_classes(idx), data: {content: step_data_content(idx), **stimulus_target(:step)}) do
                if step.href.present? && step_completed?(idx)
                  a(href: step.href, class: "decor:text-sm decor:font-medium") { step_full_label(step) }
                else
                  span(class: "decor:text-sm decor:font-medium") { step_full_label(step) }
                end
              end
            end
          end
        end
      end

      def root_element_classes
        "decor:w-full"
      end

      def progress_classes
        classes = ["decor:d-progress", "decor:w-full"]
        classes << component_color_classes(@color)
        classes << component_size_classes(@size)
        classes << "decor:transition-all decor:duration-300"
        classes.compact.join(" ")
      end

      def steps_classes
        classes = ["decor:d-steps", "decor:w-full"]
        classes << "decor:d-steps-vertical" if @vertical
        classes.compact.join(" ")
      end

      def step_classes(index)
        classes = ["decor:d-step"]

        if step_completed?(index)
          classes << step_color_classes(@color)
        elsif step_current?(index)
          classes << step_color_classes(@color)
        end

        classes.join(" ")
      end

      def step_data_content(index)
        if step_completed?(index)
          "✓"
        elsif @show_numbers
          (index + 1).to_s
        else
          "…"
        end
      end

      def component_size_classes(size)
        case size
        when :xs then "decor:d-progress-xs"
        when :sm then "decor:d-progress-sm"
        when :lg then "decor:d-progress-lg"
        else []
        end
      end

      def component_color_classes(color)
        case color
        when :primary then "decor:d-progress-primary"
        when :secondary then "decor:d-progress-secondary"
        when :accent then "decor:d-progress-accent"
        when :success then "decor:d-progress-success"
        when :error then "decor:d-progress-error"
        when :warning then "decor:d-progress-warning"
        when :info then "decor:d-progress-info"
        when :neutral then "decor:d-progress-neutral"
        else []
        end
      end

      def step_color_classes(color)
        case color
        when :primary then "decor:d-step-primary"
        when :secondary then "decor:d-step-secondary"
        when :accent then "decor:d-step-accent"
        when :success then "decor:d-step-success"
        when :error then "decor:d-step-error"
        when :warning then "decor:d-step-warning"
        when :info then "decor:d-step-info"
        when :neutral then "decor:d-step-neutral"
        else ""
        end
      end
    end
  end
end
