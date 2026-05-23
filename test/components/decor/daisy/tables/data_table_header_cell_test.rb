# frozen_string_literal: true

require "test_helper"

class Decor::Daisy::Tables::DataTableHeaderCellTest < ActiveSupport::TestCase
  test "renders as <th>" do
    html = render_component(::Decor::Daisy::Tables::DataTableHeaderCell.new(title: "Name"))
    assert_includes html, "<th"
  end

  test "renders the title text" do
    html = render_component(::Decor::Daisy::Tables::DataTableHeaderCell.new(title: "Email"))
    assert_includes html, "Email"
  end

  test "falls back to value when title is missing" do
    html = render_component(::Decor::Daisy::Tables::DataTableHeaderCell.new(value: "Fallback"))
    assert_includes html, "Fallback"
  end

  test "renders uppercase + medium-weight + base-content typography" do
    html = render_component(::Decor::Daisy::Tables::DataTableHeaderCell.new(title: "x"))
    assert_includes html, "decor:uppercase"
    assert_includes html, "decor:font-medium"
    assert_includes html, "decor:text-base-content"
  end

  test "non-numeric cell left-aligns" do
    html = render_component(::Decor::Daisy::Tables::DataTableHeaderCell.new(title: "x"))
    assert_includes html, "decor:text-left"
  end

  test "numeric cell right-aligns" do
    html = render_component(::Decor::Daisy::Tables::DataTableHeaderCell.new(title: "x", numeric: true))
    assert_includes html, "decor:text-right"
  end

  test "sort_key adds cursor-pointer and the chevron-down icon" do
    html = render_component(::Decor::Daisy::Tables::DataTableHeaderCell.new(title: "Name", sort_key: :name))
    assert_includes html, "decor:cursor-pointer"
    assert_includes html, "decor:hover:bg-base-200"
    assert_includes html, "chevron-down"
  end

  test "sort_key wires the sortable click handler via stimulus action" do
    html = render_component(::Decor::Daisy::Tables::DataTableHeaderCell.new(title: "Name", sort_key: :name))
    assert_includes html, "handleSortableClick"
    assert_includes html, 'sort-key-value="name"'
  end

  test "sorted_direction: :asc renders the chevron-up icon" do
    html = render_component(::Decor::Daisy::Tables::DataTableHeaderCell.new(title: "Name", sort_key: :name, sorted_direction: :asc))
    assert_includes html, "chevron-up"
    assert_includes html, 'sorted-direction-value="asc"'
  end

  test "sorted_direction: :desc renders the chevron-down icon at full opacity" do
    html = render_component(::Decor::Daisy::Tables::DataTableHeaderCell.new(title: "Name", sort_key: :name, sorted_direction: :desc))
    assert_includes html, "chevron-down"
    assert_includes html, "decor:opacity-100"
  end

  test "without sort_key no chevron icon is rendered" do
    html = render_component(::Decor::Daisy::Tables::DataTableHeaderCell.new(title: "x"))
    refute_includes html, "chevron-down"
    refute_includes html, "chevron-up"
  end

  test "stretch_divisor: 1 applies w-full" do
    html = render_component(::Decor::Daisy::Tables::DataTableHeaderCell.new(title: "x", stretch_divisor: 1))
    assert_includes html, "decor:w-full"
  end

  test "stretch_divisor: 2 applies w-1/2" do
    html = render_component(::Decor::Daisy::Tables::DataTableHeaderCell.new(title: "x", stretch_divisor: 2))
    assert_includes html, "decor:w-1/2"
  end

  test "row_height: :tight applies tight padding utilities" do
    html = render_component(::Decor::Daisy::Tables::DataTableHeaderCell.new(title: "x", row_height: :tight))
    assert_includes html, "decor:px-3"
    assert_includes html, "decor:py-1"
    assert_includes html, "decor:text-xs"
  end

  test "applies the daisy header-cell stimulus identifier" do
    html = render_component(::Decor::Daisy::Tables::DataTableHeaderCell.new(title: "x"))
    assert_includes html, "decor--daisy--tables--data-table-header-cell"
  end
end
