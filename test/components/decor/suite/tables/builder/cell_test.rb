# frozen_string_literal: true

require "test_helper"

class ::Decor::Suite::Tables::Builder::CellTest < ActiveSupport::TestCase
  def build_column(**overrides)
    ::Decor::Suite::Tables::Builder::Column.new(
      name: :col,
      **overrides
    )
  end

  test "component hash merges column props and drops nils" do
    column = build_column(numeric: true, colspan: 3, min_width_rem: 4, max_width: 200, emphasis: :low, weight: :medium)
    cell = ::Decor::Suite::Tables::Builder::Cell.new(
      column: column,
      data: "data",
      item_index: 0,
      rendered_content: "hello"
    )

    hash = cell.component
    assert_equal true, hash[:numeric]
    assert_equal 3, hash[:colspan]
    assert_equal 4, hash[:min_width_rem]
    assert_equal 200, hash[:max_width]
    assert_equal :low, hash[:emphasis]
    assert_equal :medium, hash[:weight]
    assert_equal "hello", hash[:value]
    assert_equal false, hash[:stop_propagation]
    refute hash.key?(:path)
    refute hash.key?(:content_clickable)
    refute hash.key?(:html_options)
    refute hash.key?(:classes)
    refute hash.key?(:row_height)
  end

  test "cell-level emphasis/weight override column-level values" do
    column = build_column(emphasis: :low, weight: :light)
    cell = ::Decor::Suite::Tables::Builder::Cell.new(
      column: column,
      item_index: 0,
      emphasis: :regular,
      weight: :medium
    )

    hash = cell.component
    assert_equal :regular, hash[:emphasis]
    assert_equal :medium, hash[:weight]
  end

  test "render_block returns the column block" do
    block = ->(item) { item.to_s }
    column = build_column(cell_block: block)
    cell = ::Decor::Suite::Tables::Builder::Cell.new(column: column, item_index: 0)
    assert_same block, cell.render_block
  end

  test "render_content returns nil when column has no cell_block" do
    column = build_column
    helpers = view_context
    assert_nil ::Decor::Suite::Tables::Builder::Cell.render_content(column, "x", 0, "x", helpers)
  end

  test "render_content dispatches on block arity (1)" do
    column = build_column(cell_block: ->(item) { item.upcase })
    helpers = view_context
    out = ::Decor::Suite::Tables::Builder::Cell.render_content(column, "foo", 0, "foo", helpers)
    assert_equal "FOO", out.to_s
  end

  test "render_content dispatches on block arity (2)" do
    column = build_column(cell_block: ->(item, idx) { "#{item}-#{idx}" })
    helpers = view_context
    out = ::Decor::Suite::Tables::Builder::Cell.render_content(column, "row", 3, "row", helpers)
    assert_equal "row-3", out.to_s
  end

  test "render_content dispatches on block arity (3) with untransformed" do
    column = build_column(cell_block: ->(item, idx, untransformed) { "#{item}|#{untransformed}|#{idx}" })
    helpers = view_context
    out = ::Decor::Suite::Tables::Builder::Cell.render_content(column, "T", 1, "U", helpers)
    assert_equal "T|U|1", out.to_s
  end

  test "render_content dispatches on block arity (4) and passes RowContext with form_builder" do
    column = build_column(cell_block: ->(item, idx, untransformed, ctx) { "#{item}/#{ctx.form_builder}" })
    helpers = view_context
    out = ::Decor::Suite::Tables::Builder::Cell.render_content(column, "T", 0, "U", helpers, form_builder: "FB")
    assert_equal "T/FB", out.to_s
  end

  test "stop_propagation flag round-trips through component hash" do
    column = build_column
    cell = ::Decor::Suite::Tables::Builder::Cell.new(column: column, item_index: 0, stop_propagation: true)
    assert_equal true, cell.component[:stop_propagation]
  end
end
