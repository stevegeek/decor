# frozen_string_literal: true

module Decor
  module Components
    module Tables
      # Abstract base for DataTableHeaderRow. Owns the prop API + slot helpers.
      # Concrete skins (Daisy, Suite) inherit and provide `view_template`
      # plus their visual-language overrides.
      class DataTableHeaderRow < ::Decor::PhlexComponent
        attr_reader :data_table_header_cells

        # Whether the row should get lower opacity or not
        prop :disabled, _Boolean, default: false

        # If row has a select box next to it
        prop :selectable_as, _Nilable(String)
        # Whether the row should get an indicator on the left side
        prop :selected, _Boolean, default: false

        def after_component_initialize
          @data_table_header_cells = []
        end

        def with_data_table_header_cell(component = nil, **attributes, &block)
          cell = component || ::Decor::Daisy::Tables::DataTableHeaderCell.new(**attributes)
          @data_table_header_cells << cell
          cell
        end
      end
    end
  end
end
