# frozen_string_literal: true

module Decor
  class FlowStep < PhlexComponent
    no_stimulus_controller

    prop :title, _Nilable(String)
    prop :description, _Nilable(String)

    prop :step, _Nilable(Integer)
    prop :icon, _Nilable(String)

    # Use unified prop system
    default_size :md
    default_color :info
    default_style :filled

    def view_template(&)
      root_element do
        render_step_indicator

        div(class: "space-y-4 md:space-y-6") do
          render ::Decor::Title.new(
            title: @title,
            description: @description,
            size: title_size
          )

          div(&) if block_given?
        end
      end
    end

    private

    def root_element_classes
      "flex gap-3 md:gap-5 mt-5 border-b border-base-300 mb-3 pb-5"
    end

    def render_step_indicator
      if @icon
        # Custom span for icons
        span(class: step_indicator_classes) do
          render ::Decor::Icon.new(name: @icon, html_options: {class: icon_classes})
        end
      elsif @step
        # Custom span for step numbers to maintain consistent styling
        span(class: step_indicator_classes) do
          "%02i" % @step
        end
      end
    end

    def title_size
      case @size
      when :xs, :sm then :xs
      when :md then :sm
      when :lg then :md
      when :xl then :lg
      else
        :md
      end
    end

    # Icon handling for custom span (when Avatar isn't used)
    def step_indicator_classes
      [
        "flex-shrink-0 flex items-center justify-center rounded-full",
        component_size_classes(@size),
        component_style_classes(@style)
      ].compact.join(" ")
    end

    def component_size_classes(size)
      case size
      when :xs then "w-6 h-6 text-xs"
      when :sm then "w-8 h-8 text-sm"
      when :md then "w-8 h-8 md:w-10 md:h-10 text-sm md:text-base"
      when :lg then "w-12 h-12 text-lg"
      when :xl then "w-16 h-16 text-xl"
      end
    end

    def component_style_classes(style)
      case style
      when :outlined
        outline_color_classes(@color)
      when :ghost
        ghost_color_classes(@color)
      else
        filled_color_classes(@color)
      end
    end

    def filled_color_classes(color)
      case color
      when :primary then "bg-primary text-primary-content border-2 border-primary"
      when :secondary then "bg-secondary text-secondary-content border-2 border-secondary"
      when :accent then "bg-accent text-accent-content border-2 border-accent"
      when :success then "bg-success text-success-content border-2 border-success"
      when :error then "bg-error text-error-content border-2 border-error"
      when :warning then "bg-warning text-warning-content border-2 border-warning"
      when :info then "bg-info text-info-content border-2 border-info"
      when :neutral then "bg-neutral text-neutral-content border-2 border-neutral"
      end
    end

    def outline_color_classes(color)
      case color
      when :primary then "border-2 border-primary text-primary bg-transparent"
      when :secondary then "border-2 border-secondary text-secondary bg-transparent"
      when :accent then "border-2 border-accent text-accent bg-transparent"
      when :success then "border-2 border-success text-success bg-transparent"
      when :error then "border-2 border-error text-error bg-transparent"
      when :warning then "border-2 border-warning text-warning bg-transparent"
      when :info then "border-2 border-info text-info bg-transparent"
      when :neutral then "border-2 border-neutral text-neutral bg-transparent"
      end
    end

    def ghost_color_classes(color)
      case color
      when :primary then "border-2 border-transparent text-primary hover:bg-primary/10"
      when :secondary then "border-2 border-transparent text-secondary hover:bg-secondary/10"
      when :accent then "border-2 border-transparent text-accent hover:bg-accent/10"
      when :success then "border-2 border-transparent text-success hover:bg-success/10"
      when :error then "border-2 border-transparent text-error hover:bg-error/10"
      when :warning then "border-2 border-transparent text-warning hover:bg-warning/10"
      when :info then "border-2 border-transparent text-info hover:bg-info/10"
      when :neutral then "border-2 border-transparent text-neutral hover:bg-neutral/10"
      end
    end

    def icon_classes
      base_size = case @size
      when :xs then "w-3 h-3"
      when :sm then "w-4 h-4"
      when :md then "w-4 h-4"
      when :lg then "w-6 h-6"
      when :xl then "w-8 h-8"
      end

      if @style == :filled
        base_size # Color will be inherited from parent
      else
        text_color = case @color
        when :success then "text-success"
        when :error then "text-error"
        when :warning then "text-warning"
        when :info then "text-info"
        when :primary then "text-primary"
        when :secondary then "text-secondary"
        when :accent then "text-accent"
        when :neutral then "text-neutral"
        else "text-info"
        end
        "#{base_size} #{text_color}"
      end
    end
  end
end
