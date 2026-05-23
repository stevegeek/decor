# frozen_string_literal: true

require "test_helper"

class ::Decor::Daisy::Forms::FormFieldLayoutTest < ActiveSupport::TestCase
  # Stand-in for the form_field_element vident root passed in from a parent
  # FormField component. The daisy layout calls stimulus_target on it.
  class FakeFieldElement
    def stimulus_target(name)
      {"data-target" => name.to_s}
    end
  end

  def build(field_id: "field", label: nil, **opts)
    ::Decor::Daisy::Forms::FormFieldLayout.new(
      field_id: field_id,
      label: label,
      form_field_element: FakeFieldElement.new,
      stimulus_classes: {valid_label: "decor:text-gray-900", invalid_label: "decor:text-error-dark"},
      **opts
    )
  end

  test "renders root with daisy form-field-layout identifier" do
    html = render_component(build(label: "Email"))
    assert_includes html, "decor--daisy--forms--form-field-layout"
  end

  test "label renders with daisyUI d-label classes and for=field_id-control" do
    html = render_component(build(field_id: "email", label: "Email address"))
    assert_includes html, "Email address"
    assert_includes html, 'for="email-control"'
    assert_includes html, "decor:d-label"
  end

  test "label_position :left adds font-medium emphasis on the label" do
    html = render_component(build(field_id: "n", label: "Name", label_position: :left))
    assert_includes html, "decor:font-medium"
  end

  test "label_position :left adds responsive grid layout classes" do
    html = render_component(build(field_id: "n", label: "Name", label_position: :left))
    assert_includes html, "decor:sm:grid"
    assert_includes html, "decor:sm:grid-cols-9"
  end

  test "label_position :top (default) does not emit the left-grid layout" do
    html = render_component(build(field_id: "n", label: "Name"))
    refute_includes html, "decor:sm:grid-cols-9"
  end

  test "label_position :right renders the label after the captured content" do
    html = render_component(build(field_id: "agree", label: "I agree", label_position: :right)) do
      "<input id=\"agree-control\" type=\"checkbox\">".html_safe
    end
    input_pos = html.index("agree-control")
    label_pos = html.index("I agree")
    assert input_pos && label_pos && input_pos < label_pos,
      "expected control to render before label for label_position: :right"
  end

  test "label_position :inside renders no label tag from the layout" do
    html = render_component(build(field_id: "n", label: "Name", label_position: :inside))
    refute_includes html, "<label"
  end

  test "description renders beneath the label with d-label-text-alt typography" do
    html = render_component(build(field_id: "n", label: "Name", description: "On invoices"))
    assert_includes html, "On invoices"
    assert_includes html, "decor:d-label-text-alt"
  end

  test "captured block content renders inside the input section" do
    html = render_component(build(field_id: "n", label: "Name")) do
      '<input id="n-control" data-x="1">'.html_safe
    end
    assert_includes html, 'data-x="1"'
  end

  test "disabled label uses the resolved disabled color class" do
    html = render_component(build(field_id: "n", label: "Name", disabled: true,
      stimulus_classes: {valid_label: "decor:text-disabled", invalid_label: "decor:text-error-dark"}))
    assert_includes html, "decor:text-disabled"
  end

  test "container target is wired from the form_field_element" do
    html = render_component(build(field_id: "n", label: "Name"))
    assert_includes html, 'data-target="container"'
  end

  test "label target is wired on the rendered label" do
    html = render_component(build(field_id: "n", label: "Name"))
    assert_includes html, 'data-decor--daisy--forms--form-field-layout-target="label"'
  end
end
