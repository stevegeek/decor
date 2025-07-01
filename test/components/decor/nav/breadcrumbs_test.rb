require "test_helper"

class Decor::Nav::BreadcrumbsTest < ActiveSupport::TestCase
  test "renders successfully with hash array" do
    crumbs = [
      {
        name: "Home",
        path: "/"
      },
      {
        name: "Beef",
        path: "/beef"
      },
      {
        name: "Fabricated",
        path: "/fabricated",
        current: true
      }
    ]

    component = Decor::Nav::Breadcrumbs.new(breadcrumbs: crumbs)
    rendered = render_component(component)

    assert_includes rendered, "breadcrumbs"
    assert_includes rendered, "Fabricated"
    assert_includes rendered, "Beef"
    assert_includes rendered, "aria-current=\"page\""
  end

  test "renders with Literal::Data objects" do
    crumbs = [
      Decor::Nav::Breadcrumbs::Breadcrumb.new(name: "Home", path: "/"),
      Decor::Nav::Breadcrumbs::Breadcrumb.new(name: "Products", path: "/products"),
      Decor::Nav::Breadcrumbs::Breadcrumb.new(name: "Current Page", path: "/current", current: true)
    ]

    component = Decor::Nav::Breadcrumbs.new(breadcrumbs: crumbs)
    rendered = render_component(component)

    assert_includes rendered, "breadcrumbs"
    assert_includes rendered, "Products"
    assert_includes rendered, "Current Page"
    assert_includes rendered, "aria-current=\"page\""
  end

  test "handles empty breadcrumbs array" do
    component = Decor::Nav::Breadcrumbs.new(breadcrumbs: [])
    rendered = render_component(component)

    assert_includes rendered, "breadcrumbs"
    # Should still show home link by default
    assert_includes rendered, "Home"
  end

  test "supports custom home configuration" do
    component = Decor::Nav::Breadcrumbs.new(
      breadcrumbs: [],
      home_path: "/dashboard",
      home_icon: "dashboard"
    )
    rendered = render_component(component)

    assert_includes rendered, "href=\"/dashboard\""
  end

  test "hides home link when show_home is false" do
    component = Decor::Nav::Breadcrumbs.new(
      breadcrumbs: [{name: "Test", path: "/test"}],
      show_home: false
    )
    rendered = render_component(component)

    refute_includes rendered, "sr-only\">Home</span>"
  end

  test "renders with icons" do
    crumbs = [
      {name: "Dashboard", path: "/dashboard", icon: "dashboard"},
      {name: "Settings", path: "/settings", icon: "cog", current: true}
    ]

    component = Decor::Nav::Breadcrumbs.new(breadcrumbs: crumbs)
    rendered = render_component(component)

    assert_includes rendered, "Dashboard"
    assert_includes rendered, "Settings"
  end

  test "handles disabled breadcrumbs" do
    crumbs = [
      {name: "Active", path: "/active"},
      {name: "Disabled", path: "/disabled", disabled: true},
      {name: "Current", path: "/current", current: true}
    ]

    component = Decor::Nav::Breadcrumbs.new(breadcrumbs: crumbs)
    rendered = render_component(component)

    assert_includes rendered, "Active"
    assert_includes rendered, "Disabled"
    assert_includes rendered, "Current"
    # Disabled items should not be links
    refute_includes rendered, "href=\"/disabled\""
  end

  test "supports mobile navigation" do
    crumbs = [
      {name: "Level 1", path: "/level1"},
      {name: "Level 2", path: "/level2", current: true}
    ]

    component = Decor::Nav::Breadcrumbs.new(breadcrumbs: crumbs, mobile_select: true)
    rendered = render_component(component)

    assert_includes rendered, "Mobile navigation:"
    assert_includes rendered, "Level 1"
    assert_includes rendered, "Level 2"
    assert_includes rendered, "md:hidden"
  end

  test "hides mobile navigation when disabled" do
    crumbs = [{name: "Test", path: "/test"}]

    component = Decor::Nav::Breadcrumbs.new(breadcrumbs: crumbs, mobile_select: false)
    rendered = render_component(component)

    refute_includes rendered, "Mobile navigation:"
    refute_includes rendered, "md:hidden mt-4"
  end

  test "supports backward compatibility with label/href format" do
    crumbs = [
      {label: "Home", href: "/"},
      {label: "Products", href: "/products"},
      {label: "Current", href: "/current", current: true}
    ]

    component = Decor::Nav::Breadcrumbs.new(breadcrumbs: crumbs)
    rendered = render_component(component)

    assert_includes rendered, "Products"
    assert_includes rendered, "href=\"/products\""
    assert_includes rendered, "aria-current=\"page\""
  end

  test "handles mixed format arrays" do
    crumbs = [
      {name: "Home", path: "/"},
      {label: "Products", href: "/products"},
      Decor::Nav::Breadcrumbs::Breadcrumb.new(name: "Current", path: "/current", current: true)
    ]

    component = Decor::Nav::Breadcrumbs.new(breadcrumbs: crumbs)
    rendered = render_component(component)

    assert_includes rendered, "Products"
    assert_includes rendered, "Current"
    assert_includes rendered, "aria-current=\"page\""
  end

  test "component inherits from PhlexComponent" do
    component = Decor::Nav::Breadcrumbs.new(breadcrumbs: [])

    assert component.is_a?(Decor::PhlexComponent)
  end

  test "uses daisyUI breadcrumbs class" do
    component = Decor::Nav::Breadcrumbs.new(breadcrumbs: [])
    rendered = render_component(component)

    assert_includes rendered, "breadcrumbs"
  end

  test "includes proper accessibility attributes" do
    component = Decor::Nav::Breadcrumbs.new(breadcrumbs: [])
    rendered = render_component(component)

    assert_includes rendered, "aria-label=\"Breadcrumb\""
  end

  test "handles objects with duck typing (legacy compatibility)" do
    # Create a mock object that responds to name and path like Loaf::Breadcrumb would
    mock_crumb = Struct.new(:name, :path, :current).new("Legacy", "/legacy", false)

    component = Decor::Nav::Breadcrumbs.new(breadcrumbs: [mock_crumb])
    rendered = render_component(component)

    assert_includes rendered, "Legacy"
    assert_includes rendered, "href=\"/legacy\""
  end
end
