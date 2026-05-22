# frozen_string_literal: true

require "test_helper"

class ::Decor::Suite::Tables::Builder::RowTest < ActiveSupport::TestCase
  def build_cell
    column = ::Decor::Suite::Tables::Builder::Column.new(name: :col)
    ::Decor::Suite::Tables::Builder::Cell.new(column: column, item_index: 0)
  end

  test "stores cells and item_index" do
    cells = [build_cell, build_cell]
    row = ::Decor::Suite::Tables::Builder::Row.new(cells: cells, item_index: 7)
    assert_equal cells, row.cells
    assert_equal 7, row.item_index
  end

  test "component hash drops nil-valued props" do
    row = ::Decor::Suite::Tables::Builder::Row.new(cells: [], item_index: 0)
    assert_equal({}, row.component)
  end

  test "component hash includes set props" do
    row = ::Decor::Suite::Tables::Builder::Row.new(
      cells: [],
      item_index: 0,
      id: "row-1",
      hover_highlight: true,
      highlight: :primary,
      disabled: false,
      selectable_as: "selected_ids[]",
      selectable_value: "42",
      selected: true,
      path: "/orders/42",
      html_options: {data: {foo: "bar"}},
      classes: "extra-row-class"
    )

    hash = row.component
    assert_equal "row-1", hash[:id]
    assert_equal true, hash[:hover_highlight]
    assert_equal :primary, hash[:highlight]
    assert_equal false, hash[:disabled]
    assert_equal "selected_ids[]", hash[:selectable_as]
    assert_equal "42", hash[:selectable_value]
    assert_equal true, hash[:selected]
    assert_equal "/orders/42", hash[:path]
    assert_equal({foo: "bar"}, hash[:html_options][:data])
    assert_equal "extra-row-class", hash[:classes]
  end

  test "prepared_form_builder is emitted under :form_builder key" do
    fb = Object.new
    row = ::Decor::Suite::Tables::Builder::Row.new(cells: [], item_index: 0, prepared_form_builder: fb)
    assert_same fb, row.component[:form_builder]
  end

  test "expanded_content_renderer is stored and readable" do
    renderer = ->(_) { "expanded" }
    row = ::Decor::Suite::Tables::Builder::Row.new(cells: [], item_index: 0, expanded_content_renderer: renderer)
    assert_same renderer, row.expanded_content_renderer
    refute row.component.key?(:expanded_content_renderer)
  end

  test "component hash never carries item_index (a builder concern)" do
    row = ::Decor::Suite::Tables::Builder::Row.new(cells: [], item_index: 5)
    refute row.component.key?(:item_index)
  end
end
