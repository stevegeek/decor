# frozen_string_literal: true

module Decor
  module Components
    module Tables
      # Abstract base for DataTable. Owns the prop API + stimulus block +
      # slot helpers. Concrete skins (Daisy, Suite) inherit and provide
      # `view_template` plus their visual-language overrides.
      class DataTable < ::Decor::PhlexComponent
        attr_reader :data_table_header, :data_table_header_rows, :data_table_rows, :data_table_footer

        prop :title, _Nilable(String)
        prop :subtitle, _Nilable(String)

        default_size :md
        default_color :base
        default_style :default

        redefine_styles :default, :bordered, :minimal

        prop :striped, _Boolean, default: true
        prop :compact, _Boolean, default: false
        prop :zebra, _Boolean, default: false
        prop :pin_rows, _Boolean, default: false
        prop :pin_cols, _Boolean, default: false

        stimulus do
          outlets header_row: ::Decor::Daisy::Tables::DataTableHeaderRow.stimulus_identifier, row: ::Decor::Daisy::Tables::DataTableRow.stimulus_identifier
        end

        def after_component_initialize
          @data_table_header_rows = []
          @data_table_rows = []
        end

        def with_data_table_header(**attributes, &block)
          @data_table_header = block
          self
        end

        def with_search_and_filter(&block)
          @search_and_filter_block = block
          self
        end

        def with_data_table_header_row(component = nil, **attributes, &block)
          header_row = component || ::Decor::Daisy::Tables::DataTableHeaderRow.new(**attributes)
          @data_table_header_rows << if block_given?
            [header_row, block]
          else
            [header_row, nil]
          end
          header_row
        end

        def with_data_table_row(component = nil, **attributes, &block)
          row = component || ::Decor::Daisy::Tables::DataTableRow.new(**attributes)
          @data_table_rows << if block_given?
            [row, block]
          else
            [row, nil]
          end
          row
        end

        def with_pagination(&block)
          @pagination_block = block
          self
        end

        def with_data_table_footer(component = nil, **attributes, &block)
          @data_table_footer = component || ::Decor::Daisy::Tables::DataTableFooter.new(**attributes)
          self
        end
      end
    end
  end
end
