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
  # @param show_label toggle
  # @param required toggle
  # @param hide_label_required_asterisk toggle
  # @param disabled toggle
  # @param helper_text text
  # @param value text
  def playground(
    name: "checkbox-group-1",
    label: "Select options...",
    show_label: true,
    size: 5,
    hide_after_showing: 3,
    value: nil,
    required: nil,
    disabled: nil,
    helper_text: nil,
    hide_label_required_asterisk: nil
  )
    render ::Decor::Forms::ExpandingCheckboxCollection.new(
      name: name,
      label: label,
      show_label: show_label,
      size: size,
      hide_after_showing: hide_after_showing,
      value: value,
      required: required,
      disabled: disabled,
      helper_text: helper_text,
      hide_required_asterisk: hide_label_required_asterisk
    ) do |c|
      c.with_checkboxes { "Checkboxes go here! This must really be created using the custom FormBuilder" }
    end
  end

  # Form field attrs
  # @param label text
  # @param show_label toggle
  # @param size number
  # @param hide_after_showing number
  # @param required toggle
  # @param hide_label_required_asterisk toggle
  # @param disabled toggle
  # @param helper_text text
  # @param value text
  def in_form(
    label: "In a form!",
    show_label: true,
    value: nil,
    size: 5,
    hide_after_showing: 3,
    required: nil,
    disabled: nil,
    helper_text: nil,
    hide_label_required_asterisk: nil
  )
    klass = Class.new(TypedForm) do
      def self.name
        "TestClass"
      end

      prop :chosen, Array, sub_type: String
    end

    render_with_template(
      locals: {
        model: klass.new(chosen: nil),
        choices: [
          OpenStruct.new(value: "yes", label: "Yes"),
          OpenStruct.new(value: "no", label: "No"),
          OpenStruct.new(value: "maybe", label: "Maybe"),
          OpenStruct.new(value: "maybe-not", label: "Maybe not"),
          OpenStruct.new(value: "maybe-not-maybe", label: "Maybe not maybe")
        ],
        label: label,
        size: size,
        hide_after_showing: hide_after_showing,
        show_label: show_label,
        value: value,
        required: required,
        disabled: disabled,
        helper_text: helper_text,
        hide_required_asterisk: hide_label_required_asterisk
      }
    )
  end
end
