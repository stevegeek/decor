# frozen_string_literal: true

# @label NumberField
class ::Decor::Suite::Forms::NumberFieldPreview < ::Lookbook::Preview
  # @group Examples

  # @label Default
  def default
    render ::Decor::Suite::Forms::NumberField.new(
      name: "quantity",
      label: "Quantity",
      placeholder: "0"
    )
  end

  # @label With value
  def with_value
    render ::Decor::Suite::Forms::NumberField.new(
      name: "quantity",
      label: "Quantity",
      value: "12"
    )
  end

  # @label Min / max / step
  def min_max_step
    render ::Decor::Suite::Forms::NumberField.new(
      name: "rating",
      label: "Rating",
      min: 0,
      max: 5,
      step: 1,
      value: "3"
    )
  end

  # @label Allow float input
  def allow_float_input
    render ::Decor::Suite::Forms::NumberField.new(
      name: "weight_kg",
      label: "Weight (kg)",
      allow_float_input: true,
      step: 0.01,
      value: "1.25"
    )
  end

  # @label Helper text
  def helper_text
    render ::Decor::Suite::Forms::NumberField.new(
      name: "qty",
      label: "Quantity",
      helper_text: "Whole numbers only."
    )
  end

  # @label Error state
  def errored
    render ::Decor::Suite::Forms::NumberField.new(
      name: "qty",
      label: "Quantity",
      value: "-3",
      error_messages: ["Must be greater than zero"]
    )
  end

  # @label Disabled
  def disabled
    render ::Decor::Suite::Forms::NumberField.new(
      name: "qty",
      label: "Quantity",
      value: "42",
      disabled: true
    )
  end

  # @label Required
  def required
    render ::Decor::Suite::Forms::NumberField.new(
      name: "qty",
      label: "Quantity",
      required: true
    )
  end

  # @group Add-ons
  # @label Boxed trailing unit
  def boxed_trailing_unit
    render ::Decor::Suite::Forms::NumberField.new(
      name: "price",
      label: "Price",
      trailing_text_add_on: "USD",
      add_on_style: :boxed
    )
  end

  # @label Boxed leading currency
  def boxed_leading_currency
    render ::Decor::Suite::Forms::NumberField.new(
      name: "amount",
      label: "Amount",
      leading_text_add_on: "$",
      add_on_style: :boxed,
      allow_float_input: true
    )
  end

  # @group Playground
  # @param label text
  # @param value text
  # @param placeholder text
  # @param helper_text text
  # @param required toggle
  # @param disabled toggle
  # @param allow_float_input toggle
  # @param min number
  # @param max number
  # @param step number
  # @param leading_text_add_on text
  # @param trailing_text_add_on text
  # @param add_on_style [Symbol] select [text, boxed]
  # @param label_position [Symbol] select [top, left, inline, right, inside]
  def playground(
    label: "Quantity",
    value: nil,
    placeholder: "0",
    helper_text: nil,
    required: false,
    disabled: false,
    allow_float_input: false,
    min: nil,
    max: nil,
    step: nil,
    leading_text_add_on: nil,
    trailing_text_add_on: nil,
    add_on_style: :text,
    label_position: :top
  )
    render ::Decor::Suite::Forms::NumberField.new(
      name: "playground",
      label: label,
      value: value,
      placeholder: placeholder,
      helper_text: helper_text,
      required: required,
      disabled: disabled,
      allow_float_input: allow_float_input,
      min: min,
      max: max,
      step: step,
      leading_text_add_on: leading_text_add_on,
      trailing_text_add_on: trailing_text_add_on,
      add_on_style: add_on_style,
      label_position: label_position
    )
  end
end
