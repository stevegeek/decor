# frozen_string_literal: true

require "test_helper"

class ::Decor::Suite::Tables::DataTableHeaderRowTest < ActiveSupport::TestCase
  test "renders as <tr>" do
    html = render_component(::Decor::Suite::Tables::DataTableHeaderRow.new)
    assert_includes html, "<tr"
  end

  test "applies the suite header-row stimulus identifier" do
    html = render_component(::Decor::Suite::Tables::DataTableHeaderRow.new)
    assert_includes html, "decor--suite--tables--data-table-header-row"
  end

  test "with_data_table_header_cell defaults to the Suite header-cell skin" do
    component = ::Decor::Suite::Tables::DataTableHeaderRow.new
    cell = component.with_data_table_header_cell(title: "Name")
    assert_kind_of ::Decor::Suite::Tables::DataTableHeaderCell, cell

    html = render_component(component)
    assert_includes html, "Name"
    assert_includes html, "decor--suite--tables--data-table-header-cell"
  end

  test "renders multiple header cells in order" do
    component = ::Decor::Suite::Tables::DataTableHeaderRow.new
    component.with_data_table_header_cell(title: "Name")
    component.with_data_table_header_cell(title: "Email")
    html = render_component(component)

    assert_includes html, "Name"
    assert_includes html, "Email"
    assert html.index("Name") < html.index("Email")
  end

  test "without selectable_as does not emit a checkbox" do
    html = render_component(::Decor::Suite::Tables::DataTableHeaderRow.new)
    refute_includes html, 'type="checkbox"'
  end

  test "with selectable_as emits a Suite checkbox cell with the given name" do
    html = render_component(::Decor::Suite::Tables::DataTableHeaderRow.new(selectable_as: "rows[]"))
    assert_includes html, 'type="checkbox"'
    assert_includes html, 'name="rows[]"'
    assert_includes html, "decor--suite--tables--data-table-cell"
  end

  test "selected: true marks the header checkbox as checked" do
    html = render_component(::Decor::Suite::Tables::DataTableHeaderRow.new(selectable_as: "rows[]", selected: true))
    assert_includes html, 'type="checkbox"'
    assert_includes html, "checked"
  end

  test "disabled: true marks the header checkbox as disabled" do
    html = render_component(::Decor::Suite::Tables::DataTableHeaderRow.new(selectable_as: "rows[]", disabled: true))
    assert_includes html, "disabled"
  end

  test "inherits from the abstract DataTableHeaderRow base" do
    assert_operator ::Decor::Suite::Tables::DataTableHeaderRow, :<, ::Decor::Components::Tables::DataTableHeaderRow
  end
end
