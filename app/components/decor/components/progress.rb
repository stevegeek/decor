# frozen_string_literal: true

module Decor
  module Components
    # Abstract base for Progress. Owns the prop API, defaults, stimulus
    # contract, slot helper, and value-only computations (progress value,
    # step completion, i18n label resolution). Concrete skins inherit and
    # provide `view_template` plus the daisyUI / Suite class strings.
    class Progress < ::Decor::PhlexComponent
      class ProgressItem < ::Literal::Data
        prop :label_key, String
        prop :href, _Nilable(String)
      end

      prop :steps, _Array(ProgressItem), default: -> { [] } do |items|
        items.map { |item| item.is_a?(ProgressItem) ? item : ProgressItem.new(**item) }
      end
      prop :i18n_key, _Nilable(String)
      prop :current_step, Integer, default: 1
      prop :style, _Nilable(_Union(:steps, :progress, :both)), default: :steps

      default_size :md
      default_color :primary

      prop :show_numbers, _Boolean, default: true
      prop :vertical, _Boolean, default: false

      stimulus do
        values_from_props :current_step, :color
        values total_steps: -> { @step_slots.any? ? @step_slots.size : @steps.size }
      end

      def initialize(**)
        @step_slots = [] # TODO: this has to be before initialize super as initialize calls to setup
        # stimilus vales in after_initialize and the values here are dependent on the step_slots ...
        super
      end

      def with_step(&block)
        @step_slots << block
      end

      private

      def progress_value
        total_steps = @step_slots.any? ? @step_slots.size : @steps.size
        return 0 if @current_step <= 0
        return 100 if @current_step > total_steps

        ((@current_step - 1).to_f / total_steps * 100).round
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
        return false unless @i18n_key.present?
        # `I18n.exists?` doesn't resolve dot-separated keys the way `I18n.t`
        # does (returns false even for present nested keys). Use `t` with
        # `default: nil` and check the result instead.
        I18n.t("#{@i18n_key}.#{step.label_key}_desc", default: nil).present?
      end

      def step_description(step)
        t("#{@i18n_key}.#{step.label_key}_desc") if has_description?(step)
      end
    end
  end
end
