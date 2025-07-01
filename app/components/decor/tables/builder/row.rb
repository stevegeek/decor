# frozen_string_literal: true

module Decor
  module Tables
    module Builder
      class Row < ::Literal::Struct
        prop :id, _Nilable(String)
        prop :cells, _Array(::Decor::Tables::Builder::Cell), default: proc { [] }
        prop :item_index, _Nilable(Integer)
        prop :path, _Any

        prop :hover_highlight, _Nilable(_Boolean)
        prop :highlight, _Nilable(Symbol)

        prop :disabled, _Nilable(_Boolean)

        prop :selectable_as, _Nilable(String)
        prop :selected, _Nilable(_Boolean)

        prop :expanded_content_renderer, _Nilable(Proc)

        prop :prepared_form_builder, _Any

        def component
          {
            id: id,
            hover_highlight: hover_highlight,
            highlight: highlight,
            disabled: disabled,
            selectable_as: selectable_as,
            selected: selected,
            path: path,
            form_builder: prepared_form_builder
          }.compact
        end
      end
    end
  end
end
