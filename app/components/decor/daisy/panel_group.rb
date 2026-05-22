# frozen_string_literal: true

module Decor
  module Daisy
    class PanelGroup < ::Decor::Components::PanelGroup
      def view_template(&)
        content = capture(&) if block_given?

        root_element do
          render ::Decor::Daisy::Card.new(size: @size, color: @color, style: @style, classes: "decor:overflow-hidden") do |card|
            card.card_header do
              card.div(class: "decor:p-4 decor:lg:p-6") do
                card.div(class: "decor:-ml-4 decor:-mt-4 decor:ml-4 decor:mt-4") do
                  card.render ::Decor::Daisy::Title.new(
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
                card.div(class: "decor:flex decor:flex-wrap decor:gap-4 decor:md:gap-5", &row_block)
              end
            end

            if content.present?
              card.div(class: "decor:p-4 decor:lg:p-6") do
                card.render content
              end
            end
          end
        end
      end

      def root_element_classes
        "decor:space-y-4"
      end

      private

      def section_classes(idx)
        base_classes = "decor:px-4 decor:py-5 decor:lg:px-6"
        if idx.odd?
          "#{base_classes} decor:bg-base-100"
        else
          "#{base_classes} decor:bg-base-200/50"
        end
      end
    end
  end
end
