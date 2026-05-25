# frozen_string_literal: true

module Decor
  module Daisy
    module Tables
      class DataTableCell < ::Decor::Components::Tables::DataTableCell
        include ::Decor::Daisy::Tables::DataTableCellClasses

        def view_template(&block)
          root_element do |s|
            if @max_width.present? || @min_width_rem.present?
              div(
                style: "#{"max-width: #{@max_width}px;" if @max_width}#{"min-width: #{@min_width_rem}rem;" if @min_width_rem}",
                class: "decor:truncate"
              ) do
                render_cell_content(s, &block)
              end
            else
              render_cell_content(s, &block)
            end
          end
        end

        def resolved_content
          @value || ""
        end

        def root_element_classes
          [
            @numeric ? "decor:text-right" : "decor:text-left",
            row_height_classes,
            *typography_classes,
            "decor:relative decor:whitespace-nowrap",
            @path ? "decor:cursor-pointer decor:hover:bg-base-200" : nil
          ].compact_blank
        end

        def root_element_attributes
          attrs = {
            element_tag: :td
          }
          if @colspan&.positive?
            attrs[:html_options] = {colspan: @colspan}
          end
          attrs
        end

        private

        def sort_key?
          @sort_key.present?
        end

        def sorted_direction?
          @sorted_direction.present?
        end

        def render_cell_content(s, &)
          if @path.present?
            a(
              class: "cell-row-link-overlay decor:absolute decor:inset-0 decor:no-underline decor:cursor-pointer",
              tabindex: "-1",
              href: @path,
              data: {**stimulus_action(:click, :handle_link_click)}
            )
            if @content_clickable
              div(class: "decor:absolute decor:inset-0") do
                div(class: "decor:h-full decor:flex decor:items-center decor:place-content-center") do
                  cell_content(&)
                end
              end
            else
              cell_content(&)
            end
          elsif @content_clickable
            div(class: "decor:absolute decor:inset-0") do
              div(class: "decor:h-full decor:flex decor:items-center decor:place-content-center") do
                cell_content(&)
              end
            end
          else
            cell_content(&)
          end
        end

        def cell_content
          if block_given?
            yield
          else
            plain resolved_content
          end
        end
      end
    end
  end
end
