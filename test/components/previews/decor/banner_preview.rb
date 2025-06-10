# @label Banner
class ::Decor::BannerPreview < ::ViewComponent::Preview
  # Banner
  # -------
  #
  # A banner is a large alert component that is used to display important messages to the user.
  # Supports different styles, icons, links, and layout options using daisyUI alert styling.
  #
  # @label Playground
  # @param body text
  # @param centered toggle
  # @param icon select [~, check-circle, x, check, download, play]
  # @param link select [~, "https://example.com"]
  # @param style select [warning, info, error, notice, success]
  def playground(body: "Hi!", centered: false, icon: nil, link: nil, style: :notice)
    render ::Decor::Banner.new(link: link, centered: centered, icon: icon, style: style) do
      body
    end
  end

  # @group Styles
  # @label Notice Style
  def style_notice
    render ::Decor::Banner.new(style: :notice) do
      "This is a notice banner with important information."
    end
  end

  # @group Styles
  # @label Success Style
  def style_success
    render ::Decor::Banner.new(style: :success) do
      "Your action was completed successfully!"
    end
  end

  # @group Styles
  # @label Warning Style
  def style_warning
    render ::Decor::Banner.new(style: :warning) do
      "Please be aware of this important warning."
    end
  end

  # @group Styles
  # @label Error Style
  def style_error
    render ::Decor::Banner.new(style: :error) do
      "An error occurred while processing your request."
    end
  end

  # @group Styles
  # @label Info Style
  def style_info
    render ::Decor::Banner.new(style: :info) do
      "Here's some helpful information for you."
    end
  end

  # @group With Icons
  # @label Success with Check Icon
  def icon_success_check
    render ::Decor::Banner.new(style: :success, icon: "check-circle") do
      "Your changes have been saved successfully!"
    end
  end

  # @group With Icons
  # @label Warning with Alert Icon
  def icon_warning_alert
    render ::Decor::Banner.new(style: :warning, icon: "exclamation-triangle") do
      "Your session will expire in 5 minutes."
    end
  end

  # @group With Icons
  # @label Error with X Icon
  def icon_error_x
    render ::Decor::Banner.new(style: :error, icon: "x") do
      "Failed to upload file. Please try again."
    end
  end

  # @group With Icons
  # @label Info with Information Icon
  def icon_info_information
    render ::Decor::Banner.new(style: :info, icon: "information-circle") do
      "Did you know you can customize your dashboard?"
    end
  end

  # @group With Icons
  # @label Notice with Bell Icon
  def icon_notice_bell
    render ::Decor::Banner.new(style: :notice, icon: "bell") do
      "You have 3 new notifications."
    end
  end

  # @group Layout
  # @label Left Aligned (Default)
  def layout_left_aligned
    render ::Decor::Banner.new(style: :info, centered: false) do
      "This banner content is aligned to the left side."
    end
  end

  # @group Layout
  # @label Centered
  def layout_centered
    render ::Decor::Banner.new(style: :info, centered: true) do
      "This banner content is centered."
    end
  end

  # @group Layout
  # @label Centered with Icon
  def layout_centered_icon
    render ::Decor::Banner.new(style: :success, centered: true, icon: "check-circle") do
      "Centered banner with icon."
    end
  end

  # @group With Links
  # @label Basic Link
  def link_basic
    render ::Decor::Banner.new(style: :info, link: "https://example.com") do
      "Check out our new features and improvements."
    end
  end

  # @group With Links
  # @label Success with Link
  def link_success
    render ::Decor::Banner.new(style: :success, link: "/settings", icon: "check-circle") do
      "Account verified! Configure your preferences."
    end
  end

  # @group With Links
  # @label Warning with Link
  def link_warning
    render ::Decor::Banner.new(style: :warning, link: "/billing", icon: "exclamation-triangle") do
      "Your payment method expires soon."
    end
  end

  # @group With Links
  # @label Error with Link
  def link_error
    render ::Decor::Banner.new(style: :error, link: "/help", icon: "x") do
      "Something went wrong. Get help."
    end
  end

  # @group With Action Slot
  # @label Custom Action Button
  def action_slot_custom
    render ::Decor::Banner.new(style: :warning) do |banner|
      banner.call_to_action do
        banner.render ::Decor::Button.new(label: "Update Now", theme: :warning, size: :small)
      end
      "A new version is available."
    end
  end

  # @group With Action Slot
  # @label Multiple Actions
  def action_slot_multiple
    render ::Decor::Banner.new(style: :info) do |banner|
      banner.call_to_action do
        banner.content_tag(:div, class: "flex gap-2") do
          banner.render ::Decor::Button.new(label: "Accept", theme: :primary, size: :small)
          banner.render ::Decor::Button.new(label: "Decline", variant: :outlined, size: :small)
        end
      end
      "Accept our updated terms of service."
    end
  end

  # @group Combinations
  # @label Success Centered with Icon and Link
  def combo_success_centered_icon_link
    render ::Decor::Banner.new(
      style: :success,
      centered: true,
      icon: "check-circle",
      link: "/dashboard"
    ) do
      "Welcome! Your account setup is complete."
    end
  end

  # @group Combinations
  # @label Warning Left with Icon and Action
  def combo_warning_left_icon_action
    render ::Decor::Banner.new(style: :warning, icon: "exclamation-triangle") do |banner|
      banner.call_to_action do
        render ::Decor::Button.new(label: "Dismiss", variant: :text, size: :small)
      end
      "Please verify your email address to continue."
    end
  end

  # @group Use Cases
  # @label Site Maintenance Notice
  def usecase_maintenance
    render ::Decor::Banner.new(style: :warning, icon: "wrench", centered: true) do
      "Scheduled maintenance will occur tonight from 2-4 AM EST."
    end
  end

  # @group Use Cases
  # @label Cookie Consent
  def usecase_cookie_consent
    render ::Decor::Banner.new(style: :info, link: "/privacy") do |banner|
      banner.call_to_action do
        render ::Decor::Button.new(label: "Accept", theme: :primary, size: :small)
      end
      "We use cookies to improve your experience."
    end
  end

  # @group Use Cases
  # @label Feature Announcement
  def usecase_feature_announcement
    render ::Decor::Banner.new(style: :success, icon: "star", link: "/features") do
      "🎉 New features are now available! Check them out."
    end
  end

  # @group Use Cases
  # @label Account Verification
  def usecase_account_verification
    render ::Decor::Banner.new(style: :warning, icon: "exclamation-triangle", link: "/verify") do
      "Please verify your email address to access all features."
    end
  end

  # @group Use Cases
  # @label System Error
  def usecase_system_error
    render ::Decor::Banner.new(style: :error, icon: "x", link: "/support") do
      "We're experiencing technical difficulties. Contact support if issues persist."
    end
  end
end
