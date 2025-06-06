# frozen_string_literal: true

module Decor
  class Banner < PhlexComponent
    no_stimulus_controller

    slot :action

    attribute :icon, String
    attribute :link, String, allow_nil: true, allow_blank: false
    attribute :style, Symbol, in: %i[warning info error notice standard success], default: :notice

    attribute :centered, :boolean, default: true

    private

    def root_element_attributes
      {
        html_options: {role: "alert"}
      }
    end

    def view_template
      render parent_element do
        if @icon
          render ::Decor::Icon.new(
            name: @icon,
            html_options: {class: "h-6 w-6"}
          )
        end
        div(class: wrapper_classes) do
          yield
        end
        if @link.present?
          link_to "Learn more", @link, class: "btn btn-sm btn-primary"
        end
        if action_slot.present?
          div do
            render action_slot
          end
        end
      end
    end

    def element_classes
      "mb-4 w-full flex #{alert_classes}"
    end

    def wrapper_classes
      @centered ? "w-full justify-center text-center" : ""
    end

    def alert_classes
      classes = ["alert"]
      case @style
      when :success
        classes << "alert-success"
      when :error
        classes << "alert-error"
      when :warning
        classes << "alert-warning"
      when :info
        classes << "alert-info"
      end

      classes.join(" ")
    end
  end
end
