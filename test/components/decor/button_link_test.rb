# frozen_string_literal: true

require "test_helper"

class Decor::ButtonLinkTest < ActiveSupport::TestCase
  def test_renders_as_link_when_not_disabled
    component = Decor::ButtonLink.new(
      label: "Click me",
      href: "/test-url"
    )

    rendered = render_fragment(component)

    # Should render as anchor tag
    link = rendered.css("a").first
    assert link
    assert_equal "/test-url", link["href"]
    assert_includes rendered.text, "Click me"
  end

  def test_renders_as_button_when_disabled
    component = Decor::ButtonLink.new(
      label: "Disabled",
      href: "/test-url",
      disabled: true
    )

    rendered = render_fragment(component)

    # Should render as button when disabled
    button = rendered.css("button").first
    assert button
    assert_equal "disabled", button["disabled"]

    # Should not have working href
    link = rendered.css("a").first
    assert_nil link
  end

  def test_adds_data_attributes
    component = Decor::ButtonLink.new(
      label: "Submit",
      href: "/submit",
      data: {confirm: "Are you sure?"}
    )

    rendered = render_fragment(component)

    link = rendered.css("a").first
    assert link
    # Data attributes are added by the framework
    assert_includes rendered.to_html, "confirm"
  end

  def test_adds_http_method_data
    component = Decor::ButtonLink.new(
      label: "Delete",
      href: "/delete",
      http_method: :delete
    )

    rendered = render_fragment(component)

    link = rendered.css("a").first
    assert link
    assert_equal "delete", link["data-turbo-method"]
  end

  def test_adds_turbo_frame_data
    component = Decor::ButtonLink.new(
      label: "In Frame",
      href: "/frame",
      turbo_frame: "modal"
    )

    rendered = render_fragment(component)

    link = rendered.css("a").first
    assert link
    assert_equal "modal", link["data-turbo-frame"]
  end

  def test_inherits_button_styling
    component = Decor::ButtonLink.new(
      label: "Styled Link",
      href: "/test",
      theme: :primary,
      size: :large
    )

    rendered = render_fragment(component)

    # Should have daisyUI button classes from parent
    assert_includes rendered.to_html, "btn"
    assert_includes rendered.to_html, "btn-primary"
    assert_includes rendered.to_html, "btn-lg"
    assert_includes rendered.to_html, "text-center"
  end

  def test_with_icon
    component = Decor::ButtonLink.new(
      label: "With Icon",
      href: "/test",
      icon: "star"
    )

    rendered = render_fragment(component)

    # Should render icon
    assert_includes rendered.to_html, "star"
    assert_includes rendered.text, "With Icon"
  end
end
