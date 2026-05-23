# frozen_string_literal: true

require "test_helper"

class ::Decor::Daisy::Forms::ErrorIconSectionTest < ActiveSupport::TestCase
  test "renders root with daisy error-icon-section identifier" do
    html = render_component(
      ::Decor::Daisy::Forms::ErrorIconSection.new(error_text: "Boom")
    )
    assert_includes html, "decor--daisy--forms--error-icon-section"
  end

  test "renders an exclamation-circle icon in text-red-500 by default" do
    html = render_component(
      ::Decor::Daisy::Forms::ErrorIconSection.new(error_text: "Boom")
    )
    assert_includes html, "exclamation-circle"
    assert_includes html, "decor:text-red-500"
  end

  test "non-floating mode adds no-pointer-events guard on the root" do
    html = render_component(
      ::Decor::Daisy::Forms::ErrorIconSection.new(error_text: "Boom")
    )
    assert_includes html, "decor:no-pointer-events"
  end

  test "root uses absolute positioning to overlay the field" do
    html = render_component(
      ::Decor::Daisy::Forms::ErrorIconSection.new(error_text: "Boom")
    )
    assert_includes html, "decor:absolute"
    assert_includes html, "decor:inset-y-1"
  end

  test "icon is sized h-5 w-5" do
    html = render_component(
      ::Decor::Daisy::Forms::ErrorIconSection.new(error_text: "Boom")
    )
    assert_includes html, "decor:h-5"
    assert_includes html, "decor:w-5"
  end

  test "show_floating_message renders tooltip with error_text stimulus target" do
    # The Daisy tooltip embeds the floating <p> inside its `data-tip` HTML
    # attribute, so the target attribute is HTML-escaped in the outer markup.
    html = render_component(
      ::Decor::Daisy::Forms::ErrorIconSection.new(error_text: "Boom", show_floating_message: true)
    )
    assert_includes html, "decor--daisy--forms--error-icon-section-target=&quot;errorText&quot;"
  end
end
