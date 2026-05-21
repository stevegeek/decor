require "test_helper"

class Decor::ActsAsLinkTest < ActiveSupport::TestCase
  # Create a test component that includes the concern
  class TestLinkComponent < Decor::PhlexComponent
    include Decor::Concerns::ActsAsLink

    no_stimulus_controller

    prop :label, String
    prop :disabled, _Boolean, default: false

    def view_template
      root_element do
        @label
      end
    end

    def root_element_classes
      "test-link"
    end
  end

  test "provides link attributes" do
    component = TestLinkComponent.new(
      label: "Test",
      href: "/test",
      target: "_blank"
    )

    rendered = render_component(component)

    assert_includes rendered, 'href="/test"'
    assert_includes rendered, 'target="_blank"'
    assert_includes rendered, "<a"
  end

  test "handles disabled state" do
    component = TestLinkComponent.new(
      label: "Disabled",
      href: "/test",
      disabled: true
    )

    rendered = render_component(component)

    refute_includes rendered, 'href="/test"'
    assert_includes rendered, 'aria-disabled="true"'
    assert_includes rendered, 'role="link"'
    assert_includes rendered, 'tabindex="-1"'
  end

  test "adds data attributes" do
    component = TestLinkComponent.new(
      label: "Test",
      href: "/test",
      data: {confirm: "Are you sure?"}
    )

    rendered = render_component(component)

    assert_includes rendered, 'data-confirm="Are you sure?"'
  end

  test "adds HTTP method data attribute" do
    component = TestLinkComponent.new(
      label: "Delete",
      href: "/test",
      http_method: :delete
    )

    rendered = render_component(component)

    assert_includes rendered, 'data-turbo-method="delete"'
  end

  test "adds turbo frame attribute" do
    component = TestLinkComponent.new(
      label: "In Frame",
      href: "/test",
      turbo_frame: "modal"
    )

    rendered = render_component(component)

    assert_includes rendered, 'data-turbo-frame="modal"'
  end

  test "adds turbo confirm attribute" do
    component = TestLinkComponent.new(
      label: "Confirm",
      href: "/test",
      turbo_confirm: "Are you sure?"
    )

    rendered = render_component(component)

    assert_includes rendered, 'data-turbo-confirm="Are you sure?"'
  end

  test "disables turbo" do
    component = TestLinkComponent.new(
      label: "No Turbo",
      href: "/test",
      turbo: false
    )

    rendered = render_component(component)

    assert_includes rendered, 'data-turbo="false"'
  end

  test "combines multiple turbo attributes" do
    component = TestLinkComponent.new(
      label: "Complex",
      href: "/test",
      data: {custom: "value"},
      http_method: :post,
      turbo_frame: "_top",
      turbo_confirm: "Sure?"
    )

    rendered = render_component(component)

    assert_includes rendered, 'data-custom="value"'
    assert_includes rendered, 'data-turbo-method="post"'
    assert_includes rendered, 'data-turbo-frame="_top"'
    assert_includes rendered, 'data-turbo-confirm="Sure?"'
  end

  test "works without data attributes" do
    component = TestLinkComponent.new(
      label: "Simple",
      href: "/test"
    )

    rendered = render_component(component)

    assert_includes rendered, 'href="/test"'
    # Should not have turbo data attributes
    refute_includes rendered, "data-turbo-method"
    refute_includes rendered, "data-turbo-frame"
    refute_includes rendered, "data-turbo-confirm"
  end

  test "handles nil href gracefully" do
    component = TestLinkComponent.new(
      label: "No href"
    )

    rendered = render_component(component)

    refute_includes rendered, "href="
    assert_includes rendered, "<a"
  end

  # ── URL scheme XSS hardening ──────────────────────────────────────────────
  # Phlex 2.4 already strips `javascript:` URLs from REF attributes
  # (href/src/action/...). ActsAsLink extends that protection to `data:` and
  # `vbscript:` schemes, which Phlex passes through but can still deliver
  # XSS in some contexts (data:text/html in iframes; vbscript: in legacy IE).

  test "strips javascript: scheme from href (covered by Phlex)" do
    component = TestLinkComponent.new(label: "Evil", href: "javascript:alert(1)")
    rendered = render_component(component)
    refute_includes rendered, "javascript:"
    refute_includes rendered, "alert(1)"
  end

  test "strips data: scheme from href" do
    component = TestLinkComponent.new(label: "Evil", href: "data:text/html,<script>alert(1)</script>")
    rendered = render_component(component)
    refute_includes rendered, "data:text/html"
  end

  test "strips data: scheme with leading whitespace and casing variations" do
    %W[\tdata:text/html,foo \ndata:text/html,foo " DATA:text/html,foo Data:text/html,foo].each do |evil|
      component = TestLinkComponent.new(label: "Evil", href: evil)
      rendered = render_component(component)
      assert_not rendered.downcase.include?("data:text"),
        "Expected data: scheme to be stripped from href=#{evil.inspect}, got: #{rendered}"
    end
  end

  test "strips data: scheme with HTML-entity encoded colon" do
    component = TestLinkComponent.new(label: "Evil", href: "data&#58;text/html,foo")
    rendered = render_component(component)
    refute_includes rendered.downcase, "data:text"
    refute_includes rendered, "data&#58;text"
  end

  test "strips vbscript: scheme from href" do
    component = TestLinkComponent.new(label: "Evil", href: "vbscript:msgbox(1)")
    rendered = render_component(component)
    refute_includes rendered, "vbscript:"
  end

  test "allows http and https hrefs" do
    component = TestLinkComponent.new(label: "OK", href: "https://example.com/path?q=1")
    rendered = render_component(component)
    assert_includes rendered, 'href="https://example.com/path?q=1"'
  end

  test "allows mailto: and tel: schemes" do
    %w[mailto:test@example.com tel:+1234567890 sms:+1234567890].each do |href|
      component = TestLinkComponent.new(label: "OK", href: href)
      rendered = render_component(component)
      assert_includes rendered, %(href="#{href}")
    end
  end

  test "allows relative and fragment hrefs" do
    %w[/foo /foo/bar ?x=1 #section foo/bar].each do |href|
      component = TestLinkComponent.new(label: "OK", href: href)
      rendered = render_component(component)
      assert_includes rendered, %(href="#{href}"), "Expected relative href #{href} to be preserved"
    end
  end
end
