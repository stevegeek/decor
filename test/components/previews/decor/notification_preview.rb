# @label Notification
class ::Decor::NotificationPreview < ::Lookbook::Preview
  # Notification
  # -------
  #
  # A notification component styled like daisyUI inline alerts with join layout.
  # Supports different styles, icons, avatars, titles, descriptions, and action buttons.
  #
  # @group Examples
  # @label Account Created
  def example_account_created
    render ::Decor::Notification.new(
      title: "Welcome!",
      description: "Your account has been successfully created.",
      icon: "check-circle",
      color: :success,
      action_buttons: [
        ::Decor::Notification::ActionButton.new(
          label: "Get Started",
          href: "#",
          primary: true
        )
      ]
    )
  end

  # @group Examples
  # @label Payment Failed
  def example_payment_failed
    render ::Decor::Notification.new(
      title: "Payment Failed",
      description: "We couldn't process your payment. Please update your payment method.",
      icon: "x-circle",
      color: :error,
      action_buttons: [
        ::Decor::Notification::ActionButton.new(
          label: "Update Payment",
          href: "#",
          color: :error,
          primary: true
        ),
        ::Decor::Notification::ActionButton.new(
          label: "Try Again",
          action_name: "retry"
        )
      ]
    )
  end

  # @group Examples
  # @label New Message
  def example_new_message
    render ::Decor::Notification.new(
      title: "New Message",
      description: "You received a message from Sarah Johnson.",
      color: :info,
      action_buttons: [
        ::Decor::Notification::ActionButton.new(
          label: "Reply",
          href: "#",
          primary: true
        )
      ]
    ) do |notification|
      notification.avatar do
        render ::Decor::Avatar.new(
          initials: "SJ",
          size: :sm
        )
      end
    end
  end

  # @group Examples
  # @label System Maintenance
  def example_maintenance
    render ::Decor::Notification.new(
      title: "Scheduled Maintenance",
      description: "The system will be down for maintenance on Sunday at 2 AM.",
      icon: "exclamation-triangle",
      color: :warning
    )
  end

  # @group Examples
  # @label File Upload Success
  def example_upload_success
    render ::Decor::Notification.new(
      title: "Upload Complete",
      description: "Your file 'document.pdf' has been uploaded successfully.",
      icon: "check-circle",
      color: :success,
      action_buttons: [
        ::Decor::Notification::ActionButton.new(
          label: "View File",
          href: "#",
          color: :primary,
          primary: true
        )
      ]
    )
  end

  # @group Playground
  # @param title text
  # @param description text
  # @param icon select [~, check-circle, x-circle, exclamation-triangle, information-circle, bell]
  # @param has_avatar toggle
  # @param has_action_buttons toggle
  # @param size [Symbol] select [~, xs, sm, md, lg, xl]
  # @param color [Symbol] select [~, base, primary, secondary, accent, neutral, success, error, warning, info]
  # @param style [Symbol] select [~, filled, outlined, ghost]
  def playground(title: "Notification Title", description: "This is a sample notification message.", icon: "information-circle", has_avatar: false, has_action_buttons: false, size: nil, color: nil, style: nil)
    render ::Decor::Notification.new(
      title: title,
      description: description,
      icon: icon,
      size: size,
      color: color,
      style: style,
      **(has_action_buttons ? {action_buttons: [
        ::Decor::Notification::ActionButton.new(
          label: "Action",
          href: "#",
          primary: true
        ),
        ::Decor::Notification::ActionButton.new(
          label: "Dismiss",
          action_name: "dismiss"
        )
      ]} : {})
    ) do |notification|
      if has_avatar
        notification.avatar do
          render ::Decor::Avatar.new(
            initials: "UN",
            size: :sm
          )
        end
      end
    end
  end

  # @group Colors
  # @label Info Style
  def style_info
    render ::Decor::Notification.new(
      title: "Information",
      description: "Here's some helpful information for you.",
      icon: "information-circle",
      color: :info
    )
  end

  # @group Colors
  # @label Success Style
  def style_success
    render ::Decor::Notification.new(
      title: "Success!",
      description: "Your account has been created successfully.",
      icon: "check-circle",
      color: :success
    )
  end

  # @group Colors
  # @label Warning Style
  def style_warning
    render ::Decor::Notification.new(
      title: "Warning",
      description: "Please verify your email address.",
      icon: "exclamation-triangle",
      color: :warning
    )
  end

  # @group Colors
  # @label Error Style
  def style_error
    render ::Decor::Notification.new(
      title: "Error",
      description: "Something went wrong. Please try again.",
      icon: "x-circle",
      color: :error
    )
  end

  # @group Content Variations
  # @label Title Only
  def content_title_only
    render ::Decor::Notification.new(
      title: "Simple notification",
      description: "",
      icon: "bell",
      color: :info
    )
  end

  # @group Content Variations
  # @label Description Only
  def content_description_only
    render ::Decor::Notification.new(
      title: "",
      description: "Just a simple message without a title.",
      icon: "information-circle",
      color: :info
    )
  end

  # @group Content Variations
  # @label No Icon
  def content_no_icon
    render ::Decor::Notification.new(
      title: "No Icon Notification",
      description: "This notification doesn't have an icon.",
      color: :info
    )
  end

  # @group With Avatar
  # @label Avatar with Initials
  def avatar_initials
    render ::Decor::Notification.new(
      title: "New Message",
      description: "You have a message from John Doe.",
      color: :info
    ) do |notification|
      notification.avatar do
        render ::Decor::Avatar.new(
          initials: "JD",
          size: :sm
        )
      end
    end
  end

  # @group With Avatar
  # @label Avatar with Image
  def avatar_image
    render ::Decor::Notification.new(
      title: "Profile Updated",
      description: "Your profile picture has been updated.",
      color: :success
    ) do |notification|
      notification.avatar do
        render ::Decor::Avatar.new(
          url: "https://i.pravatar.cc/150",
          size: :sm
        )
      end
    end
  end

  # @group With Actions
  # @label Single Action
  def actions_single
    render ::Decor::Notification.new(
      title: "Confirm Action",
      description: "Please confirm this important action.",
      icon: "exclamation-triangle",
      color: :warning,
      action_buttons: [
        ::Decor::Notification::ActionButton.new(
          label: "Confirm",
          href: "#",
          primary: true
        )
      ]
    )
  end

  # @group With Actions
  # @label Multiple Actions
  def actions_multiple
    render ::Decor::Notification.new(
      title: "Save Changes?",
      description: "You have unsaved changes.",
      icon: "exclamation-triangle",
      color: :warning,
      action_buttons: [
        ::Decor::Notification::ActionButton.new(
          label: "Save",
          href: "#",
          primary: true
        ),
        ::Decor::Notification::ActionButton.new(
          label: "Discard",
          action_name: "discard"
        )
      ]
    )
  end

  # @group With Actions
  # @label Custom Button Colors and Variants
  def actions_custom_styling
    render ::Decor::Notification.new(
      title: "Custom Action Buttons",
      description: "Demonstration of custom colors and variants for action buttons.",
      icon: "information-circle",
      color: :info,
      action_buttons: [
        ::Decor::Notification::ActionButton.new(
          label: "Primary",
          href: "#",
          color: :primary,
          style: :filled
        ),
        ::Decor::Notification::ActionButton.new(
          label: "Outlined",
          href: "#",
          color: :secondary,
          style: :outlined
        ),
        ::Decor::Notification::ActionButton.new(
          label: "Text",
          action_name: "text_action",
          color: :neutral,
          style: :ghost
        )
      ]
    )
  end

  # @group With Actions
  # @label Danger Actions
  def actions_danger
    render ::Decor::Notification.new(
      title: "Delete Account",
      description: "This action cannot be undone.",
      icon: "exclamation-triangle",
      color: :error,
      action_buttons: [
        ::Decor::Notification::ActionButton.new(
          label: "Delete",
          href: "#",
          color: :error,
          style: :filled
        ),
        ::Decor::Notification::ActionButton.new(
          label: "Cancel",
          action_name: "cancel",
          color: :neutral,
          style: :outlined
        )
      ]
    )
  end
end
