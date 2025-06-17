require "test_helper"

class Decor::Chat::ListMessageTest < ActiveSupport::TestCase
  def setup
    @message_component = Decor::Chat::ListMessage.new(
      author_name: "John Doe",
      message: "Hello, how are you today?",
      is_current_user: false,
      localised_created_at: Time.current
    )
  end

  test "renders successfully with message data" do
    rendered = render_component(@message_component)

    assert_includes rendered, "chat chat-start"
    assert_includes rendered, "Hello, how are you today?"
  end

  test "renders with daisyUI chat bubble" do
    rendered = render_component(@message_component)

    assert_includes rendered, "chat-bubble"
  end

  test "renders message content" do
    rendered = render_component(@message_component)

    assert_includes rendered, "Hello, how are you today?"
  end

  test "renders user information in header" do
    rendered = render_component(@message_component)

    assert_includes rendered, "John Doe"
  end

  test "supports current user message styling" do
    current_user_message = Decor::Chat::ListMessage.new(
      author_name: "You",
      message: "My message",
      is_current_user: true
    )
    rendered = render_component(current_user_message)

    assert_includes rendered, "chat-end"
    assert_includes rendered, "chat-bubble-primary"
  end

  test "supports other user message styling" do
    rendered = render_component(@message_component)

    assert_includes rendered, "chat-start"
    refute_includes rendered, "chat-bubble-primary"
  end

  test "renders with correct HTML structure" do
    fragment = render_fragment(@message_component)

    chat_div = fragment.at_css(".chat")
    assert_not_nil chat_div
    assert_includes chat_div["class"], "chat-start"

    bubble = fragment.at_css(".chat-bubble")
    assert_not_nil bubble
  end

  test "component inherits from PhlexComponent" do
    assert @message_component.is_a?(Decor::PhlexComponent)
  end

  test "supports avatar display" do
    message_with_avatar = Decor::Chat::ListMessage.new(
      author_name: "Jane Smith",
      author_initials: "JS",
      message: "Message with avatar",
      is_current_user: false
    )
    rendered = render_component(message_with_avatar)

    assert_includes rendered, "chat-image"
    assert_includes rendered, "avatar"
  end

  test "supports timestamp display" do
    timestamped_message = Decor::Chat::ListMessage.new(
      author_name: "User",
      message: "Timestamped message",
      localised_created_at: 2.hours.ago,
      is_current_user: false
    )
    rendered = render_component(timestamped_message)

    assert_includes rendered, "Timestamped message"
    # Should show time format for recent messages (within 24 hours)
    assert_includes rendered, ":"
  end

  test "supports footer text" do
    message_with_footer = Decor::Chat::ListMessage.new(
      author_name: "User",
      message: "Message with footer",
      footer_text: "Delivered",
      is_current_user: false
    )
    rendered = render_component(message_with_footer)

    assert_includes rendered, "Delivered"
    assert_includes rendered, "chat-footer"
  end

  test "handles old timestamps correctly" do
    old_message = Decor::Chat::ListMessage.new(
      author_name: "User",
      message: "Old message",
      localised_created_at: 2.days.ago,
      is_current_user: false
    )
    rendered = render_component(old_message)

    # Should show date format for old messages
    refute_includes rendered, ":"
  end

  test "renders message bubble with content" do
    fragment = render_fragment(@message_component)

    bubble = fragment.at_css(".chat-bubble")
    assert_not_nil bubble
    assert_includes bubble.text, "Hello, how are you today?"
  end

  test "supports attachment block" do
    message_with_attachment = Decor::Chat::ListMessage.new(
      author_name: "User",
      message: "Message with attachment",
      is_current_user: false
    )
    rendered = render_component(message_with_attachment) do |message|
      message.attachment do
        div(class: "attachment") { "File.pdf" }
      end
    end

    assert_includes rendered, "File.pdf"
    assert_includes rendered, "attachment"
  end

  test "message text appears before attachment content" do
    message_with_attachment = Decor::Chat::ListMessage.new(
      author_name: "User",
      message: "TEXT_FIRST",
      is_current_user: false
    )
    rendered = render_component(message_with_attachment) do |message|
      message.attachment do
        div(class: "test-attachment") { "ATTACHMENT_SECOND" }
      end
    end

    message_index = rendered.index("TEXT_FIRST")
    attachment_index = rendered.index("ATTACHMENT_SECOND")

    assert_not_nil message_index, "Message text should be present"
    assert_not_nil attachment_index, "Attachment content should be present"
    assert message_index < attachment_index, "Message text should appear before attachment in HTML"
  end

  test "supports attachment without message text" do
    message_attachment_only = Decor::Chat::ListMessage.new(
      author_name: "User",
      message: "",
      is_current_user: false
    )
    rendered = render_component(message_attachment_only) do |message|
      message.attachment do
        div(class: "only-attachment") { "ATTACHMENT_ONLY" }
      end
    end

    assert_includes rendered, "ATTACHMENT_ONLY"
    assert_includes rendered, "only-attachment"
    # Ensure empty message doesn't break rendering
    assert_includes rendered, "chat-bubble"
  end

  test "supports message text without attachment" do
    message_text_only = Decor::Chat::ListMessage.new(
      author_name: "User",
      message: "TEXT_ONLY",
      is_current_user: false
    )
    rendered = render_component(message_text_only)

    assert_includes rendered, "TEXT_ONLY"
    assert_includes rendered, "chat-bubble"
    # Should not contain any attachment content
    refute_includes rendered, "attachment"
  end

  test "complex attachment with card and button renders correctly" do
    message_with_complex_attachment = Decor::Chat::ListMessage.new(
      author_name: "Alice Johnson",
      message: "Complex message text",
      is_current_user: false
    )
    rendered = render_component(message_with_complex_attachment) do |message|
      message.attachment do
        div(class: "card bg-base-200 p-4 max-w-sm") do
          h4(class: "font-semibold") { "Design_Mockup_v2.png" }
          p(class: "text-sm text-base-content/70") { "2.1 MB" }
          div(class: "mt-2") do
            button(class: "btn btn-primary btn-sm") { "Download" }
          end
        end
      end
    end

    # Check basic content is present
    assert_includes rendered, "Complex message text"
    assert_includes rendered, "Design_Mockup_v2.png"
    assert_includes rendered, "Download"
    assert_includes rendered, "card bg-base-200"

    # Check content order: message first, then attachment
    message_index = rendered.index("Complex message text")
    attachment_index = rendered.index("Design_Mockup_v2.png")

    assert_not_nil message_index, "Message text should be present"
    assert_not_nil attachment_index, "Attachment content should be present"
    assert message_index < attachment_index, "Message should appear before attachment"
  end
end
