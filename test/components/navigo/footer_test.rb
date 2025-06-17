require "test_helper"

class Navigo::FooterTest < ActiveSupport::TestCase
  test "renders successfully with required attributes" do
    component = Navigo::Footer.new(supplier_name: "Test Company")
    rendered = render_component(component)

    assert_includes rendered, "footer"
    assert_includes rendered, "Test Company"
  end

  test "renders with daisyUI footer classes" do
    component = Navigo::Footer.new(supplier_name: "Test Company")
    rendered = render_component(component)

    assert_includes rendered, "footer"
    assert_includes rendered, "bg-neutral"
    assert_includes rendered, "text-neutral-content"
  end

  test "renders with light theme" do
    component = Navigo::Footer.new(supplier_name: "Test Company", theme: :light)
    rendered = render_component(component)

    assert_includes rendered, "footer"
    assert_includes rendered, "bg-base-200"
    refute_includes rendered, "bg-neutral"
  end

  test "renders link groups with Literal::Data" do
    link_groups = [
      {
        title: "Products",
        links: [
          {label: "Feature A", href: "/feature-a"},
          {label: "Feature B", href: "/feature-b", external: true}
        ]
      }
    ]

    component = Navigo::Footer.new(
      supplier_name: "Test Company",
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
      {platform: :twitter, url: "https://twitter.com/test"},
      {platform: :github, url: "https://github.com/test"}
    ]

    component = Navigo::Footer.new(
      supplier_name: "Test Company",
      social_links: social_links
    )
    rendered = render_component(component)

    assert_includes rendered, "https://twitter.com/test"
    assert_includes rendered, "https://github.com/test"
    assert_includes rendered, "btn btn-ghost btn-circle"
  end

  test "supports logo content slot" do
    component = Navigo::Footer.new(supplier_name: "Test Company")
    rendered = render_component(component) do |c|
      c.with_logo { "<div>Custom Logo</div>" }
    end

    assert_includes rendered, "Custom Logo"
  end

  test "supports custom content slot" do
    component = Navigo::Footer.new(supplier_name: "Test Company")
    rendered = render_component(component) do |c|
      c.with_content { "<div>Footer content</div>" }
    end

    assert_includes rendered, "Footer content"
  end

  test "supports custom links slot" do
    component = Navigo::Footer.new(supplier_name: "Test Company")
    rendered = render_component(component) do |c|
      c.with_links { "<a href='/about'>About</a>" }
    end

    assert_includes rendered, "About"
  end

  test "supports copyright slot" do
    component = Navigo::Footer.new(supplier_name: "Test Company")
    rendered = render_component(component) do |c|
      c.with_copyright { "© 2024 Custom Copyright" }
    end

    assert_includes rendered, "© 2024 Custom Copyright"
  end

  test "renders newsletter section when configured" do
    mock_model = Struct.new.new
    component = Navigo::Footer.new(
      supplier_name: "Test Company",
      leads_model: mock_model,
      leads_submit_path: "/leads",
      show_newsletter: true
    )
    rendered = render_component(component)

    assert_includes rendered, "Subscribe to our newsletter"
    assert_includes rendered, "Stay in the loop"
  end

  test "hides newsletter section when disabled" do
    component = Navigo::Footer.new(
      supplier_name: "Test Company",
      show_newsletter: false
    )
    rendered = render_component(component)

    refute_includes rendered, "Subscribe to our newsletter"
  end

  test "renders only visible link groups" do
    link_groups = [
      {
        title: "Visible Group",
        visible: true,
        links: [{label: "Visible Link", href: "/visible"}]
      },
      {
        title: "Hidden Group",
        visible: false,
        links: [{label: "Hidden Link", href: "/hidden"}]
      }
    ]

    component = Navigo::Footer.new(
      supplier_name: "Test Company",
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
      {platform: :twitter, url: "https://twitter.com/test", visible: true},
      {platform: :facebook, url: "https://facebook.com/test", visible: false}
    ]

    component = Navigo::Footer.new(
      supplier_name: "Test Company",
      social_links: social_links
    )
    rendered = render_component(component)

    assert_includes rendered, "https://twitter.com/test"
    refute_includes rendered, "https://facebook.com/test"
  end

  test "component inherits from PhlexComponent" do
    component = Navigo::Footer.new(supplier_name: "Test Company")

    assert component.is_a?(Navigo::PhlexComponent)
  end

  test "validates required supplier_name attribute" do
    assert_raises(ArgumentError) do
      Navigo::Footer.new(supplier_name: "")
    end
  end
end
