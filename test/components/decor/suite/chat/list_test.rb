# frozen_string_literal: true

require "test_helper"

class ::Decor::Suite::Chat::ListTest < ActiveSupport::TestCase
  def setup
    @message1 = ::Decor::Daisy::Chat::ListMessage.new(
      author_name: "John",
      message: "Hello there!",
      is_current_user: false
    )
    @message2 = ::Decor::Daisy::Chat::ListMessage.new(
      author_name: "Jane",
      message: "How are you?",
      is_current_user: false
    )
    @messages = [@message1, @message2]
  end

  test "renders ul with hairline-divided list when messages present" do
    html = render_component(::Decor::Suite::Chat::List.new(messages: @messages))
    assert_includes html, "<ul"
    assert_includes html, "decor:divide-y"
    assert_includes html, "decor:divide-suite-hairline"
    assert_includes html, "decor:list-none"
  end

  test "renders all message content" do
    html = render_component(::Decor::Suite::Chat::List.new(messages: @messages))
    assert_includes html, "Hello there!"
    assert_includes html, "How are you?"
  end

  test "root element gets not-prose when messages present" do
    html = render_component(::Decor::Suite::Chat::List.new(messages: @messages))
    assert_includes html, "decor:w-full"
    assert_includes html, "decor:not-prose"
  end

  test "root element omits not-prose when empty" do
    html = render_component(::Decor::Suite::Chat::List.new(messages: []))
    assert_includes html, "decor:w-full"
    refute_includes html, "decor:not-prose"
  end

  test "renders default empty state title with suite-section-title token" do
    html = render_component(::Decor::Suite::Chat::List.new(messages: []))
    assert_includes html, "No messages yet"
    assert_includes html, "decor:suite-section-title"
  end

  test "empty state description is hidden when no action block is given" do
    html = render_component(::Decor::Suite::Chat::List.new(messages: []))
    refute_includes html, "Start a conversation by sending a message"
    refute_includes html, "decor:suite-description"
  end

  test "renders custom empty state title and description with action slot" do
    component = ::Decor::Suite::Chat::List.new(
      messages: [],
      empty_state_title: "Nothing here",
      empty_state_description: "Add the first one."
    )
    html = render_component(component) do |list|
      list.empty_state_action do
        "Start Chat"
      end
    end
    assert_includes html, "Nothing here"
    assert_includes html, "Add the first one."
    assert_includes html, "Start Chat"
    assert_includes html, "decor:suite-description"
  end

  test "empty state container uses Suite spacing" do
    html = render_component(::Decor::Suite::Chat::List.new(messages: []))
    assert_includes html, "decor:py-6"
    assert_includes html, "decor:px-0"
  end

  test "does not render the ul when there are no messages" do
    html = render_component(::Decor::Suite::Chat::List.new(messages: []))
    refute_includes html, "<ul"
    refute_includes html, "decor:divide-suite-hairline"
  end

  test "inherits from the abstract Components::Chat::List base" do
    component = ::Decor::Suite::Chat::List.new(messages: [])
    assert component.is_a?(::Decor::Components::Chat::List)
    assert component.is_a?(::Decor::PhlexComponent)
  end

  test "list HTML uses role=list for accessibility" do
    html = render_component(::Decor::Suite::Chat::List.new(messages: @messages))
    assert_includes html, 'role="list"'
  end

  test "renders chat bubble markup from inner messages" do
    html = render_component(::Decor::Suite::Chat::List.new(messages: @messages))
    # ListMessage is a Daisy component — it emits chat-bubble classes
    assert_includes html, "chat-bubble"
  end
end
