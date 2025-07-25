# frozen_string_literal: true

module Decor
  class PanelGroup < PhlexComponent
    no_stimulus_controller

    prop :title, String
    prop :description, _Nilable(String)

    # Use unified prop system
    default_size :md
    default_color :base
    default_style :filled

    def after_component_initialize
      @panel_rows = []
    end

    def view_template(&)
      # Execute the block to collect panel rows, cta, and main content
      content = capture(&) if block_given?

      root_element do
        render ::Decor::Card.new(size: @size, color: @color, style: @style, classes: "overflow-hidden") do |card|
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

          @panel_rows.each_with_index do |row_block, idx|
            card.div(class: section_classes(idx)) do
              card.div(class: "flex flex-wrap gap-4 md:gap-5", &row_block)
            end
          end

          # Render main content if provided (this will go into the card-body automatically)
          if content.present?
            card.div(class: "p-4 lg:p-6") do
              card.render content
            end
          end
        end
      end
    end

    def with_panel_row(&block)
      return unless block_given?
      
      @panel_rows << block
    end

    def cta(&block)
      @cta_content = block
    end

    def root_element_classes
      "space-y-4"
    end

    private

    def section_classes(idx)
      base_classes = "px-4 py-5 lg:px-6"
      if idx.odd?
        "#{base_classes} bg-base-100"
      else
        "#{base_classes} bg-base-200/50"
      end
    end

  end
end
