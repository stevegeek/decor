# frozen_string_literal: true

module Decor
  # Individual statistic component for displaying a single metric
  class Stat < PhlexComponent
    no_stimulus_controller

    # Main display value for the statistic
    attribute :value, String, allow_nil: true

    # Title/label for the statistic
    attribute :title, String, allow_nil: true

    # Description text below the value
    attribute :description, String, allow_nil: true

    # Color theme for the statistic value
    attribute :color, Symbol, default: :neutral, in: %i[primary secondary accent success error warning info neutral]

    # Whether to center align the content
    attribute :centered, :boolean, default: false

    # Icon to display in the figure area
    attribute :icon, String

    # Icon color (if different from value color)
    attribute :icon_color, Symbol, in: %i[primary secondary accent success error warning info neutral]

    # Whether to include a figure area
    attribute :with_figure, :boolean, default: false

    # Whether to include an actions area
    attribute :with_actions, :boolean, default: false

    def figure(&block)
      @figure_content = block
      @with_figure = true
    end

    def actions(&block)
      @actions_content = block
      @with_actions = true
    end

    private

    def root_element_attributes
      {
        element_tag: :div
      }
    end

    def view_template(&block)
      render parent_element do
        render_figure if should_render_figure?
        render_title if @title
        render_value(&block) if @value || block_given?
        render_description if @description
        render_actions if should_render_actions?
      end
    end

    def element_classes
      classes = ["stat"]
      classes << "place-items-center" if @centered
      classes.join(" ")
    end

    def render_figure
      div(class: figure_classes) do
        if @figure_content
          instance_exec(&@figure_content)
        elsif @icon
          render ::Decor::Icon.new(
            name: @icon,
            variant: :outline,
            html_options: {class: "inline-block h-8 w-8 stroke-current"}
          )
        end
      end
    end

    def render_title
      div(class: "stat-title") { plain(@title) }
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
      div(class: "stat-desc") { plain(@description) }
    end

    def render_actions
      div(class: "stat-actions") do
        if @actions_content
          instance_exec(&@actions_content)
        end
      end
    end

    def figure_classes
      classes = ["stat-figure"]
      if @icon_color
        classes << "text-#{@icon_color}"
      elsif @color != :neutral
        classes << "text-#{@color}"
      end
      classes.join(" ")
    end

    def value_classes
      classes = ["stat-value"]
      classes << "text-#{@color}" if @color != :neutral
      classes.join(" ")
    end

    def should_render_figure?
      @with_figure || @figure_content || @icon
    end

    def should_render_actions?
      @with_actions || @actions_content
    end
  end
end
