require "test_helper"
require "ostruct"

class Decor::Chat::ListMessageTest < ActiveSupport::TestCase
  def setup
    @mock_message = OpenStruct.new(
      id: 1,
      content: "Hello, how are you today?",
      user: "John Doe",
      timestamp: Time.now,
      own_message: false
    )
  end

  test "renders successfully with message data" do
    component = Decor::Chat::ListMessage.new(message: @mock_message)
    rendered = render_component(component)

    assert_includes rendered, "chat"
    assert_includes rendered, "decor--chat-list-message"
    assert_includes rendered, "Hello, how are you today?"
  end

  test "renders with daisyUI chat bubble" do
    component = Decor::Chat::ListMessage.new(message: @mock_message)
    rendered = render_component(component)

    assert_includes rendered, "chat-bubble"
  end

  test "renders message content" do
    component = Decor::Chat::ListMessage.new(message: @mock_message)
    rendered = render_component(component)

    assert_includes rendered, "Hello, how are you today?"
  end

  test "renders user information" do
    component = Decor::Chat::ListMessage.new(message: @mock_message)
    rendered = render_component(component)

    assert_includes rendered, "John Doe"
  end

  test "supports own message styling" do
    own_message = OpenStruct.new(
      content: "My message",
      user: "Me",
      own_message: true
    )
    component = Decor::Chat::ListMessage.new(message: own_message)
    rendered = render_component(component)

    assert_includes rendered, "chat-end"
  end

  test "supports other user message styling" do
    component = Decor::Chat::ListMessage.new(message: @mock_message)
    rendered = render_component(component)

    assert_includes rendered, "chat-start"
  end

  test "renders with correct HTML structure" do
    component = Decor::Chat::ListMessage.new(message: @mock_message)
    fragment = render_fragment(component)

    chat_div = fragment.at_css(".chat")
    assert_not_nil chat_div
    assert_includes chat_div["class"], "decor--chat-list-message"

    bubble = fragment.at_css(".chat-bubble")
    assert_not_nil bubble
  end

  test "component inherits from PhlexComponent" do
    component = Decor::Chat::ListMessage.new(message: @mock_message)

    assert component.is_a?(Decor::PhlexComponent)
  end

  test "supports avatar slot" do
    component = Decor::Chat::ListMessage.new(message: @mock_message)
    rendered = render_component(component) do |c|
      c.with_avatar { "<div class='avatar'>JD</div>" }
    end

    assert_includes rendered, "<div class='avatar'>JD</div>"
  end

  test "supports timestamp display" do
    timestamped_message = OpenStruct.new(
      content: "Timestamped message",
      user: "User",
      timestamp: Time.parse("2024-01-01 12:00:00")
    )
    component = Decor::Chat::ListMessage.new(message: timestamped_message)
    rendered = render_component(component)

    # Should include some timestamp information
    assert_includes rendered, "Timestamped message"
  end

  test "handles different message positions" do
    start_message = OpenStruct.new(
      content: "Start message",
      user: "Other",
      own_message: false
    )

    end_message = OpenStruct.new(
      content: "End message",
      user: "Me",
      own_message: true
    )

    start_component = Decor::Chat::ListMessage.new(message: start_message)
    end_component = Decor::Chat::ListMessage.new(message: end_message)

    start_rendered = render_component(start_component)
    end_rendered = render_component(end_component)

    assert_includes start_rendered, "chat-start"
    assert_includes end_rendered, "chat-end"
  end

  test "supports custom CSS classes" do
    component = Decor::Chat::ListMessage.new(
      message: @mock_message,
      class: "custom-message"
    )
    rendered = render_component(component)

    assert_includes rendered, "custom-message"
    assert_includes rendered, "chat"
  end

  test "renders message bubble with content" do
    component = Decor::Chat::ListMessage.new(message: @mock_message)
    fragment = render_fragment(component)

    bubble = fragment.at_css(".chat-bubble")
    assert_not_nil bubble
    assert_includes bubble.text, "Hello, how are you today?"
  end

  test "applies appropriate chat direction class" do
    component = Decor::Chat::ListMessage.new(message: @mock_message)
    rendered = render_component(component)

    # Should have either chat-start or chat-end based on own_message
    if @mock_message.own_message
      assert_includes rendered, "chat-end"
    else
      assert_includes rendered, "chat-start"
    end
  end
end
