# frozen_string_literal: true

require "test_helper"

class ::Decor::Suite::Forms::HiddenFieldTest < ActiveSupport::TestCase
  test "renders root element with suite hidden-field identifier" do
    html = render_component(::Decor::Suite::Forms::HiddenField.new(name: "n"))
    assert_includes html, "decor--suite--forms--hidden-field"
  end

  test "renders a native input with type hidden" do
    html = render_component(::Decor::Suite::Forms::HiddenField.new(name: "token"))
    assert_match(/<input[^>]*type="hidden"/, html)
  end

  test "input name passes through" do
    html = render_component(::Decor::Suite::Forms::HiddenField.new(name: "csrf"))
    assert_match(/name="csrf"/, html)
  end

  test "value attribute passes through" do
    html = render_component(::Decor::Suite::Forms::HiddenField.new(name: "n", value: "abc123"))
    assert_match(/value="abc123"/, html)
  end

  test "autocomplete is off" do
    html = render_component(::Decor::Suite::Forms::HiddenField.new(name: "n"))
    assert_match(/autocomplete="off"/, html)
  end

  test "hidden attribute is emitted on the input" do
    html = render_component(::Decor::Suite::Forms::HiddenField.new(name: "n"))
    assert_match(/<input[^>]*hidden="hidden"/, html)
  end

  test "no label is rendered" do
    html = render_component(::Decor::Suite::Forms::HiddenField.new(name: "n", label: "Should not appear"))
    refute_includes html, "Should not appear"
    refute_match(/<label/, html)
  end

  test "no helper or error chrome is rendered" do
    html = render_component(
      ::Decor::Suite::Forms::HiddenField.new(
        name: "n",
        helper_text: "should not render",
        error_messages: ["nope"]
      )
    )
    refute_includes html, "should not render"
    refute_includes html, "nope"
    refute_includes html, "decor:suite-field-help"
  end
end
