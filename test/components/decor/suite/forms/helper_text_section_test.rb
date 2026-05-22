# frozen_string_literal: true

require "test_helper"

class ::Decor::Suite::Forms::HelperTextSectionTest < ActiveSupport::TestCase
  test "renders helper text with suite-field-help and muted gray" do
    html = render_component(
      ::Decor::Suite::Forms::HelperTextSection.new(helper_text: "Pick a strong password")
    )
    assert_includes html, "Pick a strong password"
    assert_includes html, "decor:suite-field-help"
    assert_includes html, "decor:text-gray-500"
  end

  test "renders error text with suite-danger-500 when present" do
    html = render_component(
      ::Decor::Suite::Forms::HelperTextSection.new(error_text: "Too short")
    )
    assert_includes html, "Too short"
    assert_includes html, "decor:text-suite-danger-500"
  end

  test "helper paragraph is hidden when error text is present" do
    html = render_component(
      ::Decor::Suite::Forms::HelperTextSection.new(helper_text: "Pick one", error_text: "Required")
    )
    # Helper still in DOM (for client-side swap) but hidden.
    assert_includes html, "Pick one"
    assert_includes html, "decor:hidden"
  end

  test "disabled flag mutes the helper text color further" do
    html = render_component(
      ::Decor::Suite::Forms::HelperTextSection.new(helper_text: "x", disabled: true)
    )
    assert_includes html, "decor:text-gray-400"
  end

end
