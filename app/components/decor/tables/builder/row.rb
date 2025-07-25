# frozen_string_literal: true

module Decor
  module Tables
    module Builder
      class Row < ::Literal::Struct
        # Properties unique to the builder
        prop :cells, _Array(::Decor::Tables::Builder::Cell), default: proc { [] }
        prop :item_index, _Nilable(Integer)
        prop :expanded_content_renderer, _Nilable(Proc)

        # Component instance
        prop :component, ::Decor::Tables::DataTableRow

        # Initialize with component instance
        def self.new_with_component(cells:, item_index:, expanded_content_renderer: nil, **component_props)
          component_instance = ::Decor::Tables::DataTableRow.new(**component_props.compact)
          new(
            cells: cells,
            item_index: item_index,
            expanded_content_renderer: expanded_content_renderer,
            component: component_instance
          )
        end
      end
    end
  end
end
