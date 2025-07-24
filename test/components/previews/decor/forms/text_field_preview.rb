# Text input field component for collecting single-line text from users.
# Supports various input types, validation patterns, and add-ons for enhanced functionality.
# @label TextField
class ::Decor::Forms::TextFieldPreview < ::Lookbook::Preview
  # @group Examples

  # Basic text field with label
  def default
    render ::Decor::Forms::TextField.new(
      name: "username",
      label: "Username",
      placeholder: "Enter your username"
    )
  end

  # Email input with validation
  def email_field
    render ::Decor::Forms::TextField.new(
      name: "email",
      label: "Email address",
      type: :email,
      placeholder: "you@example.com",
      required: true,
      helper_text: "We'll never share your email"
    )
  end

  # Password field with icons
  def password_field
    render ::Decor::Forms::TextField.new(
      name: "password",
      label: "Password",
      type: :password,
      leading_icon_name: "lock-closed",
      trailing_icon_name: "eye",
      required: true,
      minimum_length: 8,
      helper_text: "Must be at least 8 characters"
    )
  end

  # Field with add-ons
  def with_add_ons
    render ::Decor::Forms::TextField.new(
      name: "website",
      label: "Website URL",
      type: :url,
      leading_text_add_on: "https://",
      trailing_text_add_on: ".com",
      placeholder: "example"
    )
  end

  # @group Playground

  # Interactive playground with all TextField options
  # @param size [Symbol] select [~, xs, sm, md, lg, xl]
  # @param color [Symbol] select [~, base, primary, secondary, accent, neutral, success, error, warning, info]
  # @param style [Symbol] select [~, filled, outlined, ghost]
  # @param name text
  # @param label text
  # @param description text
  # @param value text
  # @param placeholder text
  # @param required toggle
  # @param disabled toggle
  # @param helper_text text
  # @param hide_label_required_asterisk toggle
  # @param compact toggle
  # @param label_position [Symbol] select [~, top, left, right, inline, inside]
  # @param grid_span [Symbol] select [~, span_1, span_2, span_half, span_4, span_5, span_full]
  # @param floating_error_text toggle
  # @param input_type [Symbol] select [text, password, email, number, tel, url, search]
  # @param leading_icon_name select [~, user, envelope, lock-closed, phone, search, check-circle, x, check, download, play]
  # @param trailing_icon_name select [~, user, envelope, lock-closed, phone, search, check-circle, x, check, download, play]
  # @param leading_text_add_on text
  # @param trailing_text_add_on text
  # @param pattern text
  # @param inputmode text
  # @param numerical toggle
  # @param maximum_length number
  # @param minimum_length number
  # @param validate_value_equal_to_id text
  # @param min number
  # @param max number
  # @param step number
  # @param greater_than number
  # @param less_than number
  def playground(
    size: nil,
    color: nil,
    style: nil,
    name: "text-field",
    label: "Label",
    description: nil,
    value: nil,
    placeholder: "Enter text...",
    required: false,
    disabled: false,
    helper_text: nil,
    hide_label_required_asterisk: false,
    compact: false,
    label_position: :top,
    grid_span: nil,
    floating_error_text: false,
    input_type: :text,
    leading_icon_name: nil,
    trailing_icon_name: nil,
    leading_text_add_on: nil,
    trailing_text_add_on: nil,
    pattern: nil,
    inputmode: nil,
    numerical: false,
    maximum_length: nil,
    minimum_length: nil,
    validate_value_equal_to_id: nil,
    min: nil,
    max: nil,
    step: nil,
    greater_than: nil,
    less_than: nil
  )
    render ::Decor::Forms::TextField.new(
      size: size,
      color: color,
      style: style,
      name: name,
      label: label,
      description: description,
      value: value,
      placeholder: placeholder,
      required: required,
      disabled: disabled,
      helper_text: helper_text,
      hide_required_asterisk: hide_label_required_asterisk,
      compact: compact,
      label_position: label_position,
      grid_span: grid_span,
      floating_error_text: floating_error_text,
      type: input_type,
      leading_icon_name: leading_icon_name,
      trailing_icon_name: trailing_icon_name,
      leading_text_add_on: leading_text_add_on,
      trailing_text_add_on: trailing_text_add_on,
      pattern: pattern,
      inputmode: inputmode,
      numerical: numerical,
      maximum_length: maximum_length,
      minimum_length: minimum_length,
      validate_value_equal_to_id: validate_value_equal_to_id,
      min: min,
      max: max,
      step: step,
      greater_than: greater_than,
      less_than: less_than
    )
  end

  # @group Input Types

  # Search field
  def search_input
    render ::Decor::Forms::TextField.new(
      name: "search",
      label: "Search",
      type: :search,
      leading_icon_name: "search",
      placeholder: "Search..."
    )
  end

  # Number input with constraints
  def number_input
    render ::Decor::Forms::TextField.new(
      name: "quantity",
      label: "Quantity",
      type: :number,
      min: 1,
      max: 100,
      step: 1,
      value: "1"
    )
  end

  # Phone number field
  def phone_input
    render ::Decor::Forms::TextField.new(
      name: "phone",
      label: "Phone number",
      type: :tel,
      leading_icon_name: "phone",
      pattern: "[0-9]{3}-[0-9]{3}-[0-9]{4}",
      placeholder: "123-456-7890"
    )
  end

  # @group Validation

  # Field with pattern validation
  def with_pattern
    render ::Decor::Forms::TextField.new(
      name: "code",
      label: "Product code",
      pattern: "[A-Z]{3}-[0-9]{4}",
      placeholder: "ABC-1234",
      helper_text: "Format: 3 uppercase letters, dash, 4 digits"
    )
  end

  # Field with length constraints
  def with_length_validation
    render ::Decor::Forms::TextField.new(
      name: "bio",
      label: "Short bio",
      minimum_length: 10,
      maximum_length: 100,
      helper_text: "Between 10 and 100 characters"
    )
  end

  # @group Form Integration

  # TextField in a form context
  # @param stacked_form toggle
  # @param label_position [Symbol] select [top, left, right, inline, inside]
  # @param grid_span [Symbol] select [~, span_1, span_2, span_half, span_4, span_5, span_full]
  def in_form(
    stacked_form: true,
    label_position: :left,
    grid_span: :span_half
  )
    klass = Class.new(TypedForm) do
      def self.name
        "UserForm"
      end

      prop :first_name, String
      prop :last_name, String
      prop :email, String
    end

    render_with_template(
      locals: {
        model: klass.new(first_name: "John", last_name: "Doe", email: "john@example.com", persisted: false),
        stacked_form: stacked_form,
        label_position: label_position,
        grid_span: grid_span
      }
    )
  end
end
