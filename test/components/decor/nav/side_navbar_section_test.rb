require "test_helper"

class Decor::Nav::SideNavbarSectionTest < ActiveSupport::TestCase
  test "renders successfully with menu classes" do
    component = Decor::Nav::SideNavbarSection.new(title: "Navigation")
    rendered = render_component(component)

    assert_includes rendered, "decor--nav--side-navbar-section"
    assert_includes rendered, "menu"
    assert_includes rendered, "menu-vertical"
  end

  test "renders title with DaisyUI menu-title class" do
    component = Decor::Nav::SideNavbarSection.new(title: "Settings")
    rendered = render_component(component)

    assert_includes rendered, "menu-title"
    assert_includes rendered, "text-base-content/70"
    assert_includes rendered, "Settings"
  end

  test "renders as ul element" do
    component = Decor::Nav::SideNavbarSection.new(title: "Navigation")
    fragment = render_fragment(component)

    ul_element = fragment.at_css("ul.decor--nav--side-navbar-section")
    assert_not_nil ul_element
  end

  test "supports items" do
    component = Decor::Nav::SideNavbarSection.new(title: "Navigation")
    component.with_item(title: "Dashboard", path: "/dashboard")
    rendered = render_component(component)

    assert_includes rendered, "Dashboard"
  end

  test "component inherits from PhlexComponent" do
    component = Decor::Nav::SideNavbarSection.new(title: "Navigation")

    assert component.is_a?(Decor::PhlexComponent)
  end
end
