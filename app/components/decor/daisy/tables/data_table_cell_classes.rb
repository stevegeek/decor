# frozen_string_literal: true

module Decor
  module Daisy
    module Tables
      # Shared visual helpers for daisyUI DataTableCell + DataTableHeaderCell.
      # Including class inherits an abstract base providing prop @color/@emphasis/
      # @weight/@row_height/@numeric.
      module DataTableCellClasses
        def typography_classes
          [
            daisyui_color_class,
            (!@color || @color == :base) && @emphasis == :regular && "text-gray-900",
            (!@color || @color == :base) && @emphasis == :low && "text-gray-500",
            @weight == :light && "font-light",
            @weight == :medium && "font-medium",
            @weight == :regular && "font-normal"
          ]
        end

        def row_height_classes
          case @row_height
          when :tight
            "px-3 py-1 text-xs"
          when :comfortable
            "px-4 py-4 text-sm"
          else
            "px-3 py-2 text-sm"
          end
        end

        def daisyui_color_class
          return nil unless @color && @color != :base

          case @color
          when :primary then "text-primary"
          when :secondary then "text-secondary"
          when :accent then "text-accent"
          when :neutral then "text-neutral"
          when :info then "text-info"
          when :success then "text-success"
          when :warning then "text-warning"
          when :error then "text-error"
          when :base then nil
          end
        end

        private

        def numeric?
          @numeric
        end
      end
    end
  end
end
