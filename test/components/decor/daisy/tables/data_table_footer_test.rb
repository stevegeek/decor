# frozen_string_literal: true

require "test_helper"

class Decor::Daisy::Tables::DataTableFooterTest < ActiveSupport::TestCase
  FooterSummaryLine = ::Decor::Components::Tables::DataTableFooter::FooterSummaryLine

  test "renders the daisy footer chrome on the root band" do
    html = render_component(::Decor::Daisy::Tables::DataTableFooter.new)
    assert_includes html, "decor:sm:flex"
    assert_includes html, "decor:border-t"
    assert_includes html, "decor:border-base-300"
    assert_includes html, "decor:bg-base-50/50"
  end

  test "message renders inside a paragraph with the daisy muted text" do
    html = render_component(::Decor::Daisy::Tables::DataTableFooter.new(message: "Showing 1-10 of 100"))
    assert_includes html, "Showing 1-10 of 100"
    assert_includes html, "<p"
    assert_includes html, "decor:text-base-content/70"
  end

  test "summary_lines render as a <dl> with title + value" do
    html = render_component(::Decor::Daisy::Tables::DataTableFooter.new(
      summary_lines: [FooterSummaryLine.new(title: "Subtotal", value: "$1,000.00")]
    ))
    assert_includes html, "<dl"
    assert_includes html, "Subtotal"
    assert_includes html, "$1,000.00"
    assert_includes html, "decor:divide-base-300"
  end

  test ":section separator adds the section break utilities" do
    html = render_component(::Decor::Daisy::Tables::DataTableFooter.new(
      summary_lines: [
        FooterSummaryLine.new(title: "Subtotal", value: "$1,000.00"),
        FooterSummaryLine.new(title: "Discount", value: "-$100.00", separator: :section)
      ]
    ))
    assert_includes html, "decor:border-t-2"
    assert_includes html, "decor:border-base-300"
    assert_includes html, "decor:pt-4"
  end

  test ":final separator renders a primary-tinted total row" do
    html = render_component(::Decor::Daisy::Tables::DataTableFooter.new(
      summary_lines: [
        FooterSummaryLine.new(title: "Total", value: "$1,200.00", separator: :final)
      ]
    ))
    assert_includes html, "decor:text-primary"
    assert_includes html, "decor:bg-base-50"
    assert_includes html, "decor:border-primary/20"
  end

  test "with no message and no summary_lines still renders a placeholder div" do
    html = render_component(::Decor::Daisy::Tables::DataTableFooter.new)
    refute_includes html, "Showing"
    assert_includes html, "<div"
  end

  test "html_safe summary value is emitted raw" do
    html = render_component(::Decor::Daisy::Tables::DataTableFooter.new(
      summary_lines: [FooterSummaryLine.new(title: "Total", value: "<strong>$5</strong>".html_safe)]
    ))
    assert_includes html, "<strong>$5</strong>"
  end

  test "with_left slot replaces the default message rendering" do
    component = ::Decor::Daisy::Tables::DataTableFooter.new(message: "should not show")
    component.with_left { "custom-left" }
    html = render_component(component)
    assert_includes html, "custom-left"
    refute_includes html, "should not show"
  end

  test "with_right slot replaces the default summary_lines rendering" do
    component = ::Decor::Daisy::Tables::DataTableFooter.new(
      summary_lines: [FooterSummaryLine.new(title: "Subtotal", value: "$1,000.00")]
    )
    component.with_right { "custom-right" }
    html = render_component(component)
    assert_includes html, "custom-right"
    refute_includes html, "Subtotal"
  end

  test "applies the daisy footer stimulus identifier" do
    html = render_component(::Decor::Daisy::Tables::DataTableFooter.new(message: "x"))
    assert_includes html, "decor--daisy--tables--data-table-footer"
  end
end
