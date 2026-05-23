require "test_helper"

class Decor::Daisy::LinkTest < ActiveSupport::TestCase
  test "renders basic link with label and href" do
    component = Decor::Daisy::Link.new(label: "Test Link", href: "/test")
    rendered = render_component(component)

    assert_includes rendered, "Test Link"
    assert_includes rendered, 'href="/test"'
    assert_includes rendered, "decor:d-btn-link"
    assert_includes rendered, "<a"
  end

  test "renders with different themes" do
    component = Decor::Daisy::Link.new(label: "Link", href: "#", color: :error)
    rendered = render_component(component)

    assert_includes rendered, "decor:d-link-error"
  end

  test "renders with different sizes" do
    component = Decor::Daisy::Link.new(label: "Link", href: "#", size: :lg)
    rendered = render_component(component)

    assert_includes rendered, "decor:text-lg"
  end

  test "renders disabled link" do
    component = Decor::Daisy::Link.new(label: "Disabled Link", href: "/test", disabled: true)
    rendered = render_component(component)

    assert_includes rendered, "Disabled Link"
    refute_includes rendered, 'href="/test"'
    assert_includes rendered, 'aria-disabled="true"'
    assert_includes rendered, "decor:text-gray-400"
    assert_includes rendered, "decor:cursor-not-allowed"
  end

  test "renders with icon" do
    component = Decor::Daisy::Link.new(label: "Link with Icon", href: "#", icon: "star")
    rendered = render_component(component)

    assert_includes rendered, "Link with Icon"
    assert_includes rendered, "star"
  end

  test "renders with target attribute" do
    component = Decor::Daisy::Link.new(label: "External", href: "https://example.com", target: "_blank")
    rendered = render_component(component)

    assert_includes rendered, 'target="_blank"'
    assert_includes rendered, 'href="https://example.com"'
  end

  test "renders with block content" do
    component = Decor::Daisy::Link.new(href: "/test")
    rendered = render_component(component) { "Block Content" }

    assert_includes rendered, "Block Content"
    assert_includes rendered, 'href="/test"'
  end

  test "renders with before and after slots" do
    component = Decor::Daisy::Link.new(label: "Link", href: "#")
    component.with_before_label { "Before" }
    component.with_after_label { "After" }

    rendered = render_component(component)

    assert_includes rendered, "Before"
    assert_includes rendered, "Link"
    assert_includes rendered, "After"
  end

  test "applies correct daisyUI link classes" do
    component = Decor::Daisy::Link.new(label: "Test", href: "#", color: :primary, size: :md)
    rendered = render_component(component)

    assert_includes rendered, "decor:d-btn-link"
    assert_includes rendered, "decor:d-link-primary"
    assert_includes rendered, "decor:text-base"
  end

  test "handles icon only on mobile" do
    component = Decor::Daisy::Link.new(
      label: "Mobile Icon",
      href: "#",
      icon: "star",
      icon_only_on_mobile: true
    )
    rendered = render_component(component)

    assert_includes rendered, "decor:hidden decor:md:inline"
  end
end
