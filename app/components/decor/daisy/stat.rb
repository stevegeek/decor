# frozen_string_literal: true

module Decor
  module Daisy
    class Stat < ::Decor::Components::Stat
      private

      def root_element_attributes
        {
          element_tag: :div
        }
      end

      def view_template(&block)
        root_element do
          render_figure if should_render_figure?
          render_title if @title
          render_value(&block) if @value || block_given?
          render_description if @description
          render_actions if should_render_actions?
        end
      end

      def root_element_classes
        classes = ["decor:d-stat"]
        classes << "decor:place-items-center" if @centered
        classes.join(" ")
      end

      def render_figure
        div(class: figure_classes) do
          if @figure_content
            instance_exec(&@figure_content)
          elsif @icon
            render ::Decor::Icon.new(
              name: @icon,
              style: :outline,
              html_options: {class: "decor:inline-block decor:h-8 decor:w-8 decor:stroke-current"}
            )
          end
        end
      end

      def render_title
        div(class: "decor:d-stat-title") { plain(@title) }
      end

      def render_value(&block)
        div(class: value_classes) do
          if block_given?
            yield
          else
            plain(@value)
          end
        end
      end

      def render_description
        div(class: "decor:d-stat-desc") { plain(@description) }
      end

      def render_actions
        div(class: "decor:d-stat-actions") do
          if @actions_content
            instance_exec(&@actions_content)
          end
        end
      end

      def figure_classes
        classes = ["decor:d-stat-figure"]
        color_to_use = @icon_color || @color
        if color_to_use && color_to_use != :neutral
          classes << figure_color_class(color_to_use)
        end
        classes.join(" ")
      end

      def figure_color_class(color)
        case color
        when :base then "decor:text-base-content"
        when :primary then "decor:text-primary"
        when :secondary then "decor:text-secondary"
        when :accent then "decor:text-accent"
        when :success then "decor:text-success"
        when :error then "decor:text-error"
        when :warning then "decor:text-warning"
        when :info then "decor:text-info"
        when :neutral then "decor:text-neutral"
        else ""
        end
      end

      def value_classes
        classes = ["decor:d-stat-value"]
        if @color && @color != :neutral
          classes << text_color_classes(@color)
        end
        classes.compact.join(" ")
      end
    end
  end
end
