# frozen_string_literal: true

require "test_helper"

class ::Decor::Suite::Tables::DataTableHeaderCellTest < ActiveSupport::TestCase
  test "renders as <th> with columnheader role and scope=col" do
    html = render_component(::Decor::Suite::Tables::DataTableHeaderCell.new(title: "Name"))
    assert_includes html, "<th"
    assert_includes html, 'role="columnheader"'
    assert_includes html, 'scope="col"'
  end

  test "renders the title text" do
    html = render_component(::Decor::Suite::Tables::DataTableHeaderCell.new(title: "Email"))
    assert_includes html, "Email"
  end

  test "falls back to value when title is missing" do
    html = render_component(::Decor::Suite::Tables::DataTableHeaderCell.new(value: "Fallback"))
    assert_includes html, "Fallback"
  end

  test "applies suite caption typography on the th" do
    html = render_component(::Decor::Suite::Tables::DataTableHeaderCell.new(title: "x"))
    assert_includes html, "decor:suite-caption"
    assert_includes html, "decor:font-medium"
    assert_includes html, "decor:text-gray-500"
    assert_includes html, "decor:uppercase"
  end

  test "applies a suite-hairline bottom border" do
    html = render_component(::Decor::Suite::Tables::DataTableHeaderCell.new(title: "x"))
    assert_includes html, "decor:border-b"
    assert_includes html, "decor:border-suite-hairline"
  end

  test "non-numeric cell left-aligns by default" do
    html = render_component(::Decor::Suite::Tables::DataTableHeaderCell.new(title: "x"))
    assert_includes html, "decor:text-left"
  end

  test "numeric cell right-aligns" do
    html = render_component(::Decor::Suite::Tables::DataTableHeaderCell.new(title: "x", numeric: true))
    assert_includes html, "decor:text-right"
  end

  test "default padding is the comfortable 14px/9px Suite spacing" do
    html = render_component(::Decor::Suite::Tables::DataTableHeaderCell.new(title: "x"))
    assert_includes html, "decor:px-[14px]"
    assert_includes html, "decor:py-[9px]"
  end

  test "compact: true swaps padding to the dense admin variant" do
    html = render_component(::Decor::Suite::Tables::DataTableHeaderCell.new(title: "x", compact: true))
    assert_includes html, "decor:px-3"
    assert_includes html, "decor:py-[6px]"
    refute_includes html, "decor:px-[14px]"
  end

  test "sort_key adds cursor-pointer and the down-arrow indicator" do
    html = render_component(::Decor::Suite::Tables::DataTableHeaderCell.new(title: "Name", sort_key: :name))
    assert_includes html, "decor:cursor-pointer"
    assert_includes html, "↓"
    assert_includes html, "handleSortableClick"
  end

  test "sorted_direction: :asc renders the up-arrow at 70% opacity" do
    html = render_component(::Decor::Suite::Tables::DataTableHeaderCell.new(title: "Name", sort_key: :name, sorted_direction: :asc))
    assert_includes html, "↑"
    assert_includes html, "decor:opacity-70"
  end

  test "sorted_direction: :desc renders the down-arrow at 70% opacity" do
    html = render_component(::Decor::Suite::Tables::DataTableHeaderCell.new(title: "Name", sort_key: :name, sorted_direction: :desc))
    assert_includes html, "↓"
    assert_includes html, "decor:opacity-70"
  end

  test "without sort_key the indicator hides via opacity-0" do
    html = render_component(::Decor::Suite::Tables::DataTableHeaderCell.new(title: "x"))
    refute_includes html, "↑"
    refute_includes html, "↓"
  end

  test "colspan attribute is emitted when positive" do
    html = render_component(::Decor::Suite::Tables::DataTableHeaderCell.new(title: "x", colspan: 3))
    assert_includes html, 'colspan="3"'
  end

  test "zero/negative colspan is dropped" do
    html = render_component(::Decor::Suite::Tables::DataTableHeaderCell.new(title: "x", colspan: 0))
    refute_includes html, "colspan="
  end

  test "stretch_divisor: 1 applies w-full" do
    html = render_component(::Decor::Suite::Tables::DataTableHeaderCell.new(title: "x", stretch_divisor: 1))
    assert_includes html, "decor:w-full"
  end

  test "stretch_divisor: 3 applies w-1/3" do
    html = render_component(::Decor::Suite::Tables::DataTableHeaderCell.new(title: "x", stretch_divisor: 3))
    assert_includes html, "decor:w-1/3"
  end
end
