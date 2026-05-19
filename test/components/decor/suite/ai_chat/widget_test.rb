# frozen_string_literal: true

require "test_helper"

class Decor::Suite::AiChat::WidgetTest < ActiveSupport::TestCase
  def widget(**overrides)
    ::Decor::Suite::AiChat::Widget.new(
      create_url: "/ai/messages",
      threads_url: "/ai/threads",
      **overrides
    )
  end

  test "renders fixed bottom-right z-50 root" do
    html = render_component(widget)
    assert_includes html, "decor:fixed"
    assert_includes html, "decor:bottom-4"
    assert_includes html, "decor:right-4"
    assert_includes html, "decor:z-50"
  end

  test "wires Stimulus action for window open event" do
    html = render_component(widget)
    assert_includes html, "ai-chat:open@window->decor--suite--ai-chat--widget#open"
  end

  test "exposes create_url + threads_url as Stimulus values" do
    html = render_component(widget)
    assert_includes html, "create-url-value=\"/ai/messages\""
    assert_includes html, "threads-url-value=\"/ai/threads\""
  end

  test "toggle button uses suite-primary palette + suite-fast duration" do
    html = render_component(widget)
    assert_includes html, "decor:bg-suite-primary-600"
    assert_includes html, "decor:hover:bg-suite-primary-700"
    assert_includes html, "decor:duration-suite-fast"
    assert_includes html, "decor:shadow-lg"
    assert_includes html, "decor:rounded-full"
  end

  test "toggle button wires click → toggle" do
    html = render_component(widget)
    assert_includes html, "click->decor--suite--ai-chat--widget#toggle"
  end

  test "panel uses suite-card radius, suite-hairline border, shadow-lg" do
    html = render_component(widget)
    assert_includes html, "decor:rounded-suite-card"
    assert_includes html, "decor:border-suite-hairline"
    assert_includes html, "decor:shadow-lg"
  end

  test "panel starts hidden" do
    html = render_component(widget)
    # The panel target div carries decor:hidden until the controller toggles it
    assert_includes html, "decor:hidden"
  end

  test "header uses suite-primary background + suite-section-title" do
    html = render_component(widget)
    assert_includes html, "decor:bg-suite-primary-600"
    assert_includes html, "decor:suite-section-title"
    assert_includes html, "AI Assistant"
  end

  test "New Chat button uses suite-caption + rounded-suite-control" do
    html = render_component(widget)
    assert_includes html, "New Chat"
    assert_includes html, "decor:suite-caption"
    assert_includes html, "decor:rounded-suite-control"
    assert_includes html, "click->decor--suite--ai-chat--widget#newThread"
  end

  test "welcome block renders default greeting + custom subtitle" do
    html = render_component(widget(greeting_subtitle: "Custom subtitle"))
    assert_includes html, "Hi! I&#39;m your AI assistant."
    assert_includes html, "Custom subtitle"
    assert_includes html, "decor:suite-body"
    assert_includes html, "decor:suite-description"
  end

  test "custom greeting overrides default" do
    html = render_component(widget(greeting: "Welcome, Anna."))
    assert_includes html, "Welcome, Anna."
  end

  test "messages area is the scrolling stream target" do
    html = render_component(widget)
    assert_includes html, "decor:flex-1"
    assert_includes html, "decor:overflow-y-auto"
  end

  test "thinking indicator is hidden by default + uses suite-description" do
    html = render_component(widget)
    assert_includes html, "Thinking..."
    assert_includes html, "decor:animate-bounce"
  end

  test "input is text-only autocomplete-off with suite-control radius" do
    html = render_component(widget)
    assert_includes html, "placeholder=\"Type your message...\""
    assert_includes html, "autocomplete=\"off\""
    assert_includes html, "decor:rounded-suite-control"
    assert_includes html, "decor:border-suite-hairline-strong"
  end

  test "form wires submit → send" do
    html = render_component(widget)
    assert_includes html, "submit->decor--suite--ai-chat--widget#send"
  end

  test "send button uses suite-primary palette + suite-fast duration" do
    html = render_component(widget)
    assert_includes html, "Send"
    assert_includes html, "decor:bg-suite-primary-600"
    assert_includes html, "decor:duration-suite-fast"
  end

  test "error banner uses suite-danger-600 + hidden by default" do
    html = render_component(widget)
    assert_includes html, "decor:text-suite-danger-600"
  end

  test "renders all targets the controller needs" do
    html = render_component(widget)
    # Stimulus targets are camelCased in the rendered data attribute value
    %w[
      toggleButton
      chatIcon
      closeIcon
      panel
      messages
      welcome
      thinking
      input
      sendButton
      errorBanner
    ].each do |target|
      assert_includes html, "data-decor--suite--ai-chat--widget-target=\"#{target}\"",
        "expected target #{target}"
    end
  end
end
