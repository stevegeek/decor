# frozen_string_literal: true

module Decor
  module Suite
    class Stat < ::Decor::Components::Stat
      prop :delta, _Union(:up, :down, :none), default: :none

      def view_template(&block)
        root_element do
          div(class: "decor:flex decor:items-start decor:justify-between decor:gap-3") do
            div(class: "decor:flex decor:flex-col decor:gap-1 decor:min-w-0") do
              render_title if @title
              render_value(&block) if @value || block_given?
              render_description if @description
            end
            render_figure if should_render_figure?
          end
          render_actions if should_render_actions?
        end
      end

      private

      def root_element_attributes
        {element_tag: :div}
      end

      def root_element_classes
        classes = [
          "decor:bg-white",
          "decor:border decor:border-suite-hairline",
          "decor:rounded-suite-card",
          "decor:px-4 decor:py-3"
        ]
        classes << "decor:text-center" if @centered
        classes.join(" ")
      end

      def render_title
        div(class: "decor:suite-caption decor:text-gray-500") { plain(@title) }
      end

      def render_value(&block)
        div(class: "decor:suite-section-title decor:text-gray-900 decor:tabular-nums") do
          if block_given?
            yield
          else
            plain(@value)
          end
        end
      end

      def render_description
        div(class: "decor:suite-description #{delta_color_class} decor:tabular-nums") { plain(@description) }
      end

      def render_figure
        div(class: "decor:shrink-0 #{figure_color_class}") do
          if @figure_content
            instance_exec(&@figure_content)
          elsif @icon
            render ::Decor::Icon.new(
              name: @icon,
              style: :outline,
              html_options: {class: "decor:inline-block decor:h-6 decor:w-6"}
            )
          end
        end
      end

      def render_actions
        div(class: "decor:mt-3 decor:flex decor:items-center decor:gap-2") do
          if @actions_content
            instance_exec(&@actions_content)
          end
        end
      end

      def delta_color_class
        case @delta
        when :up then "decor:text-suite-primary-700"
        when :down then "decor:text-suite-danger-700"
        else "decor:text-gray-500"
        end
      end

      def figure_color_class
        color = @icon_color || @color
        case color
        when :primary, :info then "decor:text-suite-primary-600"
        when :success then "decor:text-suite-primary-600"
        when :warning then "decor:text-suite-warning-600"
        when :error, :danger then "decor:text-suite-danger-600"
        else "decor:text-gray-400"
        end
      end
    end
  end
end
