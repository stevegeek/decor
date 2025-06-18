# @label DataTable
class ::Decor::Tables::DataTablePreview < ::Lookbook::Preview
  # DataTable
  # ---------
  #
  # A table for the display of tabulated data.
  #
  # Note: *DataTables are normally constructed using DataTableBuilder* which provides all the
  # glue logic from table to application and enabled sorting, filtering and so on.
  #
  # @param title text
  # @param header_row_height select [~, comfortable, standard, tight]
  # @param row_height select [~, comfortable, standard, tight]
  # @param cell_emphasis select [~, regular, low]
  # @param weight select [~, light, regular, medium]
  # @param paginated toggle
  # @param selectable toggle
  # @param row_disabled number
  # @param highlight_on_hover_at number
  # @param row_hover_highlight toggle
  # @param highlight_row_at number
  # @param row_highlight select [~, low, medium, high]
  # @param row_selected number
  def playground(
    title: "Title of table",
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
      title: title
    ) do |table|
      if paginated
        table.with_pagination(
          path: "/", # Just for testing, to ensure url_for doesn't break
          collection: collection,
          page_size: 10,
          current_page: 2,
          total_count: 300
        )
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

  # @param test_stretch number
  def with_stretch_columns(title: "Title of table", test_stretch: 0)
    collection = ::ApplicationCollectionBackedQuery.wrap((1..10).to_a).new

    render ::Decor::Tables::DataTable.new(
      title: title
    ) do |table|
      table.with_data_table_header_row do |table_header|
        table_header.with_data_table_header_cell(title: "Index")
        table_header.with_data_table_header_cell(title: "A", stretch_divisor: (test_stretch > 0) ? test_stretch : nil)
        table_header.with_data_table_header_cell(title: "B", stretch_divisor: (test_stretch > 1) ? test_stretch : nil)
        table_header.with_data_table_header_cell(title: "C", stretch_divisor: (test_stretch > 2) ? test_stretch : nil)
        table_header.with_data_table_header_cell(title: "D", stretch_divisor: (test_stretch > 3) ? test_stretch : nil)
      end
      collection.results.each_with_index do |v, idx|
        table.with_data_table_row do |row|
          row.with_data_table_cell(value: idx)
          row.with_data_table_cell(value: "a")
          row.with_data_table_cell(value: "b")
          row.with_data_table_cell(value: "c")
          row.with_data_table_cell(value: "d")
        end
      end
    end
  end

  # DaisyUI Size Variants
  # ---------------------
  #
  # Demonstrates different table sizes using daisyUI size classes.
  #
  # @param size select [xs, sm, md, lg, xl]
  def daisyui_sizes(size: :md)
    render ::Decor::Tables::DataTable.new(
      title: "DaisyUI Size: #{size}",
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

  # DaisyUI Zebra Striping
  # ----------------------
  #
  # Shows the zebra striping feature for alternating row colors.
  def daisyui_zebra
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

  # DaisyUI Pinned Rows
  # -------------------
  #
  # Demonstrates sticky header rows using table-pin-rows.
  def daisyui_pinned_rows
    render ::Decor::Tables::DataTable.new(
      title: "Pinned Rows (Sticky Headers)",
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

  # DaisyUI Color System
  # --------------------
  #
  # Shows different daisyUI colors applied to cells and row highlights.
  def daisyui_colors
    render ::Decor::Tables::DataTable.new(
      title: "DaisyUI Color System",
      size: :sm
    ) do |table|
      table.with_data_table_header_row do |table_header|
        table_header.with_data_table_header_cell(title: "Color")
        table_header.with_data_table_header_cell(title: "Status")
        table_header.with_data_table_header_cell(title: "Usage")
      end

      [
        ["Primary", "primary", :primary],
        ["Secondary", "secondary", :secondary],
        ["Accent", "accent", :accent],
        ["Success", "success", :success],
        ["Warning", "warning", :warning],
        ["Error", "error", :error],
        ["Info", "info", :info]
      ].each do |color_name, status, color_symbol|
        table.with_data_table_row(highlight: color_symbol) do |row|
          row.with_data_table_cell(value: color_name, color: color_symbol)
          row.with_data_table_cell(value: status)
          row.with_data_table_cell(value: "Example usage")
        end
      end
    end
  end

  # Combined DaisyUI Features
  # -------------------------
  #
  # Shows multiple daisyUI features working together.
  def daisyui_combined
    render ::Decor::Tables::DataTable.new(
      title: "Combined DaisyUI Features",
      subtitle: "Zebra striping + Pinned rows + Color system",
      size: :sm,
      zebra: true,
      pin_rows: true
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
          row.with_data_table_cell(value: priority, color: (if priority == "High"
                                                              :error
                                                            else
                                                              (priority == "Medium") ? :warning : :info
                                                            end))
          row.with_data_table_cell(value: status, color: color)
          row.with_data_table_cell(value: progress, numeric: true)
        end
      end
    end
  end

  # Selectable Rows with Multiple States
  # ------------------------------------
  #
  # Demonstrates row selection, highlighting, and different row states.
  def selectable_with_states
    render ::Decor::Tables::DataTable.new(
      title: "User Management",
      subtitle: "Selectable rows with different states and highlights"
    ) do |table|
      table.with_data_table_header_row(selectable_as: "select_all") do |table_header|
        table_header.with_data_table_header_cell(title: "Name", sort_key: :name, sorted_direction: :asc)
        table_header.with_data_table_header_cell(title: "Email", sort_key: :email)
        table_header.with_data_table_header_cell(title: "Role")
        table_header.with_data_table_header_cell(title: "Last Login", sort_key: :last_login)
        table_header.with_data_table_header_cell(title: "Status")
      end

      [
        ["Alice Johnson", "alice@company.com", "Admin", "2023-12-15", "Active", false, false, nil],
        ["Bob Smith", "bob@company.com", "Developer", "2023-12-14", "Active", true, false, :low],
        ["Carol Davis", "carol@company.com", "Designer", "2023-12-10", "Pending", false, false, nil],
        ["David Wilson", "david@company.com", "Manager", "2023-12-12", "Active", false, true, nil],
        ["Eve Brown", "eve@company.com", "Developer", "2023-11-28", "Inactive", false, false, :high]
      ].each_with_index do |(name, email, role, last_login, status, selected, disabled, highlight), idx|
        table.with_data_table_row(
          selectable_as: "user_ids[]",
          selected: selected,
          disabled: disabled,
          highlight: highlight,
          hover_highlight: true,
          path: disabled ? nil : "/users/#{idx + 1}"
        ) do |row|
          row.with_data_table_cell(value: name)
          row.with_data_table_cell(value: email)
          row.with_data_table_cell(value: role)
          row.with_data_table_cell(value: last_login)
          row.with_data_table_cell(value: status)
        end
      end
    end
  end

  # Typography and Cell Variations
  # ------------------------------
  #
  # Shows different cell typography, alignment, and formatting options.
  def typography_variations
    render ::Decor::Tables::DataTable.new(
      title: "Financial Dashboard",
      subtitle: "Different cell typography and numeric formatting"
    ) do |table|
      table.with_data_table_header_row do |table_header|
        table_header.with_data_table_header_cell(title: "Account", stretch_divisor: 2)
        table_header.with_data_table_header_cell(title: "Balance", sort_key: :balance, numeric: true, sorted_direction: :desc)
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

  # Row Height Variations
  # --------------------
  #
  # Demonstrates different row heights in a complete table context.
  def row_height_variations
    render ::Decor::Tables::DataTable.new(
      title: "Content Density Examples",
      subtitle: "Different row heights for various use cases"
    ) do |table|
      table.with_data_table_header_row do |table_header|
        table_header.with_data_table_header_cell(title: "Density", row_height: :standard)
        table_header.with_data_table_header_cell(title: "Use Case", row_height: :standard)
        table_header.with_data_table_header_cell(title: "Description", row_height: :standard)
      end

      [
        ["Comfortable", "Executive Dashboard", "More white space for easy scanning", :comfortable],
        ["Standard", "General Purpose", "Default spacing for most use cases", :standard],
        ["Tight", "Data-Dense View", "Compact spacing for maximum information", :tight]
      ].each do |density, use_case, description, row_height|
        table.with_data_table_row(hover_highlight: true) do |row|
          row.with_data_table_cell(value: density, row_height: row_height, weight: :medium)
          row.with_data_table_cell(value: use_case, row_height: row_height)
          row.with_data_table_cell(value: description, row_height: row_height, emphasis: :low)
        end
      end
    end
  end

  # Sortable Columns
  # ---------------
  #
  # Demonstrates sortable headers with different sort states.
  def sortable_columns
    render ::Decor::Tables::DataTable.new(
      title: "Product Inventory",
      subtitle: "Sortable columns with active sort indicators"
    ) do |table|
      table.with_data_table_header_row do |table_header|
        table_header.with_data_table_header_cell(title: "Product Name", sort_key: :name)
        table_header.with_data_table_header_cell(title: "Category", sort_key: :category)
        table_header.with_data_table_header_cell(title: "Price", sort_key: :price, numeric: true, sorted_direction: :desc)
        table_header.with_data_table_header_cell(title: "Stock", sort_key: :stock, numeric: true)
        table_header.with_data_table_header_cell(title: "Status", sort_key: :status, sorted_direction: :asc)
      end

      [
        ["MacBook Pro 16\"", "Laptops", "$2,399.00", 15, "In Stock"],
        ["iPhone 15 Pro", "Phones", "$999.00", 42, "In Stock"],
        ["iPad Air", "Tablets", "$599.00", 8, "Low Stock"],
        ["Apple Watch Ultra", "Wearables", "$799.00", 0, "Out of Stock"],
        ["AirPods Pro", "Audio", "$249.00", 25, "In Stock"]
      ].each do |name, category, price, stock, status|
        table.with_data_table_row(hover_highlight: true, path: "/products/#{name.parameterize}") do |row|
          row.with_data_table_cell(value: name, content_clickable: true)
          row.with_data_table_cell(value: category)
          row.with_data_table_cell(value: price, numeric: true, weight: :medium)
          row.with_data_table_cell(value: stock, numeric: true)
          row.with_data_table_cell(
            value: status,
            emphasis: ((status == "Out of Stock") ? :regular : :low),
            weight: ((status == "Out of Stock") ? :medium : :regular)
          )
        end
      end
    end
  end

  # Expandable Rows
  # --------------
  #
  # Shows rows with expandable content for additional details.
  def expandable_rows
    render ::Decor::Tables::DataTable.new(
      title: "Order Management",
      subtitle: "Rows with expandable details"
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
