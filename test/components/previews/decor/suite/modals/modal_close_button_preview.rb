# @label ModalCloseButton
class ::Decor::Suite::Modals::ModalCloseButtonPreview < ::Lookbook::Preview
  # A button that, when clicked, dispatches a window-scoped close event for
  # the Suite Modal. The optional `close_reason` is carried on the event
  # detail so listeners can branch on intent (e.g. "save" vs "cancel").

  # @group Examples
  def default
    render ::Decor::Suite::Modals::ModalCloseButton.new(
      close_reason: "ok",
      label: "OK",
      color: :primary
    )
  end

  def cancel_button
    render ::Decor::Suite::Modals::ModalCloseButton.new(
      close_reason: "cancel",
      label: "Cancel",
      style: :outlined,
      color: :neutral
    )
  end

  def save_and_close
    render ::Decor::Suite::Modals::ModalCloseButton.new(
      close_reason: "save",
      label: "Save Changes",
      icon: "check",
      color: :primary
    )
  end

  def danger_action
    render ::Decor::Suite::Modals::ModalCloseButton.new(
      close_reason: "delete",
      label: "Delete",
      icon: "x-mark",
      style: :filled,
      color: :error
    )
  end

  def icon_only_default
    render ::Decor::Suite::Modals::ModalCloseButton.new(close_reason: "dismiss")
  end
  # @endgroup

  # @group Playground
  # @param close_reason text
  # @param label text
  # @param icon select [~, check, x-mark, download]
  # @param style select [filled, outlined, ghost]
  # @param color select [primary, neutral, error, warning, success]
  # @param size select [xs, sm, md, lg, xl]
  # @param disabled toggle
  # @param full_width toggle
  def playground(
    close_reason: "ok",
    label: "OK",
    icon: nil,
    style: :filled,
    color: :primary,
    size: :md,
    disabled: false,
    full_width: false
  )
    render ::Decor::Suite::Modals::ModalCloseButton.new(
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
  def filled_style
    render ::Decor::Suite::Modals::ModalCloseButton.new(
      close_reason: "submit", label: "Submit", style: :filled, color: :primary
    )
  end

  def outlined_style
    render ::Decor::Suite::Modals::ModalCloseButton.new(
      close_reason: "cancel", label: "Cancel", style: :outlined
    )
  end

  def ghost_style
    render ::Decor::Suite::Modals::ModalCloseButton.new(
      close_reason: "close", label: "Close", style: :ghost
    )
  end
  # @endgroup

  # @group States
  def disabled_state
    render ::Decor::Suite::Modals::ModalCloseButton.new(
      close_reason: "save", label: "Save", disabled: true
    )
  end

  def full_width_state
    render ::Decor::Suite::Modals::ModalCloseButton.new(
      close_reason: "confirm", label: "Confirm", full_width: true
    )
  end
  # @endgroup
end
