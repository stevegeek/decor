# frozen_string_literal: true

require "test_helper"

class ::Decor::Suite::Forms::ErrorIconSectionTest < ActiveSupport::TestCase
  test "renders an exclamation-circle icon in suite-danger-500 by default" do
    html = render_component(
      ::Decor::Suite::Forms::ErrorIconSection.new(error_text: "Boom")
    )
    assert_includes html, "exclamation-circle"
    assert_includes html, "decor:text-suite-danger-500"
  end

  test "without floating message, root has pointer-events-none guard" do
    html = render_component(
      ::Decor::Suite::Forms::ErrorIconSection.new(error_text: "Boom")
    )
    assert_includes html, "decor:pointer-events-none"
  end

  test "show_floating_message renders the tooltip wrapper with the error text" do
    html = render_component(
      ::Decor::Suite::Forms::ErrorIconSection.new(error_text: "Required", show_floating_message: true)
    )
    assert_includes html, "Required"
  end

  test "uses suite-danger tokens not daisy semantic error" do
    html = render_component(
      ::Decor::Suite::Forms::ErrorIconSection.new(error_text: "Boom")
    )
    refute_match(/decor:text-red-500\b/, html)
    refute_match(/decor:text-error\b/, html)
  end
end
