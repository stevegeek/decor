# @label Select
class ::Decor::Forms::SelectPreview < ::Lookbook::Preview
  # Select
  # -------
  #
  # A styled native select element.
  # Can optionally include a blank option, or have the label shown as the first option.
  # Note that if the label is inside as a prompt, then the blank and prompt options are
  # disabled always, while if not then one can optionally disable the blank option.
  #
  # Form field attrs
  # @param label text
  # @param description text
  # @param compact toggle
  # @param label_position [Symbol] select [~, top, left, right, inline, inside]
  # @param grid_span [Symbol] select [~, span_1, span_2, span_half, span_4, span_5, span_full]
  # @param floating_error_text toggle
  # @param placeholder text
  # @param required toggle
  # @param disabled toggle
  # @param helper_text text
  # @param value text
  #
  # Select attrs:
  # @param selected_option select [~, "1", "2", "3", "4"]
  # @param include_blank_option toggle
  # @param disable_blank_option toggle
  # @param color select [primary, secondary, accent, success, error, warning, info, ghost, neutral]
  # @param size select [xs, sm, md, lg, xl]
  def playground(
    name: "select-1",
    label: "Select one:",
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
    selected_option: nil,
    include_blank_option: false,
    disable_blank_option: true,
    color: :primary,
    size: :md
  )
    render ::Decor::Forms::Select.new(
      name: name,
      label: label,
      description: description,
      **::Decor::Forms::Select.map_options_for_select(
        [
          {
            title: "Option 1",
            value: "1"
          }, {
            title: "Option 2",
            value: "2"
          }, {
            title: "Option 3 (disabled)",
            disabled: true,
            value: "3"
          }, {
            title: "Option 4",
            selected: true,
            value: "4"
          }
        ]
      ),
      value: value,
      required: required,
      disabled: disabled,
      helper_text: helper_text,
      hide_required_asterisk: hide_label_required_asterisk,
      compact: compact,
      label_position: label_position,
      grid_span: grid_span,
      floating_error_text: floating_error_text,
      placeholder: placeholder,
      selected_option: selected_option,
      include_blank_option: include_blank_option,
      disable_blank_option: disable_blank_option,
      color: color,
      size: size
    )
  end

  # Select boxes in a form
  #
  # @param stacked_form toggle
  #
  # Form field attrs
  # @param label text
  # @param description text
  # @param show_label toggle
  # @param compact toggle
  # @param label_position [Symbol] select [~, top, left, right, inline, inside]
  # @param grid_span [Symbol] select [~, span_1, span_2, span_half, span_4, span_5, span_full]
  # @param floating_error_text toggle
  # @param placeholder text
  # @param required toggle
  # @param disabled toggle
  # @param helper_text text
  # @param value text
  #
  # Select attrs:
  # @param selected_option select [~, "1", "2", "3", "4"]
  # @param include_blank_option toggle
  # @param disable_blank_option toggle
  def in_form(
    stacked_form: true,
    label: "Select one",
    description: nil,
    show_label: true,
    value: nil,
    required: nil,
    disabled: nil,
    compact: nil,
    label_position: :left,
    grid_span: nil,
    floating_error_text: nil,
    helper_text: nil,
    hide_label_required_asterisk: nil,
    placeholder: nil,
    selected_option: nil,
    include_blank_option: nil,
    disable_blank_option: nil
  )
    klass = Class.new(TypedForm) do
      def self.name
        "TestClass"
      end

      prop :option, String
    end

    render_with_template(
      locals: {
        model: klass.new(option: selected_option || ""),
        options: ::Decor::Forms::Select.map_options_for_select(
          [
            {
              title: "Option 1",
              value: "1"
            }, {
              title: "Option 2",
              value: "2"
            }, {
              title: "Option 3 (disabled)",
              disabled: true,
              value: "3"
            }, {
              title: "Option 4",
              value: "4"
            }, {
              title: "Option 5#{include_blank_option ? "" : " (has no value)"}",
              value: include_blank_option ? "5" : ""
            }
          ]
        ),
        stacked_form: stacked_form,
        label: label,
        description: description,
        show_label: show_label,
        value: value,
        required: required,
        disabled: disabled,
        helper_text: helper_text,
        hide_required_asterisk: hide_label_required_asterisk,
        compact: compact,
        label_position: label_position,
        grid_span: grid_span,
        floating_error_text: floating_error_text,
        placeholder: placeholder,
        selected_option: selected_option,
        include_blank_option: include_blank_option,
        disable_blank_option: disable_blank_option
      }
    )
  end

  # DaisyUI Colors and Sizes
  # ------------------------
  #
  # Showcase the different color and size options available with DaisyUI styling.
  def color_and_size_examples
    render_with_template
  end
end
