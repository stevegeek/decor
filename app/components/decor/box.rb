# frozen_string_literal: true

module Decor
  class Box < PhlexComponent
    no_stimulus_controller

    attribute :title, String
    attribute :description, String

    def html_title(&block)
      @html_title = block
    end

    def left(&block)
      @left = block
    end

    def right(&block)
      @right = block
    end

    private

    def view_template(&)
      @content = capture(&) if block_given?

      render parent_element do
        div(class: "card-body") do
          if @left.present? && @right.present?
            div(class: "flex justify-between items-start") do
              div(class: "flex-1") do
                render @left
              end
              div(class: "flex-none") do
                render @right
              end
            end
          elsif @left.present?
            render @left
          else
            if @title.present? || @html_title.present?
              h2(class: "card-title") do
                if @html_title.present?
                  render @html_title
                else
                  plain(@title)
                end
              end
            end

            if @description.present?
              p(class: "text-base-content/70") do
                plain(@description)
              end
            end

            if @right.present?
              render @right
            elsif block_given?
              div do
                @content.html_safe
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
