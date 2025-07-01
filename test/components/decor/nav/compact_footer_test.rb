require "test_helper"

class Decor::Nav::CompactFooterTest < ActiveSupport::TestCase
  test "renders successfully with required attributes" do
    component = Decor::Nav::CompactFooter.new(
      company_name: "Test Company"
    )
    rendered = render_component(component)

    assert_includes rendered, "footer"
    assert_includes rendered, "footer-center"
    assert_includes rendered, "Test Company"
  end

  test "renders with daisyUI footer classes" do
    component = Decor::Nav::CompactFooter.new(
      company_name: "Test Company"
    )
    rendered = render_component(component)

    assert_includes rendered, "footer"
    assert_includes rendered, "footer-center"
    assert_includes rendered, "bg-neutral"  # Default theme is :dark
    assert_includes rendered, "text-neutral-content"
  end

  test "renders with dark theme" do
    component = Decor::Nav::CompactFooter.new(
      company_name: "Test Company",
      theme: :dark
    )
    rendered = render_component(component)

    assert_includes rendered, "footer"
    assert_includes rendered, "bg-neutral"
    assert_includes rendered, "text-neutral-content"
  end

  test "renders social links with Literal::Data" do
    social_links = [
      Decor::Nav::Footer::SocialLink.new(platform: :twitter, url: "https://twitter.com/test"),
      Decor::Nav::Footer::SocialLink.new(platform: :github, url: "https://github.com/test")
    ]

    component = Decor::Nav::CompactFooter.new(
      company_name: "Test Company",
      social_links: social_links
    )
    rendered = render_component(component)

    assert_includes rendered, "https://twitter.com/test"
    assert_includes rendered, "https://github.com/test"
    assert_includes rendered, "btn btn-ghost btn-circle btn-sm"
  end

  test "renders footer links with Literal::Data" do
    footer_links = [
      Decor::Nav::Footer::FooterLink.new(label: "Support", href: "/support"),
      Decor::Nav::Footer::FooterLink.new(label: "Privacy", href: "/privacy", external: true)
    ]

    component = Decor::Nav::CompactFooter.new(
      company_name: "Test Company",
      footer_links: footer_links
    )
    rendered = render_component(component)

    assert_includes rendered, "Support"
    assert_includes rendered, "Privacy"
    assert_includes rendered, "href=\"/support\""
    assert_includes rendered, "target=\"_blank\""
  end

  test "supports logo content slot" do
    rendered = render_component(Decor::Nav::CompactFooter.new(company_name: "Test Company")) do |f|
      f.with_logo { f.div { "Custom Logo" } }
    end

    assert_includes rendered, "Custom Logo"
  end

  test "supports custom links slot" do
    rendered = render_component(Decor::Nav::CompactFooter.new(company_name: "Test Company")) do |f|
      f.with_links { f.a(href: "/custom") { "Custom Link" } }
    end

    assert_includes rendered, "Custom Link"
  end

  test "supports copyright slot" do
    rendered = render_component(Decor::Nav::CompactFooter.new(company_name: "Test Company")) do |f|
      f.with_copyright { f.plain "© 2024 Custom Copyright" }
    end

    assert_includes rendered, "© 2024 Custom Copyright"
  end

  test "hides logo when show_logo is false" do
    component = Decor::Nav::CompactFooter.new(
      company_name: "Test Company",
      show_logo: false
    )
    rendered = render_component(component)

    refute_includes rendered, "logo-type-color-black.svg"
  end

  test "renders only visible social links" do
    social_links = [
      Decor::Nav::Footer::SocialLink.new(platform: :twitter, url: "https://twitter.com/test", visible: true),
      Decor::Nav::Footer::SocialLink.new(platform: :facebook, url: "https://facebook.com/test", visible: false)
    ]

    component = Decor::Nav::CompactFooter.new(
      company_name: "Test Company",
      social_links: social_links
    )
    rendered = render_component(component)

    assert_includes rendered, "https://twitter.com/test"
    refute_includes rendered, "https://facebook.com/test"
  end

  test "renders all supported social platforms" do
    social_links = [
      Decor::Nav::Footer::SocialLink.new(platform: :facebook, url: "https://facebook.com/test"),
      Decor::Nav::Footer::SocialLink.new(platform: :twitter, url: "https://twitter.com/test"),
      Decor::Nav::Footer::SocialLink.new(platform: :instagram, url: "https://instagram.com/test"),
      Decor::Nav::Footer::SocialLink.new(platform: :linkedin, url: "https://linkedin.com/company/test"),
      Decor::Nav::Footer::SocialLink.new(platform: :youtube, url: "https://youtube.com/@test"),
      Decor::Nav::Footer::SocialLink.new(platform: :github, url: "https://github.com/test")
    ]

    component = Decor::Nav::CompactFooter.new(
      company_name: "Test Company",
      social_links: social_links
    )
    rendered = render_component(component)

    social_links.each do |link|
      assert_includes rendered, link.url
    end
  end

  test "renders external link attributes correctly" do
    footer_links = [
      Decor::Nav::Footer::FooterLink.new(label: "Internal", href: "/internal", external: false),
      Decor::Nav::Footer::FooterLink.new(label: "External", href: "https://external.com", external: true)
    ]

    component = Decor::Nav::CompactFooter.new(
      company_name: "Test Company",
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
    component = Decor::Nav::CompactFooter.new(
      company_name: "Test Company"
    )

    assert component.is_a?(Decor::PhlexComponent)
  end

  test "validates required company_name attribute" do
    assert_raises(Dry::Struct::Error) do
      Decor::Nav::CompactFooter.new(
        company_name: ""
      )
    end
  end
end
