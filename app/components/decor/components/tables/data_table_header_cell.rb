# frozen_string_literal: true

module Decor
  module Components
    module Tables
      class DataTableHeaderCell < ::Decor::Components::Tables::DataTableCell
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

        private

        def sort_key?
          @sort_key.present?
        end
      end
    end
  end
end
