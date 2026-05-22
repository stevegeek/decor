# @label Alert
class ::Decor::Suite::Modals::AlertPreview < ::Lookbook::Preview
  # Thin wrapper around Modal for simple alert dialogs — a title, a message,
  # severity-colored chrome, and a single dismissal button in the footer.
  # Optionally dispatches a custom DOM event when dismissed (via
  # `dismiss_event`) so listeners can react to acknowledgement.

  # @group Examples
  # @label Default (info, start open)
  def default
    render ::Decor::Suite::Modals::Alert.new(
      title: "Heads up",
      message: "An informational notice the user can acknowledge.",
      start_open: true
    )
  end

  # @label Variant: success
  def variant_success
    render ::Decor::Suite::Modals::Alert.new(
      title: "All done",
      message: "Your changes were saved.",
      variant: :success,
      start_open: true
    )
  end

  # @label Variant: warning
  def variant_warning
    render ::Decor::Suite::Modals::Alert.new(
      title: "Heads up",
      message: "This will affect downstream consumers.",
      variant: :warning,
      start_open: true
    )
  end

  # @label Variant: danger
  def variant_danger
    render ::Decor::Suite::Modals::Alert.new(
      title: "Couldn't save",
      message: "Please try again.",
      variant: :danger,
      button_label: "OK",
      start_open: true
    )
  end

  # @label With Dismiss Event
  def with_dismiss_event
    render ::Decor::Suite::Modals::Alert.new(
      title: "Saved",
      message: "Listeners on the window can react to the dismiss event.",
      variant: :success,
      dismiss_event: "order-saved-acknowledged",
      start_open: true
    )
  end

  # @label Custom button label
  def custom_button_label
    render ::Decor::Suite::Modals::Alert.new(
      title: "Almost there",
      message: "Pick a label that matches the action being acknowledged.",
      button_label: "Got it",
      start_open: true
    )
  end
  # @endgroup

  # @group Playground
  # @param title text
  # @param message text
  # @param variant select [neutral, info, success, warning, danger, destructive]
  # @param button_label text
  # @param dismiss_event text
  # @param start_open toggle
  def playground(
    title: "Heads up",
    message: "An informational notice the user can acknowledge.",
    variant: :info,
    button_label: "OK",
    dismiss_event: nil,
    start_open: true
  )
    render ::Decor::Suite::Modals::Alert.new(
      title: title,
      message: message,
      variant: variant,
      button_label: button_label,
      dismiss_event: dismiss_event.presence,
      start_open: start_open
    )
  end
  # @endgroup
end
