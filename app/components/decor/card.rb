# frozen_string_literal: true

module Decor
  # A card is a container for content which has a border and a shadow.
  class Card < PhlexComponent
    no_stimulus_controller

    prop :title, _Nilable(String)
    prop :image_url, _Nilable(String)
    prop :image_position, _Union(:top, :bottom, :left, :right), default: :top
    prop :image_alt, String, default: ""

    # Size of the card
    prop :size, _Union(:xs, :sm, :md, :lg, :xl), default: :md

    # Color scheme using DaisyUI semantic colors
    prop :color, _Union(:base, :primary, :secondary, :accent, :success, :error, :warning, :info, :neutral), default: :base

    # Visual variant
    prop :variant, _Union(:filled, :outlined, :ghost), default: :filled

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

    def element_classes
      classes = ["card"]
      classes << size_classes
      classes << color_classes
      classes << variant_classes
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
      case @variant
      when :ghost
        ""
      when :outlined
        "bg-base-100"
      else
        # Filled variant
        case @color
        when :base then "bg-base-100"
        when :primary then "bg-primary text-primary-content"
        when :secondary then "bg-secondary text-secondary-content"
        when :accent then "bg-accent text-accent-content"
        when :success then "bg-success text-success-content"
        when :error then "bg-error text-error-content"
        when :warning then "bg-warning text-warning-content"
        when :info then "bg-info text-info-content"
        when :neutral then "bg-neutral text-neutral-content"
        end
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

    def size_classes
      case @size
      when :xs then "card-xs"
      when :sm then "card-sm"
      when :md then "card-md"
      when :lg then "card-lg"
      when :xl then "card-xl"
      end
    end

    def color_classes
      case @variant
      when :ghost
        # Ghost variant doesn't use background colors
        nil
      when :outlined
        # Outlined variant uses base background
        "bg-base-100"
      else
        # Filled variant
        case @color
        when :base then "bg-base-100"
        when :primary then "bg-primary text-primary-content"
        when :secondary then "bg-secondary text-secondary-content"
        when :accent then "bg-accent text-accent-content"
        when :success then "bg-success text-success-content"
        when :error then "bg-error text-error-content"
        when :warning then "bg-warning text-warning-content"
        when :info then "bg-info text-info-content"
        when :neutral then "bg-neutral text-neutral-content"
        end
      end
    end

    def variant_classes
      case @variant
      when :filled
        "shadow-sm"
      when :outlined
        outline_variant_classes
      when :ghost
        "shadow-none"
      end
    end

    def outline_variant_classes
      border_color = case @color
      when :base then "border-base-300"
      when :primary then "border-primary"
      when :secondary then "border-secondary"
      when :accent then "border-accent"
      when :success then "border-success"
      when :error then "border-error"
      when :warning then "border-warning"
      when :info then "border-info"
      when :neutral then "border-neutral"
      end

      "border #{border_color}"
    end
  end
end
