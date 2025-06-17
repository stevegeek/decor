require "test_helper"

class Decor::Chat::ListTest < ActiveSupport::TestCase
  def setup
    @message1 = Decor::Chat::ListMessage.new(
      author_name: "John",
      message: "Hello there!",
      is_current_user: false
    )
    @message2 = Decor::Chat::ListMessage.new(
      author_name: "Jane",
      message: "How are you?",
      is_current_user: false
    )
    @mock_messages = [@message1, @message2]
  end

  test "renders successfully with messages" do
    component = Decor::Chat::List.new(messages: @mock_messages)
    rendered = render_component(component)

    assert_includes rendered, "flex flex-col gap-2 p-4"
  end

  test "renders message content from collection" do
    component = Decor::Chat::List.new(messages: @mock_messages)
    rendered = render_component(component)

    assert_includes rendered, "Hello there!"
    assert_includes rendered, "How are you?"
  end

  test "renders with proper container styling" do
    component = Decor::Chat::List.new(messages: @mock_messages)
    rendered = render_component(component)

    assert_includes rendered, "flex flex-col gap-2 p-4"
  end

  test "renders each message as chat components" do
    component = Decor::Chat::List.new(messages: @mock_messages)
    rendered = render_component(component)

    assert_includes rendered, "chat chat-start"
    assert_includes rendered, "chat-bubble"
  end

  test "component inherits from PhlexComponent" do
    component = Decor::Chat::List.new(messages: @mock_messages)

    assert component.is_a?(Decor::PhlexComponent)
  end

  test "supports empty messages collection" do
    component = Decor::Chat::List.new(messages: [])
    rendered = render_component(component)

    assert_includes rendered, "No messages yet"
    assert_includes rendered, "flex flex-col gap-2 p-4"
  end

  test "renders empty state when no messages" do
    component = Decor::Chat::List.new(messages: [])
    rendered = render_component(component)

    assert_includes rendered, "No messages yet"
    # Description only shows when there's an action slot
    refute_includes rendered, "Start a conversation by sending a message"
  end

  test "renders with correct HTML structure" do
    component = Decor::Chat::List.new(messages: @mock_messages)
    fragment = render_fragment(component)

    container = fragment.at_css("div")
    assert_not_nil container
    assert_includes container["class"], "flex flex-col gap-2 p-4"
  end

  test "handles empty messages array gracefully" do
    component = Decor::Chat::List.new(messages: [])
    rendered = render_component(component)

    assert_includes rendered, "flex flex-col gap-2 p-4"
    assert_includes rendered, "No messages yet"
  end

  test "renders ListMessage components correctly" do
    component = Decor::Chat::List.new(messages: @mock_messages)
    rendered = render_component(component)

    # Should contain both messages
    assert_includes rendered, "Hello there!"
    assert_includes rendered, "How are you?"

    # Should have chat structure
    assert_includes rendered, "chat-bubble"
    assert_includes rendered, "chat-start"
  end

  test "supports empty state with action button" do
    component = Decor::Chat::List.new(
      messages: [],
      empty_state_title: "Custom empty title",
      empty_state_description: "Custom description"
    )
    rendered = render_component(component) do |list|
      list.empty_state_action do
        "Start Chat"
      end
    end

    assert_includes rendered, "Custom empty title"
    assert_includes rendered, "Custom description"
    assert_includes rendered, "Start Chat"
  end
end
