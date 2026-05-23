# frozen_string_literal: true

require "test_helper"

class Decor::Daisy::Tables::DataTableRowTest < ActiveSupport::TestCase
  test "renders as <tr>" do
    html = render_component(::Decor::Daisy::Tables::DataTableRow.new)
    assert_includes html, "<tr"
  end

  test "applies the daisy row stimulus identifier" do
    html = render_component(::Decor::Daisy::Tables::DataTableRow.new)
    assert_includes html, "decor--daisy--tables--data-table-row"
  end

  test "renders nested cells passed via with_data_table_cell" do
    component = ::Decor::Daisy::Tables::DataTableRow.new
    component.with_data_table_cell(::Decor::Daisy::Tables::DataTableCell.new(value: "Alice"))
    component.with_data_table_cell(::Decor::Daisy::Tables::DataTableCell.new(value: "alice@example.com"))
    html = render_component(component)

    assert_includes html, "Alice"
    assert_includes html, "alice@example.com"
  end

  test "without selectable_as does not emit a checkbox" do
    html = render_component(::Decor::Daisy::Tables::DataTableRow.new)
    refute_includes html, 'type="checkbox"'
  end

  test "with selectable_as emits a checkbox cell with the given name" do
    html = render_component(::Decor::Daisy::Tables::DataTableRow.new(selectable_as: "rows[]"))
    assert_includes html, 'type="checkbox"'
    assert_includes html, 'name="rows[]"'
  end

  test "selected: true marks the row checkbox as checked" do
    html = render_component(::Decor::Daisy::Tables::DataTableRow.new(selectable_as: "rows[]", selected: true))
    assert_includes html, "checked"
  end

  test "disabled: true applies opacity-50 + disables the checkbox" do
    html = render_component(::Decor::Daisy::Tables::DataTableRow.new(selectable_as: "rows[]", disabled: true))
    assert_includes html, "decor:opacity-50"
    assert_includes html, "disabled"
  end

  test "hidden: true applies the hidden utility" do
    html = render_component(::Decor::Daisy::Tables::DataTableRow.new(hidden: true))
    assert_includes html, "decor:hidden"
  end

  test "hover_highlight: true applies hover bg + transition utilities" do
    html = render_component(::Decor::Daisy::Tables::DataTableRow.new(hover_highlight: true))
    assert_includes html, "decor:hover:bg-base-200"
    assert_includes html, "decor:transition-colors"
  end

  test "highlight: :primary applies the primary tint background" do
    html = render_component(::Decor::Daisy::Tables::DataTableRow.new(highlight: :primary))
    assert_includes html, "decor:bg-primary/20"
  end

  test "highlight: :gray_low applies bg-gray-50" do
    html = render_component(::Decor::Daisy::Tables::DataTableRow.new(highlight: :gray_low))
    assert_includes html, "decor:bg-gray-50"
  end

  test "expanded content block renders a second <tr> with the block output" do
    component = ::Decor::Daisy::Tables::DataTableRow.new
    component.with_data_table_cell(::Decor::Daisy::Tables::DataTableCell.new(value: "primary"))
    component.with_expanded_content { "expanded-body" }
    html = render_component(component)

    assert_includes html, "expanded-body"
    assert_includes html, "decor:border-b"
    assert_equal 2, html.scan("<tr").length
  end

  test "inherits from the abstract DataTableRow base" do
    assert_operator ::Decor::Daisy::Tables::DataTableRow, :<, ::Decor::Components::Tables::DataTableRow
  end
end
