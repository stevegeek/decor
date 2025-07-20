# frozen_string_literal: true

module Decor
  # Container component for grouping multiple statistics
  class Stats < PhlexComponent
    no_stimulus_controller

    # Layout orientation for the stats
    prop :orientation, _Union(:horizontal, :vertical), default: :horizontal

    # Whether to add shadow styling
    prop :shadow, _Boolean, default: true

    # Whether to add background styling
    prop :background, _Boolean, default: false

    # Responsive behavior - vertical on mobile, horizontal on desktop
    prop :responsive, _Boolean, default: false

    private

    def root_element_attributes
      {
        element_tag: :div,
        html_options: {
          role: "group",
          "aria-label": "Statistics"
        }
      }
    end

    def view_template
      root_element do
        yield if block_given?
      end
    end

    def element_classes
      classes = ["stats"]

      if @responsive
        classes << "stats-vertical lg:stats-horizontal"
      elsif @orientation == :vertical
        classes << "stats-vertical"
      end

      classes << "shadow" if @shadow
      classes << "bg-base-100" if @background

      classes.join(" ")
    end
  end
end
