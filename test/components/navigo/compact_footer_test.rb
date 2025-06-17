require "test_helper"

class Navigo::CompactFooterTest < ActiveSupport::TestCase
  test "renders successfully with required attributes" do
    component = Navigo::CompactFooter.new(
      supplier_name: "Test Company",
      supplier_support_email_address: "support@test.com"
    )
    rendered = render_component(component)

    assert_includes rendered, "footer"
    assert_includes rendered, "footer-center"
    assert_includes rendered, "Test Company"
  end

  test "renders with daisyUI footer classes" do
    component = Navigo::CompactFooter.new(
      supplier_name: "Test Company",
      supplier_support_email_address: "support@test.com"
    )
    rendered = render_component(component)

    assert_includes rendered, "footer"
    assert_includes rendered, "footer-center"
    assert_includes rendered, "bg-base-200"
  end

  test "renders with dark theme" do
    component = Navigo::CompactFooter.new(
      supplier_name: "Test Company",
      supplier_support_email_address: "support@test.com",
      theme: :dark
    )
    rendered = render_component(component)

    assert_includes rendered, "footer"
    assert_includes rendered, "bg-neutral"
    assert_includes rendered, "text-neutral-content"
  end

  test "renders social links with Literal::Data" do
    social_links = [
      {platform: :twitter, url: "https://twitter.com/test"},
      {platform: :github, url: "https://github.com/test"}
    ]

    component = Navigo::CompactFooter.new(
      supplier_name: "Test Company",
      supplier_support_email_address: "support@test.com",
      social_links: social_links
    )
    rendered = render_component(component)

    assert_includes rendered, "https://twitter.com/test"
    assert_includes rendered, "https://github.com/test"
    assert_includes rendered, "btn btn-ghost btn-circle btn-sm"
  end

  test "renders footer links with Literal::Data" do
    footer_links = [
      {label: "Support", href: "/support"},
      {label: "Privacy", href: "/privacy", external: true}
    ]

    component = Navigo::CompactFooter.new(
      supplier_name: "Test Company",
      supplier_support_email_address: "support@test.com",
      footer_links: footer_links
    )
    rendered = render_component(component)

    assert_includes rendered, "Support"
    assert_includes rendered, "Privacy"
    assert_includes rendered, "href=\"/support\""
    assert_includes rendered, "target=\"_blank\""
  end

  test "supports legacy social media attributes" do
    component = Navigo::CompactFooter.new(
      supplier_name: "Test Company",
      supplier_support_email_address: "support@test.com",
      facebook_url: "https://facebook.com/test",
      twitter_url: "https://twitter.com/test",
      linkedin_url: "https://linkedin.com/company/test"
    )
    rendered = render_component(component)

    assert_includes rendered, "https://facebook.com/test"
    assert_includes rendered, "https://twitter.com/test"
    assert_includes rendered, "https://linkedin.com/company/test"
  end

  test "supports logo content slot" do
    component = Navigo::CompactFooter.new(
      supplier_name: "Test Company",
      supplier_support_email_address: "support@test.com"
    )
    rendered = render_component(component) do |c|
      c.with_logo { "<div>Custom Logo</div>" }
    end

    assert_includes rendered, "Custom Logo"
  end

  test "supports custom links slot" do
    component = Navigo::CompactFooter.new(
      supplier_name: "Test Company",
      supplier_support_email_address: "support@test.com"
    )
    rendered = render_component(component) do |c|
      c.with_links { "<a href='/custom'>Custom Link</a>" }
    end

    assert_includes rendered, "Custom Link"
  end

  test "supports copyright slot" do
    component = Navigo::CompactFooter.new(
      supplier_name: "Test Company",
      supplier_support_email_address: "support@test.com"
    )
    rendered = render_component(component) do |c|
      c.with_copyright { "© 2024 Custom Copyright" }
    end

    assert_includes rendered, "© 2024 Custom Copyright"
  end

  test "hides logo when show_logo is false" do
    component = Navigo::CompactFooter.new(
      supplier_name: "Test Company",
      supplier_support_email_address: "support@test.com",
      show_logo: false
    )
    rendered = render_component(component)

    refute_includes rendered, "logo-type-color-black.svg"
  end

  test "renders only visible social links" do
    social_links = [
      {platform: :twitter, url: "https://twitter.com/test", visible: true},
      {platform: :facebook, url: "https://facebook.com/test", visible: false}
    ]

    component = Navigo::CompactFooter.new(
      supplier_name: "Test Company",
      supplier_support_email_address: "support@test.com",
      social_links: social_links
    )
    rendered = render_component(component)

    assert_includes rendered, "https://twitter.com/test"
    refute_includes rendered, "https://facebook.com/test"
  end

  test "renders all supported social platforms" do
    social_links = [
      {platform: :facebook, url: "https://facebook.com/test"},
      {platform: :twitter, url: "https://twitter.com/test"},
      {platform: :instagram, url: "https://instagram.com/test"},
      {platform: :linkedin, url: "https://linkedin.com/company/test"},
      {platform: :youtube, url: "https://youtube.com/@test"},
      {platform: :github, url: "https://github.com/test"}
    ]

    component = Navigo::CompactFooter.new(
      supplier_name: "Test Company",
      supplier_support_email_address: "support@test.com",
      social_links: social_links
    )
    rendered = render_component(component)

    social_links.each do |link|
      assert_includes rendered, link[:url]
    end
  end

  test "renders external link attributes correctly" do
    footer_links = [
      {label: "Internal", href: "/internal", external: false},
      {label: "External", href: "https://external.com", external: true}
    ]

    component = Navigo::CompactFooter.new(
      supplier_name: "Test Company",
      supplier_support_email_address: "support@test.com",
      footer_links: footer_links
    )
    rendered = render_component(component)

    # Internal link should not have target="_blank"
    internal_link_match = rendered.match(%r{<a[^>]*href="/internal"[^>]*>})
    refute_nil internal_link_match
    refute_includes internal_link_match[0], 'target="_blank"'

    # External link should have target="_blank" and rel attributes
    external_link_match = rendered.match(%r{<a[^>]*href="https://external.com"[^>]*>})
    refute_nil external_link_match
    assert_includes external_link_match[0], 'target="_blank"'
    assert_includes external_link_match[0], 'rel="noopener noreferrer"'
  end

  test "component inherits from PhlexComponent" do
    component = Navigo::CompactFooter.new(
      supplier_name: "Test Company",
      supplier_support_email_address: "support@test.com"
    )

    assert component.is_a?(Navigo::PhlexComponent)
  end

  test "validates required supplier_name attribute" do
    assert_raises(ArgumentError) do
      Navigo::CompactFooter.new(
        supplier_name: "",
        supplier_support_email_address: "support@test.com"
      )
    end
  end

  test "validates required supplier_support_email_address attribute" do
    assert_raises(ArgumentError) do
      Navigo::CompactFooter.new(
        supplier_name: "Test Company",
        supplier_support_email_address: ""
      )
    end
  end
end
