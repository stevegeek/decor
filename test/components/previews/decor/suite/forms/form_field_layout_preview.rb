# frozen_string_literal: true

# @label FormFieldLayout
class ::Decor::Suite::Forms::FormFieldLayoutPreview < ::Lookbook::Preview
  # @group Label position
  # @label Top
  def label_top
    render ::Decor::Suite::Forms::FormFieldLayout.new(
      field_id: "name-top",
      label: "Full name",
      label_position: :top
    ) do
      stand_in_input(id: "name-top")
    end
  end

  # @label Left
  def label_left
    render ::Decor::Suite::Forms::FormFieldLayout.new(
      field_id: "name-left",
      label: "Full name",
      description: "Appears on invoices.",
      label_position: :left
    ) do
      stand_in_input(id: "name-left")
    end
  end

  # @label Right (checkbox style)
  def label_right
    render ::Decor::Suite::Forms::FormFieldLayout.new(
      field_id: "agree-right",
      label: "I agree to the terms",
      label_position: :right
    ) do
      stand_in_input(id: "agree-right", type: "checkbox")
    end
  end

  # @label Inline
  def label_inline
    render ::Decor::Suite::Forms::FormFieldLayout.new(
      field_id: "name-inline",
      label: "Full name",
      label_position: :inline
    ) do
      stand_in_input(id: "name-inline")
    end
  end

  # @label Inside (no label rendered by layout)
  def label_inside
    render ::Decor::Suite::Forms::FormFieldLayout.new(
      field_id: "name-inside",
      label: "Full name",
      label_position: :inside
    ) do
      stand_in_input(id: "name-inside")
    end
  end

  # @group Helper / error caption

  # @label With helper text
  def helper_text
    render ::Decor::Suite::Forms::FormFieldLayout.new(
      field_id: "username-help",
      label: "Username"
    ) do |layout|
      layout.with_helper_text_section(helper_text: "3 to 32 characters. Letters and numbers only.")
      stand_in_input(id: "username-help")
    end
  end

  # @label With error text
  def error_text
    render ::Decor::Suite::Forms::FormFieldLayout.new(
      field_id: "username-err",
      label: "Username"
    ) do |layout|
      layout.with_helper_text_section(error_text: "Must be at least 3 characters.")
      stand_in_input(id: "username-err")
    end
  end

  # @label Disabled
  def disabled
    render ::Decor::Suite::Forms::FormFieldLayout.new(
      field_id: "ein-dis",
      label: "Tax ID",
      disabled: true
    ) do |layout|
      layout.with_helper_text_section(helper_text: "Locked while your tax review is pending.", disabled: true)
      stand_in_input(id: "ein-dis", value: "12-3456789", disabled: true)
    end
  end

  # @group Playground

  # @param label text
  # @param description text
  # @param label_position [Symbol] select [top, left, right, inline, inside]
  # @param helper_text text
  # @param error_text text
  # @param disabled toggle
  def playground(
    label: "Email",
    description: nil,
    label_position: :top,
    helper_text: nil,
    error_text: nil,
    disabled: false
  )
    render ::Decor::Suite::Forms::FormFieldLayout.new(
      field_id: "playground",
      label: label,
      description: description,
      label_position: label_position,
      disabled: disabled
    ) do |layout|
      if helper_text.present? || error_text.present?
        layout.with_helper_text_section(
          helper_text: helper_text.presence,
          error_text: error_text.presence,
          disabled: disabled
        )
      end
      stand_in_input(id: "playground", disabled: disabled)
    end
  end

  private

  # Renders a minimal native input that matches the FormFieldLayout's
  # `for="{field_id}-control"` expectation. Keeps the preview decoupled
  # from any concrete Suite field skin.
  def stand_in_input(id:, type: "text", value: nil, disabled: false)
    safe(
      %(<input id="#{id}-control" name="#{id}" type="#{type}"#{%( value="#{value}") if value}#{" disabled" if disabled} class="decor:block decor:w-full decor:suite-input-base decor:border decor:border-suite-hairline-strong decor:rounded-suite-control decor:bg-white" />)
    )
  end

  def safe(str)
    str.respond_to?(:html_safe) ? str.html_safe : str
  end
end
