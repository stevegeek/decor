# frozen_string_literal: true

module Decor
  # A card is a container for content which has a border and a shadow.
  class Card < PhlexComponent
    no_stimulus_controller

    attribute :title, String
    slot :header

    private

    def view_template
      render parent_element do
        if header_slot.present?
          render header_slot
        end
        div(class: "card-body") do
          if @title.present?
            span(class: "card-title") { @title }
          end
          yield if block_given?
        end
      end
    end

    def element_classes
      "card bg-base-100 shadow-sm"
    end
  end
end
