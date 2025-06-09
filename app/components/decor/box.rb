# frozen_string_literal: true

module Decor
  class Box < PhlexComponent
    no_stimulus_controller

    slot :html_title
    slot :left
    slot :right

    attribute :title, String
    attribute :description, String

    private

    def view_template(&block)
      render parent_element do
        div(class: "card-body") do
          # Handle slots layout
          if left_slot.present? && right_slot.present?
            # Both slots: create flex layout
            div(class: "flex justify-between items-start") do
              div(class: "flex-1") do
                render left_slot
              end
              div(class: "flex-none") do
                render right_slot
              end
            end
          elsif left_slot.present?
            # Only left slot
            render left_slot
          else
            # Standard content layout
            if @title.present? || html_title_slot.present?
              h2(class: "card-title") do
                if html_title_slot.present?
                  render html_title_slot
                else
                  plain(@title)
                end
              end
            end

            # Description section
            if @description.present?
              p(class: "text-base-content/70") do
                plain(@description)
              end
            end

            # Right slot or block content
            if right_slot.present?
              render right_slot
            elsif block_given?
              div do
                yield
              end
            end
          end
        end
      end
    end

    def element_classes
      "card card-bordered bg-base-200 shadow-sm"
    end
  end
end
