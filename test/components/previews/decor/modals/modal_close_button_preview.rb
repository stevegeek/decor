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
  # @param color select [primary, secondary, danger, warning, neutral]
  # @param size select [medium, large, wide, small, micro, link]
  # @param full_width toggle
  def playground(
    close_reason: "ok",
    label: "OK",
    icon: nil,
    variant: :contained,
    color: :primary,
    size: :medium,
    disabled: false,
    full_width: false
  )
    render ::Decor::Modals::ModalCloseButton.new(
      close_reason: close_reason,
      label: label,
      icon: icon,
      variant: variant,
      color: color,
      size: size,
      disabled: disabled,
      full_width: full_width
    )
  end

  def in_modal
  end
end
