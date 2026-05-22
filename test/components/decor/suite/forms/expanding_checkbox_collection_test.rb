# frozen_string_literal: true

require "test_helper"

class ::Decor::Suite::Forms::ExpandingCheckboxCollectionTest < ActiveSupport::TestCase
  CHECKBOXES_HTML = <<~HTML.strip
    <input type="checkbox" value="1" name="prefs[]">Option 1
    <input type="checkbox" value="2" name="prefs[]">Option 2
    <input type="checkbox" value="3" name="prefs[]">Option 3
  HTML

  def build(**overrides)
    component = ::Decor::Suite::Forms::ExpandingCheckboxCollection.new(
      name: "prefs",
      size: 3,
      **overrides
    )
    component.instance_variable_set(:@checkboxes, CHECKBOXES_HTML)
    component
  end

  test "renders root element with suite expanding-checkbox-collection identifier" do
    html = render_component(build)
    assert_includes html, "decor--suite--forms--expanding-checkbox-collection"
  end

  test "inherits from the abstract ExpandingCheckboxCollection (and FormField)" do
    component = build
    assert component.is_a?(::Decor::Components::Forms::ExpandingCheckboxCollection)
    assert component.is_a?(::Decor::Components::Forms::FormField)
  end

  test "renders the supplied checkbox HTML inside the list container" do
    html = render_component(build)
    assert_includes html, "Option 1"
    assert_includes html, "Option 2"
    assert_includes html, "Option 3"
  end

  test "renders the supplied native checkbox inputs (count matches @checkboxes)" do
    fragment = render_fragment(build)
    inputs = fragment.css('input[type="checkbox"]')
    assert_equal 3, inputs.length
  end

  test "uses suite tokens for layout (suite-field-gap)" do
    html = render_component(build)
    assert_includes html, "decor:suite-field-gap"
  end

  test "every Tailwind utility is prefixed with decor:" do
    html = render_component(build)
    assert_includes html, "decor:flex"
    assert_includes html, "decor:flex-col"
    assert_includes html, "decor:gap-2"
  end

  test "renders the label with suite-field-label typography" do
    html = render_component(build(label: "Pick some"))
    assert_includes html, "Pick some"
    assert_includes html, "decor:suite-field-label"
    assert_includes html, "decor:text-gray-900"
  end

  test "required adds an asterisk to the label" do
    html = render_component(build(label: "Pick some", required: true))
    assert_includes html, "Pick some *"
  end

  test "no show-more toggle when size <= hide_after_showing" do
    html = render_component(build(size: 2, hide_after_showing: 5))
    refute_includes html, "Show more..."
  end

  test "no show-more toggle when hide_after_showing is nil" do
    html = render_component(build(size: 10))
    refute_includes html, "Show more..."
  end

  test "renders the Suite Button toggle when size > hide_after_showing" do
    html = render_component(build(size: 10, hide_after_showing: 3))
    assert_includes html, "Show more..."
    assert_includes html, "decor:text-suite-primary-600"
    assert_match(/<button[^>]*type="button"/, html)
  end

  test "toggle button wires stimulus action + target onto the root controller" do
    html = render_component(build(size: 10, hide_after_showing: 3))
    # The action references this component's stimulus identifier; Vident
    # camel-cases the method name so it ends up as "showMore".
    assert_match(/data-action="[^"]*showMore[^"]*"/, html)
    assert_match(/data-[^=]*-target="showMoreLink"/, html)
  end

  test "disabled state applies the disabled chrome and dims the label" do
    html = render_component(build(label: "Pick some", disabled: true))
    assert_includes html, "decor:disabled"
    assert_includes html, "decor:text-disabled"
  end

  test "helper_text renders below the list using suite-field-help" do
    html = render_component(build(helper_text: "Pick at least one"))
    assert_includes html, "Pick at least one"
    assert_includes html, "decor:suite-field-help"
    assert_includes html, "decor:text-gray-500"
  end

  test "error message renders in suite-danger-700 and suppresses helper text" do
    html = render_component(
      build(helper_text: "Pick at least one", error_messages: ["Required"])
    )
    assert_includes html, "Required"
    assert_includes html, "decor:text-suite-danger-500"
    refute_includes html, "Pick at least one"
  end

  test "floating_error_text suppresses inline error rendering" do
    html = render_component(
      build(floating_error_text: true, error_messages: ["Required"])
    )
    refute_includes html, ">Required<"
  end

end
