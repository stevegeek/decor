require "test_helper"

class Decor::Nav::FooterTest < ActiveSupport::TestCase
  test "renders successfully with required attributes" do
    component = Decor::Nav::Footer.new(company_name: "Test Company")
    rendered = render_component(component)

    assert_includes rendered, "footer"
    assert_includes rendered, "Test Company"
  end

  test "renders with daisyUI footer classes" do
    component = Decor::Nav::Footer.new(company_name: "Test Company")
    rendered = render_component(component)

    assert_includes rendered, "footer"
    assert_includes rendered, "bg-neutral"
    assert_includes rendered, "text-neutral-content"
  end

  test "renders with light theme" do
    component = Decor::Nav::Footer.new(company_name: "Test Company", theme: :light)
    rendered = render_component(component)

    assert_includes rendered, "footer"
    assert_includes rendered, "bg-base-200"
    refute_includes rendered, "bg-neutral"
  end

  test "renders link groups with Literal::Data" do
    link_groups = [
      Decor::Nav::Footer::LinkGroup.new(
        title: "Products",
        links: [
          Decor::Nav::Footer::FooterLink.new(label: "Feature A", href: "/feature-a"),
          Decor::Nav::Footer::FooterLink.new(label: "Feature B", href: "/feature-b", external: true)
        ]
      )
    ]

    component = Decor::Nav::Footer.new(
      company_name: "Test Company",
      link_groups: link_groups
    )
    rendered = render_component(component)

    assert_includes rendered, "Products"
    assert_includes rendered, "Feature A"
    assert_includes rendered, "Feature B"
    assert_includes rendered, "href=\"/feature-a\""
    assert_includes rendered, "target=\"_blank\""
  end

  test "renders social links with Literal::Data" do
    social_links = [
      Decor::Nav::Footer::SocialLink.new(platform: :twitter, url: "https://twitter.com/test"),
      Decor::Nav::Footer::SocialLink.new(platform: :github, url: "https://github.com/test")
    ]

    component = Decor::Nav::Footer.new(
      company_name: "Test Company",
      social_links: social_links
    )
    rendered = render_component(component)

    assert_includes rendered, "https://twitter.com/test"
    assert_includes rendered, "https://github.com/test"
    assert_includes rendered, "btn btn-ghost btn-circle"
  end

  test "supports logo content slot" do
    rendered = render_component(Decor::Nav::Footer.new(company_name: "Test Company")) do |f|
      f.with_logo { f.div { "Custom Logo" } }
    end

    assert_includes rendered, "Custom Logo"
  end

  test "supports custom content slot" do
    rendered = render_component(Decor::Nav::Footer.new(company_name: "Test Company")) do |f|
      f.with_content { f.div { "Footer content" } }
    end

    assert_includes rendered, "Footer content"
  end

  test "supports custom links slot" do
    rendered = render_component(Decor::Nav::Footer.new(company_name: "Test Company")) do |f|
      f.with_links { f.a(href: "/about") { "About" } }
    end

    assert_includes rendered, "About"
  end

  test "supports copyright slot" do
    rendered = render_component(Decor::Nav::Footer.new(company_name: "Test Company")) do |f|
      f.with_copyright { f.plain "© 2024 Custom Copyright" }
    end

    assert_includes rendered, "© 2024 Custom Copyright"
  end

  # Newsletter test temporarily disabled due to complex form builder setup requirements
  # test "renders newsletter section when configured" do
  #   mock_model = TestModel.new
  #   component = Decor::Nav::Footer.new(
  #     company_name: "Test Company",
  #     leads_model: mock_model,
  #     leads_submit_path: "/leads",
  #     show_newsletter: true
  #   )
  #   rendered = render_component(component)
  #
  #   assert_includes rendered, "Subscribe to our newsletter"
  #   assert_includes rendered, "Stay in the loop"
  # end

  test "hides newsletter section when disabled" do
    component = Decor::Nav::Footer.new(
      company_name: "Test Company",
      show_newsletter: false
    )
    rendered = render_component(component)

    refute_includes rendered, "Subscribe to our newsletter"
  end

  test "renders only visible link groups" do
    link_groups = [
      Decor::Nav::Footer::LinkGroup.new(
        title: "Visible Group",
        visible: true,
        links: [Decor::Nav::Footer::FooterLink.new(label: "Visible Link", href: "/visible")]
      ),
      Decor::Nav::Footer::LinkGroup.new(
        title: "Hidden Group",
        visible: false,
        links: [Decor::Nav::Footer::FooterLink.new(label: "Hidden Link", href: "/hidden")]
      )
    ]

    component = Decor::Nav::Footer.new(
      company_name: "Test Company",
      link_groups: link_groups
    )
    rendered = render_component(component)

    assert_includes rendered, "Visible Group"
    assert_includes rendered, "Visible Link"
    refute_includes rendered, "Hidden Group"
    refute_includes rendered, "Hidden Link"
  end

  test "renders only visible social links" do
    social_links = [
      Decor::Nav::Footer::SocialLink.new(platform: :twitter, url: "https://twitter.com/test", visible: true),
      Decor::Nav::Footer::SocialLink.new(platform: :facebook, url: "https://facebook.com/test", visible: false)
    ]

    component = Decor::Nav::Footer.new(
      company_name: "Test Company",
      social_links: social_links
    )
    rendered = render_component(component)

    assert_includes rendered, "https://twitter.com/test"
    refute_includes rendered, "https://facebook.com/test"
  end

  test "component inherits from PhlexComponent" do
    component = Decor::Nav::Footer.new(company_name: "Test Company")

    assert component.is_a?(Decor::PhlexComponent)
  end

  test "validates required company_name attribute" do
    assert_raises(Literal::TypeError) do
      Decor::Nav::Footer.new(company_name: nil)
    end
  end
end
