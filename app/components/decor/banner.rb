# frozen_string_literal: true

module Decor
  class Banner < PhlexComponent
    no_stimulus_controller

    prop :icon, _Nilable(String)
    prop :link, _Nilable(_String(&:present?))
    prop :style, _Nilable(_Union(:warning, :info, :error, :notice, :standard, :success)), default: :notice

    prop :centered, _Boolean, default: false

    def call_to_action(&block)
      @call_to_action = block
    end

    private

    def root_element_attributes
      {
        html_options: {role: "alert"}
      }
    end

    def view_template
      root_element do
        if @icon
          render ::Decor::Icon.new(
            name: @icon,
            html_options: {class: "h-6 w-6"}
          )
        end
        div(class: wrapper_classes) do
          yield if block_given?
        end
        if @link.present?
          link_to "Learn more", @link, class: button_classes
        end
        if @call_to_action.present?
          div(class: "flex gap-2") do
            render @call_to_action
          end
        end
      end
    end

    def root_element_classes
      "mb-4 w-full flex #{alert_classes}"
    end

    def wrapper_classes
      @centered ? "w-full justify-center text-center" : "flex-1"
    end

    def alert_classes
      style = case @style
      when :success
        "alert-success"
      when :error
        "alert-error"
      when :warning
        "alert-warning"
      when :info
        "alert-info"
      when :notice, :standard, nil
        # default style - no additional class needed
        nil
      end

      "alert #{style}"
    end

    def button_classes
      style = case @style
      when :success
        "btn-success"
      when :error
        "btn-error"
      when :warning
        "btn-warning"
      when :info
        "btn-info"
      when :notice, :standard, nil
        "btn-secondary"
      else
        "btn-secondary"
      end
      "btn btn-sm #{style}"
    end
  end
end
