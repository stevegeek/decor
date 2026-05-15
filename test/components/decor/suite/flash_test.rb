# frozen_string_literal: true

require "test_helper"

class ::Decor::Suite::FlashTest < ActiveSupport::TestCase
  test "renders title + text with default suite-primary palette" do
    html = render_component(::Decor::Suite::Flash.new(title: "Heads up", text: "All good."))
    assert_includes html, "Heads up"
    assert_includes html, "All good."
    assert_includes html, "decor:bg-suite-primary-50"
    assert_includes html, "decor:border-suite-primary-100"
    assert_includes html, "decor:text-suite-primary-700"
  end

  test "color :success swaps suite-success palette on root + icon wrap" do
    html = render_component(::Decor::Suite::Flash.new(title: "Ok", text: "Done", color: :success))
    assert_includes html, "decor:bg-suite-success-50"
    assert_includes html, "decor:bg-suite-success-100"
    assert_includes html, "decor:text-suite-success-600"
    refute_includes html, "decor:bg-suite-primary-50"
  end

  test "color :error swaps suite-danger palette" do
    html = render_component(::Decor::Suite::Flash.new(title: "Oops", text: "x", color: :error))
    assert_includes html, "decor:bg-suite-danger-50"
    assert_includes html, "decor:border-suite-danger-100"
    assert_includes html, "decor:text-suite-danger-700"
  end

  test "color :warning swaps suite-warning palette" do
    html = render_component(::Decor::Suite::Flash.new(title: "Heads", text: "y", color: :warning))
    assert_includes html, "decor:bg-suite-warning-50"
    assert_includes html, "decor:border-suite-warning-100"
    assert_includes html, "decor:text-suite-warning-700"
  end

  test "renders close-X button with stimulus hide action and suite-control radius" do
    html = render_component(::Decor::Suite::Flash.new(title: "T", text: "Y"))
    assert_includes html, "data-action"
    assert_includes html, "tabler-x"
    assert_includes html, "decor:rounded-suite-control"
  end

  test "title uses suite-section-title typography token" do
    html = render_component(::Decor::Suite::Flash.new(title: "Heads up", text: "All good."))
    assert_includes html, "decor:suite-section-title"
  end

  test "body uses suite-description typography token" do
    html = render_component(::Decor::Suite::Flash.new(title: "T", text: "Body text"))
    assert_includes html, "decor:suite-description"
  end

  test "root uses rounded-suite-card radius" do
    html = render_component(::Decor::Suite::Flash.new(title: "T", text: "Y"))
    assert_includes html, "decor:rounded-suite-card"
  end

  test "collapse_if_empty hides root when no text" do
    html = render_component(::Decor::Suite::Flash.new(collapse_if_empty: true))
    assert_includes html, "decor:hidden"
    assert_includes html, "hidden"
  end

  test "block fallback renders when no flash text" do
    html = render_component(::Decor::Suite::Flash.new(collapse_if_empty: false)) { "fallback-body".html_safe }
    assert_includes html, "fallback-body"
  end
end
