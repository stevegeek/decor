# @label ModalCloseButton
class ::Decor::Modals::ModalCloseButtonPreview < ::Lookbook::Preview
  # A button that triggers the modal close action, typically rendered inside modal views
  # as a Cancel or OK button. The `close_reason` is passed to the modal's `onClose` callback.

  # @group Examples
  # Key examples demonstrating common use cases for modal close buttons

  def default
    render ::Decor::Modals::ModalCloseButton.new(
      close_reason: "ok",
      label: "OK"
    )
  end

  def cancel_button
    render ::Decor::Modals::ModalCloseButton.new(
      close_reason: "cancel",
      label: "Cancel",
      style: :outlined,
      color: :neutral
    )
  end

  def save_and_close
    render ::Decor::Modals::ModalCloseButton.new(
      close_reason: "save",
      label: "Save Changes",
      icon: "check",
      color: :primary
    )
  end

  def danger_action
    render ::Decor::Modals::ModalCloseButton.new(
      close_reason: "delete",
      label: "Delete",
      icon: "x",
      style: :filled,
      color: :error
    )
  end

  # @endgroup

  # @group Playground
  # Interactive example with all parameters

  # @param close_reason text
  # @param label text
  # @param icon select [~, check-circle, x, check, download, play]
  # @param style select [filled, outlined, ghost]
  # @param color select [primary, secondary, error, warning, neutral]
  # @param size select [medium, large, wide, small, micro, link]
  # @param disabled toggle
  # @param full_width toggle
  def playground(
    close_reason: "ok",
    label: "OK",
    icon: nil,
    style: :filled,
    color: :primary,
    size: :medium,
    disabled: false,
    full_width: false
  )
    render ::Decor::Modals::ModalCloseButton.new(
      close_reason: close_reason,
      label: label,
      icon: icon,
      style: style,
      color: color,
      size: size,
      disabled: disabled,
      full_width: full_width
    )
  end

  # @endgroup

  # @group Styles
  # Different button styles for modal close actions

  def filled_style
    render ::Decor::Modals::ModalCloseButton.new(
      close_reason: "submit",
      label: "Submit",
      style: :filled
    )
  end

  def outlined_style
    render ::Decor::Modals::ModalCloseButton.new(
      close_reason: "cancel",
      label: "Cancel",
      style: :outlined
    )
  end

  def ghost_style
    render ::Decor::Modals::ModalCloseButton.new(
      close_reason: "close",
      label: "Close",
      style: :ghost
    )
  end

  # @endgroup

  # @group Close Reasons
  # Examples of different close reasons passed to modal callback

  def accept_reason
    render ::Decor::Modals::ModalCloseButton.new(
      close_reason: "accept",
      label: "Accept",
      icon: "check-circle",
      color: :primary
    )
  end

  def reject_reason
    render ::Decor::Modals::ModalCloseButton.new(
      close_reason: "reject",
      label: "Reject",
      icon: "x",
      color: :error
    )
  end

  def skip_reason
    render ::Decor::Modals::ModalCloseButton.new(
      close_reason: "skip",
      label: "Skip for Now",
      style: :ghost,
      color: :neutral
    )
  end

  # @endgroup

  # @group States
  # Different button states

  def disabled_state
    render ::Decor::Modals::ModalCloseButton.new(
      close_reason: "save",
      label: "Save",
      disabled: true
    )
  end

  def full_width_state
    render ::Decor::Modals::ModalCloseButton.new(
      close_reason: "confirm",
      label: "Confirm",
      full_width: true
    )
  end

  # @endgroup

  # @group In Modal Context
  # Example of modal close button used within an actual modal

  def in_modal
  end

  # @endgroup
end
