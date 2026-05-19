# frozen_string_literal: true

require "test_helper"

class Decor::Suite::Chat::ListMessageTest < ActiveSupport::TestCase
  def setup
    @component = Decor::Suite::Chat::ListMessage.new(
      author_name: "Jane Goodall",
      author_initials: "JG",
      message: "Hello, how are you today?",
      localised_created_at: Time.zone.local(2026, 5, 1, 14, 23),
      is_current_user: false
    )
  end

  test "renders <li> root with suite list-message identity class" do
    rendered = render_component(@component)
    assert_match(/<li[^>]*decor--suite--chat-list-message/, rendered)
  end

  test "renders the author name" do
    rendered = render_component(@component)
    assert_includes rendered, "Jane Goodall"
  end

  test "renders the message body" do
    rendered = render_component(@component)
    assert_includes rendered, "Hello, how are you today?"
  end

  test "renders a <time> element with iso8601 datetime attribute" do
    rendered = render_component(@component)
    assert_match(/<time[^>]*datetime="2026-05-01T14:23:00/, rendered)
  end

  test "uses suite typography tokens (suite-body / suite-description)" do
    rendered = render_component(@component)
    assert_includes rendered, "decor:suite-body"
    assert_includes rendered, "decor:suite-description"
  end

  test "other-user message uses gray author name and no primary tint" do
    rendered = render_component(@component)
    assert_includes rendered, "decor:text-gray-900"
    refute_includes rendered, "decor:bg-suite-primary-50"
    refute_includes rendered, "decor:text-suite-primary-700"
  end

  test "own-message uses suite-primary-50 row tint and primary author name color" do
    own = Decor::Suite::Chat::ListMessage.new(
      author_name: "Me",
      message: "My message",
      is_current_user: true
    )
    rendered = render_component(own)
    assert_includes rendered, "decor:bg-suite-primary-50"
    assert_includes rendered, "decor:text-suite-primary-700"
  end

  test "renders suite Avatar when initials present" do
    rendered = render_component(@component)
    assert_match(/decor--suite--avatar/, rendered)
    assert_includes rendered, "JG"
  end

  test "falls back to icon placeholder when no initials or image" do
    no_avatar_data = Decor::Suite::Chat::ListMessage.new(
      author_name: "Anonymous",
      message: "Hi"
    )
    rendered = render_component(no_avatar_data)
    assert_match(/aria-label="User"/, rendered)
    assert_includes rendered, "decor:bg-suite-gray-25"
  end

  test "show_avatar: false hides the avatar column entirely" do
    no_avatar = Decor::Suite::Chat::ListMessage.new(
      author_name: "Jane",
      author_initials: "J",
      message: "Hi",
      show_avatar: false
    )
    rendered = render_component(no_avatar)
    refute_match(/decor--suite--avatar/, rendered)
  end

  test "show_timestamp: false omits the <time> element" do
    no_time = Decor::Suite::Chat::ListMessage.new(
      author_name: "Jane",
      message: "Hi",
      show_timestamp: false
    )
    rendered = render_component(no_time)
    refute_match(/<time/, rendered)
  end

  test "older timestamps render as date (m/d), recent as time (H:M)" do
    old = Decor::Suite::Chat::ListMessage.new(
      author_name: "Jane",
      message: "Old",
      localised_created_at: 3.days.ago
    )
    recent = Decor::Suite::Chat::ListMessage.new(
      author_name: "Jane",
      message: "Recent",
      localised_created_at: 1.hour.ago
    )
    old_rendered = render_component(old)
    recent_rendered = render_component(recent)
    assert_match(%r{<time[^>]*>\d{2}/\d{2}</time>}, old_rendered)
    assert_match(/<time[^>]*>\d{2}:\d{2}<\/time>/, recent_rendered)
  end

  test "footer_text renders inside a suite-caption block" do
    with_footer = Decor::Suite::Chat::ListMessage.new(
      author_name: "Jane",
      message: "Hi",
      footer_text: "Delivered"
    )
    rendered = render_component(with_footer)
    assert_includes rendered, "Delivered"
    assert_includes rendered, "decor:suite-caption"
  end

  test "attachment block renders inside a suite-card panel above unspecified content" do
    with_attachment = Decor::Suite::Chat::ListMessage.new(
      author_name: "Jane",
      message: "See file"
    )
    rendered = render_component(with_attachment) do |m|
      m.attachment do
        div(class: "test-attachment") { "File.pdf" }
      end
    end
    assert_includes rendered, "File.pdf"
    assert_includes rendered, "decor:rounded-suite-card"
    assert_includes rendered, "decor:bg-suite-gray-25"
  end

  test "inherits from the components base" do
    assert @component.is_a?(Decor::Components::Chat::ListMessage)
  end
end
