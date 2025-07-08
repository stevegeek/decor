# frozen_string_literal: true

module Decor
  class Progress < PhlexComponent
    class ProgressItem < ::Literal::Data
      prop :label_key, String
      prop :href, _Nilable(String)
    end

    prop :steps, _Array(ProgressItem), default: -> { [] } do |items|
      items.map { |item| item.is_a?(ProgressItem) ? item : ProgressItem.new(item) }
    end
    prop :i18n_key, _Nilable(String)
    prop :current_step, Integer, default: 1
    prop :color, _Union(:primary, :secondary, :accent, :success, :error, :warning, :info), default: :primary
    prop :size, _Union(:xs, :sm, :md, :lg), default: :md
    prop :variant, _Union(:steps, :progress, :both), default: :steps
    prop :show_numbers, _Boolean, default: true
    prop :vertical, _Boolean, default: false

    stimulus do
      values_from_props :current_step
      values total_steps: -> { @steps.size }
    end

    def view_template
      root_element do
        case @variant
        when :progress
          render_progress_bar
        when :steps
          render_steps_indicator
        when :both
          render_progress_bar
          div(class: "divider")
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
        @steps.each_with_index do |step, idx|
          li(class: step_classes(idx), data: {content: step_data_content(idx), **stimulus_target(:step)}) do
            if step.href.present? && step_completed?(idx)
              a(href: step.href, class: "text-sm font-medium") { step_full_label(step) }
            else
              span(class: "text-sm font-medium") { step_full_label(step) }
            end
          end
        end
      end
    end

    def element_classes
      "w-full"
    end

    def progress_classes
      classes = ["progress", "w-full"]
      classes << "progress-#{@color}"
      classes << size_class
      classes << "transition-all duration-300"
      classes.compact.join(" ")
    end

    def steps_classes
      classes = ["steps", "w-full"]
      classes << "steps-vertical" if @vertical
      classes.compact.join(" ")
    end

    def step_classes(index)
      classes = ["step"]

      if step_completed?(index)
        classes << "step-#{@color}"
      elsif step_current?(index)
        classes << "step-#{@color}"
      end

      classes.join(" ")
    end

    def step_data_content(index)
      if step_completed?(index)
        "✓"
      elsif @show_numbers
        (index + 1).to_s
      end
    end

    def size_class
      case @size
      when :xs then "progress-xs"
      when :sm then "progress-sm"
      when :lg then "progress-lg"
      else ""
      end
    end

    def progress_value
      return 0 if @current_step <= 0
      return 100 if @current_step > @steps.size

      ((@current_step - 1).to_f / @steps.size * 100).round
    end

    def step_completed?(index)
      @current_step > index + 1
    end

    def step_current?(index)
      @current_step == index + 1
    end

    def step_label(step)
      if @i18n_key.present?
        t("#{@i18n_key}.#{step.label_key}")
      else
        step.label_key
      end
    end

    def step_full_label(step)
      label = step_label(step)
      desc = has_description?(step) ? step_description(step) : nil
      desc ? "#{label} - #{desc}" : label
    end

    def has_description?(step)
      @i18n_key.present? && I18n.exists?("#{@i18n_key}.#{step.label_key}_desc")
    end

    def step_description(step)
      t("#{@i18n_key}.#{step.label_key}_desc") if has_description?(step)
    end
  end
end
