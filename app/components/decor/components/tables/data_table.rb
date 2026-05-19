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

        # Persistent selection across pagination — Stimulus controller stores
        # selected row identifiers in localStorage keyed by `table_identifier`.
        prop :table_identifier, _Nilable(String)
        prop :enable_selection_persistence, _Boolean, default: false

        # Extra HTML attributes applied to the inner <table> element so callers
        # can attach Stimulus controllers / data hooks to the table itself.
        prop :table_html_options, Hash, default: -> { {} }

        # Customisable empty-state copy/icon shown when no body rows are
        # rendered. The default "inbox" icon reads as a generic empty
        # container to non-technical users; pass `empty_state_icon` to
        # override (e.g. "users" for an empty user list, "shopping-cart"
        # for an empty order list).
        prop :empty_state_icon, String, default: "inbox"
        prop :empty_state_title, String, default: "Nothing here yet"

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
          outlets({
            ::Decor::Daisy::Tables::DataTableHeaderRow.stimulus_identifier => nil,
            ::Decor::Daisy::Tables::DataTableRow.stimulus_identifier => nil
          })

          values table_id: -> { @table_identifier },
            persist_selections: -> { @enable_selection_persistence }
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
