# frozen_string_literal: true

require "test_helper"

class ::Decor::Suite::Tables::FilterBarChipTest < ActiveSupport::TestCase
  test "renders as an anchor with the chip label" do
    html = render_component(::Decor::Suite::Tables::FilterBarChip.new(label: "Open"))
    assert_includes html, "<a"
    assert_includes html, "Open"
  end

  test "default (inactive) chip uses the neutral white surface + hairline border" do
    html = render_component(::Decor::Suite::Tables::FilterBarChip.new(label: "Open"))
    assert_includes html, "decor:bg-white"
    assert_includes html, "decor:border-suite-hairline"
    assert_includes html, "decor:text-gray-700"
    assert_includes html, "decor:hover:bg-gray-50"
    refute_includes html, "decor:bg-suite-primary-50"
  end

  test "active chip swaps to the suite-primary tinted palette" do
    html = render_component(::Decor::Suite::Tables::FilterBarChip.new(label: "Open", active: true))
    assert_includes html, "decor:bg-suite-primary-50"
    assert_includes html, "decor:text-suite-primary-700"
    assert_includes html, "decor:border-suite-primary-200"
  end

  test "applies suite chip layout (rounded-suite-control, suite-fast duration, leading-none)" do
    html = render_component(::Decor::Suite::Tables::FilterBarChip.new(label: "Open"))
    assert_includes html, "decor:rounded-suite-control"
    assert_includes html, "decor:duration-suite-fast"
    assert_includes html, "decor:leading-none"
    assert_includes html, "decor:inline-flex"
    assert_includes html, "decor:items-center"
  end

  test "count badge renders with tabular-nums when count is set" do
    html = render_component(::Decor::Suite::Tables::FilterBarChip.new(label: "Open", count: 7))
    assert_includes html, ">7<"
    assert_includes html, "decor:font-tabular-nums"
    assert_includes html, "decor:rounded-full"
  end

  test "count badge uses neutral gray palette when inactive" do
    html = render_component(::Decor::Suite::Tables::FilterBarChip.new(label: "Open", count: 7))
    assert_includes html, "decor:bg-gray-200"
    assert_includes html, "decor:text-gray-700"
  end

  test "count badge uses suite-primary palette when active" do
    html = render_component(::Decor::Suite::Tables::FilterBarChip.new(label: "Open", count: 7, active: true))
    assert_includes html, "decor:bg-suite-primary-100"
    assert_includes html, "decor:text-suite-primary-700"
  end

  test "no count means no badge is rendered" do
    html = render_component(::Decor::Suite::Tables::FilterBarChip.new(label: "Open"))
    refute_includes html, "decor:rounded-full"
  end

  test "icon renders a Decor::Icon when supplied" do
    html = render_component(::Decor::Suite::Tables::FilterBarChip.new(label: "Open", icon: "check"))
    assert_includes html, "<svg"
    assert_includes html, "decor:h-3.5"
    assert_includes html, "decor:w-3.5"
  end

  test "href encodes the chip value into the configured param_name" do
    html = render_component(::Decor::Suite::Tables::FilterBarChip.new(label: "Open", value: "open", param_name: :by_state))
    # CGI.parse stores values as arrays, so to_query produces by_state[]=open
    assert_match(/href="[^"]*by_state(%5B%5D|\[\])?=open[^"]*"/, html)
  end

  test "href omits the param entirely when value is blank (the 'all' chip)" do
    html = render_component(::Decor::Suite::Tables::FilterBarChip.new(label: "All", value: nil, param_name: :by_state))
    refute_match(/by_state/, html)
  end

end
