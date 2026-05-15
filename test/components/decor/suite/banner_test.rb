# frozen_string_literal: true

require "test_helper"

class ::Decor::Suite::BannerTest < ActiveSupport::TestCase
  test "renders default muted info palette" do
    html = render_component(::Decor::Suite::Banner.new) { "body" }
    assert_includes html, "body"
    assert_includes html, "decor:bg-info/10"
    assert_includes html, "decor:border-info/30"
  end

  test "color :success swaps muted-success palette" do
    html = render_component(::Decor::Suite::Banner.new(color: :success)) { "ok" }
    assert_includes html, "decor:bg-success/10"
    assert_includes html, "decor:border-success/30"
    refute_includes html, "decor:bg-info/10"
  end

  test "color :error swaps muted-error palette" do
    html = render_component(::Decor::Suite::Banner.new(color: :error)) { "x" }
    assert_includes html, "decor:bg-error/10"
    assert_includes html, "decor:border-error/30"
  end

  test "color :neutral uses base-200 + black/15 border" do
    html = render_component(::Decor::Suite::Banner.new(color: :neutral)) { "n" }
    assert_includes html, "decor:bg-base-200"
    assert_includes html, "decor:border-black/15"
  end

  test "icon prop renders a Tabler icon when provided" do
    html = render_component(::Decor::Suite::Banner.new(icon: "info-circle")) { "b" }
    assert_includes html, "tabler-info-circle"
  end

  test "body block renders inside the body wrapper" do
    html = render_component(::Decor::Suite::Banner.new) { "the-body-content".html_safe }
    assert_includes html, "the-body-content"
    assert_includes html, "decor:flex-1"
  end

  test "link renders a 'Learn more' anchor with the given href" do
    html = render_component(::Decor::Suite::Banner.new(link: "/x")) { "b" }
    assert_includes html, "href=\"/x\""
    assert_includes html, "Learn more"
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
