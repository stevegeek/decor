# frozen_string_literal: true

require "test_helper"

class Decor::Suite::ClickToCopyTest < ActiveSupport::TestCase
  test "renders chip variant by default with suite-token bordered styling" do
    rendered = render_component(Decor::Suite::ClickToCopy.new { "value" })
    assert_includes rendered, "decor:border-suite-hairline-strong"
    assert_includes rendered, "decor:rounded-suite-control"
    assert_includes rendered, "decor:bg-suite-gray-25"
    assert_includes rendered, "decor:duration-suite-fast"
    assert_includes rendered, "value"
  end

  test "renders inline variant without bordered styling" do
    rendered = render_component(Decor::Suite::ClickToCopy.new(variant: :inline) { "value" })
    refute_includes rendered, "decor:border-suite-hairline-strong"
    assert_includes rendered, "decor:suite-description"
  end

  test "uses :tag_name for root element" do
    rendered = render_component(Decor::Suite::ClickToCopy.new(tag_name: :div) { "x" })
    assert_includes rendered, "<div"
    assert_includes rendered, "decor--suite--click-to-copy"
  end

  test "carries to_copy value when prop is set" do
    rendered = render_component(Decor::Suite::ClickToCopy.new(to_copy: "secret") { "displayed" })
    assert_includes rendered, "to-copy-value=\"secret\""
  end

  test "stimulus action wires click → copy" do
    rendered = render_component(Decor::Suite::ClickToCopy.new { "x" })
    assert_includes rendered, "click->decor--suite--click-to-copy#copy"
  end
end
