# frozen_string_literal: true

module Decor
  class Panel < PhlexComponent
    no_stimulus_controller

    attribute :title, String
    attribute :icon, String

    def view_template(&)
      render parent_element do
        render ::Decor::Title.new(
          title: @title,
          icon: @icon,
          size: :sm
        )

        div(class: "mt-1.5 text-sm", &)
      end
    end

    private

    def element_classes
      "space-y-2"
    end
  end
end
