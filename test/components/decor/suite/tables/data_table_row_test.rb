# frozen_string_literal: true

require "test_helper"

class ::Decor::Suite::Tables::DataTableRowTest < ActiveSupport::TestCase
  test "renders as <tr>" do
    html = render_component(::Decor::Suite::Tables::DataTableRow.new)
    assert_includes html, "<tr"
  end

  test "applies the suite row stimulus identifier" do
    html = render_component(::Decor::Suite::Tables::DataTableRow.new)
    assert_includes html, "decor--suite--tables--data-table-row"
  end

  test "with_data_table_cell defaults to the Suite cell skin" do
    component = ::Decor::Suite::Tables::DataTableRow.new
    cell = component.with_data_table_cell(value: "Alice")
    assert_kind_of ::Decor::Suite::Tables::DataTableCell, cell

    html = render_component(component)
    assert_includes html, "Alice"
    assert_includes html, "decor--suite--tables--data-table-cell"
  end

  test "renders multiple cells in order" do
    component = ::Decor::Suite::Tables::DataTableRow.new
    component.with_data_table_cell(value: "Alice")
    component.with_data_table_cell(value: "alice@example.com")
    html = render_component(component)

    assert_includes html, "Alice"
    assert_includes html, "alice@example.com"
    assert html.index("Alice") < html.index("alice@example.com")
  end

  test "cell block (yielded under render) overrides value rendering" do
    component = ::Decor::Suite::Tables::DataTableRow.new
    component.with_data_table_cell(value: "ignored") { "from-block" }
    html = render_component(component)

    assert_includes html, "from-block"
  end

  test "without selectable_as does not emit a checkbox" do
    html = render_component(::Decor::Suite::Tables::DataTableRow.new)
    refute_includes html, 'type="checkbox"'
  end

  test "with selectable_as emits a Suite checkbox cell with the given name and value" do
    html = render_component(::Decor::Suite::Tables::DataTableRow.new(selectable_as: "rows[]", selectable_value: "abc123"))
    assert_includes html, 'type="checkbox"'
    assert_includes html, 'name="rows[]"'
    assert_includes html, 'value="abc123"'
  end

  test "selected: true marks the row checkbox as checked" do
    html = render_component(::Decor::Suite::Tables::DataTableRow.new(selectable_as: "rows[]", selected: true))
    assert_includes html, "checked"
  end

  test "disabled: true applies opacity-50 and disables the checkbox" do
    html = render_component(::Decor::Suite::Tables::DataTableRow.new(selectable_as: "rows[]", disabled: true))
    assert_includes html, "decor:opacity-50"
    assert_includes html, "disabled"
  end

  test "hidden: true applies the hidden utility" do
    html = render_component(::Decor::Suite::Tables::DataTableRow.new(hidden: true))
    assert_includes html, "decor:hidden"
  end

  test "hover_highlight: true uses the suite-gray-25 hover bg" do
    html = render_component(::Decor::Suite::Tables::DataTableRow.new(hover_highlight: true))
    assert_includes html, "decor:hover:bg-suite-gray-25"
    assert_includes html, "decor:transition-colors"
  end

  test "highlight: :low uses the suite primary tint background" do
    html = render_component(::Decor::Suite::Tables::DataTableRow.new(highlight: :low))
    assert_includes html, "decor:bg-suite-primary-50"
  end

  test "highlight: :high uses the suite-primary-100 background" do
    html = render_component(::Decor::Suite::Tables::DataTableRow.new(highlight: :high))
    assert_includes html, "decor:bg-suite-primary-100"
  end

  test "with_expanded_content renders a second <tr> with the block output" do
    component = ::Decor::Suite::Tables::DataTableRow.new
    component.with_data_table_cell(value: "primary")
    component.with_expanded_content { "expanded-body" }
    html = render_component(component)

    assert_includes html, "expanded-body"
    assert_includes html, "decor:border-b"
    assert_equal 2, html.scan("<tr").length
  end

  test "inherits from the abstract DataTableRow base" do
    assert_operator ::Decor::Suite::Tables::DataTableRow, :<, ::Decor::Components::Tables::DataTableRow
  end
end
