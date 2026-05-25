# frozen_string_literal: true

require "test_helper"

class Decor::Suite::ButtonLinkTest < ActiveSupport::TestCase
  test "renders as anchor with href when not disabled" do
    html = render_component(Decor::Suite::ButtonLink.new(label: "Click", href: "/foo"))
    assert_includes html, "<a"
    assert_includes html, 'href="/foo"'
    assert_includes html, "Click"
  end

  test "renders as disabled button when disabled" do
    html = render_component(Decor::Suite::ButtonLink.new(label: "Nope", href: "/foo", disabled: true))
    assert_includes html, "<button"
    assert_includes html, 'disabled="disabled"'
    refute_includes html, 'href="/foo"'
  end

  test "applies suite-control radius and duration-suite-fast" do
    html = render_component(Decor::Suite::ButtonLink.new(label: "x", href: "/x"))
    assert_includes html, "decor:rounded-suite-control"
    assert_includes html, "decor:duration-suite-fast"
  end

  test "primary filled uses suite-primary tokens, not daisyUI semantics" do
    html = render_component(Decor::Suite::ButtonLink.new(label: "x", href: "/x", color: :primary, style: :filled))
    assert_includes html, "decor:bg-suite-primary-500"
    refute_includes html, "decor:bg-primary "
    refute_includes html, "decor:d-btn"
  end

  test "outlined primary uses suite-primary-200 border" do
    html = render_component(Decor::Suite::ButtonLink.new(label: "x", href: "/x", color: :primary, style: :outlined))
    assert_includes html, "decor:border-suite-primary-200"
    assert_includes html, "decor:text-suite-primary-700"
  end

  test "soft danger uses suite-danger-50 surface and -700 text" do
    html = render_component(Decor::Suite::ButtonLink.new(label: "x", href: "/x", color: :error, style: :soft))
    assert_includes html, "decor:bg-suite-danger-50"
    assert_includes html, "decor:text-suite-danger-700"
    assert_includes html, "decor:border-suite-danger-100"
  end

  test "default base/filled uses hairline-strong border + white surface" do
    html = render_component(Decor::Suite::ButtonLink.new(label: "x", href: "/x"))
    assert_includes html, "decor:bg-white"
    assert_includes html, "decor:border-suite-hairline-strong"
  end

  test "emits both data-method and data-turbo-method via ActsAsLink" do
    html = render_component(Decor::Suite::ButtonLink.new(label: "Delete", href: "/x", http_method: :delete))
    assert_includes html, 'data-turbo-method="delete"'
  end

  test "passes through turbo_frame as data-turbo-frame" do
    html = render_component(Decor::Suite::ButtonLink.new(label: "x", href: "/x", turbo_frame: "modal"))
    assert_includes html, 'data-turbo-frame="modal"'
  end

  test "target attribute is rendered" do
    html = render_component(Decor::Suite::ButtonLink.new(label: "x", href: "/x", target: "_blank"))
    assert_includes html, 'target="_blank"'
  end

  test "renders icon when icon prop set" do
    html = render_component(Decor::Suite::ButtonLink.new(label: "Star", href: "/x", icon: "star"))
    assert_includes html, "star"
    assert_includes html, "Star"
  end

  test "full_width adds w-full modifier" do
    html = render_component(Decor::Suite::ButtonLink.new(label: "x", href: "/x", full_width: true))
    assert_includes html, "decor:w-full"
  end

  test "default size is :md — applies 13px text and suite-control radius" do
    html = render_component(Decor::Suite::ButtonLink.new(label: "x", href: "/x"))
    assert_includes html, "decor:text-[13px]"
    assert_includes html, "decor:rounded-suite-control"
  end
end
