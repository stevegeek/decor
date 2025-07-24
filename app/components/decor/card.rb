# frozen_string_literal: true

module Decor
  # A card is a container for content which has a border and a shadow.
  class Card < PhlexComponent
    include Decor::Concerns::StyleColorClasses

    no_stimulus_controller

    prop :title, _Nilable(String)
    prop :image_url, _Nilable(String)
    prop :image_position, _Union(:top, :bottom, :left, :right), default: :top
    prop :image_alt, String, default: ""

    default_size :md
    default_color :base
    default_style :filled

    def card_header(&block)
      @card_header = block
    end

    # Alias for backward compatibility
    alias_method :with_header, :card_header

    private

    def view_template(&)
      @content = capture(&) if block_given?

      root_element do
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

    def root_element_classes
      classes = ["card"]
      classes << size_classes
      classes << style_classes
      classes << "flex-row" if image_position_horizontal?
      classes.compact.join(" ")
    end

    def card_content_classes
      return "" unless image_position_horizontal?

      bg_class = get_background_class_for_content
      case @image_position
      when :left
        "flex flex-col #{bg_class} rounded-r-box flex-1"
      when :right
        "flex flex-col #{bg_class} rounded-l-box flex-1"
      end
    end

    def get_background_class_for_content
      # For horizontal image cards, we need to apply the background to the content area
      case @style
      when :ghost
        ""
      when :outlined
        "bg-base-100"
      else
        # Filled style
        filled_color_classes(@color)
      end
    end

    def render_header_and_body
      div(class: "card-body") do
        if @card_header.present?
          render @card_header
        end
        if @title.present?
          span(class: "card-title") { @title }
        end
        raw @content.html_safe if @content.present?
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

    def component_size_classes(size)
      case size
      when :xs then "card-xs"
      when :sm then "card-sm"
      when :md then "card-md"
      when :lg then "card-lg"
      when :xl then "card-xl"
      else
        ""
      end
    end

    def component_style_classes(style)
      # Override the base implementation to add card-specific shadow classes
      case style
      when :filled
        "#{filled_color_classes(@color)} shadow-sm"
      when :outlined
        "#{outline_color_classes(@color)} bg-base-100"
      when :ghost
        "#{ghost_color_classes(@color)} shadow-none"
      else
        ""
      end
    end
  end
end
