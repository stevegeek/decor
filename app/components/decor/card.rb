# frozen_string_literal: true

module Decor
  # A card is a container for content which has a border and a shadow.
  class Card < PhlexComponent
    no_stimulus_controller

    attribute :title, String
    attribute :image_url, String
    attribute :image_position, Symbol, default: :top, in: [:top, :bottom, :left, :right]
    attribute :image_alt, String, default: ""

    def card_header(&block)
      @card_header = block
    end

    private

    def view_template(&)
      @content = capture(&) if block_given?

      render parent_element do
        if @image_url.present? && (@image_position == :left || @image_position == :top)
          image_element
        end

        if image_position_horizontal?
          div(class: card_content_classes) do
            render_header_and_body
          end
        else
          render_header_and_body
        end

        if @image_url.present? && (@image_position == :right || @image_position == :bottom)
          image_element
        end
      end
    end

    def element_classes
      base_classes = "card bg-base-100 shadow-sm"
      if image_position_horizontal?
        "#{base_classes} flex-row"
      else
        base_classes
      end
    end

    def card_content_classes
      return "" unless image_position_horizontal?

      case @image_position
      when :left
        "flex flex-col bg-base-100 rounded-r-box flex-1"
      when :right
        "flex flex-col bg-base-100 rounded-l-box flex-1"
      end
    end

    def render_header_and_body
      if @card_header.present?
        render @card_header
      end
      div(class: "card-body") do
        if @title.present?
          span(class: "card-title") { @title }
        end
        render @content if @content.present?
      end
    end

    def image_element
      div(class: image_classes, style: image_background_style)
    end

    def image_classes
      base_classes = "bg-center bg-cover"

      case @image_position
      when :top
        "#{base_classes} rounded-t-box w-full h-60"
      when :bottom
        "#{base_classes} rounded-b-box w-full h-60"
      when :left
        "#{base_classes} rounded-l-box w-48"
      when :right
        "#{base_classes} rounded-r-box w-48"
      end
    end

    def image_background_style
      "background-image: url('#{@image_url}')" if @image_url.present?
    end

    def image_position_horizontal?
      [:left, :right].include?(@image_position)
    end
  end
end
