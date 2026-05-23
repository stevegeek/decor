# frozen_string_literal: true

require "test_helper"

class ::Decor::Daisy::Forms::HelperTextSectionTest < ActiveSupport::TestCase
  test "renders helper text with daisyUI validator-hint when no error present" do
    html = render_component(
      ::Decor::Daisy::Forms::HelperTextSection.new(helper_text: "Pick a strong password")
    )
    assert_includes html, "Pick a strong password"
    assert_includes html, "decor:d-validator-hint"
  end

  test "renders error text with text-error when error_text supplied" do
    html = render_component(
      ::Decor::Daisy::Forms::HelperTextSection.new(error_text: "Too short")
    )
    assert_includes html, "Too short"
    assert_includes html, "decor:text-error"
  end

  test "suppresses helper text when error text is present" do
    html = render_component(
      ::Decor::Daisy::Forms::HelperTextSection.new(helper_text: "Pick one", error_text: "Required")
    )
    refute_includes html, "Pick one"
    assert_includes html, "Required"
  end

  test "disabled flag adds opacity-50 to the helper text" do
    html = render_component(
      ::Decor::Daisy::Forms::HelperTextSection.new(helper_text: "x", disabled: true)
    )
    assert_includes html, "decor:opacity-50"
  end

  test "error_section: false suppresses the error block" do
    html = render_component(
      ::Decor::Daisy::Forms::HelperTextSection.new(error_text: "Boom", error_section: false)
    )
    refute_includes html, "Boom"
  end

  test "collapsing_helper_text: true removes the mt-1 top spacer on the root" do
    html = render_component(
      ::Decor::Daisy::Forms::HelperTextSection.new(helper_text: "x", collapsing_helper_text: true)
    )
    refute_match(/class="decor--daisy--forms--helper-text-section decor:mt-1"/, html)
  end

  test "collapsing_helper_text: false (default) keeps the mt-1 spacer on the root" do
    html = render_component(
      ::Decor::Daisy::Forms::HelperTextSection.new(helper_text: "x")
    )
    assert_includes html, "decor:mt-1"
  end

  test "helper_text target is wired" do
    html = render_component(
      ::Decor::Daisy::Forms::HelperTextSection.new(helper_text: "x")
    )
    assert_includes html, 'data-decor--daisy--forms--helper-text-section-target="helperText"'
  end

  test "error_text target is wired" do
    html = render_component(
      ::Decor::Daisy::Forms::HelperTextSection.new(error_text: "Boom")
    )
    assert_includes html, 'data-decor--daisy--forms--helper-text-section-target="errorText"'
  end
end
