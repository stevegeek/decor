# frozen_string_literal: true

require "test_helper"

class ::Decor::Daisy::Forms::HiddenFieldTest < ActiveSupport::TestCase
  test "renders root element with daisy hidden-field identifier" do
    html = render_component(::Decor::Daisy::Forms::HiddenField.new(name: "n"))
    assert_includes html, "decor--daisy--forms--hidden-field"
  end

  test "renders a native input with type hidden" do
    html = render_component(::Decor::Daisy::Forms::HiddenField.new(name: "token"))
    assert_match(/<input[^>]*type="hidden"/, html)
  end

  test "input name passes through" do
    html = render_component(::Decor::Daisy::Forms::HiddenField.new(name: "csrf"))
    assert_match(/name="csrf"/, html)
  end

  test "value attribute passes through" do
    html = render_component(::Decor::Daisy::Forms::HiddenField.new(name: "n", value: "abc123"))
    assert_match(/value="abc123"/, html)
  end

  test "autocomplete is off" do
    html = render_component(::Decor::Daisy::Forms::HiddenField.new(name: "n"))
    assert_match(/autocomplete="off"/, html)
  end

  test "root carries hidden attribute" do
    html = render_component(::Decor::Daisy::Forms::HiddenField.new(name: "n"))
    assert_match(/<div[^>]*hidden="hidden"/, html)
  end

  test "input carries form-control controller wiring" do
    html = render_component(::Decor::Daisy::Forms::HiddenField.new(name: "n"))
    assert_includes html, 'data-controller="decor--forms--form-control"'
  end

  test "no label is rendered" do
    html = render_component(::Decor::Daisy::Forms::HiddenField.new(name: "n", label: "Should not appear"))
    refute_includes html, "Should not appear"
    refute_match(/<label/, html)
  end

  test "no helper or error chrome is rendered" do
    html = render_component(
      ::Decor::Daisy::Forms::HiddenField.new(
        name: "n",
        helper_text: "should not render",
        error_messages: ["nope"]
      )
    )
    refute_includes html, "should not render"
    refute_includes html, "nope"
    refute_includes html, "decor:d-validator-hint"
  end
end
