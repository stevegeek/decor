# @label Confirm
class ::Decor::Suite::Modals::ConfirmPreview < ::Lookbook::Preview
  # A Suite Modal pre-wired with a Cancel/Confirm button pair for the
  # canonical "are you sure?" dialog pattern. On confirm-click an optional
  # named CustomEvent is dispatched to `window` so listeners can react to
  # the user's intent; the modal then closes via the standard Suite Modal
  # close event protocol.

  # @group Examples
  # @label Default (info)
  def default
    render ::Decor::Suite::Modals::Confirm.new(
      title: "Continue?",
      message: "This will save your changes and continue to the next step.",
      start_open: true
    )
  end

  # @label Success variant
  def success
    render ::Decor::Suite::Modals::Confirm.new(
      title: "Mark as complete?",
      message: "The item will be moved to the completed list.",
      variant: :success,
      confirm_label: "Complete",
      start_open: true
    )
  end

  # @label Warning variant
  def warning
    render ::Decor::Suite::Modals::Confirm.new(
      title: "Discard changes?",
      message: "Your unsaved edits will be lost.",
      variant: :warning,
      confirm_label: "Discard",
      start_open: true
    )
  end

  # @label Destructive (delete)
  def destructive
    render ::Decor::Suite::Modals::Confirm.new(
      title: "Delete order?",
      message: "This can't be undone.",
      variant: :destructive,
      confirm_label: "Delete",
      confirm_event: "delete-order",
      start_open: true
    )
  end

  # @label Custom labels
  def custom_labels
    render ::Decor::Suite::Modals::Confirm.new(
      title: "Send proposal?",
      message: "The buyer will be notified by email immediately.",
      variant: :info,
      confirm_label: "Send now",
      cancel_label: "Not yet",
      start_open: true
    )
  end
  # @endgroup

  # @group Playground
  # @param title text
  # @param message text
  # @param variant [Symbol] select [neutral, info, success, warning, danger, destructive]
  # @param confirm_label text
  # @param cancel_label text
  # @param confirm_event text
  # @param start_open toggle
  # @param closeable toggle
  def playground(
    title: "Continue?",
    message: "This will perform the action.",
    variant: :info,
    confirm_label: "Confirm",
    cancel_label: "Cancel",
    confirm_event: "",
    start_open: true,
    closeable: true
  )
    render ::Decor::Suite::Modals::Confirm.new(
      title: title,
      message: message,
      variant: variant,
      confirm_label: confirm_label,
      cancel_label: cancel_label,
      confirm_event: confirm_event.presence,
      start_open: start_open,
      closeable: closeable
    )
  end
  # @endgroup
end
