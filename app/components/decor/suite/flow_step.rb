# frozen_string_literal: true

module Decor
  module Suite
    # Suite FlowStep — muted step indicator with card-chromed child-block content
    # area. Step circle uses bg-{color}/10 + border-{color}/40 tint; child block
    # carries a tinted-card chrome (muted background + hairline border).
    class FlowStep < ::Decor::Daisy::FlowStep
      def view_template(&)
        root_element do
          render_step_indicator

          div(class: "decor:flex-1 decor:min-w-0") do
            render ::Decor::Daisy::Title.new(
              title: @title,
              description: @description,
              size: title_size
            )

            if block_given?
              div(class: child_block_classes, &)
            end
          end
        end
      end

      private

      def child_block_classes
        "decor:mt-2.5 decor:px-3.5 decor:py-3 decor:bg-base-200/40 decor:border decor:border-black/10 decor:rounded-md decor:text-xs decor:text-base-content/60"
      end

      def filled_color_classes(color)
        case color
        when :primary then "decor:bg-primary/10 decor:border-2 decor:border-primary/40 decor:text-primary"
        when :secondary then "decor:bg-secondary/10 decor:border-2 decor:border-secondary/40 decor:text-secondary"
        when :accent then "decor:bg-accent/10 decor:border-2 decor:border-accent/40 decor:text-accent"
        when :success then "decor:bg-success/10 decor:border-2 decor:border-success/40 decor:text-success"
        when :error then "decor:bg-error/10 decor:border-2 decor:border-error/40 decor:text-error"
        when :warning then "decor:bg-warning/10 decor:border-2 decor:border-warning/40 decor:text-warning"
        when :info then "decor:bg-info/10 decor:border-2 decor:border-info/40 decor:text-info"
        when :neutral then "decor:bg-base-200 decor:border-2 decor:border-black/15 decor:text-base-content"
        end
      end

      def outline_color_classes(color)
        case color
        when :primary then "decor:border-2 decor:border-primary/60 decor:text-primary decor:bg-transparent"
        when :secondary then "decor:border-2 decor:border-secondary/60 decor:text-secondary decor:bg-transparent"
        when :accent then "decor:border-2 decor:border-accent/60 decor:text-accent decor:bg-transparent"
        when :success then "decor:border-2 decor:border-success/60 decor:text-success decor:bg-transparent"
        when :error then "decor:border-2 decor:border-error/60 decor:text-error decor:bg-transparent"
        when :warning then "decor:border-2 decor:border-warning/60 decor:text-warning decor:bg-transparent"
        when :info then "decor:border-2 decor:border-info/60 decor:text-info decor:bg-transparent"
        when :neutral then "decor:border-2 decor:border-black/30 decor:text-base-content decor:bg-transparent"
        end
      end
    end
  end
end
