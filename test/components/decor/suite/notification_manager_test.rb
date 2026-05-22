# frozen_string_literal: true

require "test_helper"

class ::Decor::Suite::NotificationManagerTest < ActiveSupport::TestCase
  test "renders manager container with stimulus identifier" do
    html = render_component(::Decor::Suite::NotificationManager.new)
    assert_includes html, "decor--suite--notification-manager"
    assert_includes html, 'data-controller="decor--suite--notification-manager"'
  end

  test "exposes notification container as stimulus target" do
    html = render_component(::Decor::Suite::NotificationManager.new)
    assert_includes html, "decor--suite--notification-manager-target=\"notificationContainer\""
  end

  test "default position is top-right and uses fixed top/right utilities" do
    html = render_component(::Decor::Suite::NotificationManager.new)
    assert_includes html, "decor:fixed"
    assert_includes html, "decor:top-4"
    assert_includes html, "decor:right-4"
    assert_includes html, "decor:flex-col"
  end

  test "bottom_right position uses bottom/right + column-reverse" do
    html = render_component(::Decor::Suite::NotificationManager.new(position: :bottom_right))
    assert_includes html, "decor:bottom-4"
    assert_includes html, "decor:right-4"
    assert_includes html, "decor:flex-col-reverse"
  end

  test "top_center position uses centring transform" do
    html = render_component(::Decor::Suite::NotificationManager.new(position: :top_center))
    assert_includes html, "decor:left-1/2"
    assert_includes html, "decor:-translate-x-1/2"
    assert_includes html, "decor:top-4"
  end

  test "renders with high z-index so it floats above page content" do
    html = render_component(::Decor::Suite::NotificationManager.new)
    assert_includes html, "decor:z-50"
  end

  test "wrapper is pointer-events-none so dead space does not block the page" do
    html = render_component(::Decor::Suite::NotificationManager.new)
    assert_includes html, "decor:pointer-events-none"
  end

  test "writes position and max_visible as stimulus values" do
    html = render_component(::Decor::Suite::NotificationManager.new(position: :bottom_left, max_visible: 3))
    assert_includes html, "decor--suite--notification-manager-position-value=\"bottom-left\""
    assert_includes html, "decor--suite--notification-manager-max-visible-value=\"3\""
  end

  test "publishes notification_base class for the controller to apply per toast" do
    html = render_component(::Decor::Suite::NotificationManager.new)
    assert_includes html, "decor--suite--notification-manager-notification-base-class"
    assert_includes html, "decor:rounded-suite-control"
    assert_includes html, "decor:border-suite-hairline-strong"
    assert_includes html, "decor:max-w-[380px]"
  end

  test "wires show/dismiss/dismissAll window events to controller actions" do
    html = render_component(::Decor::Suite::NotificationManager.new)
    assert_includes html, "decor--suite--notification-manager:show@window->decor--suite--notification-manager#handleShowEvent"
    assert_includes html, "decor--suite--notification-manager:dismissAll@window->decor--suite--notification-manager#handleDismissAllEvent"
    assert_includes html, "decor--suite--notification-manager:dismiss@window->decor--suite--notification-manager#handleDismissSingleEvent"
  end

  test "sets aria-live=assertive on the wrapper for screen-reader announcements" do
    html = render_component(::Decor::Suite::NotificationManager.new)
    assert_includes html, "aria-live=\"assertive\""
  end

  test "emits a Suite Notification template the controller can clone" do
    html = render_component(::Decor::Suite::NotificationManager.new)
    fragment = Nokogiri::HTML5.fragment(html)
    template = fragment.at_css("template")
    assert_not_nil template
    template_html = template.inner_html
    assert_includes template_html, "data-notification-slot=\"accent\""
    assert_includes template_html, "data-notification-slot=\"title\""
    assert_includes template_html, "decor:rounded-suite-control"
  end
end
