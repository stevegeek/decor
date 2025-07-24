require "test_helper"

class Decor::Tables::DataTableTest < ActiveSupport::TestCase
  test "renders successfully" do
    component = Decor::Tables::DataTable.new
    rendered = render_component(component)

    assert_includes rendered, "table"
    assert_includes rendered, "decor--tables--data-table"
  end

  test "renders with daisyUI table classes by default" do
    component = Decor::Tables::DataTable.new
    rendered = render_component(component)

    assert_includes rendered, "table"
  end

  test "supports daisyUI size variants" do
    component = Decor::Tables::DataTable.new(size: :xs)
    rendered = render_component(component)
    assert_includes rendered, "table-xs"

    component = Decor::Tables::DataTable.new(size: :sm)
    rendered = render_component(component)
    assert_includes rendered, "table-sm"

    component = Decor::Tables::DataTable.new(size: :lg)
    rendered = render_component(component)
    assert_includes rendered, "table-lg"

    component = Decor::Tables::DataTable.new(size: :xl)
    rendered = render_component(component)
    assert_includes rendered, "table-xl"

    # md is default, no class needed
    component = Decor::Tables::DataTable.new(size: :md)
    rendered = render_component(component)
    refute_includes rendered, "table-md"
  end

  test "supports zebra striping" do
    component = Decor::Tables::DataTable.new(zebra: true)
    rendered = render_component(component)

    assert_includes rendered, "table-zebra"
  end

  test "supports pinned rows" do
    component = Decor::Tables::DataTable.new(pin_rows: true)
    rendered = render_component(component)

    assert_includes rendered, "table-pin-rows"
  end

  test "supports pinned columns" do
    component = Decor::Tables::DataTable.new(pin_cols: true)
    rendered = render_component(component)

    assert_includes rendered, "table-pin-cols"
  end

  test "supports title and subtitle with daisyUI colors" do
    component = Decor::Tables::DataTable.new(title: "Test Table", subtitle: "Test Subtitle")
    rendered = render_component(component)

    assert_includes rendered, "Test Table"
    assert_includes rendered, "Test Subtitle"
    assert_includes rendered, "text-base-content"
    assert_includes rendered, "text-base-content/70"
  end

  test "uses daisyUI overflow wrapper" do
    component = Decor::Tables::DataTable.new
    rendered = render_component(component)

    assert_includes rendered, "overflow-x-auto"
  end

  test "uses daisyUI color system for header" do
    component = Decor::Tables::DataTable.new
    rendered = render_component(component)

    assert_includes rendered, "bg-base-200"
  end

  test "supports style system with daisyUI colors" do
    component = Decor::Tables::DataTable.new(style: :bordered)
    rendered = render_component(component)

    assert_includes rendered, "border-base-300"
  end

  test "renders empty state with daisyUI colors" do
    component = Decor::Tables::DataTable.new
    rendered = render_component(component)

    assert_includes rendered, "No data..."
    assert_includes rendered, "bg-base-100"
    assert_includes rendered, "border-base-300"
  end

  test "maintains backward compatibility with existing attributes" do
    component = Decor::Tables::DataTable.new(
      style: :minimal,
      striped: true,
      compact: true
    )
    rendered = render_component(component)

    assert_includes rendered, "table"
    assert_includes rendered, "text-xs"
    assert_includes rendered, "divide-base-200"
  end

  test "supports header rows slot" do
    component = Decor::Tables::DataTable.new
    rendered = render_component(component) do |c|
      c.with_data_table_header_row do |header_row|
        header_row.with_data_table_header_cell(title: "Name")
        header_row.with_data_table_header_cell(title: "Email")
      end
    end

    assert_includes rendered, "Name"
    assert_includes rendered, "Email"
  end

  test "supports body rows slot" do
    component = Decor::Tables::DataTable.new
    rendered = render_component(component) do |c|
      c.with_data_table_row do |row|
        row.with_data_table_cell(value: "Test Name")
        row.with_data_table_cell(value: "test@example.com")
      end
    end

    assert_includes rendered, "Test Name"
    assert_includes rendered, "test@example.com"
  end

  test "supports footer slot" do
    component = Decor::Tables::DataTable.new
    rendered = render_component(component) do |c|
      c.with_data_table_footer(message: "Footer message")
    end

    assert_includes rendered, "Footer message"
    assert_includes rendered, "border-base-300"
  end

  test "component inherits from PhlexComponent" do
    component = Decor::Tables::DataTable.new

    assert component.is_a?(Decor::PhlexComponent)
  end

  test "supports search and filter slot" do
    component = Decor::Tables::DataTable.new
    rendered = render_component(component) do |c|
      c.with_search_and_filter do
        c.div(class: "decor--search-and-filter") { "Search and Filter Content" }
      end
    end

    assert_includes rendered, "decor--search-and-filter"
  end

  test "supports pagination slot" do
    component = Decor::Tables::DataTable.new
    rendered = render_component(component) do |c|
      c.with_pagination do
        c.div(class: "decor--pagination") { "Pagination Content" }
      end
    end

    assert_includes rendered, "decor--pagination"
  end
end
