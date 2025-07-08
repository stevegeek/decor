# @label ExpandingCheckboxCollection
class ::Decor::Forms::ExpandingCheckboxCollectionPreview < ::Lookbook::Preview
  # -------
  #
  # A ExpandingCheckboxCollection is a group of checkboxes. It shows a certain number of checkboxes, then
  # hides the rest, which can be expanded by clicking a 'Show more' link.
  # Behaviour is controlled by a StimulusJS controller. The component is a type of FormField component.
  #
  # Form field attrs
  # @param name text
  # @param label text
  # @param size number
  # @param hide_after_showing number
  # @param variant [Symbol] select [~, default, joined]
  # @param color [Symbol] select [~, primary, secondary, accent, neutral, success, warning, info, error]
  # @param required toggle
  # @param hide_label_required_asterisk toggle
  # @param disabled toggle
  # @param helper_text text
  # @param value text
  def playground(
    name: "checkbox-group-1",
    label: "Select options...",
    size: 5,
    hide_after_showing: 3,
    variant: :default,
    color: :primary,
    value: nil,
    required: false,
    disabled: false,
    helper_text: nil,
    hide_label_required_asterisk: false
  )
    component = ::Decor::Forms::ExpandingCheckboxCollection.new(
      name: name,
      label: label,
      size: size,
      hide_after_showing: hide_after_showing,
      variant: variant,
      color: color,
      value: value,
      required: required,
      disabled: disabled,
      helper_text: helper_text,
      hide_required_asterisk: hide_label_required_asterisk
    )
    component.instance_variable_set(:@checkboxes, "Checkboxes go here! This must really be created using the custom FormBuilder")
    render component
  end

  # Form field attrs
  # @param label text
  # @param size number
  # @param hide_after_showing number
  # @param variant [Symbol] select [~, default, joined]
  # @param color [Symbol] select [~, primary, secondary, accent, neutral, success, warning, info, error]
  # @param required toggle
  # @param hide_label_required_asterisk toggle
  # @param disabled toggle
  # @param helper_text text
  # @param value text
  def in_form(
    label: "In a form!",
    value: nil,
    size: 5,
    hide_after_showing: 3,
    variant: :default,
    color: nil,
    required: false,
    disabled: false,
    helper_text: nil,
    hide_label_required_asterisk: false
  )
    klass = Class.new(TypedForm) do
      def self.name
        "TestClass"
      end

      prop :chosen, Array
    end

    render_with_template(
      locals: {
        model: klass.new(chosen: []),
        choices: [
          {value: "yes", label: "Yes"},
          {value: "no", label: "No"},
          {value: "maybe", label: "Maybe"},
          {value: "maybe-not", label: "Maybe not"},
          {value: "maybe-not-maybe", label: "Maybe not maybe"}
        ],
        label: label,
        size: size,
        hide_after_showing: hide_after_showing,
        variant: variant,
        color: color,
        value: value,
        required: required,
        disabled: disabled,
        helper_text: helper_text,
        hide_required_asterisk: hide_label_required_asterisk
      }
    )
  end
end
