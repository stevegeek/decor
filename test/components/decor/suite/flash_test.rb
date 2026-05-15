# frozen_string_literal: true

require "test_helper"

class ::Decor::Suite::FlashTest < ActiveSupport::TestCase
  test "renders title + text with default info palette" do
    html = render_component(::Decor::Suite::Flash.new(title: "Heads up", text: "All good."))
    assert_includes html, "Heads up"
    assert_includes html, "All good."
    assert_includes html, "decor:bg-info/10"
    assert_includes html, "decor:border-info/30"
  end

  test "color :success swaps muted-success palette on root + icon wrap" do
    html = render_component(::Decor::Suite::Flash.new(title: "Ok", text: "Done", color: :success))
    assert_includes html, "decor:bg-success/10"
    assert_includes html, "decor:bg-success/15"
    refute_includes html, "decor:bg-info/10"
  end

  test "color :error swaps muted-error palette" do
    html = render_component(::Decor::Suite::Flash.new(title: "Oops", text: "x", color: :error))
    assert_includes html, "decor:bg-error/10"
    assert_includes html, "decor:border-error/30"
  end

  test "renders close-X button with stimulus hide action" do
    html = render_component(::Decor::Suite::Flash.new(title: "T", text: "Y"))
    assert_includes html, "data-action"
    assert_includes html, "tabler-x"
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
