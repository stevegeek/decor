require "test_helper"

class Decor::Nav::SideNavbarSubItemTest < ActiveSupport::TestCase
  test "renders successfully with DaisyUI classes" do
    component = Decor::Nav::SideNavbarSubItem.new(title: "Profile", path: "/profile")
    rendered = render_component(component)

    assert_includes rendered, "decor--nav--side-navbar-sub-item"
    assert_includes rendered, "text-base-content"
    assert_includes rendered, "hover:bg-base-200"
  end

  test "renders as li element" do
    component = Decor::Nav::SideNavbarSubItem.new(title: "Profile", path: "/profile")
    fragment = render_fragment(component)

    li_element = fragment.at_css("li.decor--nav--side-navbar-sub-item")
    assert_not_nil li_element
  end

  test "applies active styling when selected" do
    component = Decor::Nav::SideNavbarSubItem.new(title: "Profile", path: "/profile", selected: true)
    rendered = render_component(component)

    assert_includes rendered, "active"
    assert_includes rendered, "bg-primary"
    assert_includes rendered, "text-primary-content"
  end

  test "renders icon with proper styling" do
    component = Decor::Nav::SideNavbarSubItem.new(title: "Profile", path: "/profile", icon: "user")
    rendered = render_component(component)

    assert_includes rendered, "text-base-content/70"
    assert_includes rendered, "group-hover:text-primary"
  end

  test "defaults path to hash when not provided" do
    component = Decor::Nav::SideNavbarSubItem.new(title: "Profile")
    rendered = render_component(component)

    assert_includes rendered, 'href="#"'
  end

  test "component inherits from PhlexComponent" do
    component = Decor::Nav::SideNavbarSubItem.new(title: "Profile", path: "/profile")

    assert component.is_a?(Decor::PhlexComponent)
  end
end
