# @label DataTable
class ::Decor::Tables::DataTablePreview < ::Lookbook::Preview
  # A flexible table component for displaying tabulated data with support for sorting,
  # selection, pagination, and various styling options.
  #
  # DataTables are typically constructed using DataTableBuilder for full application
  # integration with sorting, filtering, and other advanced features.

  # @group Examples

  # Basic Data Table
  # ----------------
  # A simple table with sortable headers and numeric columns.
  def default
    render ::Decor::Tables::DataTable.new(
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

  # Selectable Table with States
  # ----------------------------
  # Demonstrates row selection, highlighting, and different row states.
  def selectable
    render ::Decor::Tables::DataTable.new(
      title: "User Management",
      subtitle: "Select users to perform bulk actions"
    ) do |table|
      table.with_data_table_header_row(selectable_as: "select_all") do |table_header|
        table_header.with_data_table_header_cell(title: "Name", sort_key: :name, sorted_direction: :asc)
        table_header.with_data_table_header_cell(title: "Email", sort_key: :email)
        table_header.with_data_table_header_cell(title: "Role")
        table_header.with_data_table_header_cell(title: "Status")
      end

      [
        ["Alice Johnson", "alice@company.com", "Admin", "Active", false, false, nil],
        ["Bob Smith", "bob@company.com", "Developer", "Active", true, false, :low],
        ["Carol Davis", "carol@company.com", "Designer", "Pending", false, false, nil],
        ["David Wilson", "david@company.com", "Manager", "Active", false, true, nil],
        ["Eve Brown", "eve@company.com", "Developer", "Inactive", false, false, :high]
      ].each_with_index do |(name, email, role, status, selected, disabled, highlight), idx|
        table.with_data_table_row(
          selectable_as: "user_ids[]",
          selected: selected,
          disabled: disabled,
          highlight: highlight,
          hover_highlight: true
        ) do |row|
          row.with_data_table_cell(value: name)
          row.with_data_table_cell(value: email)
          row.with_data_table_cell(value: role)
          row.with_data_table_cell(value: status)
        end
      end
    end
  end

  # Table with Pagination
  # ---------------------
  # Shows a data table with pagination controls.
  def with_pagination
    collection = ::ApplicationCollectionBackedQuery.wrap((1..10).to_a).new

    render ::Decor::Tables::DataTable.new(
      title: "Transaction History"
    ) do |table|
      table.with_pagination do
        render ::Decor::Pagination.new(
          path: "/",
          collection: collection,
          page_size: 10,
          current_page: 2,
          total_count: 300
        )
      end

      table.with_data_table_header_row do |table_header|
        table_header.with_data_table_header_cell(title: "ID")
        table_header.with_data_table_header_cell(title: "Date")
        table_header.with_data_table_header_cell(title: "Description")
        table_header.with_data_table_header_cell(title: "Amount", numeric: true)
      end

      collection.results.each_with_index do |v, idx|
        table.with_data_table_row do |row|
          row.with_data_table_cell(value: "##{1000 + idx}")
          row.with_data_table_cell(value: (Date.today - idx).strftime("%Y-%m-%d"))
          row.with_data_table_cell(value: ["Purchase", "Refund", "Transfer", "Deposit"].sample)
          row.with_data_table_cell(value: "$#{(Random.rand * 1000).round(2)}", numeric: true)
        end
      end
    end
  end

  # Styled Table with Colors
  # ------------------------
  # Demonstrates daisyUI color system and styling options.
  def styled
    render ::Decor::Tables::DataTable.new(
      title: "Task Status",
      size: :sm,
      zebra: true
    ) do |table|
      table.with_data_table_header_row do |table_header|
        table_header.with_data_table_header_cell(title: "Task")
        table_header.with_data_table_header_cell(title: "Priority")
        table_header.with_data_table_header_cell(title: "Status")
        table_header.with_data_table_header_cell(title: "Progress", numeric: true)
      end

      [
        ["Implement authentication", "High", "In Progress", "75%", :warning],
        ["Design landing page", "Medium", "Complete", "100%", :success],
        ["Write documentation", "Low", "Not Started", "0%", :error],
        ["Set up CI/CD", "High", "In Progress", "50%", :info],
        ["Performance testing", "Medium", "Pending", "25%", :primary]
      ].each do |task, priority, status, progress, color|
        table.with_data_table_row do |row|
          row.with_data_table_cell(value: task)
          row.with_data_table_cell(
            value: priority,
            color: if priority == "High"
                     :error
                   else
                     ((priority == "Medium") ? :warning : :info)
                   end
          )
          row.with_data_table_cell(value: status, color: color)
          row.with_data_table_cell(value: progress, numeric: true)
        end
      end
    end
  end

  # @group Playground

  # @param title text
  # @param size [Symbol] select [~, xs, sm, md, lg, xl]
  # @param color [Symbol] select [~, base, primary, secondary, accent, neutral, success, error, warning, info]
  # @param style [Symbol] select [~, filled, outlined, ghost]
  # @param header_row_height [Symbol] select [~, comfortable, standard, tight]
  # @param row_height [Symbol] select [~, comfortable, standard, tight]
  # @param cell_emphasis [Symbol] select [~, regular, low]
  # @param weight [Symbol] select [~, light, regular, medium]
  # @param paginated toggle
  # @param selectable toggle
  # @param row_disabled number
  # @param highlight_on_hover_at number
  # @param row_hover_highlight toggle
  # @param highlight_row_at number
  # @param row_highlight [Symbol] select [~, low, medium, high]
  # @param row_selected number
  def playground(
    title: "Title of table",
    size: nil,
    color: nil,
    style: nil,
    header_row_height: :standard,
    row_height: :standard,
    paginated: true,
    cell_emphasis: :regular,
    weight: :regular,
    selectable: false,
    row_disabled: nil,
    highlight_on_hover_at: nil,
    row_hover_highlight: nil,
    highlight_row_at: nil,
    row_highlight: :medium,
    row_selected: nil
  )
    collection = ::ApplicationCollectionBackedQuery.wrap((1..10).to_a).new

    render ::Decor::Tables::DataTable.new(
      title: title,
      size: size,
      color: color,
      style: style
    ) do |table|
      if paginated
        table.with_pagination do
          render ::Decor::Pagination.new(
            path: "/",
            collection: collection,
            page_size: 10,
            current_page: 2,
            total_count: 300
          )
        end
      end

      table.with_data_table_header_row(selectable_as: selectable ? "header_checkbox" : nil) do |table_header|
        table_header.with_data_table_header_cell(
          row_height: header_row_height,
          title: "Row Number",
          sorted_direction: "asc",
          sort_key: :row_number
        )
        table_header.with_data_table_header_cell(
          row_height: header_row_height,
          title: "Number"
        )
        table_header.with_data_table_header_cell(
          row_height: header_row_height,
          title: "A random number",
          sort_key: :random
        )
        table_header.with_data_table_header_cell(
          row_height: header_row_height,
          title: "X1",
          numeric: true
        )
        table_header.with_data_table_header_cell(
          row_height: header_row_height,
          title: "X2",
          numeric: true
        )
        table_header.with_data_table_header_cell(
          row_height: header_row_height,
          title: "Y",
          numeric: true,
          sort_key: :y,
          weight: :regular
        )
        table_header.with_data_table_header_cell(
          row_height: header_row_height,
          title: "Z",
          weight: :light,
          colspan: 2
        )
      end

      collection.results.each_with_index do |v, idx|
        table.with_data_table_row(
          selectable_as: selectable ? "row_checkbox_#{idx}" : nil,
          disabled: row_disabled == idx,
          hover_highlight: (highlight_on_hover_at == idx) ? row_hover_highlight : nil,
          highlight: (highlight_row_at == idx) ? row_highlight : nil,
          selected: row_selected == idx
        ) do |row|
          row.with_data_table_cell(emphasis: cell_emphasis, weight: weight, row_height: row_height, value: idx)
          row.with_data_table_cell(emphasis: cell_emphasis, weight: weight, row_height: row_height, value: v)
          row.with_data_table_cell(emphasis: cell_emphasis, weight: weight, row_height: row_height, value: Random.rand, path: "#foo")
          row.with_data_table_cell(emphasis: cell_emphasis, weight: weight, row_height: row_height, colspan: 2, numeric: true, value: (Random.rand * 100).to_i)
          row.with_data_table_cell(emphasis: cell_emphasis, weight: weight, row_height: row_height, numeric: true, value: (Random.rand * 100).to_i)
          row.with_data_table_cell(emphasis: cell_emphasis, weight: weight, row_height: row_height, max_width: 50, value: Random.rand)
          row.with_data_table_cell(emphasis: cell_emphasis, weight: weight, row_height: row_height, value: " good!")
        end
      end
    end
  end

  # @group Size Variants

  # @param size select [xs, sm, md, lg, xl]
  def sizes(size: :md)
    render ::Decor::Tables::DataTable.new(
      title: "Table Size: #{size}",
      size: size
    ) do |table|
      table.with_data_table_header_row do |table_header|
        table_header.with_data_table_header_cell(title: "Name")
        table_header.with_data_table_header_cell(title: "Status")
        table_header.with_data_table_header_cell(title: "Value", numeric: true)
      end

      [
        ["Alice Johnson", "Active", 150],
        ["Bob Smith", "Pending", 250],
        ["Carol White", "Inactive", 75]
      ].each do |name, status, value|
        table.with_data_table_row do |row|
          row.with_data_table_cell(value: name)
          row.with_data_table_cell(value: status)
          row.with_data_table_cell(value: value, numeric: true)
        end
      end
    end
  end

  # @group Row Heights

  # @param row_height select [comfortable, standard, tight]
  # @param header_row_height select [comfortable, standard, tight]
  def row_heights(row_height: :standard, header_row_height: :standard)
    render ::Decor::Tables::DataTable.new(
      title: "Row Height Demo"
    ) do |table|
      table.with_data_table_header_row do |table_header|
        table_header.with_data_table_header_cell(title: "Density", row_height: header_row_height)
        table_header.with_data_table_header_cell(title: "Use Case", row_height: header_row_height)
        table_header.with_data_table_header_cell(title: "Description", row_height: header_row_height)
      end

      [
        ["Comfortable", "Executive Dashboard", "More white space for easy scanning"],
        ["Standard", "General Purpose", "Default spacing for most use cases"],
        ["Tight", "Data-Dense View", "Compact spacing for maximum information"]
      ].each do |density, use_case, description|
        table.with_data_table_row(hover_highlight: true) do |row|
          row.with_data_table_cell(value: density, row_height: row_height, weight: :medium)
          row.with_data_table_cell(value: use_case, row_height: row_height)
          row.with_data_table_cell(value: description, row_height: row_height, emphasis: :low)
        end
      end
    end
  end

  # @group Typography

  # Cell Typography Variations
  # --------------------------
  # Shows different cell typography, emphasis, and weight options.
  def typography
    render ::Decor::Tables::DataTable.new(
      title: "Financial Summary"
    ) do |table|
      table.with_data_table_header_row do |table_header|
        table_header.with_data_table_header_cell(title: "Account")
        table_header.with_data_table_header_cell(title: "Balance", numeric: true)
        table_header.with_data_table_header_cell(title: "Change", numeric: true)
        table_header.with_data_table_header_cell(title: "Notes")
      end

      [
        ["Checking Account", "$15,234.56", "+$234.56", "Primary account", :regular, :medium],
        ["Savings Account", "$45,789.12", "+$1,234.12", "High yield savings", :regular, :regular],
        ["Investment Portfolio", "$128,456.78", "-$2,456.78", "Diversified portfolio", :regular, :medium],
        ["Emergency Fund", "$25,000.00", "$0.00", "Six months expenses", :low, :light],
        ["Credit Card", "-$3,456.78", "-$456.78", "Monthly expenses", :regular, :regular]
      ].each do |account, balance, change, notes, emphasis, weight|
        table.with_data_table_row(hover_highlight: true) do |row|
          row.with_data_table_cell(value: account, weight: weight)
          row.with_data_table_cell(value: balance, numeric: true, weight: :medium)
          row.with_data_table_cell(
            value: change,
            numeric: true,
            emphasis: change.start_with?("-") ? :regular : :low,
            weight: change.start_with?("-") ? :medium : :regular
          )
          row.with_data_table_cell(value: notes, emphasis: emphasis)
        end
      end
    end
  end

  # @group Special Features

  # Zebra Striping
  # --------------
  # Alternating row colors for better readability.
  def zebra_striping
    render ::Decor::Tables::DataTable.new(
      title: "Zebra Striped Table",
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

  # Pinned Header Rows
  # ------------------
  # Sticky headers that remain visible while scrolling.
  def pinned_rows
    render ::Decor::Tables::DataTable.new(
      title: "Pinned Headers (Scroll to see effect)",
      pin_rows: true,
      zebra: true
    ) do |table|
      table.with_data_table_header_row do |table_header|
        table_header.with_data_table_header_cell(title: "ID")
        table_header.with_data_table_header_cell(title: "Name")
        table_header.with_data_table_header_cell(title: "Department")
        table_header.with_data_table_header_cell(title: "Salary", numeric: true)
      end

      (1..20).each do |i|
        table.with_data_table_row do |row|
          row.with_data_table_cell(value: i)
          row.with_data_table_cell(value: "Employee #{i}")
          row.with_data_table_cell(value: ["Engineering", "Marketing", "Sales", "HR"].sample)
          row.with_data_table_cell(value: "$#{rand(50000..99999).to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse}", numeric: true)
        end
      end
    end
  end

  # Column Stretching
  # -----------------
  # Demonstrates stretch_divisor for flexible column widths.
  # @param test_stretch number
  def stretch_columns(test_stretch: 2)
    collection = ::ApplicationCollectionBackedQuery.wrap((1..5).to_a).new

    render ::Decor::Tables::DataTable.new(
      title: "Flexible Column Widths"
    ) do |table|
      table.with_data_table_header_row do |table_header|
        table_header.with_data_table_header_cell(title: "Index")
        table_header.with_data_table_header_cell(title: "Column A", stretch_divisor: (test_stretch > 0) ? test_stretch : nil)
        table_header.with_data_table_header_cell(title: "Column B", stretch_divisor: (test_stretch > 1) ? test_stretch : nil)
        table_header.with_data_table_header_cell(title: "Column C", stretch_divisor: (test_stretch > 2) ? test_stretch : nil)
        table_header.with_data_table_header_cell(title: "Column D", stretch_divisor: (test_stretch > 3) ? test_stretch : nil)
      end

      collection.results.each_with_index do |v, idx|
        table.with_data_table_row do |row|
          row.with_data_table_cell(value: idx)
          row.with_data_table_cell(value: "Content A")
          row.with_data_table_cell(value: "Content B")
          row.with_data_table_cell(value: "Content C")
          row.with_data_table_cell(value: "Content D")
        end
      end
    end
  end

  # Expandable Row Content
  # ----------------------
  # Shows rows with expandable details section.
  def expandable_content
    render ::Decor::Tables::DataTable.new(
      title: "Order Management",
      subtitle: "Click to expand order details"
    ) do |table|
      table.with_data_table_header_row do |table_header|
        table_header.with_data_table_header_cell(title: "Order #")
        table_header.with_data_table_header_cell(title: "Customer")
        table_header.with_data_table_header_cell(title: "Total", numeric: true)
        table_header.with_data_table_header_cell(title: "Status")
      end

      [
        ["#12345", "Alice Johnson", "$1,234.56", "Shipped"],
        ["#12346", "Bob Smith", "$567.89", "Processing"],
        ["#12347", "Carol Davis", "$2,345.67", "Delivered"]
      ].each_with_index do |(order_id, customer, total, status), idx|
        table.with_data_table_row(hover_highlight: true) do |row|
          row.with_data_table_cell(value: order_id, weight: :medium)
          row.with_data_table_cell(value: customer)
          row.with_data_table_cell(value: total, numeric: true, weight: :medium)
          row.with_data_table_cell(value: status)

          if idx == 1  # Show expanded content for second row as example
            row.with_expanded_content do |expanded|
              expanded.td(colspan: 4, class: "px-6 py-4 bg-gray-50") do
                expanded.div(class: "space-y-3") do
                  expanded.h4("Order Details", class: "font-medium text-gray-900")
                  expanded.div(class: "grid grid-cols-2 gap-4 text-sm") do
                    expanded.div do
                      expanded.p("Items:", class: "font-medium text-gray-700")
                      expanded.ul(class: "mt-1 text-gray-600") do
                        expanded.li("MacBook Pro 16\" × 1")
                        expanded.li("Magic Mouse × 1")
                      end
                    end
                    expanded.div do
                      expanded.p("Shipping:", class: "font-medium text-gray-700")
                      expanded.p("123 Main St, City, ST 12345", class: "mt-1 text-gray-600")
                      expanded.p("Expected: Dec 20, 2023", class: "text-gray-600")
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
