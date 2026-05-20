# frozen_string_literal: true

module Decor
  module Suite
    module Tables
      module Builder
        # Pure-Ruby data carrier used by the Suite DataTable builder pipeline to
        # describe a single cell before it is rendered. It does NOT instantiate
        # the view component itself; instead `#component` returns the kwargs
        # hash a caller can splat into `::Decor::Suite::Tables::DataTableCell.new`.
        #
        # `self.render_content` materialises the cell block's value via the host
        # app's view helpers (`helpers.capture { ... }`), supporting block arities
        # 1..4 to match the column DSL.
        #
        # Notes on the port:
        # - The original Confinus class mixed in `LiteralExtensions::StructHelpers`
        #   (a `merge`/`+`/`==`/`attributes` shim from the pre-Literal `TypedStruct`
        #   era). That shim is not carried over; consumers that need merge can use
        #   `Cell.new(**a.to_h.merge(b.to_h))`.
        class Cell < ::Literal::Struct
          prop :column, ::Decor::Suite::Tables::Builder::Column
          prop :data, _Nilable(_Any)
          prop :untransformed, _Nilable(_Any)
          prop :item_index, Integer
          prop :row_height, _Nilable(Symbol)

          prop :emphasis, _Nilable(Symbol)
          prop :weight, _Nilable(Symbol)

          # Path that the parent row navigates to; used to render an anchor
          # overlay around the cell contents (preserves ctrl/middle-click).
          prop :path, _Nilable(_Any)
          # If true the cell content is rendered inside an absolutely-positioned
          # div over the cell so interactive controls get first dibs on events.
          prop :content_clickable, _Nilable(_Boolean)
          # If true a click in the cell will not propagate to the row.
          prop :stop_propagation, _Boolean, default: false

          prop :html_options, _Nilable(_Any)
          prop :classes, _Nilable(_Union(String, _Array(String)))
          prop :rendered_content, _Nilable(String)

          # Minimal object passed as the 4th block arg so templates can do
          # `row_context.form_builder.hidden_field(...)` when the column block
          # takes `(item, index, untransformed, row_context)`.
          RowContext = ::Struct.new(:form_builder)

          def self.render_content(column, data, item_index, untransformed, helpers, form_builder: nil)
            return nil unless column.cell_block

            # ERB callers need `helpers.capture { ... }` to harvest the
            # ActionView output buffer. Pure-Ruby callers (Phlex blocks,
            # tests) just return a string from the block, so we skip the
            # capture machinery when the helper context doesn't respond to
            # `capture`.
            invoke = lambda do |block, *args|
              if helpers.respond_to?(:capture)
                helpers.capture { block.call(*args) }
              else
                block.call(*args)
              end
            end

            case column.cell_block.arity
            when -2, -1, 1
              invoke.call(column.cell_block, data)
            when 2
              invoke.call(column.cell_block, data, item_index)
            when 3
              invoke.call(column.cell_block, data, item_index, untransformed)
            when 4, -5
              row_context = RowContext.new(form_builder)
              invoke.call(column.cell_block, data, item_index, untransformed, row_context)
            else
              invoke.call(column.cell_block)
            end
          end

          def render_block
            column.cell_block
          end

          # Kwargs hash suitable for `::Decor::Suite::Tables::DataTableCell.new(**...)`.
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
              html_options: html_options,
              classes: classes,
              value: rendered_content
            }.compact
          end
        end
      end
    end
  end
end
