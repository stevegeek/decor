# frozen_string_literal: true

module Decor
  module Daisy
    class FlowStep < ::Decor::Components::FlowStep
      def view_template(&)
        root_element do
          render_step_indicator

          div(class: "decor:space-y-4 decor:md:space-y-6") do
            render ::Decor::Daisy::Title.new(
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
        "decor:flex decor:gap-3 decor:md:gap-5 decor:mt-5 decor:border-b decor:border-base-300 decor:mb-3 decor:pb-5"
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
          "decor:flex-shrink-0 decor:flex decor:items-center decor:justify-center decor:rounded-full",
          component_size_classes(@size),
          component_style_classes(@style)
        ].compact.join(" ")
      end

      def component_size_classes(size)
        case size
        when :xs then "decor:w-6 decor:h-6 decor:text-xs"
        when :sm then "decor:w-8 decor:h-8 decor:text-sm"
        when :md then "decor:w-8 decor:h-8 decor:md:w-10 decor:md:h-10 decor:text-sm decor:md:text-base"
        when :lg then "decor:w-12 decor:h-12 decor:text-lg"
        when :xl then "decor:w-16 decor:h-16 decor:text-xl"
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
        when :primary then "decor:bg-primary decor:text-primary-content decor:border-2 decor:border-primary"
        when :secondary then "decor:bg-secondary decor:text-secondary-content decor:border-2 decor:border-secondary"
        when :accent then "decor:bg-accent decor:text-accent-content decor:border-2 decor:border-accent"
        when :success then "decor:bg-success decor:text-success-content decor:border-2 decor:border-success"
        when :error then "decor:bg-error decor:text-error-content decor:border-2 decor:border-error"
        when :warning then "decor:bg-warning decor:text-warning-content decor:border-2 decor:border-warning"
        when :info then "decor:bg-info decor:text-info-content decor:border-2 decor:border-info"
        when :neutral then "decor:bg-neutral decor:text-neutral-content decor:border-2 decor:border-neutral"
        end
      end

      def outline_color_classes(color)
        case color
        when :primary then "decor:border-2 decor:border-primary decor:text-primary decor:bg-transparent"
        when :secondary then "decor:border-2 decor:border-secondary decor:text-secondary decor:bg-transparent"
        when :accent then "decor:border-2 decor:border-accent decor:text-accent decor:bg-transparent"
        when :success then "decor:border-2 decor:border-success decor:text-success decor:bg-transparent"
        when :error then "decor:border-2 decor:border-error decor:text-error decor:bg-transparent"
        when :warning then "decor:border-2 decor:border-warning decor:text-warning decor:bg-transparent"
        when :info then "decor:border-2 decor:border-info decor:text-info decor:bg-transparent"
        when :neutral then "decor:border-2 decor:border-neutral decor:text-neutral decor:bg-transparent"
        end
      end

      def ghost_color_classes(color)
        case color
        when :primary then "decor:border-2 decor:border-transparent decor:text-primary decor:hover:bg-primary/10"
        when :secondary then "decor:border-2 decor:border-transparent decor:text-secondary decor:hover:bg-secondary/10"
        when :accent then "decor:border-2 decor:border-transparent decor:text-accent decor:hover:bg-accent/10"
        when :success then "decor:border-2 decor:border-transparent decor:text-success decor:hover:bg-success/10"
        when :error then "decor:border-2 decor:border-transparent decor:text-error decor:hover:bg-error/10"
        when :warning then "decor:border-2 decor:border-transparent decor:text-warning decor:hover:bg-warning/10"
        when :info then "decor:border-2 decor:border-transparent decor:text-info decor:hover:bg-info/10"
        when :neutral then "decor:border-2 decor:border-transparent decor:text-neutral decor:hover:bg-neutral/10"
        end
      end

      def icon_classes
        base_size = case @size
        when :xs then "decor:w-3 decor:h-3"
        when :sm then "decor:w-4 decor:h-4"
        when :md then "decor:w-4 decor:h-4"
        when :lg then "decor:w-6 decor:h-6"
        when :xl then "decor:w-8 decor:h-8"
        end

        if @style == :filled
          base_size # Color will be inherited from parent
        else
          text_color = case @color
          when :success then "decor:text-success"
          when :error then "decor:text-error"
          when :warning then "decor:text-warning"
          when :info then "decor:text-info"
          when :primary then "decor:text-primary"
          when :secondary then "decor:text-secondary"
          when :accent then "decor:text-accent"
          when :neutral then "decor:text-neutral"
          else "decor:text-info"
          end
          "#{base_size} #{text_color}"
        end
      end
    end
  end
end
