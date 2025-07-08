# frozen_string_literal: true

module Decor
  module Tables
    module Builder
      class Cell < ::Literal::Struct
        prop :column, ::Decor::Tables::Builder::Column
        prop :data, _Nilable(_Any)
        prop :untransformed, _Nilable(_Any)
        prop :item_index, _Nilable(Integer)
        prop :row_height, _Nilable(Symbol)

        prop :emphasis, _Nilable(Symbol)
        prop :weight, _Nilable(Symbol)

        # Path that row navigates to, used to create an anchor around cell contents
        prop :path, _Nilable(_Any)
        # If clickable the content is placed in an absolutely positioned div over the cell, thus
        # allowing it first dibs on events
        prop :content_clickable, _Boolean, default: false
        # If the cell is meant to stop propagation of events, then a click in the cell will
        # prevent the event from propagating to the row.
        prop :stop_propagation, _Boolean, default: false

        def render_block
          column.cell_block
        end

        def component
          {
            numeric: column.numeric,
            colspan: column.colspan,
            min_width_rem: column.min_width_rem,
            max_width: column.max_width,
            path: path,
            emphasis: emphasis || column.emphasis,
            weight: weight || column.weight,
            row_height: row_height,
            content_clickable: content_clickable,
            stop_propagation: stop_propagation,
            value: rendered_content
          }.compact
        end

        def rendered_content
          return nil unless column.cell_block

          case column.cell_block.arity
          when -2, -1, 1
            column.cell_block.call(data).to_s
          when 2
            column.cell_block.call(data, item_index).to_s
          when 3
            column.cell_block.call(data, item_index, untransformed).to_s
          else
            column.cell_block.call.to_s
          end
        end
      end
    end
  end
end
