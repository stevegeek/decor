# frozen_string_literal: true

module Decor
  module Daisy
    module Tables
      class DataTableHeaderCell < ::Decor::Components::Tables::DataTableHeaderCell
        include ::Decor::Daisy::Tables::DataTableCellClasses

        def view_template
          root_element do
            div(class: "decor:group decor:flex decor:items-center") do
              if sort_key?
                render ::Decor::Daisy::Icon.new(
                  name: sort_icon,
                  html_options: {class: "decor:mr-2 decor:h-4 decor:w-4 #{sorted_direction? ? "decor:opacity-100" : "decor:opacity-25"} decor:group-hover:opacity-100 decor:group-hover:text-primary"}
                )
              end
              span(class: "decor:flex-1") { resolved_content }
            end
          end
        end

        def resolved_content
          @title || (@value || "")
        end

        def root_element_classes
          [
            sort_key? && "decor:cursor-pointer decor:hover:bg-base-200",
            numeric? ? "decor:text-right" : "decor:text-left",
            sorted_direction? && "decor:text-primary",
            row_height_classes,
            *typography_classes,
            stretch_class,
            "decor:text-base-content decor:font-medium decor:whitespace-nowrap decor:uppercase decor:text-xs decor:tracking-wider"
          ].compact_blank
        end

        def stretch_class
          return nil if @stretch_divisor.nil?
          case @stretch_divisor
          when 1
            "decor:w-full"
          when 2
            "decor:w-1/2"
          when 3
            "decor:w-1/3"
          when 4
            "decor:w-1/4"
          else
            "decor:w-1/5"
          end
        end

        def sort_icon
          (@sorted_direction == :asc) ? "chevron-up" : "chevron-down"
        end

        private

        def sorted_direction?
          @sorted_direction.present?
        end

        def root_element_attributes
          attrs = {
            element_tag: :th,
            role: "columnheader",
            scope: "col"
          }

          if @colspan&.positive?
            attrs[:colspan] = @colspan
          end

          attrs
        end
      end
    end
  end
end
