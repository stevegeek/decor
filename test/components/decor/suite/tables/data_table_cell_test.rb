# frozen_string_literal: true

require "test_helper"

class ::Decor::Suite::Tables::DataTableCellTest < ActiveSupport::TestCase
  test "renders as <td>" do
    html = render_component(::Decor::Suite::Tables::DataTableCell.new(value: "hello"))
    assert_includes html, "<td"
    assert_includes html, "hello"
  end

  test "renders block content verbatim" do
    html = render_component(::Decor::Suite::Tables::DataTableCell.new) { "block-content" }
    assert_includes html, "block-content"
  end

  test "applies suite-hairline bottom divider, not raw black/10" do
    html = render_component(::Decor::Suite::Tables::DataTableCell.new)
    assert_includes html, "decor:border-suite-hairline"
    refute_includes html, "decor:border-black/10"
  end

  test "applies suite-body typography by default" do
    html = render_component(::Decor::Suite::Tables::DataTableCell.new(value: "x"))
    assert_includes html, "decor:suite-body"
  end

  test "tight row_height uses suite-dense-body + reduced padding" do
    html = render_component(::Decor::Suite::Tables::DataTableCell.new(value: "x", row_height: :tight))
    assert_includes html, "decor:suite-dense-body"
    assert_includes html, "decor:px-3"
    assert_includes html, "decor:py-1"
  end

  test "comfortable row_height uses larger padding" do
    html = render_component(::Decor::Suite::Tables::DataTableCell.new(value: "x", row_height: :comfortable))
    assert_includes html, "decor:px-4"
    assert_includes html, "decor:py-3"
  end

  test "standard row_height uses the historical 14px/7px Suite padding" do
    html = render_component(::Decor::Suite::Tables::DataTableCell.new(value: "x"))
    assert_includes html, "decor:px-[14px]"
    assert_includes html, "decor:py-[7px]"
  end

  test "compact prop swaps padding to the dense admin variant regardless of row_height" do
    html = render_component(::Decor::Suite::Tables::DataTableCell.new(value: "x", compact: true, row_height: :comfortable))
    assert_includes html, "decor:px-3"
    assert_includes html, "decor:py-[5px]"
    refute_includes html, "decor:px-4"
  end

  test "numeric cells right-align with tabular-nums" do
    html = render_component(::Decor::Suite::Tables::DataTableCell.new(value: "1.23", numeric: true))
    assert_includes html, "decor:text-right"
    assert_includes html, "decor:tabular-nums"
  end

  test "non-numeric cells left-align by default" do
    html = render_component(::Decor::Suite::Tables::DataTableCell.new(value: "x"))
    assert_includes html, "decor:text-left"
  end

  test "explicit align: :center wraps content in a flex justify-center div" do
    html = render_component(::Decor::Suite::Tables::DataTableCell.new(value: "x", align: :center))
    assert_includes html, "decor:text-center"
    assert_includes html, "decor:flex"
    assert_includes html, "decor:justify-center"
  end

  test "explicit align: :right overrides numeric default" do
    html = render_component(::Decor::Suite::Tables::DataTableCell.new(value: "x", align: :right))
    assert_includes html, "decor:text-right"
  end

  test "align beats numeric when both set" do
    html = render_component(::Decor::Suite::Tables::DataTableCell.new(value: "x", numeric: true, align: :left))
    assert_includes html, "decor:text-left"
    refute_includes html, "decor:tabular-nums"
  end

  test "emphasis: :low uses muted gray" do
    html = render_component(::Decor::Suite::Tables::DataTableCell.new(value: "x", emphasis: :low))
    assert_includes html, "decor:text-gray-500"
  end

  test "emphasis: :regular uses gray-800" do
    html = render_component(::Decor::Suite::Tables::DataTableCell.new(value: "x"))
    assert_includes html, "decor:text-gray-800"
  end

  test "weight: :medium applies font-medium" do
    html = render_component(::Decor::Suite::Tables::DataTableCell.new(value: "x", weight: :medium))
    assert_includes html, "decor:font-medium"
  end

  test "colspan emits the colspan attribute" do
    html = render_component(::Decor::Suite::Tables::DataTableCell.new(value: "x", colspan: 3))
    assert_includes html, 'colspan="3"'
  end

  test "zero or negative colspan is dropped (header-hide convention)" do
    html = render_component(::Decor::Suite::Tables::DataTableCell.new(value: "x", colspan: 0))
    refute_includes html, "colspan="
  end

  test "max_width and min_width_rem render an inline-style truncate wrapper" do
    html = render_component(::Decor::Suite::Tables::DataTableCell.new(value: "long", max_width: 200, min_width_rem: 10))
    assert_includes html, "max-width: 200px"
    assert_includes html, "min-width: 10rem"
    assert_includes html, "decor:truncate"
  end

  test "path renders a cell-row-link-overlay anchor, cursor-pointer, no underline" do
    html = render_component(::Decor::Suite::Tables::DataTableCell.new(value: "go", path: "/foo"))
    assert_includes html, "cell-row-link-overlay"
    assert_includes html, 'href="/foo"'
    assert_includes html, 'tabindex="-1"'
    assert_includes html, "decor:cursor-pointer"
    assert_includes html, "decor:absolute"
    assert_includes html, "decor:inset-0"
  end

  test "no path: no link overlay, no cursor-pointer" do
    html = render_component(::Decor::Suite::Tables::DataTableCell.new(value: "x"))
    refute_includes html, "cell-row-link-overlay"
    refute_includes html, "decor:cursor-pointer"
  end

  test "content_clickable wraps content in absolute-positioned flex box" do
    html = render_component(::Decor::Suite::Tables::DataTableCell.new(value: "x", content_clickable: true))
    assert_includes html, "decor:absolute"
    assert_includes html, "decor:inset-0"
    assert_includes html, "decor:place-content-center"
  end

  test "Stimulus controller name resolves to decor--suite--tables--data-table-cell" do
    html = render_component(::Decor::Suite::Tables::DataTableCell.new(value: "x"))
    assert_includes html, "decor--suite--tables--data-table-cell"
  end

  test "stop_propagation wires the click action handler" do
    html = render_component(::Decor::Suite::Tables::DataTableCell.new(value: "x", stop_propagation: true))
    assert_includes html, "handleCellClickToStopPropagation"
  end

  test "path renders the link click handler action" do
    html = render_component(::Decor::Suite::Tables::DataTableCell.new(value: "x", path: "/foo"))
    assert_includes html, "handleLinkClick"
  end

  test "html_safe value is emitted raw" do
    html = render_component(::Decor::Suite::Tables::DataTableCell.new(value: "<em>bold</em>".html_safe))
    assert_includes html, "<em>bold</em>"
  end

  test "plain (non-html_safe) value is HTML-escaped" do
    html = render_component(::Decor::Suite::Tables::DataTableCell.new(value: "<script>x</script>"))
    refute_includes html, "<script>x</script>"
    assert_includes html, "&lt;script&gt;"
  end

  test "no_path_navigation Stimulus value is exposed for downstream JS" do
    html = render_component(::Decor::Suite::Tables::DataTableCell.new(value: "x"))
    assert_includes html, "no-path-navigation-value=\"true\""
  end
end
