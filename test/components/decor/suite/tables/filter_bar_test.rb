# frozen_string_literal: true

require "test_helper"

class ::Decor::Suite::Tables::FilterBarTest < ActiveSupport::TestCase
  test "renders as a div with the suite chrome (hairline divider + gray-25 surface)" do
    html = render_component(::Decor::Suite::Tables::FilterBar.new)
    assert_includes html, "<div"
    assert_includes html, "decor:border-b"
    assert_includes html, "decor:border-suite-hairline"
    assert_includes html, "decor:bg-suite-gray-25"
  end

  test "applies the Suite chip-row layout padding" do
    html = render_component(::Decor::Suite::Tables::FilterBar.new)
    assert_includes html, "decor:pl-5"
    assert_includes html, "decor:pr-4"
    assert_includes html, "decor:py-[9px]"
    assert_includes html, "decor:flex"
    assert_includes html, "decor:items-center"
  end

  test "with no chips and no meta, still renders the bar" do
    html = render_component(::Decor::Suite::Tables::FilterBar.new)
    assert_includes html, "decor:bg-suite-gray-25"
    refute_includes html, "decor:ml-auto"
  end

  test "with_chip appends chips that render inside the bar" do
    component = ::Decor::Suite::Tables::FilterBar.new
    component.with_chip(label: "Open", value: "open", count: 7)
    component.with_chip(label: "Closed", value: "closed")
    html = render_component(component)
    assert_includes html, "Open"
    assert_includes html, "Closed"
    assert_includes html, "7"
  end

  test "chips? predicate reflects whether any chips have been added" do
    component = ::Decor::Suite::Tables::FilterBar.new
    refute component.chips?
    component.with_chip(label: "Open")
    assert component.chips?
  end

  test "with_chip returns the chip so callers can chain or capture it" do
    component = ::Decor::Suite::Tables::FilterBar.new
    chip = component.with_chip(label: "Open", value: "open")
    assert_kind_of ::Decor::Suite::Tables::FilterBarChip, chip
    assert_equal "Open", chip.label
  end

  test "with_chip propagates the bar's param_name into each chip" do
    component = ::Decor::Suite::Tables::FilterBar.new(param_name: :by_state)
    chip = component.with_chip(label: "Open", value: "open")
    assert_equal :by_state, chip.param_name
  end

  test "meta renders right-aligned in a muted tabular-nums span" do
    html = render_component(::Decor::Suite::Tables::FilterBar.new(meta: "42 results"))
    assert_includes html, "42 results"
    assert_includes html, "decor:ml-auto"
    assert_includes html, "decor:text-gray-500"
    assert_includes html, "decor:font-tabular-nums"
    assert_includes html, "decor:text-xs"
  end

  test "no meta means no right-aligned cluster" do
    html = render_component(::Decor::Suite::Tables::FilterBar.new)
    refute_includes html, "decor:ml-auto"
  end

  test "uses decor: prefix on every Tailwind class (no naked utilities)" do
    html = render_component(::Decor::Suite::Tables::FilterBar.new(meta: "x"))
    refute_match(/class="[^"]*(?<![\w:])flex(?![\w-])[^"]*"/, html)
    refute_match(/class="[^"]*(?<![\w:])bg-suite-gray-25(?![\w-])[^"]*"/, html)
    refute_match(/class="[^"]*(?<![\w:])border-b(?![\w-])[^"]*"/, html)
  end

end
