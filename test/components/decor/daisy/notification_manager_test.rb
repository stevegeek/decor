require "test_helper"

class Decor::Daisy::NotificationManagerTest < ActiveSupport::TestCase
  test "renders successfully with default attributes" do
    component = Decor::Daisy::NotificationManager.new
    rendered = render_component(component)

    assert_includes rendered, "decor--daisy--notification-manager"
    assert_includes rendered, "decor:d-toast"
  end

  test "renders with daisyUI toast classes" do
    component = Decor::Daisy::NotificationManager.new
    rendered = render_component(component)

    assert_includes rendered, "decor:d-toast"
    assert_includes rendered, "decor:d-toast-top"
    assert_includes rendered, "decor:d-toast-end"
  end

  test "renders with Stimulus controller" do
    component = Decor::Daisy::NotificationManager.new
    rendered = render_component(component)

    assert_includes rendered, 'data-controller="decor--daisy--notification-manager"'
  end

  test "renders with correct positioning classes" do
    component = Decor::Daisy::NotificationManager.new
    fragment = render_fragment(component)

    toast_div = fragment.at_css('[class~="decor:d-toast"]')
    assert_not_nil toast_div
    assert_includes toast_div["class"], "decor:d-toast-top"
    assert_includes toast_div["class"], "decor:d-toast-end"
  end

  test "renders with z-index for layering" do
    component = Decor::Daisy::NotificationManager.new
    rendered = render_component(component)

    assert_includes rendered, "decor:z-50"
  end

  test "provides Stimulus event handlers for notification control" do
    component = Decor::Daisy::NotificationManager.new
    rendered = render_component(component)

    assert_includes rendered, "decor--daisy--notification-manager:show@window->decor--daisy--notification-manager#handleShowEvent"
    assert_includes rendered, "decor--daisy--notification-manager:dismissAll@window->decor--daisy--notification-manager#handleDismissAllEvent"
    assert_includes rendered, "decor--daisy--notification-manager:dismiss@window->decor--daisy--notification-manager#handleDismissSingleEvent"
  end

  test "component inherits from PhlexComponent" do
    component = Decor::Daisy::NotificationManager.new

    assert component.is_a?(Decor::PhlexComponent)
  end

  test "renders empty when no notifications provided" do
    component = Decor::Daisy::NotificationManager.new
    rendered = render_component(component)

    assert_includes rendered, "decor:d-toast"
    assert_includes rendered, "decor--daisy--notification-manager"
  end

  test "renders with fixed positioning" do
    component = Decor::Daisy::NotificationManager.new
    rendered = render_component(component)

    assert_includes rendered, "decor:fixed"
  end

  test "includes Stimulus target for notification container" do
    component = Decor::Daisy::NotificationManager.new
    rendered = render_component(component)

    assert_includes rendered, "decor--daisy--notification-manager-target=\"notificationContainer\""
  end

  test "renders with data attributes for Stimulus" do
    component = Decor::Daisy::NotificationManager.new
    fragment = render_fragment(component)

    toast_div = fragment.at_css('[class~="decor:d-toast"]')
    assert_not_nil toast_div

    controller_attr = toast_div["data-controller"]
    assert_not_nil controller_attr
    assert_includes controller_attr, "decor--daisy--notification-manager"
  end

  test "applies consistent CSS class structure" do
    component = Decor::Daisy::NotificationManager.new
    rendered = render_component(component)

    assert_includes rendered, "decor--daisy--notification-manager"
    assert_includes rendered, "decor:d-toast decor:d-toast-top decor:d-toast-end"
    assert_includes rendered, "decor:fixed decor:z-50"
  end

  test "renders as div element with toast classes" do
    component = Decor::Daisy::NotificationManager.new
    fragment = render_fragment(component)

    div = fragment.at_css("div")
    assert_not_nil div
    assert_includes div["class"], "decor:d-toast"
    assert_includes div["class"], "decor--daisy--notification-manager"
  end
end
