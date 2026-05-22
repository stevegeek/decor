# frozen_string_literal: true

require "test_helper"

class ::Decor::Suite::CardTest < ActiveSupport::TestCase
  test "body-only renders content inside body wrapper with suite-description token" do
    html = render_component(::Decor::Suite::Card.new) { "body-content".html_safe }
    assert_includes html, "body-content"
    assert_includes html, "decor:suite-description"
    assert_includes html, "decor:text-gray-500"
  end

  test "root has suite surface chrome" do
    html = render_component(::Decor::Suite::Card.new) { "x".html_safe }
    assert_includes html, "decor:bg-white"
    assert_includes html, "decor:border-suite-hairline"
    assert_includes html, "decor:rounded-suite-card"
  end

  test "with_header block renders header row with suite-hairline border" do
    html = render_component(::Decor::Suite::Card.new) do |card|
      card.with_header { "header-content".html_safe }
      "body".html_safe
    end
    assert_includes html, "header-content"
    assert_includes html, "decor:border-b"
    assert_includes html, "decor:border-suite-hairline"
  end

  test "with_title block renders title row with suite-dense-body semibold text" do
    html = render_component(::Decor::Suite::Card.new) do |card|
      card.with_title { "Title here" }
      "body".html_safe
    end
    assert_includes html, "Title here"
    assert_includes html, "decor:suite-dense-body"
    assert_includes html, "decor:font-semibold"
    assert_includes html, "decor:text-gray-900"
  end

  test "with_footer block renders footer with gray-25 bar and right-aligned actions" do
    html = render_component(::Decor::Suite::Card.new) do |card|
      card.with_footer { "footer-content".html_safe }
      "body".html_safe
    end
    assert_includes html, "footer-content"
    assert_includes html, "decor:bg-suite-gray-25"
    assert_includes html, "decor:justify-end"
    assert_includes html, "decor:border-t"
    assert_includes html, "decor:border-suite-hairline"
  end

  test "renders header, title, body, footer in document order" do
    html = render_component(::Decor::Suite::Card.new) do |card|
      card.with_header { "HEADER_SLOT".html_safe }
      card.with_title { "TITLE_SLOT" }
      card.with_footer { "FOOTER_SLOT".html_safe }
      "BODY_SLOT".html_safe
    end
    header_at = html.index("HEADER_SLOT")
    title_at = html.index("TITLE_SLOT")
    body_at = html.index("BODY_SLOT")
    footer_at = html.index("FOOTER_SLOT")
    assert header_at, "header missing"
    assert title_at, "title missing"
    assert body_at, "body missing"
    assert footer_at, "footer missing"
    assert header_at < title_at, "header should precede title"
    assert title_at < body_at, "title should precede body"
    assert body_at < footer_at, "body should precede footer"
  end
end
