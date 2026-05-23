# frozen_string_literal: true

require "test_helper"

class Decor::Daisy::Tables::DataTableHeaderRowTest < ActiveSupport::TestCase
  test "renders as <tr>" do
    html = render_component(::Decor::Daisy::Tables::DataTableHeaderRow.new)
    assert_includes html, "<tr"
  end

  test "applies the daisy header-row stimulus identifier" do
    html = render_component(::Decor::Daisy::Tables::DataTableHeaderRow.new)
    assert_includes html, "decor--daisy--tables--data-table-header-row"
  end

  test "renders nested header cells passed via with_data_table_header_cell" do
    component = ::Decor::Daisy::Tables::DataTableHeaderRow.new
    component.with_data_table_header_cell(::Decor::Daisy::Tables::DataTableHeaderCell.new(title: "Name"))
    component.with_data_table_header_cell(::Decor::Daisy::Tables::DataTableHeaderCell.new(title: "Email"))
    html = render_component(component)

    assert_includes html, "Name"
    assert_includes html, "Email"
  end

  test "without selectable_as does not emit a checkbox" do
    html = render_component(::Decor::Daisy::Tables::DataTableHeaderRow.new)
    refute_includes html, 'type="checkbox"'
  end

  test "with selectable_as emits a checkbox cell with the given name" do
    html = render_component(::Decor::Daisy::Tables::DataTableHeaderRow.new(selectable_as: "rows[]"))
    assert_includes html, 'type="checkbox"'
    assert_includes html, 'name="rows[]"'
  end

  test "selected: true marks the header checkbox as checked" do
    html = render_component(::Decor::Daisy::Tables::DataTableHeaderRow.new(selectable_as: "rows[]", selected: true))
    assert_includes html, 'type="checkbox"'
    assert_includes html, "checked"
  end

  test "disabled: true marks the header checkbox as disabled" do
    html = render_component(::Decor::Daisy::Tables::DataTableHeaderRow.new(selectable_as: "rows[]", disabled: true))
    assert_includes html, "disabled"
  end

  test "inherits from the abstract DataTableHeaderRow base" do
    assert_operator ::Decor::Daisy::Tables::DataTableHeaderRow, :<, ::Decor::Components::Tables::DataTableHeaderRow
  end

  test "yields a block (consumed by vanish) without rendering it" do
    html = render_component(::Decor::Daisy::Tables::DataTableHeaderRow.new) { "yielded-content" }
    refute_includes html, "yielded-content"
  end
end
