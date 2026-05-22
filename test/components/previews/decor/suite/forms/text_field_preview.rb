# frozen_string_literal: true

# @label TextField
class ::Decor::Suite::Forms::TextFieldPreview < ::Lookbook::Preview
  # @group Examples

  # @label Default
  def default
    render ::Decor::Suite::Forms::TextField.new(
      name: "first_name",
      label: "First name",
      placeholder: "Jane"
    )
  end

  # @label With value
  def with_value
    render ::Decor::Suite::Forms::TextField.new(
      name: "email",
      label: "Email",
      value: "jane@example.com",
      type: :email
    )
  end

  # @label Helper text
  def helper_text
    render ::Decor::Suite::Forms::TextField.new(
      name: "username",
      label: "Username",
      helper_text: "3 to 32 characters. Letters and numbers only."
    )
  end

  # @label Error state
  def errored
    render ::Decor::Suite::Forms::TextField.new(
      name: "username",
      label: "Username",
      value: "x",
      error_messages: ["Must be at least 3 characters"]
    )
  end

  # @label Disabled
  def disabled
    render ::Decor::Suite::Forms::TextField.new(
      name: "ein",
      label: "Tax ID",
      value: "12-3456789",
      disabled: true
    )
  end

  # @label Required
  def required
    render ::Decor::Suite::Forms::TextField.new(
      name: "name",
      label: "Full name",
      required: true
    )
  end

  # @group Add-ons (icon)
  # @label Leading icon
  def leading_icon
    render ::Decor::Suite::Forms::TextField.new(
      name: "search",
      label: "Search",
      leading_icon_name: "magnifying-glass",
      placeholder: "Find a product"
    )
  end

  # @label Trailing icon
  def trailing_icon
    render ::Decor::Suite::Forms::TextField.new(
      name: "email",
      label: "Email",
      trailing_icon_name: "envelope"
    )
  end

  # @group Add-ons (boxed)
  # @label Boxed leading text
  def boxed_leading_text
    render ::Decor::Suite::Forms::TextField.new(
      name: "website",
      label: "Website",
      leading_text_add_on: "https://",
      add_on_style: :boxed,
      placeholder: "example.com"
    )
  end

  # @label Boxed trailing text
  def boxed_trailing_text
    render ::Decor::Suite::Forms::TextField.new(
      name: "price",
      label: "Price",
      trailing_text_add_on: "USD",
      add_on_style: :boxed,
      type: :number
    )
  end

  # @label Boxed both sides
  def boxed_both_sides
    render ::Decor::Suite::Forms::TextField.new(
      name: "amount",
      label: "Amount",
      leading_text_add_on: "$",
      trailing_text_add_on: ".00",
      add_on_style: :boxed,
      type: :number
    )
  end

  # @group Label positions
  # @label Label left
  def label_left
    render ::Decor::Suite::Forms::TextField.new(
      name: "company",
      label: "Company name",
      label_position: :left,
      description: "The legal name of your business."
    )
  end

  # @label Label inline
  def label_inline
    render ::Decor::Suite::Forms::TextField.new(
      name: "company",
      label: "Company",
      label_position: :inline
    )
  end

  # @group Playground
  # @param label text
  # @param value text
  # @param placeholder text
  # @param helper_text text
  # @param required toggle
  # @param disabled toggle
  # @param type [Symbol] select [text, email, password, number, tel, url, search]
  # @param leading_icon_name select [~, magnifying-glass, envelope, user, lock-closed]
  # @param trailing_icon_name select [~, magnifying-glass, envelope, user, lock-closed]
  # @param leading_text_add_on text
  # @param trailing_text_add_on text
  # @param add_on_style [Symbol] select [text, boxed]
  # @param label_position [Symbol] select [top, left, inline, right, inside]
  def playground(
    label: "Field label",
    value: nil,
    placeholder: nil,
    helper_text: nil,
    required: false,
    disabled: false,
    type: :text,
    leading_icon_name: nil,
    trailing_icon_name: nil,
    leading_text_add_on: nil,
    trailing_text_add_on: nil,
    add_on_style: :text,
    label_position: :top
  )
    render ::Decor::Suite::Forms::TextField.new(
      name: "playground",
      label: label,
      value: value,
      placeholder: placeholder,
      helper_text: helper_text,
      required: required,
      disabled: disabled,
      type: type,
      leading_icon_name: leading_icon_name,
      trailing_icon_name: trailing_icon_name,
      leading_text_add_on: leading_text_add_on,
      trailing_text_add_on: trailing_text_add_on,
      add_on_style: add_on_style,
      label_position: label_position
    )
  end
end
