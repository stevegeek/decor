require "test_helper"

class ::Decor::Suite::Tables::DataTableTest < ActiveSupport::TestCase
  test "renders successfully with Suite stimulus identifier" do
    rendered = render_component(::Decor::Suite::Tables::DataTable.new)
    assert_includes rendered, "decor--suite--tables--data-table"
  end

  test "renders title and subtitle in Suite header band" do
    rendered = render_component(
      ::Decor::Suite::Tables::DataTable.new(title: "Products", subtitle: "All inventory")
    )
    assert_includes rendered, "Products"
    assert_includes rendered, "All inventory"
    assert_includes rendered, "decor:suite-section-title"
    assert_includes rendered, "decor:suite-description"
    assert_includes rendered, "decor:border-suite-hairline"
  end

  test "uses Suite card chrome on root" do
    rendered = render_component(::Decor::Suite::Tables::DataTable.new)
    assert_includes rendered, "decor:bg-white"
    assert_includes rendered, "decor:border-suite-hairline"
    assert_includes rendered, "decor:rounded-suite-card"
  end

  test "renders empty state with dashed Suite callout" do
    rendered = render_component(::Decor::Suite::Tables::DataTable.new)
    assert_includes rendered, "No data..."
    assert_includes rendered, "decor:border-dashed"
    assert_includes rendered, "decor:border-suite-hairline"
  end

  test "renders header rows in gray-25 band" do
    rendered = render_component(::Decor::Suite::Tables::DataTable.new) do |c|
      c.with_data_table_header_row do |h|
        h.with_data_table_header_cell(title: "Name")
      end
    end
    assert_includes rendered, "decor:bg-suite-gray-25"
    assert_includes rendered, "Name"
  end

  test "renders body rows" do
    rendered = render_component(::Decor::Suite::Tables::DataTable.new) do |c|
      c.with_data_table_row do |r|
        r.with_data_table_cell(value: "Row content")
      end
    end
    assert_includes rendered, "Row content"
    refute_includes rendered, "No data..."
  end

  test "applies 13px dense body type to table" do
    rendered = render_component(::Decor::Suite::Tables::DataTable.new)
    assert_includes rendered, "decor:text-[13px]"
    assert_includes rendered, "decor:w-full"
    assert_includes rendered, "decor:border-collapse"
  end

  test "zebra prop emits striping utility for tbody rows" do
    rendered = render_component(::Decor::Suite::Tables::DataTable.new(zebra: true))
    assert_includes rendered, "tbody_tr:nth-child(even)"
    assert_includes rendered, "bg-suite-gray-25"
  end

  test "pin_rows prop emits sticky thead utility" do
    rendered = render_component(::Decor::Suite::Tables::DataTable.new(pin_rows: true))
    assert_includes rendered, "thead]:sticky"
  end

  test "passes table_html_options through to the table element" do
    rendered = render_component(
      ::Decor::Suite::Tables::DataTable.new(table_html_options: {data: {turbo: "true"}})
    )
    assert_includes rendered, "data-turbo"
  end

  test "emits Stimulus values for selection persistence" do
    rendered = render_component(
      ::Decor::Suite::Tables::DataTable.new(
        table_identifier: "users_table",
        enable_selection_persistence: true
      )
    )
    assert_includes rendered, "users_table"
    assert_includes rendered, "persist-selections"
  end

  test "emits Stimulus targets for scroll shadow + body" do
    rendered = render_component(::Decor::Suite::Tables::DataTable.new)
    assert_includes rendered, "tableContentContainer"
    assert_includes rendered, "tableBody"
  end

  test "inherits from the abstract DataTable base" do
    assert_operator ::Decor::Suite::Tables::DataTable, :<, ::Decor::Components::Tables::DataTable
  end

  test "Suite skin does not leak daisyUI semantic color tokens" do
    rendered = render_component(
      ::Decor::Suite::Tables::DataTable.new(title: "Test", subtitle: "Sub")
    )
    refute_includes rendered, "decor:bg-base-200"
    refute_includes rendered, "decor:text-base-content"
    refute_includes rendered, "decor:border-base-300"
  end
end
