# frozen_string_literal: true

require "test_helper"

class ::Decor::Suite::BannerTest < ActiveSupport::TestCase
  test "renders default suite-primary palette" do
    html = render_component(::Decor::Suite::Banner.new) { "body" }
    assert_includes html, "body"
    assert_includes html, "decor:bg-suite-primary-50"
    assert_includes html, "decor:border-suite-primary-100"
    assert_includes html, "decor:text-suite-primary-700"
  end

  test "color :success swaps suite-success palette" do
    html = render_component(::Decor::Suite::Banner.new(color: :success)) { "ok" }
    assert_includes html, "decor:bg-suite-success-50"
    assert_includes html, "decor:border-suite-success-100"
    refute_includes html, "decor:bg-suite-primary-50"
  end

  test "color :error swaps suite-danger palette" do
    html = render_component(::Decor::Suite::Banner.new(color: :error)) { "x" }
    assert_includes html, "decor:bg-suite-danger-50"
    assert_includes html, "decor:border-suite-danger-100"
    assert_includes html, "decor:text-suite-danger-700"
  end

  test "color :warning swaps suite-warning palette" do
    html = render_component(::Decor::Suite::Banner.new(color: :warning)) { "y" }
    assert_includes html, "decor:bg-suite-warning-50"
    assert_includes html, "decor:border-suite-warning-100"
    assert_includes html, "decor:text-suite-warning-700"
  end

  test "color :neutral uses suite-gray-25 + hairline border" do
    html = render_component(::Decor::Suite::Banner.new(color: :neutral)) { "n" }
    assert_includes html, "decor:bg-suite-gray-25"
    assert_includes html, "decor:border-suite-hairline"
  end

  test "icon prop renders a Tabler icon with suite-* icon color" do
    html = render_component(::Decor::Suite::Banner.new(icon: "info-circle")) { "b" }
    assert_includes html, "tabler-info-circle"
    assert_includes html, "decor:text-suite-primary-600"
  end

  test "body block renders inside the body wrapper" do
    html = render_component(::Decor::Suite::Banner.new) { "the-body-content".html_safe }
    assert_includes html, "the-body-content"
    assert_includes html, "decor:flex-1"
  end

  test "body uses suite-dense-body typography token" do
    html = render_component(::Decor::Suite::Banner.new) { "b" }
    assert_includes html, "decor:suite-dense-body"
  end

  test "body uses rounded-suite-card radius" do
    html = render_component(::Decor::Suite::Banner.new) { "b" }
    assert_includes html, "decor:rounded-suite-card"
  end

  test "link renders a 'Learn more' anchor with the given href and suite tokens" do
    html = render_component(::Decor::Suite::Banner.new(link: "/x")) { "b" }
    assert_includes html, "href=\"/x\""
    assert_includes html, "Learn more"
    assert_includes html, "decor:rounded-suite-control"
    assert_includes html, "decor:duration-suite-fast"
    assert_includes html, "decor:bg-white/55"
    assert_includes html, "decor:suite-description"
  end

  test "call_to_action block renders inside the right-side wrapper" do
    html = render_component(::Decor::Suite::Banner.new) do |banner|
      banner.call_to_action { "cta-content".html_safe }
      "body".html_safe
    end
    assert_includes html, "cta-content"
  end

  test "default centered: true wraps body in max-w-7xl mx-auto" do
    html = render_component(::Decor::Suite::Banner.new) { "b" }
    assert_includes html, "decor:max-w-7xl"
    assert_includes html, "decor:mx-auto"
  end

  test "centered: false omits the max-w-7xl wrapper" do
    html = render_component(::Decor::Suite::Banner.new(centered: false)) { "b" }
    refute_includes html, "decor:max-w-7xl"
  end
end
