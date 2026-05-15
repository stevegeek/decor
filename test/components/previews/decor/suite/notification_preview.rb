# @label Notification
class ::Decor::Suite::NotificationPreview < ::Lookbook::Preview
  # @group Examples
  # @label Saved (success, with progress)
  def example_saved
    render ::Decor::Suite::Notification.new(
      color: :success,
      title: "Saved",
      body: "Your changes have been saved.",
      show_progress: true
    )
  end

  # @group Examples
  # @label Error (sticky, with retry)
  def example_error
    render ::Decor::Suite::Notification.new(
      color: :error,
      title: "Something went wrong",
      body: "We couldn't save your changes.",
      sticky: true,
      actions: [
        {text: "Retry", style: :primary, event_name: "retry-save"},
        {text: "Dismiss", style: :ghost, event_name: "dismiss"}
      ]
    )
  end

  # @group Examples
  # @label With destination link
  def example_with_destination
    render ::Decor::Suite::Notification.new(
      color: :info,
      title: "Item added",
      body: "Added to your cart.",
      destination: {text: "View cart", href: "#"},
      show_progress: true
    )
  end

  # @group Examples
  # @label Warning
  def example_warning
    render ::Decor::Suite::Notification.new(
      color: :warning,
      title: "Heads up",
      body: "Your session expires in 5 minutes."
    )
  end

  # @group Examples
  # @label Neutral
  def example_neutral
    render ::Decor::Suite::Notification.new(
      title: "Notice",
      body: "A neutral message."
    )
  end

  # @group States
  # @label Title only
  def state_title_only
    render ::Decor::Suite::Notification.new(color: :success, title: "All done")
  end

  # @group States
  # @label Body only
  def state_body_only
    render ::Decor::Suite::Notification.new(color: :info, body: "Quiet status message.")
  end

  # @group States
  # @label Actions only
  def state_actions_only
    render ::Decor::Suite::Notification.new(
      color: :warning,
      actions: [
        {text: "Confirm", style: :primary},
        {text: "Cancel", style: :ghost}
      ]
    )
  end

  # @group Playground
  # @param title text
  # @param body text
  # @param color [Symbol] select [~, neutral, success, error, warning, info]
  # @param show_progress toggle
  # @param sticky toggle
  def playground(title: "Saved", body: "Your changes have been saved.", color: :success, show_progress: true, sticky: false)
    render ::Decor::Suite::Notification.new(
      title: title,
      body: body,
      color: color,
      show_progress: show_progress,
      sticky: sticky
    )
  end
end
