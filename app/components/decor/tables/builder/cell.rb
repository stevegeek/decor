# frozen_string_literal: true

module Decor
  module Tables
    module Builder
      class Cell < ::Literal::Struct
        prop :column, ::Decor::Tables::Builder::Column
        prop :data, _Nilable(_Any)
        prop :untransformed, _Nilable(_Any)
        prop :item_index, _Nilable(Integer)

        prop :component, ::Decor::Daisy::Tables::DataTableCell

        def render_block
          column.cell_block
        end

        def self.new_with_component(column:, data:, untransformed:, item_index:, **cell_props)
          component_props = {
            numeric: column.numeric,
            colspan: column.colspan,
            min_width_rem: column.min_width_rem,
            max_width: column.max_width,
            emphasis: column.emphasis,
            weight: column.weight,
            value: rendered_content(column, data, item_index, untransformed),
            **cell_props
          }.compact

          component_instance = ::Decor::Daisy::Tables::DataTableCell.new(**component_props)

          new(
            column: column,
            data: data,
            untransformed: untransformed,
            item_index: item_index,
            component: component_instance
          )
        end

        def self.rendered_content(column, data, item_index, untransformed)
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
