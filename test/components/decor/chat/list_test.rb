require "test_helper"
require "ostruct"

class Decor::Chat::ListTest < ActiveSupport::TestCase
  def setup
    @mock_messages = [
      OpenStruct.new(id: 1, content: "Hello there!", user: "John", timestamp: Time.now),
      OpenStruct.new(id: 2, content: "How are you?", user: "Jane", timestamp: Time.now)
    ]
  end

  test "renders successfully with messages" do
    component = Decor::Chat::List.new(messages: @mock_messages)
    rendered = render_component(component)

    assert_includes rendered, "chat"
    assert_includes rendered, "decor--chat-list"
  end

  test "renders with daisyUI chat classes" do
    component = Decor::Chat::List.new(messages: @mock_messages)
    rendered = render_component(component)

    assert_includes rendered, "chat"
  end

  test "supports messages slot" do
    component = Decor::Chat::List.new(messages: @mock_messages)
    rendered = render_component(component) do |c|
      c.with_messages { "<div class='chat chat-start'>Custom message</div>" }
    end

    assert_includes rendered, "Custom message"
    assert_includes rendered, "chat-start"
  end

  test "renders message content from collection" do
    component = Decor::Chat::List.new(messages: @mock_messages)
    rendered = render_component(component)

    assert_includes rendered, "Hello there!"
    assert_includes rendered, "How are you?"
  end

  test "renders with scrollable container" do
    component = Decor::Chat::List.new(messages: @mock_messages)
    rendered = render_component(component)

    assert_includes rendered, "overflow-y-auto"
  end

  test "component inherits from PhlexComponent" do
    component = Decor::Chat::List.new(messages: @mock_messages)

    assert component.is_a?(Decor::PhlexComponent)
  end

  test "supports empty messages collection" do
    component = Decor::Chat::List.new(messages: [])
    rendered = render_component(component)

    assert_includes rendered, "chat"
    assert_includes rendered, "decor--chat-list"
  end

  test "renders with correct HTML structure" do
    component = Decor::Chat::List.new(messages: @mock_messages)
    fragment = render_fragment(component)

    container = fragment.at_css(".chat")
    assert_not_nil container
    assert_includes container["class"], "decor--chat-list"
  end

  test "supports custom CSS classes" do
    component = Decor::Chat::List.new(
      messages: @mock_messages,
      class: "custom-chat-list"
    )
    rendered = render_component(component)

    assert_includes rendered, "custom-chat-list"
    assert_includes rendered, "chat"
  end

  test "handles nil messages gracefully" do
    component = Decor::Chat::List.new(messages: nil)
    rendered = render_component(component)

    assert_includes rendered, "chat"
    assert_includes rendered, "decor--chat-list"
  end

  test "renders with maximum height for scrolling" do
    component = Decor::Chat::List.new(messages: @mock_messages)
    rendered = render_component(component)

    # Should have height constraints for scrolling
    assert_includes rendered, "overflow-y-auto"
  end

  test "supports message rendering with chat components" do
    component = Decor::Chat::List.new(messages: @mock_messages)
    rendered = render_component(component) do |c|
      c.with_messages do
        "<div class='chat chat-start'><div class='chat-bubble'>Test message</div></div>"
      end
    end

    assert_includes rendered, "chat-bubble"
    assert_includes rendered, "Test message"
  end

  test "applies default element classes" do
    component = Decor::Chat::List.new(messages: @mock_messages)
    rendered = render_component(component)

    assert_includes rendered, "decor--chat-list"
    assert_includes rendered, "overflow-y-auto"
  end
end
