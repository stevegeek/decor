# frozen_string_literal: true

module Decor
  module Components
    class Stat < ::Decor::PhlexComponent
      no_stimulus_controller

      prop :value, _Nilable(String)
      prop :title, _Nilable(String)
      prop :description, _Nilable(String)
      prop :centered, _Boolean, default: false
      prop :icon, _Nilable(String)
      prop :icon_color, _Nilable(_Union(:base, :primary, :secondary, :accent, :success, :error, :warning, :info, :neutral))

      default_color :neutral

      prop :with_figure, _Boolean, default: false
      prop :with_actions, _Boolean, default: false

      def figure(&block)
        @figure_content = block
        @with_figure = true
      end

      def actions(&block)
        @actions_content = block
        @with_actions = true
      end

      private

      def should_render_figure?
        @with_figure || @figure_content || @icon
      end

      def should_render_actions?
        @with_actions || @actions_content
      end
    end
  end
end
