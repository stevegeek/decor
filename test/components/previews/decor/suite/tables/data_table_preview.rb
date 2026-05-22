# @label DataTable
class ::Decor::Suite::Tables::DataTablePreview < ::Lookbook::Preview
  # An admin-density tabular surface with hairline chrome, compact 13px body
  # type, gray-25 header row, and a dashed empty-state callout.
  #
  # DataTables are typically constructed via a builder for full sort / filter
  # / pagination integration, but the slot API can be used directly too.

  # @group Examples

  # Basic Data Table
  # ----------------
  # A simple table with sortable headers and numeric columns.
  def default
    render ::Decor::Suite::Tables::DataTable.new(
      title: "Product Inventory"
    ) do |table|
      table.with_data_table_header_row do |table_header|
        table_header.with_data_table_header_cell(title: "Product", sort_key: :name)
        table_header.with_data_table_header_cell(title: "Category", sort_key: :category)
        table_header.with_data_table_header_cell(title: "Price", sort_key: :price, numeric: true, sorted_direction: :desc)
        table_header.with_data_table_header_cell(title: "Stock", sort_key: :stock, numeric: true)
      end

      [
        ["MacBook Pro 16\"", "Laptops", "$2,399.00", 15],
        ["iPhone 15 Pro", "Phones", "$999.00", 42],
        ["iPad Air", "Tablets", "$599.00", 8],
        ["AirPods Pro", "Audio", "$249.00", 25]
      ].each do |name, category, price, stock|
        table.with_data_table_row(hover_highlight: true) do |row|
          row.with_data_table_cell(value: name)
          row.with_data_table_cell(value: category)
          row.with_data_table_cell(value: price, numeric: true, weight: :medium)
          row.with_data_table_cell(value: stock, numeric: true)
        end
      end
    end
  end

  # Title + Subtitle
  # ----------------
  # Header band with title + subtitle muted caption.
  def with_subtitle
    render ::Decor::Suite::Tables::DataTable.new(
      title: "User Management",
      subtitle: "Select users to perform bulk actions"
    ) do |table|
      table.with_data_table_header_row do |table_header|
        table_header.with_data_table_header_cell(title: "Name")
        table_header.with_data_table_header_cell(title: "Email")
        table_header.with_data_table_header_cell(title: "Role")
      end

      [
        ["Alice Johnson", "alice@example.com", "Admin"],
        ["Bob Smith", "bob@example.com", "Developer"],
        ["Carol Davis", "carol@example.com", "Designer"]
      ].each do |name, email, role|
        table.with_data_table_row do |row|
          row.with_data_table_cell(value: name)
          row.with_data_table_cell(value: email)
          row.with_data_table_cell(value: role)
        end
      end
    end
  end

  # Empty State
  # -----------
  # Dashed callout shown when no rows are added.
  def empty
    render ::Decor::Suite::Tables::DataTable.new(
      title: "Empty Inventory"
    ) do |table|
      table.with_data_table_header_row do |table_header|
        table_header.with_data_table_header_cell(title: "Product")
        table_header.with_data_table_header_cell(title: "Stock")
      end
    end
  end

  # Zebra Striping
  # --------------
  # Alternating row backgrounds for high-density tables.
  def zebra
    render ::Decor::Suite::Tables::DataTable.new(
      title: "Zebra Striped",
      zebra: true
    ) do |table|
      table.with_data_table_header_row do |table_header|
        table_header.with_data_table_header_cell(title: "Product")
        table_header.with_data_table_header_cell(title: "Category")
        table_header.with_data_table_header_cell(title: "Price", numeric: true)
      end

      [
        ["MacBook Pro", "Laptop", "$2,399"],
        ["iPhone 14", "Phone", "$799"],
        ["iPad Air", "Tablet", "$599"],
        ["Apple Watch", "Wearable", "$399"],
        ["AirPods Pro", "Audio", "$249"]
      ].each do |product, category, price|
        table.with_data_table_row do |row|
          row.with_data_table_cell(value: product)
          row.with_data_table_cell(value: category)
          row.with_data_table_cell(value: price, numeric: true)
        end
      end
    end
  end

  # @group Playground

  # @param title text
  # @param subtitle text
  # @param zebra toggle
  # @param pin_rows toggle
  def playground(
    title: "Inventory",
    subtitle: nil,
    zebra: false,
    pin_rows: false
  )
    render ::Decor::Suite::Tables::DataTable.new(
      title: title,
      subtitle: subtitle,
      zebra: zebra,
      pin_rows: pin_rows
    ) do |table|
      table.with_data_table_header_row do |table_header|
        table_header.with_data_table_header_cell(title: "Row")
        table_header.with_data_table_header_cell(title: "Name")
        table_header.with_data_table_header_cell(title: "Value", numeric: true)
      end

      (1..6).each do |i|
        table.with_data_table_row do |row|
          row.with_data_table_cell(value: i)
          row.with_data_table_cell(value: "Item #{i}")
          row.with_data_table_cell(value: (i * 100), numeric: true)
        end
      end
    end
  end
end
