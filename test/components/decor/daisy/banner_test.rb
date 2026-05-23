require "test_helper"

class Decor::Daisy::BannerTest < ActiveSupport::TestCase
  test "renders successfully with block content" do
    component = Decor::Daisy::Banner.new
    rendered = render_component(component) { "Test banner content" }

    assert_includes rendered, "Test banner content"
    assert_includes rendered, "decor:mb-4"
    assert_includes rendered, "decor:d-alert" # daisyUI alert class
    assert_includes rendered, 'role="alert"'
  end

  test "applies correct style colors" do
    component = Decor::Daisy::Banner.new(color: :success)
    rendered = render_component(component) { "Success message" }

    assert_includes rendered, "decor:d-alert-success"
  end

  test "renders with daisyUI alert structure" do
    component = Decor::Daisy::Banner.new(color: :info)
    rendered = render_component(component) { "Info message" }

    assert_includes rendered, "decor:d-alert decor:d-alert-info"
    assert_includes rendered, 'role="alert"'
  end

  test "applies left aligned layout by default" do
    component = Decor::Daisy::Banner.new
    rendered = render_component(component) { "Left aligned banner" }

    assert_includes rendered, "decor:flex-1"
    refute_includes rendered, "decor:justify-center decor:text-center"
  end

  test "applies centered layout when specified" do
    component = Decor::Daisy::Banner.new(centered: true)
    rendered = render_component(component) { "Centered banner" }

    assert_includes rendered, "decor:justify-center decor:text-center"
  end

  test "renders with icon" do
    component = Decor::Daisy::Banner.new(icon: "star")
    rendered = render_component(component) { "Banner with icon" }

    assert_includes rendered, "star"
    assert_includes rendered, "decor:h-6 decor:w-6"
  end

  test "renders with link" do
    component = Decor::Daisy::Banner.new(link: "/learn-more")
    rendered = render_component(component) { "Banner with link" }

    assert_includes rendered, "Learn more"
    assert_includes rendered, 'href="/learn-more"'
    assert_includes rendered, "decor:d-btn decor:d-btn-sm decor:d-btn-primary"
  end

  test "renders different error styles" do
    component = Decor::Daisy::Banner.new(color: :error)
    rendered = render_component(component) { "Error message" }

    assert_includes rendered, "decor:d-alert-error"
  end

  test "renders different warning styles" do
    component = Decor::Daisy::Banner.new(color: :warning)
    rendered = render_component(component) { "Warning message" }

    assert_includes rendered, "decor:d-alert-warning"
  end

  test "uses nokogiri for parsing" do
    component = Decor::Daisy::Banner.new(color: :info)
    fragment = render_fragment(component) { "Info banner" }

    banner_div = fragment.at_css(".decor--daisy--banner")
    assert_not_nil banner_div
    assert_includes banner_div["class"], "decor:mb-4"

    alert_div = fragment.at_css('div[role="alert"]')
    assert_not_nil alert_div
    assert_includes alert_div["class"], "decor:d-alert decor:d-alert-info"
  end
end
