# frozen_string_literal: true

require "test_helper"

class ::Decor::Suite::Tables::DataTableFooterTest < ActiveSupport::TestCase
  FooterSummaryLine = ::Decor::Components::Tables::DataTableFooter::FooterSummaryLine

  test "renders a hairline top border + suite-gray-25 background on the root band" do
    html = render_component(::Decor::Suite::Tables::DataTableFooter.new)
    assert_includes html, "decor:border-t"
    assert_includes html, "decor:border-suite-hairline"
    assert_includes html, "decor:bg-suite-gray-25"
  end

  test "applies the suite footer padding/gap layout" do
    html = render_component(::Decor::Suite::Tables::DataTableFooter.new)
    assert_includes html, "decor:px-5"
    assert_includes html, "decor:py-[10px]"
    assert_includes html, "decor:gap-4"
    assert_includes html, "decor:sm:flex-row"
    assert_includes html, "decor:sm:justify-between"
  end

  test "message renders in a suite-description paragraph, muted gray" do
    html = render_component(::Decor::Suite::Tables::DataTableFooter.new(message: "Showing 1-10 of 100"))
    assert_includes html, "Showing 1-10 of 100"
    assert_includes html, "decor:suite-description"
    assert_includes html, "decor:text-gray-500"
    assert_includes html, "decor:tabular-nums"
  end

  test "with no message and no summary lines, still renders the band" do
    html = render_component(::Decor::Suite::Tables::DataTableFooter.new)
    refute_includes html, "Showing"
    assert_includes html, "decor:bg-suite-gray-25"
  end

  test "summary_lines render as a <dl> on the right with suite-description rows" do
    html = render_component(::Decor::Suite::Tables::DataTableFooter.new(
      summary_lines: [
        FooterSummaryLine.new(title: "Subtotal", value: "$1,000.00")
      ]
    ))
    assert_includes html, "<dl"
    assert_includes html, "Subtotal"
    assert_includes html, "$1,000.00"
    assert_includes html, "decor:suite-description"
    assert_includes html, "decor:tabular-nums"
  end

  test ":section separator opens a top-padded breathing-room row" do
    html = render_component(::Decor::Suite::Tables::DataTableFooter.new(
      summary_lines: [
        FooterSummaryLine.new(title: "Subtotal", value: "$1,000.00"),
        FooterSummaryLine.new(title: "Discount", value: "-$100.00", separator: :section)
      ]
    ))
    assert_includes html, "decor:pt-2"
  end

  test ":final separator renders a bold primary-colored total row with a hairline above" do
    html = render_component(::Decor::Suite::Tables::DataTableFooter.new(
      summary_lines: [
        FooterSummaryLine.new(title: "Subtotal", value: "$1,000.00"),
        FooterSummaryLine.new(title: "Total", value: "$1,200.00", separator: :final)
      ]
    ))
    assert_includes html, "decor:border-t"
    assert_includes html, "decor:border-suite-hairline"
    assert_includes html, "decor:suite-body"
    assert_includes html, "decor:font-semibold"
    assert_includes html, "decor:text-primary"
  end

  test "non-final summary values use medium-weight gray-700" do
    html = render_component(::Decor::Suite::Tables::DataTableFooter.new(
      summary_lines: [
        FooterSummaryLine.new(title: "Subtotal", value: "$1,000.00")
      ]
    ))
    assert_includes html, "decor:text-gray-700"
    assert_includes html, "decor:font-medium"
  end

  test "html_safe summary value is emitted raw" do
    html = render_component(::Decor::Suite::Tables::DataTableFooter.new(
      summary_lines: [
        FooterSummaryLine.new(title: "Total", value: "<strong>$5</strong>".html_safe)
      ]
    ))
    assert_includes html, "<strong>$5</strong>"
  end

  test "with_left slot replaces the default message rendering" do
    component = ::Decor::Suite::Tables::DataTableFooter.new(message: "should not show")
    component.with_left { "custom-left-content" }
    html = render_component(component)
    assert_includes html, "custom-left-content"
    refute_includes html, "should not show"
  end

  test "with_right slot replaces the default summary_lines rendering" do
    component = ::Decor::Suite::Tables::DataTableFooter.new(
      summary_lines: [FooterSummaryLine.new(title: "Subtotal", value: "$1,000.00")]
    )
    component.with_right { "custom-right-content" }
    html = render_component(component)
    assert_includes html, "custom-right-content"
    refute_includes html, "Subtotal"
  end

  test "uses decor: prefix on every Tailwind class (no naked utilities)" do
    html = render_component(::Decor::Suite::Tables::DataTableFooter.new(message: "x"))
    assert_includes html, "decor:flex"
    refute_match(/class="[^"]*(?<![\w:])flex(?![\w-])[^"]*"/, html)
    refute_match(/class="[^"]*(?<![\w:])border-t(?![\w-])[^"]*"/, html)
    refute_match(/class="[^"]*(?<![\w:])bg-suite-gray-25(?![\w-])[^"]*"/, html)
  end
end
