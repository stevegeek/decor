# @label Button
class ::Decor::ButtonPreview < ::ViewComponent::Preview
  # Buttons
  # -------
  #
  # By default a button will use the `button` element but one can specify
  # another tag (eg 'a') using the `tag` option.
  #
  # @param label text
  # @param disabled toggle
  # @param icon select [~, check-circle, x, check, download, play]
  # @param variant select [contained, outlined, text]
  # @param theme select [primary, secondary, danger, warning]
  # @param element_tag select [button, a]
  # @param size select [medium, large, wide, small, micro]
  # @param full_width toggle
  def playground(
    label: "Button",
    icon: nil,
    variant: :contained,
    theme: :primary,
    size: :medium,
    element_tag: :button,
    disabled: false,
    full_width: false
  )
    render ::Decor::Button.new(
      label: label,
      icon: icon,
      variant: variant,
      theme: theme,
      size: size,
      element_tag: element_tag,
      disabled: disabled,
      full_width: full_width
    )
  end
end
