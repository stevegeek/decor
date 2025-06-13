# @label NotificationManager
class ::Decor::NotificationManagerPreview < ::Lookbook::Preview
  # NotificationManager
  # -------
  #
  # The NotificationManager is a component which provides the mechanism and display area for
  # notifications or alerts that slide into view in the top right of the screen.
  #
  # In general we may render only 1 NotificationManager at a time & then reuse it at runtime
  # by adding notifications via the JS part of the component.
  #
  # ## Event API
  #
  # - `decor--notification-manager:show@window` - Show notification
  # - `decor--notification-manager:dismissAll@window` - Dismiss all notifications
  # - `decor--notification-manager:dismiss@window` - Dismiss single notification
  #
  # ## Event Detail Options
  #
  # - `content` - HTML content (must be marked safe)
  # - `contentHref` - URL for remote content
  # - `timeout` - Auto-dismiss timeout (default 3000ms, Infinity for persistent)

  # @label Interactive Playground
  # Interactive controls for testing different notification types and behaviors
  def playground
    render ::Decor::Card.new(title: "Notification Playground") do |p|
      p.div(class: "grid grid-cols-2 md:grid-cols-4 gap-4") do
        p.render ::Decor::Button.new(
          label: "Success",
          color: :primary,
          html_options: {onclick: playground_notification_js("success", "Operation completed successfully!", "Your changes have been saved.", 3000, "check")}
        )
        p.render ::Decor::Button.new(
          label: "Error",
          color: :danger,
          html_options: {onclick: playground_notification_js("error", "Something went wrong", "Please try again or contact support.", 5000, "x")}
        )
        p.render ::Decor::Button.new(
          label: "Warning",
          color: :warning,
          html_options: {onclick: playground_notification_js("warning", "Action required", "Please review your settings.", 4000)}
        )
        p.render ::Decor::Button.new(
          label: "Info",
          color: :secondary,
          html_options: {onclick: playground_notification_js("info", "New feature available", "Check out the latest updates.", 3000)}
        )
      end

      p.div(class: "grid grid-cols-2 md:grid-cols-4 gap-4") do
        p.render ::Decor::Button.new(
          label: "No Timeout",
          variant: :outlined,
          html_options: {onclick: playground_notification_js("info", "Persistent notification", "This will stay until dismissed.", "Infinity")}
        )
        p.render ::Decor::Button.new(
          label: "3 Seconds",
          variant: :outlined,
          html_options: {onclick: playground_notification_js("info", "Quick message", "Auto-dismisses in 3 seconds.", 3000)}
        )
        p.render ::Decor::Button.new(
          label: "5 Seconds",
          variant: :outlined,
          html_options: {onclick: playground_notification_js("info", "Standard timeout", "Auto-dismisses in 5 seconds.", 5000)}
        )
        p.render ::Decor::Button.new(
          label: "10 Seconds",
          variant: :outlined,
          html_options: {onclick: playground_notification_js("info", "Long message", "Auto-dismisses in 10 seconds.", 10000)}
        )
      end

      p.div(class: "flex gap-4 flex-wrap") do
        p.render ::Decor::Button.new(
          label: "Dismiss All",
          variant: :outlined,
          color: :danger,
          html_options: {onclick: playground_dismiss_all_js}
        )
        p.render ::Decor::Button.new(
          label: "Show Multiple",
          variant: :outlined,
          color: :primary,
          html_options: {onclick: playground_multiple_notifications_js}
        )
        p.render ::Decor::Button.new(
          label: "With Actions",
          variant: :outlined,
          color: :secondary,
          html_options: {onclick: playground_notification_with_actions_js}
        )
      end
    end
  end

  # @!group Basic Examples

  # @label Simple Notifications
  # Basic text notifications with different content
  def simple_notifications
    render ::Decor::Card.new(title: "Simple Notifications") do |p|
      p.p(class: "text-base-content/70 mb-4") { "Simple notifications with plain text content and default styling." }
      p.div(class: "flex gap-3 flex-wrap") do
        p.render ::Decor::Button.new(
          label: "Welcome Message",
          color: :primary,
          html_options: {onclick: simple_notification_js("Welcome!", "Thanks for joining our platform.")}
        )
        p.render ::Decor::Button.new(
          label: "Task Complete",
          color: :secondary,
          html_options: {onclick: simple_notification_js("Task Completed", "Your task has been finished successfully.")}
        )
        p.render ::Decor::Button.new(
          label: "Settings Saved",
          color: :neutral,
          html_options: {onclick: simple_notification_js("Settings Updated", "Your preferences have been saved.")}
        )
      end
    end
  end

  # @label Auto-dismiss Timing
  # Different auto-dismiss timeout behaviors
  def timeout_examples
    render ::Decor::Card.new(title: "Auto-dismiss Timing") do |p|
      p.p(class: "text-base-content/70 mb-4") { "Test different timeout durations to see how long notifications stay visible before auto-dismissing." }
      p.div(class: "grid grid-cols-2 md:grid-cols-4 gap-4") do
        p.div(class: "text-center") do
          p.p(class: "text-sm font-medium mb-2") { "Quick (3s)" }
          p.render ::Decor::Button.new(
            label: "3 Second Message",
            color: :secondary,
            size: :small,
            html_options: {onclick: timeout_notification_js("Quick Update", "This message disappears in 3 seconds.", 3000)}
          )
        end
        p.div(class: "text-center") do
          p.p(class: "text-sm font-medium mb-2") { "Standard (5s)" }
          p.render ::Decor::Button.new(
            label: "5 Second Message",
            color: :primary,
            size: :small,
            html_options: {onclick: timeout_notification_js("Standard Notice", "This message disappears in 5 seconds.", 5000)}
          )
        end
        p.div(class: "text-center") do
          p.p(class: "text-sm font-medium mb-2") { "Extended (10s)" }
          p.render ::Decor::Button.new(
            label: "10 Second Message",
            color: :warning,
            size: :small,
            html_options: {onclick: timeout_notification_js("Extended Notice", "This message disappears in 10 seconds.", 10000)}
          )
        end
        p.div(class: "text-center") do
          p.p(class: "text-sm font-medium mb-2") { "No Timeout" }
          p.render ::Decor::Button.new(
            label: "Persistent Message",
            color: :danger,
            size: :small,
            html_options: {onclick: timeout_notification_js("Persistent Alert", "This message stays until manually dismissed.", "Infinity")}
          )
        end
      end
    end
  end

  # @label Persistent Notifications
  # Notifications that don't auto-dismiss
  def persistent_notifications
    render ::Decor::Card.new(title: "Persistent Notifications") do |p|
      p.div(class: "space-y-3") do
        p.div(class: "flex gap-3 flex-wrap") do
          p.render ::Decor::Button.new(
            label: "Critical Alert",
            color: :danger,
            html_options: {onclick: persistent_notification_js("Critical System Alert", "Your account requires immediate attention. Please review your security settings.")}
          )
          p.render ::Decor::Button.new(
            label: "Confirm Action",
            color: :warning,
            html_options: {onclick: persistent_notification_js("Confirmation Required", "Are you sure you want to delete this item? This action cannot be undone.")}
          )
          p.render ::Decor::Button.new(
            label: "Important Update",
            color: :secondary,
            html_options: {onclick: persistent_notification_js("System Maintenance", "Scheduled maintenance will begin in 30 minutes. Please save your work.")}
          )
        end
        p.div(class: "divider") { "Management Controls" }
        p.div(class: "flex gap-3") do
          p.render ::Decor::Button.new(
            label: "Show Multiple Persistent",
            variant: :outlined,
            color: :primary,
            size: :small,
            html_options: {onclick: multiple_persistent_notifications_js}
          )
          p.render ::Decor::Button.new(
            label: "Dismiss All",
            variant: :outlined,
            color: :danger,
            size: :small,
            html_options: {onclick: playground_dismiss_all_js}
          )
        end
      end
    end
  end

  # @!endgroup

  # @!group Styled Notifications

  # @label Notification Colors
  # Styled notifications with icons
  def success_notifications
    render ::Decor::Card.new(title: "Success Notifications") do |p|
      p.p(class: "text-base-content/70 mb-4") { "Positive feedback messages for completed actions and successful operations." }
      p.div(class: "grid grid-cols-1 md:grid-cols-2 gap-4") do
        p.render ::Decor::Button.new(
          label: "Profile Updated",
          color: :primary,
          size: :small,
          html_options: {onclick: styled_notification_js("success", "Profile Updated Successfully", "Your profile information has been saved and updated.")}
        )
        p.render ::Decor::Button.new(
          label: "Payment Processed",
          color: :danger,
          size: :small,
          html_options: {onclick: styled_notification_js("success", "Payment Processed", "Your payment of $49.99 has been successfully processed.")}
        )
        p.render ::Decor::Button.new(
          label: "File Uploaded",
          color: :warning,
          size: :small,
          html_options: {onclick: styled_notification_js("success", "File Upload Complete", "document.pdf has been uploaded successfully.")}
        )
        p.render ::Decor::Button.new(
          label: "Account Created",
          color: :secondary,
          size: :small,
          html_options: {onclick: styled_notification_js("success", "Account Created", "Welcome! Your account has been successfully created.")}
        )
      end
    end
  end

  # @!endgroup

  # @!group Advanced Features

  # @label Action Buttons
  # Notifications with interactive buttons
  def action_buttons
    render ::Decor::Card.new(title: "Interactive Action Buttons") do |p|
      p.p(class: "text-base-content/70 mb-4") { "Notifications with actionable buttons that allow users to take immediate action without leaving the current page." }
      p.div(class: "space-y-3") do
        p.div(class: "grid grid-cols-1 md:grid-cols-2 gap-4") do
          p.render ::Decor::Button.new(
            label: "Undo Delete",
            color: :warning,
            size: :small,
            html_options: {onclick: action_notification_js("File Deleted", "document.pdf has been moved to trash.", "Undo", "View Trash")}
          )
          p.render ::Decor::Button.new(
            label: "Confirm Action",
            color: :danger,
            size: :small,
            html_options: {onclick: action_notification_js("Delete Confirmation", "Are you sure you want to permanently delete this item?", "Delete", "Cancel")}
          )
          p.render ::Decor::Button.new(
            label: "Retry Failed",
            color: :secondary,
            size: :small,
            html_options: {onclick: action_notification_js("Upload Failed", "Connection timed out while uploading your file.", "Retry", "Cancel")}
          )
          p.render ::Decor::Button.new(
            label: "View Details",
            color: :primary,
            size: :small,
            html_options: {onclick: action_notification_js("Payment Successful", "Your payment of $49.99 has been processed.", "View Receipt", "Download PDF")}
          )
        end
        p.div(class: "divider") { "Single Action Examples" }
        p.div(class: "flex gap-3 flex-wrap") do
          p.render ::Decor::Button.new(
            label: "Single Action",
            variant: :outlined,
            color: :primary,
            size: :small,
            html_options: {onclick: single_action_notification_js("Update Available", "A new version of the app is ready to install.", "Update Now")}
          )
          p.render ::Decor::Button.new(
            label: "Call to Action",
            variant: :outlined,
            color: :neutral,
            size: :small,
            html_options: {onclick: single_action_notification_js("Welcome Bonus", "Complete your profile to receive 100 bonus points!", "Complete Profile")}
          )
        end
      end
    end
  end

  private

  def render_to_string(component)
    ApplicationController.render(
      component,
      layout: false
    )
  end

  def styled_notification_content(style, title, description, icon = nil)
    render_to_string ::Decor::Notification.new(
      title: title,
      description: description,
      icon: icon,
      style: style.to_sym
    )
  end

  def notification_with_actions(title, description, primary_label, secondary_label = nil)
    actions = [::Decor::Notification::ActionButton.new(label: primary_label, primary: true)]
    actions << ::Decor::Notification::ActionButton.new(label: secondary_label) if secondary_label

    render_to_string ::Decor::Notification.new(
      title: title,
      description: description,
      action_buttons: actions
    )
  end

  def playground_notification_js(style, title, description, timeout, icon = nil)
    content = styled_notification_content(style, title, description, icon)
    # Handle Infinity timeout properly in JavaScript - no quotes around Infinity
    timeout_value = (timeout == "Infinity") ? "Infinity" : timeout.to_i

    <<~JS.html_safe
      const evt = new CustomEvent("decor--notification-manager:show", {
        bubbles: true,
        cancelable: false,
        detail: { 
          __safe: true,
          content: #{content.to_json},
          timeout: #{timeout_value}
        }
      });
      window.dispatchEvent(evt);
    JS
  end

  def playground_dismiss_all_js
    <<~JS.html_safe
      const evt = new CustomEvent("decor--notification-manager:dismissAll", {
        bubbles: true,
        cancelable: false
      });
      window.dispatchEvent(evt);
    JS
  end

  def playground_multiple_notifications_js
    <<~JS.html_safe
      const notifications = [
        { style: "success", title: "First notification", description: "This is the first message" },
        { style: "info", title: "Second notification", description: "This is the second message" },
        { style: "warning", title: "Third notification", description: "This is the third message" }
      ];
      
      notifications.forEach((notif, index) => {
        setTimeout(() => {
          const content = `#{styled_notification_content("success", "Notification", "Multiple notification test").gsub('"', '\\"')}`;
          const evt = new CustomEvent("decor--notification-manager:show", {
            bubbles: true,
            cancelable: false,
            detail: { 
              __safe: true,
              content: content.replace("Notification", notif.title).replace("Multiple notification test", notif.description),
              timeout: 5000
            }
          });
          window.dispatchEvent(evt);
        }, index * 500);
      });
    JS
  end

  def playground_notification_with_actions_js
    content = notification_with_actions("Confirm action", "Are you sure you want to proceed?", "Confirm", "Cancel")
    detail = {__safe: true, content: content, timeout: "Infinity"}

    <<~JS.html_safe
      const evt = new CustomEvent("decor--notification-manager:show", {
        bubbles: true,
        cancelable: false,
        detail: #{detail.to_json}
      });
      window.dispatchEvent(evt);
    JS
  end

  def simple_notification_js(title, description)
    detail = {__safe: true, content: "<div class='alert'><div><h4>#{title}</h4><p>#{description}</p></div></div>", timeout: 3000}

    <<~JS.html_safe
      const evt = new CustomEvent("decor--notification-manager:show", {
        bubbles: true,
        cancelable: false,
        detail: #{detail.to_json}
      });
      window.dispatchEvent(evt);
    JS
  end

  def timeout_notification_js(title, description, timeout)
    # Handle Infinity timeout properly in JavaScript - no quotes around Infinity
    timeout_value = (timeout == "Infinity") ? "Infinity" : timeout.to_i
    content = "<div class='alert alert-info'><div><h4>#{title}</h4><p>#{description}</p></div></div>"

    <<~JS.html_safe
      const evt = new CustomEvent("decor--notification-manager:show", {
        bubbles: true,
        cancelable: false,
        detail: { 
          __safe: true, 
          content: #{content.to_json}, 
          timeout: #{timeout_value} 
        }
      });
      window.dispatchEvent(evt);
    JS
  end

  def persistent_notification_js(title, description)
    content = "<div class='alert alert-warning'><div><h4>#{title}</h4><p>#{description}</p></div></div>"

    <<~JS.html_safe
      const evt = new CustomEvent("decor--notification-manager:show", {
        bubbles: true,
        cancelable: false,
        detail: { 
          __safe: true, 
          content: #{content.to_json}, 
          timeout: Infinity 
        }
      });
      window.dispatchEvent(evt);
    JS
  end

  def multiple_persistent_notifications_js
    <<~JS.html_safe
      const notifications = [
        { title: "Security Warning", description: "Multiple failed login attempts detected on your account." },
        { title: "Payment Required", description: "Your subscription will expire in 3 days. Please update payment method." },
        { title: "Data Backup", description: "Click here to backup your important data before the system update." }
      ];
      
      notifications.forEach((notif, index) => {
        setTimeout(() => {
          const evt = new CustomEvent("decor--notification-manager:show", {
            bubbles: true,
            cancelable: false,
            detail: { 
              __safe: true, 
              content: `<div class='alert alert-error'><div><h4>${notif.title}</h4><p>${notif.description}</p></div></div>`,
              timeout: Infinity
            }
          });
          window.dispatchEvent(evt);
        }, index * 300);
      });
    JS
  end

  def styled_notification_js(style, title, description)
    content = styled_notification_content(style, title, description)
    detail = {__safe: true, content: content, timeout: 4000}

    <<~JS.html_safe
      const evt = new CustomEvent("decor--notification-manager:show", {
        bubbles: true,
        cancelable: false,
        detail: #{detail.to_json}
      });
      window.dispatchEvent(evt);
    JS
  end

  def action_notification_js(title, description, primary_action, secondary_action)
    content = notification_with_actions(title, description, primary_action, secondary_action)

    <<~JS.html_safe
      const evt = new CustomEvent("decor--notification-manager:show", {
        bubbles: true,
        cancelable: false,
        detail: { 
          __safe: true, 
          content: #{content.to_json}, 
          timeout: Infinity 
        }
      });
      window.dispatchEvent(evt);
    JS
  end

  def single_action_notification_js(title, description, action_label)
    content = notification_with_actions(title, description, action_label)

    <<~JS.html_safe
      const evt = new CustomEvent("decor--notification-manager:show", {
        bubbles: true,
        cancelable: false,
        detail: { 
          __safe: true, 
          content: #{content.to_json}, 
          timeout: Infinity 
        }
      });
      window.dispatchEvent(evt);
    JS
  end
end
