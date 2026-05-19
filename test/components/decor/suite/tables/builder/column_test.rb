# frozen_string_literal: true

require "test_helper"

class ::Decor::Suite::Tables::Builder::ColumnTest < ActiveSupport::TestCase
  test "defaults are applied" do
    col = ::Decor::Suite::Tables::Builder::Column.new(name: :sku)
    assert_equal :sku, col.name
    assert_equal 0, col.index
    assert_equal false, col.sortable
    assert_equal false, col.stretch
    assert_equal false, col.numeric
    assert_equal true, col.navigates_to_path
    assert_equal false, col.stop_propagation
    assert_nil col.cell_block
  end

  test "sortable?/stretch?/stop_propagation? predicates" do
    col = ::Decor::Suite::Tables::Builder::Column.new(name: :x, sortable: true, stretch: true, stop_propagation: true)
    assert col.sortable?
    assert col.stretch?
    assert col.stop_propagation?
  end

  test "content_clickable? returns false when nil" do
    col = ::Decor::Suite::Tables::Builder::Column.new(name: :x)
    refute col.content_clickable?
  end

  test "navigates_to_path? is false when content_clickable? is true" do
    col = ::Decor::Suite::Tables::Builder::Column.new(name: :x, content_clickable: true)
    assert col.content_clickable?
    refute col.navigates_to_path?, "content-clickable cells must not navigate to row path"
  end

  test "navigates_to_path? respects navigates_to_path=false" do
    col = ::Decor::Suite::Tables::Builder::Column.new(name: :x, navigates_to_path: false)
    refute col.navigates_to_path?
  end

  test "navigates_to_path? is true when both flags are at defaults" do
    col = ::Decor::Suite::Tables::Builder::Column.new(name: :x)
    assert col.navigates_to_path?
  end

  test "header / layout props are exposed" do
    col = ::Decor::Suite::Tables::Builder::Column.new(
      name: :price,
      title: "Price",
      colspan: 2,
      numeric: true,
      emphasis: :low,
      weight: :medium,
      min_width_rem: 8,
      max_width: 320,
      classes: ["tabular", "right"]
    )
    assert_equal "Price", col.title
    assert_equal 2, col.colspan
    assert col.numeric
    assert_equal :low, col.emphasis
    assert_equal :medium, col.weight
    assert_equal 8, col.min_width_rem
    assert_equal 320, col.max_width
    assert_equal ["tabular", "right"], col.classes
  end

  test "cell_block is stored as-is" do
    block = ->(item) { item.to_s.upcase }
    col = ::Decor::Suite::Tables::Builder::Column.new(name: :x, cell_block: block)
    assert_same block, col.cell_block
  end
end
