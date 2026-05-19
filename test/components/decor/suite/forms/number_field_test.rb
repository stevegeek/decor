# frozen_string_literal: true

require "test_helper"

class ::Decor::Suite::Forms::NumberFieldTest < ActiveSupport::TestCase
  test "renders root element with suite number-field identifier" do
    html = render_component(::Decor::Suite::Forms::NumberField.new(name: "n", label: "Label"))
    assert_includes html, "decor--suite--forms--number-field"
  end

  test "renders a native input with type number by default" do
    html = render_component(::Decor::Suite::Forms::NumberField.new(name: "qty", label: "Quantity"))
    assert_match(/<input[^>]*type="number"/, html)
  end

  test "input is right-aligned with tabular figures" do
    html = render_component(::Decor::Suite::Forms::NumberField.new(name: "qty", label: "Quantity"))
    assert_includes html, "decor:text-right"
    assert_includes html, "decor:tabular-nums"
  end

  test "min / max / step pass through to the input element" do
    html = render_component(
      ::Decor::Suite::Forms::NumberField.new(name: "qty", label: "Quantity", min: 0, max: 10, step: 1)
    )
    assert_match(/min="0"/, html)
    assert_match(/max="10"/, html)
    assert_match(/step="1"/, html)
  end

  test "default pattern gates integer-only input" do
    html = render_component(::Decor::Suite::Forms::NumberField.new(name: "qty", label: "Quantity"))
    assert_match(/pattern="\[0-9\]\*"/, html)
  end

  test "allow_float_input widens pattern to accept decimal point" do
    html = render_component(
      ::Decor::Suite::Forms::NumberField.new(name: "weight", label: "Weight", allow_float_input: true)
    )
    assert_match(/pattern="\[0-9-\.\]\*"/, html)
  end

  test "numerical default emits the data-form-control validate hook" do
    html = render_component(::Decor::Suite::Forms::NumberField.new(name: "qty", label: "Quantity"))
    assert_includes html, "data-form-control-validate-type-value=\"number\""
  end

  test "label renders with suite-field-label density-aware typography" do
    html = render_component(::Decor::Suite::Forms::NumberField.new(name: "qty", label: "Quantity"))
    assert_includes html, "Quantity"
    assert_includes html, "decor:suite-field-label"
  end

  test "helper text renders below the field" do
    html = render_component(
      ::Decor::Suite::Forms::NumberField.new(name: "qty", label: "Quantity", helper_text: "Whole numbers only.")
    )
    assert_includes html, "Whole numbers only."
    assert_includes html, "decor:suite-field-help"
  end

  test "error state applies suite-danger chrome" do
    html = render_component(
      ::Decor::Suite::Forms::NumberField.new(name: "qty", label: "Quantity", error_messages: ["Bad"])
    )
    assert_includes html, "decor:border-suite-danger-500"
    assert_includes html, "decor:bg-suite-danger-50"
    assert_includes html, "decor:text-suite-danger-700"
    assert_includes html, "Bad"
  end

  test "disabled marks input disabled and applies suite hairline chrome" do
    html = render_component(::Decor::Suite::Forms::NumberField.new(name: "qty", label: "Quantity", disabled: true))
    assert_match(/<input[^>]*disabled/, html)
    assert_includes html, "decor:border-suite-hairline"
    assert_includes html, "decor:cursor-not-allowed"
  end

  test "boxed trailing unit add-on renders shell with suite-gray-25 cell" do
    html = render_component(
      ::Decor::Suite::Forms::NumberField.new(
        name: "price", label: "Price",
        trailing_text_add_on: "USD", add_on_style: :boxed
      )
    )
    assert_includes html, "decor:bg-suite-gray-25"
    assert_includes html, "decor:rounded-suite-control"
    assert_includes html, "USD"
  end

  test "uses suite tokens for default input chrome" do
    html = render_component(::Decor::Suite::Forms::NumberField.new(name: "qty", label: "Quantity"))
    assert_includes html, "decor:border-suite-hairline-strong"
    assert_includes html, "decor:rounded-suite-control"
    assert_includes html, "decor:duration-suite-fast"
  end

  test "no daisy semantic color leakage" do
    html = render_component(::Decor::Suite::Forms::NumberField.new(name: "qty", label: "Quantity"))
    refute_includes html, "decor:bg-info"
    refute_includes html, "decor:text-info"
    refute_includes html, "decor:d-input"
    refute_includes html, "decor:d-validator"
  end

  test "required appends an asterisk to the label" do
    html = render_component(
      ::Decor::Suite::Forms::NumberField.new(name: "qty", label: "Quantity", required: true)
    )
    assert_includes html, "Quantity *"
  end
end
