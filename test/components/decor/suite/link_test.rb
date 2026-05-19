# frozen_string_literal: true

require "test_helper"

class Decor::Suite::LinkTest < ActiveSupport::TestCase
  test "renders as anchor with href and label" do
    html = render_component(Decor::Suite::Link.new(label: "Learn more", href: "/docs"))
    assert_includes html, "<a"
    assert_includes html, 'href="/docs"'
    assert_includes html, "Learn more"
  end

  test "target=_blank is rendered" do
    html = render_component(Decor::Suite::Link.new(label: "x", href: "/x", target: "_blank"))
    assert_includes html, 'target="_blank"'
  end

  test "default color :primary uses suite-primary-700 text and hover -800" do
    html = render_component(Decor::Suite::Link.new(label: "x", href: "/x"))
    assert_includes html, "decor:text-suite-primary-700"
    assert_includes html, "decor:hover:text-suite-primary-800"
  end

  test "color :error uses suite-danger-700 text" do
    html = render_component(Decor::Suite::Link.new(label: "x", href: "/x", color: :error))
    assert_includes html, "decor:text-suite-danger-700"
    refute_includes html, "decor:text-suite-primary-700"
  end

  test "color :success uses suite-success-700 text" do
    html = render_component(Decor::Suite::Link.new(label: "x", href: "/x", color: :success))
    assert_includes html, "decor:text-suite-success-700"
  end

  test "color :base falls back to neutral gray text" do
    html = render_component(Decor::Suite::Link.new(label: "x", href: "/x", color: :base))
    assert_includes html, "decor:text-gray-700"
    refute_includes html, "decor:text-suite-primary-700"
  end

  test "applies hover underline + no-underline base" do
    html = render_component(Decor::Suite::Link.new(label: "x", href: "/x"))
    assert_includes html, "decor:no-underline"
    assert_includes html, "decor:hover:underline"
  end

  test "uses duration-suite-fast transition" do
    html = render_component(Decor::Suite::Link.new(label: "x", href: "/x"))
    assert_includes html, "decor:duration-suite-fast"
    assert_includes html, "decor:transition-colors"
  end

  test "focus-visible halo uses primary-100 token" do
    html = render_component(Decor::Suite::Link.new(label: "x", href: "/x"))
    assert_includes html, "decor:focus-visible:shadow-[0_0_0_3px_var(--color-suite-primary-100)]"
  end

  test "default size :md uses 13px text" do
    html = render_component(Decor::Suite::Link.new(label: "x", href: "/x"))
    assert_includes html, "decor:text-[13px]"
  end

  test "size :sm uses text-xs" do
    html = render_component(Decor::Suite::Link.new(label: "x", href: "/x", size: :sm))
    assert_includes html, "decor:text-xs"
  end

  test "renders icon when icon prop set" do
    html = render_component(Decor::Suite::Link.new(label: "Open", href: "/x", icon: "arrow-right"))
    assert_includes html, "arrow-right"
    assert_includes html, "Open"
  end

  test "disabled renders aria-disabled link (still <a>) without href" do
    html = render_component(Decor::Suite::Link.new(label: "Nope", href: "/x", disabled: true))
    assert_includes html, 'aria-disabled="true"'
    refute_includes html, 'href="/x"'
  end

  test "passes through turbo_frame as data-turbo-frame" do
    html = render_component(Decor::Suite::Link.new(label: "x", href: "/x", turbo_frame: "modal"))
    assert_includes html, 'data-turbo-frame="modal"'
  end

  test "does not emit a daisyUI link class" do
    html = render_component(Decor::Suite::Link.new(label: "x", href: "/x", color: :primary))
    refute_includes html, "decor:d-link"
    refute_includes html, "decor:d-btn"
  end

  test "rejects colors outside the suite scheme" do
    assert_raises(Literal::TypeError) { Decor::Suite::Link.new(label: "x", href: "/x", color: :accent) }
    assert_raises(Literal::TypeError) { Decor::Suite::Link.new(label: "x", href: "/x", color: :neutral) }
  end

  test "block content overrides label" do
    html = render_component(Decor::Suite::Link.new(label: "ignored", href: "/x")) { "Block body" }
    assert_includes html, "Block body"
  end
end
