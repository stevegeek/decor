# frozen_string_literal: true

module Decor
  module Components
    module Tables
      # Abstract base for DataTableRow. Owns the prop API + stimulus block +
      # slot helpers (with_expanded_content, with_data_table_cell).
      # Concrete skins (Daisy, Suite) inherit and provide `view_template`
      # plus their visual-language overrides.
      class DataTableRow < ::Decor::PhlexComponent
        include ::Decor::Concerns::StyleColorClasses
        attr_reader :expanded_content

        # Background changes on hover
        prop :hover_highlight, _Nilable(_Boolean)

        # Background is highlighted
        prop :highlight, _Nilable(_Union(:gray_low, :gray_medium, :gray_high, :low, :medium, :high, :primary, :secondary, :accent, :info, :success, :warning, :error))

        # Use base color as default (no special styling)
        default_color :base

        # Whether the row should get lower opacity or not
        prop :disabled, _Boolean, default: false

        # Whether the row should be hidden or not
        prop :hidden, _Boolean, default: false

        # If row has a select box next to it
        prop :selectable_as, _Nilable(String)
        # The value posted by the selection checkbox (e.g. record encoded_id)
        prop :selectable_value, _Nilable(String)
        # Whether the row should get an indicator on the left side
        prop :selected, _Boolean, default: false

        # A row can optionally link to another page.
        prop :path, _Nilable(String)

        prop :data_table_cells, _Array(::Decor::Daisy::Tables::DataTableCell), default: -> { [] }

        # A row can optionally have a form builder which can then be used to created nested forms per row. The form builder
        # is normally prepared by the data table builder when preparing the table row data.
        prop :form_builder, _Nilable(::ActionView::Helpers::FormBuilder)

        stimulus do
          actions [:click, :handle_row_click]
          classes selected: "decor:bg-base-200"
          values_from_props :id
          values href: -> { @path }
        end

        def with_expanded_content(&block)
          @expanded_content = block
          self
        end

        def with_data_table_cell(component = nil, **attributes, &block)
          cell = component || ::Decor::Daisy::Tables::DataTableCell.new(**attributes)
          @data_table_cells << [cell, block]
          cell
        end
      end
    end
  end
end
