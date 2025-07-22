# frozen_string_literal: true

module Decor
  module Tables
    class DataTableHeaderCell < DataTableCell
      # The string title to be rendered in the cell
      prop :title, _Nilable(String)

      # Whether the cell should stretch to fill the remaining space or not.
      # The stretch divisor, setting the stretch based on how many other stretch columns are present.
      prop :stretch_divisor, _Nilable(Integer)

      # Change default weight to medium
      prop :weight, _Union(:light, :regular, :medium), default: :medium

      # Sort key, if nil then column is not sortable
      prop :sort_key, _Nilable(Symbol)
      # Current sort direction of the column
      prop :sorted_direction, _Nilable(_Union(:asc, :desc))

      stimulus do
        actions -> { [:click, :handle_sortable_click] if sort_key? }
        values sort_key: -> { @sort_key }, sorted_direction: -> { @sorted_direction }
      end

      def view_template
        root_element do
          div(class: "group flex items-center") do
            if sort_key?
              render ::Decor::Icon.new(
                name: sort_icon,
                html_options: {class: "mr-2 h-4 w-4 #{sorted_direction? ? "opacity-100" : "opacity-25"} group-hover:opacity-100 group-hover:text-primary"}
              )
            end
            span(class: "flex-1") { resolved_content }
          end
        end
      end

      def resolved_content
        @title || super
      end

      def root_element_classes
        [
          sort_key? && "cursor-pointer hover:bg-base-200",
          numeric? ? "text-right" : "text-left",
          sorted_direction? && "text-primary",
          row_height_classes,
          *typography_classes,
          stretch_class,
          # Use daisyUI base colors with fallback
          "text-base-content font-medium whitespace-nowrap uppercase text-xs tracking-wider"
        ].compact_blank
      end

      def stretch_class
        return nil if @stretch_divisor.nil?
        case @stretch_divisor
        when 1
          "w-full"
        when 2
          "w-1/2"
        when 3
          "w-1/3"
        when 4
          "w-1/4"
        else
          "w-1/5"
        end
      end

      def sort_icon
        (@sorted_direction == :asc) ? "chevron-up" : "chevron-down"
      end

      private

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
