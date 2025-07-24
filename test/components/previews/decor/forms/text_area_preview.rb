# @label TextArea
class ::Decor::Forms::TextAreaPreview < ::Lookbook::Preview
  # Multi-line text input field for capturing longer text content like comments, descriptions, or messages.

  # @group Examples

  # @label Default
  # Basic textarea with standard configuration
  def default
    render ::Decor::Forms::TextArea.new(
      name: "comment",
      label: "Comment",
      placeholder: "Enter your comment here..."
    )
  end

  # @label With Helper Text
  # TextArea with helper text to guide users
  def with_helper_text
    render ::Decor::Forms::TextArea.new(
      name: "description",
      label: "Product Description",
      helper_text: "Provide a detailed description of the product (minimum 50 characters)",
      minimum_length: 50,
      rows: 6
    )
  end

  # @label Required Field
  # TextArea marked as required with validation
  def required_field
    render ::Decor::Forms::TextArea.new(
      name: "feedback",
      label: "Your Feedback",
      required: true,
      placeholder: "Please share your feedback...",
      maximum_length: 500,
      helper_text: "Maximum 500 characters"
    )
  end

  # @label With Error State
  # TextArea showing error state
  def with_error
    render ::Decor::Forms::TextArea.new(
      name: "bio",
      label: "Biography",
      value: "Too short",
      error_messages: ["Biography must be at least 20 characters long"],
      minimum_length: 20
    )
  end

  # @endgroup

  # @group Playground

  # @label Playground
  # Experiment with all TextArea properties
  #
  # Form field attrs
  # @param name text
  # @param label text
  # @param description text
  # @param compact toggle
  # @param label_position select [~, top, left, right, inline, inside]
  # @param grid_span [Symbol] select [~, span_1, span_2, span_half, span_4, span_5, span_full]
  # @param floating_error_text toggle
  # @param placeholder text
  # @param required toggle
  # @param hide_label_required_asterisk toggle
  # @param disabled toggle
  # @param helper_text text
  # @param value text
  # @param color select [primary, secondary, accent, success, error, warning, info]
  # @param size select [xs, sm, md, lg]
  # @param style select [~, plain, bordered, filled]
  #
  # TextArea attrs:
  # @param rows number
  # @param cols number
  # @param pattern text
  # @param maximum_length number
  # @param minimum_length number
  def playground(
    name: "text-area-1",
    label: "What is your story?",
    description: nil,
    value: nil,
    required: false,
    disabled: false,
    helper_text: nil,
    hide_label_required_asterisk: false,
    compact: false,
    label_position: :top,
    grid_span: nil,
    floating_error_text: false,
    placeholder: nil,
    rows: 5,
    cols: nil,
    pattern: nil,
    maximum_length: nil,
    minimum_length: nil,
    color: :primary,
    size: :md,
    style: nil
  )
    render ::Decor::Forms::TextArea.new(
      name: name,
      label: label,
      description: description,
      value: value,
      required: required,
      disabled: disabled,
      helper_text: helper_text,
      compact: compact,
      label_position: label_position,
      grid_span: grid_span,
      floating_error_text: floating_error_text,
      placeholder: placeholder,
      hide_required_asterisk: hide_label_required_asterisk,
      rows: rows,
      cols: cols,
      pattern: pattern,
      maximum_length: maximum_length,
      minimum_length: minimum_length,
      color: color,
      size: size,
      style: style
    )
  end

  # @endgroup

  # @group Colors & Sizes

  # @label Color & Size Variants
  # All available color and size combinations
  def color_and_size_variants
    render_with_template(template: "decor/forms/text_area_preview/color_and_size_examples")
  end

  # @endgroup

  # @group States

  # @label Disabled State
  # TextArea in disabled state
  def disabled_state
    render ::Decor::Forms::TextArea.new(
      name: "disabled_textarea",
      label: "Disabled TextArea",
      value: "This textarea is disabled",
      disabled: true,
      helper_text: "This field cannot be edited"
    )
  end

  # @label With Character Counter
  # TextArea with character limit indicator
  def with_character_counter
    render ::Decor::Forms::TextArea.new(
      name: "limited_textarea",
      label: "Short Message",
      placeholder: "Type your message...",
      maximum_length: 100,
      helper_text: "Maximum 100 characters",
      rows: 3
    )
  end

  # @endgroup

  # @group Form Integration

  # @label In Form Context
  # TextArea integrated within a form
  #
  # @param stacked_form toggle
  #
  # Form field attrs
  # @param label text
  # @param description text
  # @param compact toggle
  # @param label_position select [~, top, left, right, inline, inside]
  # @param grid_span [Symbol] select [~, span_1, span_2, span_half, span_4, span_5, span_full]
  # @param floating_error_text toggle
  # @param placeholder text
  # @param required toggle
  # @param hide_label_required_asterisk toggle
  # @param disabled toggle
  # @param helper_text text
  # @param value text
  #
  # TextArea attrs:
  # @param pattern text
  # @param maximum_length number
  # @param minimum_length number
  def in_form(
    stacked_form: true,
    label: "What is your story?",
    description: nil,
    value: nil,
    required: nil,
    disabled: nil,
    helper_text: nil,
    hide_label_required_asterisk: nil,
    compact: false,
    label_position: :left,
    grid_span: :span_half,
    floating_error_text: nil,
    placeholder: nil,
    pattern: nil,
    maximum_length: nil,
    minimum_length: nil
  )
    klass = Class.new(TypedForm) do
      def self.name
        "TestClass"
      end

      prop :text, String
    end

    render_with_template(
      locals: {
        model: klass.new(text: ""),
        stacked_form: stacked_form,
        label: label,
        description: description,
        value: value,
        required: required,
        disabled: disabled,
        helper_text: helper_text,
        hide_label_required_asterisk: hide_label_required_asterisk,
        compact: compact,
        label_position: label_position,
        grid_span: grid_span,
        floating_error_text: floating_error_text,
        placeholder: placeholder,
        pattern: pattern,
        maximum_length: maximum_length,
        minimum_length: minimum_length
      }
    )
  end

  # @endgroup

  # @group Layout Options

  # @label Compact Mode
  # TextArea with compact spacing
  def compact_mode
    render ::Decor::Forms::TextArea.new(
      name: "compact_notes",
      label: "Quick Notes",
      compact: true,
      rows: 3,
      placeholder: "Add a quick note..."
    )
  end

  # @label Custom Dimensions
  # TextArea with custom row and column settings
  def custom_dimensions
    render ::Decor::Forms::TextArea.new(
      name: "custom_textarea",
      label: "Custom Size TextArea",
      rows: 10,
      cols: 60,
      placeholder: "This textarea has custom dimensions (10 rows, 60 columns)"
    )
  end

  # @endgroup
end
