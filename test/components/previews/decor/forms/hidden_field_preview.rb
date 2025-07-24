# @label HiddenField
#
# Hidden input fields store data that should be submitted with a form but not visible to users.
# Used for CSRF tokens, IDs, or other metadata that needs to be included in form submissions.
class ::Decor::Forms::HiddenFieldPreview < ::Lookbook::Preview
  # @!group Examples

  # @label Default
  # Basic hidden field with a value
  def default
    render ::Decor::Forms::HiddenField.new(
      name: "user_id",
      value: "12345"
    )
  end

  # @label CSRF Token
  # Hidden field for CSRF protection
  def csrf_token
    render ::Decor::Forms::HiddenField.new(
      name: "authenticity_token",
      value: "xyz789token"
    )
  end

  # @label Form Integration
  # Hidden field used within a form context
  #
  # @param value text
  def form_integration(value: "hidden-value-123")
    klass = Class.new(TypedForm) do
      def self.name
        "TestClass"
      end

      prop :text, String
    end

    render_with_template(
      locals: {
        model: klass.new(text: value),
        disabled: false,
        value: value
      }
    )
  end

  # @!endgroup

  # @!group Playground

  # @label Playground
  # Experiment with all available parameters
  #
  # @param name text "Field name attribute"
  # @param value text "Field value"
  # @param disabled toggle "Disable the field"
  def playground(
    name: "hidden_field",
    value: "example_value",
    disabled: false
  )
    render ::Decor::Forms::HiddenField.new(
      name: name,
      value: value,
      disabled: disabled
    )
  end

  # @!endgroup

  # @!group States

  # @label Disabled
  # Hidden field in disabled state
  def disabled
    render ::Decor::Forms::HiddenField.new(
      name: "disabled_field",
      value: "cannot_change",
      disabled: true
    )
  end

  # @label Empty Value
  # Hidden field with no value
  def empty_value
    render ::Decor::Forms::HiddenField.new(
      name: "empty_field",
      value: nil
    )
  end

  # @!endgroup
end
