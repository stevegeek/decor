# @label SwitchingBox
class ::Decor::SwitchingBoxPreview < ::Lookbook::Preview
  # SwitchingBox
  # -------
  #
  # A switching box is a Box which shows content and contains a form and switch
  # rendered on the right which submits on change. Used for switching things on and off
  # outside of a form. Perfect for feature toggles, settings, and preferences.
  #
  # @group Examples
  # @label Basic Switching Box
  def basic_switching_box
    render ::Decor::SwitchingBox.new(
      title: "Enable Notifications",
      description: "Receive email alerts for important updates",
      property_name: :notifications,
      model: create_model(:notifications, true),
      url: "/settings/notifications"
    )
  end

  # @group Examples
  # @label With Additional Content
  def with_additional_content
    render ::Decor::SwitchingBox.new(
      title: "Two-Factor Authentication",
      description: "Add an extra layer of security to your account",
      property_name: :two_factor,
      model: create_model(:two_factor, false),
      url: "/settings/security"
    ) do |box|
      box.left do
        content_tag :div, class: "text-sm text-warning" do
          "Requires authenticator app"
        end
      end
    end
  end

  # @group Examples
  # @label Feature Toggle
  def feature_toggle
    render ::Decor::SwitchingBox.new(
      title: "Beta Features",
      description: "Try out new features before they're officially released",
      property_name: :beta_features,
      switch_options: {checked: true},
      model: create_model(:beta_features, true),
      url: "/features/beta"
    ) do |box|
      box.left do
        content_tag :div, class: "flex gap-2" do
          box.render(::Decor::Badge.new(label: "BETA", color: :warning))
          box.render(::Decor::Badge.new(label: "Experimental", color: :info))
        end
      end
    end
  end

  # @group Playground
  # @param title text
  # @param description text
  # @param show_slot toggle
  # @param switch_options_checked toggle
  # @param property_name text
  def playground(title: "Hi!", description: "This is a description", show_slot: false, switch_options_checked: false, property_name: :switch)
    render ::Decor::SwitchingBox.new(
      title: title,
      description: description,
      switch_options: {checked: switch_options_checked},
      property_name: property_name,
      model: Class.new {
               include ActiveModel::Model
               def self.name = "Test"
               attr_accessor :switch
             }.new(property_name => switch_options_checked),
      url: "#"
    ) do |box|
      if show_slot
        box.left do
          "left"
        end
      end
    end
  end

  # @group States
  # @label Checked State
  def state_checked
    render ::Decor::SwitchingBox.new(
      title: "Email Marketing",
      description: "Receive promotional emails and newsletters",
      property_name: :marketing,
      switch_options: {checked: true},
      model: create_model(:marketing, true),
      url: "/preferences/marketing"
    )
  end

  # @group States
  # @label Unchecked State
  def state_unchecked
    render ::Decor::SwitchingBox.new(
      title: "Auto-save Drafts",
      description: "Automatically save your work as you type",
      property_name: :autosave,
      switch_options: {checked: false},
      model: create_model(:autosave, false),
      url: "/preferences/autosave"
    )
  end

  # @group Layouts
  # @label Simple Layout
  def layout_simple
    render ::Decor::SwitchingBox.new(
      title: "Dark Mode",
      description: "Use dark theme across the application",
      property_name: :dark_mode,
      model: create_model(:dark_mode, false),
      url: "/settings/theme"
    )
  end

  # @group Layouts
  # @label With Left Content
  def layout_with_left
    render ::Decor::SwitchingBox.new(
      title: "Data Collection",
      description: "Help improve our services by sharing anonymous usage data",
      property_name: :analytics,
      model: create_model(:analytics, true),
      url: "/privacy/analytics"
    ) do |box|
      box.left do
        content_tag :a, "Privacy Policy", href: "#", class: "link link-primary text-sm"
      end
    end
  end

  # @group Examples
  # @label Privacy Settings
  def privacy_settings
    render ::Decor::SwitchingBox.new(
      title: "Public Profile",
      description: "Make your profile visible to other users",
      property_name: :public_profile,
      model: create_model(:public_profile, true),
      url: "/privacy/profile"
    ) do |box|
      box.left do
        content_tag :div, class: "text-sm text-base-content/70" do
          "Visible to: Everyone"
        end
      end
    end
  end

  # @group Examples
  # @label System Preferences
  def system_preferences
    render ::Decor::SwitchingBox.new(
      title: "Automatic Updates",
      description: "Download and install updates automatically",
      property_name: :auto_update,
      switch_options: {checked: true},
      model: create_model(:auto_update, true),
      url: "/system/updates"
    ) do |box|
      box.left do
        content_tag :div, class: "text-sm" do
          safe_join([
            content_tag(:span, "Last checked: ", class: "text-base-content/70"),
            content_tag(:span, "2 hours ago", class: "font-medium")
          ])
        end
      end
    end
  end

  # @group Examples
  # @label Subscription Toggle
  def subscription_toggle
    render ::Decor::SwitchingBox.new(
      title: "Premium Subscription",
      description: "Access all premium features and content",
      property_name: :premium,
      switch_options: {checked: false},
      model: create_model(:premium, false),
      url: "/subscription/toggle"
    ) do |box|
      box.left do
        content_tag :div, class: "flex items-center gap-2" do
          safe_join([
            render(::Decor::Badge.new(label: "$9.99/month", color: :primary)),
            content_tag(:span, "7-day free trial", class: "text-sm text-success")
          ])
        end
      end
    end
  end

  private

  def create_model(property_name, value)
    Class.new {
      include ActiveModel::Model
      def self.name = "TestSwitchingBox"
      attr_accessor property_name
    }.new(property_name => value)
  end
end
