# frozen_string_literal: true

module Decor
  class PanelGroup < PhlexComponent
    no_stimulus_controller

    prop :title, String
    prop :description, _Nilable(String)

    # Size of the panel group
    prop :size, _Union(:xs, :sm, :md, :lg, :xl), default: :md

    # Color scheme using DaisyUI semantic colors
    prop :color, _Union(:base, :primary, :secondary, :accent, :success, :error, :warning, :info, :neutral), default: :base

    # Visual variant
    prop :variant, _Union(:filled, :outlined, :ghost), default: :filled

    def after_component_initialize
      @panels = []
    end

    def view_template(&)
      # Execute the block to collect panels, cta, and main content
      @main_content = capture(&) if block_given?

      root_element do
        render ::Decor::Card.new(size: @size, color: @color, variant: @variant, html_options: card_html_options) do |card|
          card.card_header do
            card.div(class: "p-4 lg:p-6") do
              card.div(class: "-ml-4 -mt-4 ml-4 mt-4") do
                card.render ::Decor::Title.new(
                  title: @title,
                  description: @description,
                  size: :md
                ) do |title|
                  title.render @cta_content if @cta_content
                end
              end
            end
          end

          @panels.each_with_index do |panel_row, idx|
            card.div(class: section_classes(idx)) do
              card.div(class: "grid #{grid_size(panel_row)} gap-4 md:gap-5") do
                panel_row.each { |panel| card.render panel }
              end
            end
          end

          # Render main content if provided (this will go into the card-body automatically)
          if @main_content.present?
            card.div(class: "p-4 lg:p-6") do
              card.render @main_content
            end
          end
        end
      end
    end

    def panels(&block)
      panel_list = instance_exec(&block)
      if panel_list.is_a?(Array)
        @panels << panel_list
      else
        raise ArgumentError, "Expected an array of panels, got #{panel_list.class}"
      end
    end

    def panel(title:, icon: nil, &content)
      ::Decor::Panel.new(title: title, icon: icon, &content)
    end

    def cta(&block)
      @cta_content = block
    end

    def element_classes
      "space-y-4"
    end

    private

    def card_html_options
      {class: "overflow-hidden"}
    end

    def section_classes(idx)
      base_classes = "px-4 py-5 lg:px-6"
      if idx.odd?
        "#{base_classes} bg-base-100"
      else
        "#{base_classes} bg-base-200/50"
      end
    end

    def grid_size(panel_row)
      case panel_row.size
      when 1
        "md:grid-cols-1"
      when 2
        "md:grid-cols-2"
      when 3
        "md:grid-cols-3"
      when 4
        "md:grid-cols-4"
      when 5
        "md:grid-cols-5"
      else
        "md:grid-cols-6"
      end
    end
  end
end
