# @label Notification
class ::Decor::NotificationPreview < ::Lookbook::Preview
  # Notification
  # -------
  #
  # A notification component styled like daisyUI inline alerts with join layout.
  # Supports different styles, icons, avatars, titles, descriptions, and action buttons.
  #
  # @label Playground
  # @param title text
  # @param description text
  # @param icon select [~, check-circle, x-circle, exclamation-triangle, information-circle, bell]
  # @param style select [info, success, warning, error]
  # @param has_avatar toggle
  # @param has_action_buttons toggle
  def playground(title: "Notification Title", description: "This is a sample notification message.", icon: "information-circle", style: :info, has_avatar: false, has_action_buttons: false)
    render ::Decor::Notification.new(
      title: title,
      description: description,
      icon: icon,
      style: style,
      **(has_action_buttons ? {action_buttons: [
        {
          label: "Action",
          href: "#",
          primary: true
        },
        {
          label: "Dismiss",
          action_name: "dismiss"
        }
      ]} : {})
    ) do |notification|
      if has_avatar
        notification.avatar do
          render ::Decor::Avatar.new(
            initials: "UN",
            size: :small
          )
        end
      end
    end
  end

  # @group Styles
  # @label Info Style
  def style_info
    render ::Decor::Notification.new(
      title: "Information",
      description: "Here's some helpful information for you.",
      icon: "information-circle",
      style: :info
    )
  end

  # @group Styles
  # @label Success Style
  def style_success
    render ::Decor::Notification.new(
      title: "Success!",
      description: "Your account has been created successfully.",
      icon: "check-circle",
      style: :success
    )
  end

  # @group Styles
  # @label Warning Style
  def style_warning
    render ::Decor::Notification.new(
      title: "Warning",
      description: "Please verify your email address.",
      icon: "exclamation-triangle",
      style: :warning
    )
  end

  # @group Styles
  # @label Error Style
  def style_error
    render ::Decor::Notification.new(
      title: "Error",
      description: "Something went wrong. Please try again.",
      icon: "x-circle",
      style: :error
    )
  end

  # @group Content Variations
  # @label Title Only
  def content_title_only
    render ::Decor::Notification.new(
      title: "Simple notification",
      icon: "bell",
      style: :info
    )
  end

  # @group Content Variations
  # @label Description Only
  def content_description_only
    render ::Decor::Notification.new(
      description: "Just a simple message without a title.",
      icon: "information-circle",
      style: :info
    )
  end

  # @group Content Variations
  # @label No Icon
  def content_no_icon
    render ::Decor::Notification.new(
      title: "No Icon Notification",
      description: "This notification doesn't have an icon.",
      style: :info
    )
  end

  # @group With Avatar
  # @label Avatar with Initials
  def avatar_initials
    render ::Decor::Notification.new(
      title: "New Message",
      description: "You have a message from John Doe.",
      style: :info
    ) do |notification|
      notification.avatar do
        render ::Decor::Avatar.new(
          initials: "JD",
          size: :small
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
      style: :success
    ) do |notification|
      notification.avatar do
        render ::Decor::Avatar.new(
          url: "https://i.pravatar.cc/150",
          size: :small
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
      style: :warning,
      action_buttons: [
        {
          label: "Confirm",
          href: "#",
          primary: true
        }
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
      style: :warning,
      action_buttons: [
        {
          label: "Save",
          href: "#",
          primary: true
        },
        {
          label: "Discard",
          action_name: "discard"
        }
      ]
    )
  end

  # @group Real-world Examples
  # @label Account Created
  def example_account_created
    render ::Decor::Notification.new(
      title: "Welcome!",
      description: "Your account has been successfully created.",
      icon: "check-circle",
      style: :success,
      action_buttons: [
        {
          label: "Get Started",
          href: "#",
          primary: true
        }
      ]
    )
  end

  # @group Real-world Examples
  # @label Payment Failed
  def example_payment_failed
    render ::Decor::Notification.new(
      title: "Payment Failed",
      description: "We couldn't process your payment. Please update your payment method.",
      icon: "x-circle",
      style: :error,
      action_buttons: [
        {
          label: "Update Payment",
          href: "#",
          primary: true
        },
        {
          label: "Try Again",
          action_name: "retry"
        }
      ]
    )
  end

  # @group Real-world Examples
  # @label New Message
  def example_new_message
    render ::Decor::Notification.new(
      title: "New Message",
      description: "You received a message from Sarah Johnson.",
      style: :info,
      action_buttons: [
        {
          label: "Reply",
          href: "#",
          primary: true
        }
      ]
    ) do |notification|
      notification.avatar do
        render ::Decor::Avatar.new(
          initials: "SJ",
          size: :small
        )
      end
    end
  end

  # @group Real-world Examples
  # @label System Maintenance
  def example_maintenance
    render ::Decor::Notification.new(
      title: "Scheduled Maintenance",
      description: "The system will be down for maintenance on Sunday at 2 AM.",
      icon: "exclamation-triangle",
      style: :warning
    )
  end

  # @group Real-world Examples
  # @label File Upload Success
  def example_upload_success
    render ::Decor::Notification.new(
      title: "Upload Complete",
      description: "Your file 'document.pdf' has been uploaded successfully.",
      icon: "check-circle",
      style: :success,
      action_buttons: [
        {
          label: "View File",
          href: "#",
          primary: true
        }
      ]
    )
  end
end
