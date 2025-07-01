require "test_helper"

class Decor::Nav::SideNavbarItemTest < ActiveSupport::TestCase
  test "renders successfully with DaisyUI classes" do
    component = Decor::Nav::SideNavbarItem.new(title: "Dashboard", path: "/dashboard")
    rendered = render_component(component)

    assert_includes rendered, "decor--nav--side-navbar-item"
    assert_includes rendered, "text-base-content"
    assert_includes rendered, "hover:bg-base-200"
  end

  test "renders as li element" do
    component = Decor::Nav::SideNavbarItem.new(title: "Dashboard", path: "/dashboard")
    fragment = render_fragment(component)

    li_element = fragment.at_css("li.decor--nav--side-navbar-item")
    assert_not_nil li_element
  end

  test "applies active styling when selected" do
    component = Decor::Nav::SideNavbarItem.new(title: "Dashboard", path: "/dashboard", selected: true)
    rendered = render_component(component)

    assert_includes rendered, "active"
    assert_includes rendered, "bg-primary"
    assert_includes rendered, "text-primary-content"
  end

  test "renders icon with proper styling" do
    component = Decor::Nav::SideNavbarItem.new(title: "Dashboard", path: "/dashboard", icon: "home")
    rendered = render_component(component)

    assert_includes rendered, "text-base-content/70"
    assert_includes rendered, "group-hover:text-primary"
  end

  test "renders counter badge" do
    component = Decor::Nav::SideNavbarItem.new(title: "Messages", path: "/messages", counter: 5)
    rendered = render_component(component)

    assert_includes rendered, "badge"
    assert_includes rendered, "badge-primary"
    assert_includes rendered, "5"
  end

  test "supports sub-items with details/summary" do
    component = Decor::Nav::SideNavbarItem.new(title: "Settings")
    component.with_sub_item(title: "Profile", path: "/profile")
    rendered = render_component(component)

    assert_includes rendered, "details"
    assert_includes rendered, "summary"
    assert_includes rendered, "Profile"
  end

  test "component inherits from PhlexComponent" do
    component = Decor::Nav::SideNavbarItem.new(title: "Dashboard", path: "/dashboard")

    assert component.is_a?(Decor::PhlexComponent)
  end
end
