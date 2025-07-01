require "test_helper"

class Decor::Nav::SideNavbarTest < ActiveSupport::TestCase
  def setup
    @menu_items = [
      {
        title: "Navigation",
        items: [
          {
            title: "Dashboard",
            icon: "home",
            path: "/dashboard",
            selected: true
          }
        ]
      }
    ]
  end

  test "renders successfully with default attributes" do
    component = Decor::Nav::SideNavbar.new(
      landscape_logo_url: "/logo.png",
      avatar_logo_url: "/avatar.png",
      menu_items: @menu_items
    )
    rendered = render_component(component)

    assert_includes rendered, "decor--nav--side-navbar"
    assert_includes rendered, "bg-base-300"
  end

  test "renders with DaisyUI classes" do
    component = Decor::Nav::SideNavbar.new(
      landscape_logo_url: "/logo.png",
      avatar_logo_url: "/avatar.png",
      menu_items: @menu_items
    )
    rendered = render_component(component)

    assert_includes rendered, "bg-base-300"
    assert_includes rendered, "input-bordered"
  end

  test "supports collapsible behavior" do
    component = Decor::Nav::SideNavbar.new(
      landscape_logo_url: "/logo.png",
      avatar_logo_url: "/avatar.png",
      menu_items: @menu_items,
      collapsed: true
    )
    rendered = render_component(component)

    assert_includes rendered, "side-navbar-desktop"
    assert_includes rendered, "lg:w-20"
  end

  test "component inherits from PhlexComponent" do
    component = Decor::Nav::SideNavbar.new(
      landscape_logo_url: "/logo.png",
      avatar_logo_url: "/avatar.png",
      menu_items: @menu_items
    )

    assert component.is_a?(Decor::PhlexComponent)
  end

  test "renders search input with DaisyUI styling" do
    component = Decor::Nav::SideNavbar.new(
      landscape_logo_url: "/logo.png",
      avatar_logo_url: "/avatar.png",
      menu_items: @menu_items
    )
    rendered = render_component(component)

    assert_includes rendered, "input"
    assert_includes rendered, "input-bordered"
    assert_includes rendered, "text-base-content"
    assert_includes rendered, "focus:border-primary"
  end

  test "supports responsive design" do
    component = Decor::Nav::SideNavbar.new(
      landscape_logo_url: "/logo.png",
      avatar_logo_url: "/avatar.png",
      menu_items: @menu_items
    )
    rendered = render_component(component)

    assert_includes rendered, "lg:fixed"
    assert_includes rendered, "lg:w-72"
  end

  test "renders navigation items" do
    component = Decor::Nav::SideNavbar.new(
      landscape_logo_url: "/logo.png",
      avatar_logo_url: "/avatar.png",
      menu_items: @menu_items
    )
    rendered = render_component(component)

    assert_includes rendered, "Dashboard"
    assert_includes rendered, "Navigation"
  end
end
