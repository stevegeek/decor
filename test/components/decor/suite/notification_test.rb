# frozen_string_literal: true

require "test_helper"

class ::Decor::Suite::NotificationTest < ActiveSupport::TestCase
  test "renders title + body with suite typography tokens" do
    html = render_component(::Decor::Suite::Notification.new(title: "Saved", body: "Your changes have been saved."))
    assert_includes html, "Saved"
    assert_includes html, "Your changes have been saved."
    assert_includes html, "decor:suite-section-title"
    assert_includes html, "decor:suite-dense-body"
  end

  test "default color is :neutral and uses gray accent" do
    html = render_component(::Decor::Suite::Notification.new(title: "Heads up", body: "Note."))
    assert_includes html, "decor:bg-gray-400"
  end

  test "color :info uses suite-primary accent" do
    html = render_component(::Decor::Suite::Notification.new(title: "Heads up", body: "Note.", color: :info))
    assert_includes html, "decor:bg-suite-primary-500"
  end

  test "color :success uses suite-success accent" do
    html = render_component(::Decor::Suite::Notification.new(title: "Ok", body: "Done", color: :success))
    assert_includes html, "decor:bg-suite-success-500"
    refute_includes html, "decor:bg-suite-primary-500"
  end

  test "color :error uses suite-danger accent" do
    html = render_component(::Decor::Suite::Notification.new(title: "Oops", body: "x", color: :error))
    assert_includes html, "decor:bg-suite-danger-500"
  end

  test "color :warning uses suite-warning accent" do
    html = render_component(::Decor::Suite::Notification.new(title: "Heads", body: "y", color: :warning))
    assert_includes html, "decor:bg-suite-warning-500"
  end

  test "neutral color falls back to gray accent" do
    html = render_component(::Decor::Suite::Notification.new(title: "x", body: "y", color: :neutral))
    assert_includes html, "decor:bg-gray-400"
  end

  test "root uses suite-control radius, hairline-strong border, white surface" do
    html = render_component(::Decor::Suite::Notification.new(title: "T", body: "B"))
    assert_includes html, "decor:rounded-suite-control"
    assert_includes html, "decor:border-suite-hairline-strong"
    assert_includes html, "decor:bg-white"
  end

  test "renders dismiss-X button with aria-label and suite-control radius" do
    html = render_component(::Decor::Suite::Notification.new(title: "T", body: "B"))
    assert_includes html, "aria-label=\"Dismiss\""
    assert_includes html, "tabler-x"
  end

  test "header is hidden when title is nil" do
    html = render_component(::Decor::Suite::Notification.new(body: "Body only"))
    assert_includes html, "data-notification-slot=\"header\""
    # Phlex emits `hidden=""` for empty hidden attribute
    assert_match(/data-notification-slot="header"[^>]*hidden/, html)
  end

  test "body container is hidden when body and destination are both nil" do
    html = render_component(::Decor::Suite::Notification.new(title: "Just a title"))
    assert_match(/data-notification-slot="body"[^>]*hidden/, html)
  end

  test "actions footer is hidden when actions empty" do
    html = render_component(::Decor::Suite::Notification.new(title: "T", body: "B"))
    assert_match(/data-notification-slot="actions"[^>]*hidden/, html)
  end

  test "progress bar is hidden by default" do
    html = render_component(::Decor::Suite::Notification.new(title: "T", body: "B"))
    assert_match(/data-notification-slot="progress"[^>]*hidden/, html)
  end

  test "progress bar visible when show_progress is true and not sticky" do
    html = render_component(::Decor::Suite::Notification.new(title: "T", body: "B", show_progress: true))
    # The progress slot div should not carry a hidden attribute
    refute_match(/data-notification-slot="progress"[^>]*hidden/, html)
  end

  test "sticky suppresses progress bar even with show_progress true" do
    html = render_component(::Decor::Suite::Notification.new(title: "T", body: "B", show_progress: true, sticky: true))
    assert_match(/data-notification-slot="progress"[^>]*hidden/, html)
  end

  test "destination renders link with text and href" do
    html = render_component(::Decor::Suite::Notification.new(
      title: "Added",
      body: "Item added.",
      destination: {text: "View cart", href: "/cart"}
    ))
    assert_includes html, "View cart"
    assert_includes html, "href=\"/cart\""
  end

  test "actions render as buttons with event_name data attribute" do
    html = render_component(::Decor::Suite::Notification.new(
      title: "Confirm?",
      actions: [{text: "Retry", style: :primary, event_name: "retry"}]
    ))
    assert_includes html, "Retry"
    assert_includes html, "data-notification-action-event=\"retry\""
    assert_includes html, "decor:text-suite-primary-700"
  end

  test "actions with href render as anchor tags" do
    html = render_component(::Decor::Suite::Notification.new(
      title: "T",
      actions: [{text: "View", style: :primary, href: "/somewhere"}]
    ))
    assert_includes html, "<a"
    assert_includes html, "href=\"/somewhere\""
    assert_includes html, "View"
  end

  test "all slot data attributes are present (template-mode contract)" do
    html = render_component(::Decor::Suite::Notification.new(title: "T", body: "B"))
    assert_includes html, "data-notification-slot=\"accent\""
    assert_includes html, "data-notification-slot=\"header\""
    assert_includes html, "data-notification-slot=\"title\""
    assert_includes html, "data-notification-slot=\"close\""
    assert_includes html, "data-notification-slot=\"body\""
    assert_includes html, "data-notification-slot=\"body-text\""
    assert_includes html, "data-notification-slot=\"destination\""
    assert_includes html, "data-notification-slot=\"actions\""
    assert_includes html, "data-notification-slot=\"action-template\""
    assert_includes html, "data-notification-slot=\"progress\""
  end

  test "description (Daisy heritage prop) is honored when body is absent" do
    html = render_component(::Decor::Suite::Notification.new(title: "T", description: "From description"))
    assert_includes html, "From description"
  end

  test "header separator only present when title accompanies further content" do
    with_more = render_component(::Decor::Suite::Notification.new(title: "T", body: "B"))
    title_only = render_component(::Decor::Suite::Notification.new(title: "T"))
    assert_includes with_more, "decor:border-suite-hairline"
    # Title-only must not have the separator beneath the header
    refute_match(/data-notification-slot="header"[^>]*decor:border-b/, title_only)
  end
end
