# frozen_string_literal: true

require "test_helper"

class ::Decor::Suite::TabsTest < ActiveSupport::TestCase
  TabInfo = ::Decor::Components::Tabs::TabInfo

  test "renders nav with tabs aria label and segmented strip chrome" do
    html = render_component(::Decor::Suite::Tabs.new(
      links: [TabInfo.new(title: "Overview", href: "#overview", active: true)]
    ))
    assert_includes html, "aria-label=\"Tabs\""
    assert_includes html, "decor:bg-gray-100"
    assert_includes html, "decor:rounded-suite-control"
  end

  test "active link uses white pill with suite-primary-700 text" do
    html = render_component(::Decor::Suite::Tabs.new(
      links: [TabInfo.new(title: "Active", href: "#a", active: true)]
    ))
    assert_includes html, "aria-current=\"page\""
    assert_includes html, "decor:bg-white"
    assert_includes html, "decor:text-suite-primary-700"
  end

  test "inactive link uses gray-600 text with hover state" do
    html = render_component(::Decor::Suite::Tabs.new(
      links: [
        TabInfo.new(title: "Active", href: "#a", active: true),
        TabInfo.new(title: "Other", href: "#b")
      ]
    ))
    assert_includes html, "decor:text-gray-600"
    assert_includes html, "decor:hover:bg-gray-200/60"
  end

  test "disabled tab renders as span with aria-disabled and not-allowed cursor" do
    html = render_component(::Decor::Suite::Tabs.new(
      links: [TabInfo.new(title: "Soon", disabled: true)]
    ))
    assert_includes html, "aria-disabled=\"true\""
    assert_includes html, "decor:cursor-not-allowed"
    assert_includes html, "decor:text-gray-400"
    refute_includes html, "href"
  end

  test "tab without href renders as inactive span (non-interactive)" do
    html = render_component(::Decor::Suite::Tabs.new(
      links: [TabInfo.new(title: "Info only")]
    ))
    assert_includes html, "<span"
    assert_includes html, "Info only"
    refute_includes html, "aria-disabled"
  end

  test "badge on active tab uses suite-primary-100 fill" do
    html = render_component(::Decor::Suite::Tabs.new(
      links: [TabInfo.new(title: "Inbox", href: "#i", active: true, badge_text: "12")]
    ))
    assert_includes html, "12"
    assert_includes html, "decor:bg-suite-primary-100"
    assert_includes html, "decor:text-suite-primary-700"
  end

  test "badge on inactive tab uses neutral gray fill" do
    html = render_component(::Decor::Suite::Tabs.new(
      links: [
        TabInfo.new(title: "A", href: "#a", active: true),
        TabInfo.new(title: "Drafts", href: "#d", badge_text: "3")
      ]
    ))
    assert_includes html, "decor:bg-gray-200"
    assert_includes html, "decor:text-gray-600"
  end

  test "status caption renders below/beside strip with suite-dense-body" do
    html = render_component(::Decor::Suite::Tabs.new(
      links: [TabInfo.new(title: "One", href: "#o", active: true)],
      status: "Updated 5m ago"
    ))
    assert_includes html, "Updated 5m ago"
    assert_includes html, "decor:suite-dense-body"
  end

  test "omits status caption when blank" do
    html = render_component(::Decor::Suite::Tabs.new(
      links: [TabInfo.new(title: "One", href: "#o", active: true)]
    ))
    refute_includes html, "decor:suite-dense-body"
  end

  test "uses duration-suite-fast transition token" do
    html = render_component(::Decor::Suite::Tabs.new(
      links: [TabInfo.new(title: "One", href: "#o", active: true)]
    ))
    assert_includes html, "decor:duration-suite-fast"
  end

  test "wires stimulus controller with wrapper and scroll targets" do
    html = render_component(::Decor::Suite::Tabs.new(
      links: [TabInfo.new(title: "One", href: "#o", active: true)]
    ))
    assert_includes html, "data-controller"
    assert_includes html, "decor--suite--tabs"
    assert_includes html, "data-decor--suite--tabs-target=\"wrapper\""
    assert_includes html, "data-decor--suite--tabs-target=\"scroll\""
    assert_includes html, "scroll->decor--suite--tabs#scrolled"
  end

  test "strip wrapper has scoped class for scoped scroll-shadow rule" do
    html = render_component(::Decor::Suite::Tabs.new(
      links: [TabInfo.new(title: "One", href: "#o", active: true)]
    ))
    assert_includes html, "decor--suite--tabs__strip-wrapper"
  end

  test "focus ring uses suite-primary-500" do
    html = render_component(::Decor::Suite::Tabs.new(
      links: [TabInfo.new(title: "One", href: "#o", active: true)]
    ))
    assert_includes html, "decor:focus-visible:ring-suite-primary-500"
  end
end
