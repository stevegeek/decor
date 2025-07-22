# @label Toggle
class ::Decor::TogglePreview < ::Lookbook::Preview
  # Toggle
  # -------
  #
  # A switch component that can be toggled on or off and POSTs to a URL on change.
  # Built with DaisyUI's toggle styling, this component provides a clean interface
  # for boolean settings and preferences.
  #
  # @group Examples
  # @label Basic Toggle
  def basic_toggle
    render ::Decor::Toggle.new(
      property_name: :notifications,
      url: "/settings/notifications",
      http_method: :patch,
      model: create_model(:notifications, true)
    )
  end

  # @group Examples
  # @label Unchecked Toggle
  def unchecked_toggle
    render ::Decor::Toggle.new(
      property_name: :email_alerts,
      url: "/settings/email_alerts",
      http_method: :patch,
      model: create_model(:email_alerts, false)
    )
  end

  # @group Examples
  # @label Feature Toggle
  def feature_toggle
    render ::Decor::Toggle.new(
      property_name: :dark_mode,
      url: "/preferences/dark_mode",
      http_method: :post,
      model: create_model(:dark_mode, true)
    )
  end

  # @group Playground
  # @param url text
  # @param http_method select [~, get, post, put, patch, delete]
  # @param checked toggle
  # @param size [Symbol] select [~, xs, sm, md, lg, xl]
  # @param color [Symbol] select [~, base, primary, secondary, accent, neutral, success, error, warning, info]
  # @param style [Symbol] select [~, filled, outlined, ghost]
  def playground(url: "#", http_method: :patch, checked: false, size: nil, color: nil, style: nil)
    render ::Decor::Toggle.new(
      property_name: :testing,
      url: url,
      http_method: http_method,
      model: create_model(:testing, checked),
      size: size,
      color: color,
      style: style
    )
  end

  # @group HTTP Methods
  # @label GET Method
  def method_get
    render ::Decor::Toggle.new(
      property_name: :feature_flag,
      url: "/api/feature",
      http_method: :get,
      model: create_model(:feature_flag, true)
    )
  end

  # @group HTTP Methods
  # @label POST Method
  def method_post
    render ::Decor::Toggle.new(
      property_name: :subscription,
      url: "/api/subscribe",
      http_method: :post,
      model: create_model(:subscription, false)
    )
  end

  # @group HTTP Methods
  # @label PUT Method
  def method_put
    render ::Decor::Toggle.new(
      property_name: :status,
      url: "/api/status",
      http_method: :put,
      model: create_model(:status, true)
    )
  end

  # @group HTTP Methods
  # @label PATCH Method (Default)
  def method_patch
    render ::Decor::Toggle.new(
      property_name: :active,
      url: "/api/settings",
      http_method: :patch,
      model: create_model(:active, true)
    )
  end

  # @group HTTP Methods
  # @label DELETE Method
  def method_delete
    render ::Decor::Toggle.new(
      property_name: :remove_on_disable,
      url: "/api/feature",
      http_method: :delete,
      model: create_model(:remove_on_disable, false)
    )
  end

  # @group Examples
  # @label Settings Toggle
  def settings_toggle
    render ::Decor::Toggle.new(
      property_name: :public_profile,
      url: "/user/settings/visibility",
      http_method: :patch,
      model: create_model(:public_profile, true)
    )
  end

  # @group Examples
  # @label Feature Flag
  def feature_flag_toggle
    render ::Decor::Toggle.new(
      property_name: :beta_features,
      url: "/account/features/beta",
      http_method: :post,
      model: create_model(:beta_features, false)
    )
  end

  # @group Examples
  # @label Notification Preference
  def notification_preference
    render ::Decor::Toggle.new(
      property_name: :push_notifications,
      url: "/notifications/push",
      http_method: :patch,
      model: create_model(:push_notifications, true)
    )
  end

  private

  def create_model(property_name, value)
    Class.new {
      include ActiveModel::Model
      def self.name = "TestToggle"
      attr_accessor property_name
    }.new(property_name => value)
  end
end
