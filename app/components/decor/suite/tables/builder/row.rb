# frozen_string_literal: true

module Decor
  module Suite
    module Tables
      module Builder
        class Row < ::Literal::Struct
          prop :id, _Nilable(String)
          prop :cells, _Array(::Decor::Suite::Tables::Builder::Cell), reader: :public
          prop :item_index, Integer, reader: :public
          prop :path, _Nilable(_Any)

          prop :hover_highlight, _Nilable(_Boolean)
          prop :highlight, _Nilable(Symbol)

          prop :disabled, _Nilable(_Boolean)

          prop :selectable_as, _Nilable(String)
          prop :selectable_value, _Nilable(String)
          prop :selected, _Nilable(_Boolean)

          prop :expanded_content_renderer, _Nilable(Proc), reader: :public

          prop :prepared_form_builder, _Nilable(_Any)

          prop :html_options, _Nilable(_Any)
          prop :classes, _Nilable(_Union(String, _Array(String)))

          # Kwargs hash suitable for `::Decor::Suite::Tables::DataTableRow.new(**...)`.
          def component
            {
              id: id,
              hover_highlight: hover_highlight,
              highlight: highlight,
              disabled: disabled,
              selectable_as: selectable_as,
              selectable_value: selectable_value,
              selected: selected,
              path: path,
              form_builder: prepared_form_builder,
              html_options: html_options,
              classes: classes
            }.compact
          end
        end
      end
    end
  end
end
