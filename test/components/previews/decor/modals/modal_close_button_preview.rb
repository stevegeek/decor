# @label ModalCloseButton
class ::Decor::Modals::ModalCloseButtonPreview < ::Lookbook::Preview
  # ModalCloseButton
  # -------
  #
  # A button that triggers the modal close action, typically rendered in the
  # views displayed inside a modal, as say a Cancel or OK button. The
  # `close_reason` is passed to the modal's `onClose` callback.
  #
  # @param close_reason text
  # @param label text
  # @param icon select [~, check-circle, x, check, download, play]
  # @param disabled toggle
  # @param variant select [contained, outlined, text]
  # @param theme select [primary, secondary, inverse]
  # @param element_tag select [button, a]
  # @param size select [medium, large, wide, small, micro, link]
  # @param full_width toggle
  def playground(
    close_reason: "ok",
    label: "OK",
    icon: nil,
    variant: :contained,
    theme: :primary,
    size: :medium,
    element_tag: :button,
    disabled: false,
    full_width: false
  )
    render ::Decor::ModalCloseButton.new(
      close_reason: close_reason,
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

  def in_modal
  end
end
