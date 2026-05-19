# frozen_string_literal: true

require "test_helper"

class ::Decor::Suite::Forms::FormFieldLayoutTest < ActiveSupport::TestCase
  test "renders the label and a for attribute pointing at field_id-control" do
    html = render_component(
      ::Decor::Suite::Forms::FormFieldLayout.new(field_id: "email", label: "Email address")
    )
    assert_includes html, "Email address"
    assert_includes html, 'for="email-control"'
  end

  test "label uses density-aware suite-field-label typography" do
    html = render_component(
      ::Decor::Suite::Forms::FormFieldLayout.new(field_id: "name", label: "Name")
    )
    assert_includes html, "decor:suite-field-label"
  end

  test "label_position :top stacks with suite-field-gap" do
    html = render_component(
      ::Decor::Suite::Forms::FormFieldLayout.new(field_id: "n", label: "Name", label_position: :top)
    )
    assert_includes html, "decor:suite-field-gap"
    assert_includes html, "decor:flex-col"
  end

  test "label_position :left puts label in a 180px gutter and emphasises the label" do
    html = render_component(
      ::Decor::Suite::Forms::FormFieldLayout.new(field_id: "n", label: "Name", label_position: :left)
    )
    assert_includes html, "decor:sm:w-[180px]"
    assert_includes html, "decor:font-semibold"
    assert_includes html, "decor:sm:items-baseline"
  end

  test "label_position :right renders the label after the control content" do
    html = render_component(
      ::Decor::Suite::Forms::FormFieldLayout.new(field_id: "agree", label: "I agree", label_position: :right)
    ) { "<input id=\"agree-control\" type=\"checkbox\" />".html_safe }
    # Label should appear AFTER the input in source order.
    input_pos = html.index("agree-control")
    label_pos = html.index("I agree")
    assert input_pos && label_pos && input_pos < label_pos,
      "expected control to render before label for label_position: :right"
  end

  test "label_position :inline puts label in gutter without :left's mt-1" do
    html = render_component(
      ::Decor::Suite::Forms::FormFieldLayout.new(field_id: "n", label: "Name", label_position: :inline)
    )
    assert_includes html, "decor:sm:w-[180px]"
    refute_includes html, "decor:sm:w-[180px] decor:sm:shrink-0 decor:mt-1"
  end

  test "label_position :inside renders no label on the layout itself" do
    html = render_component(
      ::Decor::Suite::Forms::FormFieldLayout.new(field_id: "n", label: "Name", label_position: :inside)
    )
    refute_includes html, '<label'
  end

  test "description renders below the label using suite-field-help" do
    html = render_component(
      ::Decor::Suite::Forms::FormFieldLayout.new(field_id: "n", label: "Name", description: "On invoices")
    )
    assert_includes html, "On invoices"
    assert_includes html, "decor:suite-field-help"
  end

  test "disabled label uses muted gray" do
    html = render_component(
      ::Decor::Suite::Forms::FormFieldLayout.new(field_id: "n", label: "Name", disabled: true)
    )
    assert_includes html, "decor:text-gray-400"
  end

  test "captured block content renders inside the input section" do
    html = render_component(
      ::Decor::Suite::Forms::FormFieldLayout.new(field_id: "n", label: "Name")
    ) { "<input id=\"n-control\" data-x=\"1\" />".html_safe }
    assert_includes html, 'data-x="1"'
  end

  test "with_helper_text_section renders the helper caption beneath the control" do
    layout = ::Decor::Suite::Forms::FormFieldLayout.new(field_id: "n", label: "Name")
    html = render_component(layout) do |l|
      l.with_helper_text_section(helper_text: "Use your full name")
      ""
    end
    assert_includes html, "Use your full name"
    assert_includes html, "decor:suite-field-help"
  end

  test "with_helper_text_section error_text uses suite-danger-700 color" do
    layout = ::Decor::Suite::Forms::FormFieldLayout.new(field_id: "n", label: "Name")
    html = render_component(layout) do |l|
      l.with_helper_text_section(error_text: "Required")
      ""
    end
    assert_includes html, "Required"
    assert_includes html, "decor:text-suite-danger-700"
  end

  test "grid_span :span_half emits the half-width responsive class" do
    html = render_component(
      ::Decor::Suite::Forms::FormFieldLayout.new(field_id: "n", label: "Name", grid_span: :span_half)
    )
    assert_includes html, "decor:sm:col-span-6"
    assert_includes html, "decor:lg:col-span-3"
  end

  test "uses no daisyUI semantic color tokens" do
    html = render_component(
      ::Decor::Suite::Forms::FormFieldLayout.new(field_id: "n", label: "Name")
    ) do |l|
      l.with_helper_text_section(error_text: "x")
      ""
    end
    refute_match(/decor:(bg|text|border)-(error|info|success|warning)\b/, html)
  end
end
