# frozen_string_literal: true

module Decor
  module Suite
    class Progress < ::Decor::Components::Progress
      def view_template(&)
        vanish(&)
        root_element do
          case @style
          when :progress
            render_progress_bar
          when :both
            render_progress_bar
            div(class: "decor:my-3 decor:border-t decor:border-suite-hairline")
            render_steps_indicator
          else # :steps or nil
            render_steps_indicator
          end
        end
      end

      private

      def root_element_classes
        "decor:w-full decor:bg-white"
      end

      def render_progress_bar
        div(
          class: "decor:w-full decor:overflow-hidden decor:rounded-full #{bar_height_classes} #{bar_track_classes}",
          role: "progressbar",
          aria_valuenow: progress_value.to_s,
          aria_valuemin: "0",
          aria_valuemax: "100",
          aria_label: "Progress: #{progress_value}% complete",
          data: stimulus_target(:progress)
        ) do
          div(
            class: "decor:h-full decor:rounded-full decor:transition-all decor:duration-suite-base decor:ease-out #{bar_fill_classes}",
            style: "width: #{progress_value}%;"
          )
        end
      end

      def bar_height_classes
        case @size
        when :xs then "decor:h-1"
        when :sm then "decor:h-1.5"
        when :lg then "decor:h-3"
        when :xl then "decor:h-4"
        else "decor:h-2"
        end
      end

      def bar_track_classes
        case @color
        when :success then "decor:bg-suite-success-50"
        when :warning then "decor:bg-suite-warning-50"
        when :error, :danger then "decor:bg-suite-danger-50"
        when :neutral, :secondary then "decor:bg-gray-100"
        else "decor:bg-suite-primary-50"
        end
      end

      def bar_fill_classes
        case @color
        when :success then "decor:bg-suite-success-500"
        when :warning then "decor:bg-suite-warning-500"
        when :error, :danger then "decor:bg-suite-danger-500"
        when :neutral, :secondary then "decor:bg-gray-500"
        else "decor:bg-suite-primary-500"
        end
      end

      def render_steps_indicator
        item_count = @step_slots.any? ? @step_slots.size : @steps.size

        nav(class: "decor:mx-auto decor:max-w-7xl", aria_label: "Progress") do
          ol(
            role: "list",
            class: container_classes
          ) do
            item_count.times do |idx|
              render_step_li(idx, item_count)
            end
          end
        end
      end

      def container_classes
        if @vertical
          "decor:flex decor:flex-col decor:gap-5"
        else
          "decor:flex decor:flex-col decor:gap-5 decor:lg:flex-row decor:lg:items-start decor:lg:gap-4"
        end
      end

      def render_step_li(idx, total)
        is_first = idx.zero?
        is_last = idx == total - 1
        state = step_state(idx)
        step = @steps[idx]

        li(
          class: li_classes,
          data: stimulus_target(:step)
        ) do
          div(class: head_classes) do
            span(class: "decor:hidden decor:lg:flex decor:flex-1 decor:items-center decor:justify-end decor:gap-[13px] decor:mr-2", aria_hidden: "true") do
              render_dots(connector_color_before(idx)) unless is_first
            end

            render_marker(idx, state)

            span(class: "decor:hidden decor:lg:flex decor:flex-1 decor:items-center decor:justify-start decor:gap-[13px] decor:ml-2", aria_hidden: "true") do
              render_dots(connector_color_after(idx)) unless is_last
            end

            unless is_last
              span(class: "decor:flex decor:flex-col decor:items-center decor:gap-[13px] decor:py-2 decor:lg:hidden", aria_hidden: "true") do
                render_dots(connector_color_after(idx))
              end
            end
          end

          if step
            render_labels(step, state)
          elsif @step_slots[idx]
            render @step_slots[idx]
          end
        end
      end

      def li_classes
        if @vertical
          "decor:flex decor:items-start decor:gap-3 decor:min-w-0"
        else
          "decor:flex decor:items-start decor:gap-3 decor:lg:flex-col decor:lg:items-center decor:lg:text-center decor:lg:flex-1 decor:min-w-0"
        end
      end

      def head_classes
        if @vertical
          "decor:flex decor:flex-col decor:items-center decor:shrink-0"
        else
          "decor:flex decor:flex-col decor:items-center decor:shrink-0 decor:lg:flex-row decor:lg:w-full decor:lg:items-center"
        end
      end

      def step_state(idx)
        if @current_step > idx + 1
          :completed
        elsif @current_step == idx + 1
          :current
        else
          :upcoming
        end
      end

      def render_marker(idx, state)
        span(
          class: marker_classes(state),
          aria_hidden: (state == :current) ? nil : "true"
        ) do
          if state == :completed
            render_check_icon
          elsif @show_numbers
            plain (idx + 1).to_s
          else
            plain "·"
          end
        end
      end

      def marker_classes(state)
        base = "decor:shrink-0 decor:inline-flex decor:items-center decor:justify-center decor:rounded-full decor:font-semibold decor:tabular-nums decor:transition-colors decor:duration-suite-fast decor:ease-out "
        base += "#{marker_size_classes} "
        base += marker_state_classes(state)
        base
      end

      def marker_size_classes
        case @size
        when :xs then "decor:w-6 decor:h-6 decor:text-[11px]"
        when :sm then "decor:w-7 decor:h-7 decor:text-xs"
        when :lg then "decor:w-10 decor:h-10 decor:text-sm"
        when :xl then "decor:w-12 decor:h-12 decor:text-base"
        else "decor:w-8 decor:h-8 decor:suite-dense-body"
        end
      end

      def marker_state_classes(state)
        saturated = saturated_color_class
        muted_text = muted_text_class
        case state
        when :completed
          "decor:text-white decor:border #{saturated.sub("bg-", "border-")} #{saturated}"
        when :current
          "decor:bg-white #{muted_text} decor:border-2 #{saturated.sub("bg-", "border-")}"
        else
          "decor:bg-white decor:text-gray-500 decor:border decor:border-suite-hairline-strong"
        end
      end

      def saturated_color_class
        case @color
        when :success then "decor:bg-suite-success-500"
        when :warning then "decor:bg-suite-warning-500"
        when :error, :danger then "decor:bg-suite-danger-500"
        when :neutral, :secondary then "decor:bg-gray-500"
        else "decor:bg-suite-primary-500"
        end
      end

      def muted_text_class
        case @color
        when :success then "decor:text-suite-success-700"
        when :warning then "decor:text-suite-warning-700"
        when :error, :danger then "decor:text-suite-danger-700"
        when :neutral, :secondary then "decor:text-gray-700"
        else "decor:text-suite-primary-700"
        end
      end

      def render_check_icon
        raw safe(<<~SVG)
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 12 10" width="12" height="10" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true" class="decor:text-white">
            <path d="M1 5.5 L4.5 9 L11 1"/>
          </svg>
        SVG
      end

      def render_dots(color_class)
        3.times do
          span(class: "decor:block decor:w-[5px] decor:h-[5px] decor:rounded-full #{color_class}")
        end
      end

      def connector_color_before(idx)
        (@current_step > idx) ? connector_active_class : "decor:bg-suite-hairline-strong"
      end

      def connector_color_after(idx)
        (@current_step > idx + 1) ? connector_active_class : "decor:bg-suite-hairline-strong"
      end

      def connector_active_class
        case @color
        when :success then "decor:bg-suite-success-500"
        when :warning then "decor:bg-suite-warning-500"
        when :error, :danger then "decor:bg-suite-danger-500"
        when :neutral, :secondary then "decor:bg-gray-400"
        else "decor:bg-suite-primary-400"
        end
      end

      def render_labels(step, state)
        container_classes = if @vertical
          "decor:min-w-0 decor:flex-1 decor:flex decor:flex-col"
        else
          "decor:min-w-0 decor:flex-1 decor:lg:flex-none decor:lg:mt-2 decor:flex decor:flex-col"
        end

        label_classes = "decor:suite-dense-body decor:leading-[1.3] decor:font-semibold decor:tracking-[0.01em] #{label_state_classes(state)}"
        desc_classes = "decor:suite-description decor:text-gray-500 decor:mt-0.5"

        if step.href.present?
          a(
            href: step.href,
            class: "#{container_classes} decor:rounded-suite-control decor:hover:no-underline decor:focus:outline-hidden decor:focus-visible:shadow-[0_0_0_3px_var(--color-suite-primary-100,#dbeafe)] decor:transition-shadow decor:duration-suite-fast decor:ease-out",
            aria: (state == :current) ? {current: "step"} : {}
          ) do
            span(class: label_classes) { step_label(step) }
            if has_description?(step)
              span(class: desc_classes) { step_description(step) }
            end
          end
        else
          div(
            class: container_classes,
            aria: (state == :current) ? {current: "step"} : {}
          ) do
            span(class: label_classes) { step_label(step) }
            if has_description?(step)
              span(class: desc_classes) { step_description(step) }
            end
          end
        end
      end

      def label_state_classes(state)
        case state
        when :current then muted_text_class
        when :completed then "decor:text-gray-900"
        else "decor:text-gray-500"
        end
      end
    end
  end
end
