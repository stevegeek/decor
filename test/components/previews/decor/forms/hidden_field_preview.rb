# @label HiddenField
class ::Decor::Forms::HiddenFieldPreview < ::Lookbook::Preview
  # HiddenField
  # -------
  #
  # A hidden input field
  #
  # ---------
  # Form field attrs
  # @param name text
  # @param disabled toggle
  # @param value text
  def playground(
    name: "text-field-1",
    disabled: false,
    value: nil
  )
    render ::Decor::Forms::HiddenField.new(
      name: name,
      disabled: disabled,
      value: value
    )
  end

  # Example of a HiddenField used in a form.
  #
  # Form field attrs
  # @param disabled toggle
  # @param value text
  def in_form(
    disabled: false,
    value: nil
  )
    klass = Class.new(TypedForm) do
      def self.name
        "TestClass"
      end

      prop :text, String
    end

    render_with_template(
      locals: {
        model: klass.new(text: value || ""),
        value: value,
        disabled: disabled
      }
    )
  end
end
