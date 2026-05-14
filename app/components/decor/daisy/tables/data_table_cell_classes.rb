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
            (!@color || @color == :base) && @emphasis == :regular && "decor:text-gray-900",
            (!@color || @color == :base) && @emphasis == :low && "decor:text-gray-500",
            @weight == :light && "decor:font-light",
            @weight == :medium && "decor:font-medium",
            @weight == :regular && "decor:font-normal"
          ]
        end

        def row_height_classes
          case @row_height
          when :tight
            "decor:px-3 decor:py-1 decor:text-xs"
          when :comfortable
            "decor:px-4 decor:py-4 decor:text-sm"
          else
            "decor:px-3 decor:py-2 decor:text-sm"
          end
        end

        def daisyui_color_class
          return nil unless @color && @color != :base

          case @color
          when :primary then "decor:text-primary"
          when :secondary then "decor:text-secondary"
          when :accent then "decor:text-accent"
          when :neutral then "decor:text-neutral"
          when :info then "decor:text-info"
          when :success then "decor:text-success"
          when :warning then "decor:text-warning"
          when :error then "decor:text-error"
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
