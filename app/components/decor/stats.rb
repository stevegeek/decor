# frozen_string_literal: true

module Decor
  # Container component for grouping multiple statistics
  class Stats < PhlexComponent
    no_stimulus_controller

    # Layout orientation for the stats
    attribute :orientation, Symbol, default: :horizontal, in: %i[horizontal vertical]

    # Whether to add shadow styling
    attribute :shadow, :boolean, default: true

    # Whether to add background styling
    attribute :background, :boolean, default: false

    # Responsive behavior - vertical on mobile, horizontal on desktop
    attribute :responsive, :boolean, default: false

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
      render parent_element do
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
