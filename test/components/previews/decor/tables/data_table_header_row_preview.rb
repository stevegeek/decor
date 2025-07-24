# frozen_string_literal: true

# @label Data Table Header Row
class ::Decor::Tables::DataTableHeaderRowPreview < ::Lookbook::Preview
  # Table header row component that contains header cells and supports row selection.
  # Used within data tables to define column headers with optional sorting and selection capabilities.

  # @!group Examples

  # @label Basic Header Row
  def default
    render_with_table do |table|
      table.render ::Decor::Tables::DataTableHeaderRow.new do |row|
        row.with_data_table_header_cell(title: "Name")
        row.with_data_table_header_cell(title: "Email")
        row.with_data_table_header_cell(title: "Status")
        row.with_data_table_header_cell(title: "Actions")
      end
    end
  end

  # @label Sortable Headers
  def sortable
    render_with_table do |table|
      table.render ::Decor::Tables::DataTableHeaderRow.new do |row|
        row.with_data_table_header_cell(title: "Name", sort_key: :name)
        row.with_data_table_header_cell(title: "Email", sort_key: :email)
        row.with_data_table_header_cell(title: "Created", sort_key: :created_at)
        row.with_data_table_header_cell(title: "Amount", sort_key: :amount, numeric: true)
      end
    end
  end

  # @label Selectable Header Row
  def selectable
    render_with_table do |table|
      table.render ::Decor::Tables::DataTableHeaderRow.new(
        selectable_as: "Select all rows",
        selected: false
      ) do |row|
        row.with_data_table_header_cell(title: "Name", sort_key: :name)
        row.with_data_table_header_cell(title: "Email", sort_key: :email)
        row.with_data_table_header_cell(title: "Status")
      end
    end
  end

  # @label Mixed Column Types
  def mixed_columns
    render_with_table do |table|
      table.render ::Decor::Tables::DataTableHeaderRow.new do |row|
        row.with_data_table_header_cell(title: "ID", sort_key: :id, numeric: true)
        row.with_data_table_header_cell(title: "Product", sort_key: :product)
        row.with_data_table_header_cell(title: "Price", sort_key: :price, numeric: true)
        row.with_data_table_header_cell(title: "Stock", sort_key: :stock, numeric: true)
        row.with_data_table_header_cell(title: "Actions", align: :right)
      end
    end
  end

  # @!group Playground

  # @label Playground
  # @param selectable_as [String] text "Select all items"
  # @param selected [Boolean] toggle
  # @param disabled [Boolean] toggle
  def playground(selectable_as: "Select all items", selected: false, disabled: false)
    render_with_table do |table|
      table.render ::Decor::Tables::DataTableHeaderRow.new(
        selectable_as: selectable_as.presence,
        selected: selected,
        disabled: disabled
      ) do |row|
        row.with_data_table_header_cell(title: "Name", sort_key: :name)
        row.with_data_table_header_cell(title: "Email", sort_key: :email)
        row.with_data_table_header_cell(title: "Amount", sort_key: :amount, numeric: true)
        row.with_data_table_header_cell(title: "Status")
        row.with_data_table_header_cell(title: "Actions", align: :right)
      end
    end
  end

  # @!group Selection States

  # @label Unselected Header
  def selection_unselected
    render_with_table do |table|
      table.render ::Decor::Tables::DataTableHeaderRow.new(
        selectable_as: "Select all",
        selected: false
      ) do |row|
        row.with_data_table_header_cell(title: "Name", sort_key: :name)
        row.with_data_table_header_cell(title: "Email", sort_key: :email)
        row.with_data_table_header_cell(title: "Role")
      end
    end
  end

  # @label Selected Header
  def selection_selected
    render_with_table do |table|
      table.render ::Decor::Tables::DataTableHeaderRow.new(
        selectable_as: "Deselect all",
        selected: true
      ) do |row|
        row.with_data_table_header_cell(title: "Name", sort_key: :name)
        row.with_data_table_header_cell(title: "Email", sort_key: :email)
        row.with_data_table_header_cell(title: "Role")
      end
    end
  end

  # @label Disabled Selection
  def selection_disabled
    render_with_table do |table|
      table.render ::Decor::Tables::DataTableHeaderRow.new(
        selectable_as: "Selection disabled",
        selected: false,
        disabled: true
      ) do |row|
        row.with_data_table_header_cell(title: "Name", sort_key: :name)
        row.with_data_table_header_cell(title: "Email", sort_key: :email)
        row.with_data_table_header_cell(title: "Role")
      end
    end
  end

  private

  def render_with_table(&block)
    render ::Decor::Element.new do |e|
      e.table(class: "min-w-full border border-gray-200") do
        e.thead(class: "bg-gray-50", &block)
      end
    end
  end
end
