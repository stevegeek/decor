# frozen_string_literal: true

module Decor
  module Components
    module Tables
      class DataTableRow < ::Decor::PhlexComponent
        include ::Decor::Concerns::StyleColorClasses

        attr_reader :expanded_content

        prop :hover_highlight, _Nilable(_Boolean)

        prop :highlight, _Nilable(_Union(:gray_low, :gray_medium, :gray_high, :low, :medium, :high, :primary, :secondary, :accent, :info, :success, :warning, :error))

        default_color :base

        prop :disabled, _Boolean, default: false

        prop :hidden, _Boolean, default: false

        prop :selectable_as, _Nilable(String)
        # The value posted by the selection checkbox (e.g. record encoded_id)
        prop :selectable_value, _Nilable(String)
        prop :selected, _Boolean, default: false

        prop :path, _Nilable(String)

        prop :data_table_cells, _Array(::Decor::Daisy::Tables::DataTableCell), default: -> { [] }

        # Per-row form builder; normally prepared by the table builder so nested
        # row forms reuse the parent's CSRF token and naming scope.
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
