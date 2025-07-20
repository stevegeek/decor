require "test_helper"

class Decor::Nav::TopNavbarTest < ActiveSupport::TestCase
  test "renders successfully with default attributes" do
    component = Decor::Nav::TopNavbar.new
    rendered = render_component(component)

    assert_includes rendered, "navbar"
    assert_includes rendered, "decor--nav--top-navbar"
  end

  test "renders with daisyUI navbar classes" do
    component = Decor::Nav::TopNavbar.new
    rendered = render_component(component)

    assert_includes rendered, "navbar"
    assert_includes rendered, "bg-base-100"
  end

  test "supports account menu" do
    component = Decor::Nav::TopNavbar.new
    component.with_account_menu(position: :right) do |menu|
      plain "Account Menu Test"
    end
    rendered = render_component(component)

    assert_includes rendered, "Account Menu Test"
  end

  test "supports notifications menu" do
    component = Decor::Nav::TopNavbar.new
    component.with_notifications_menu(position: :right) do |menu|
      menu.trigger_button_content { "Notifications" }
      menu.menu_item(::Decor::DropdownItem.new(text: "Alert", href: "#"))
    end
    rendered = render_component(component)

    assert_includes rendered, "Notifications"
  end

  test "supports both account and notifications menus" do
    component = Decor::Nav::TopNavbar.new
    component.with_account_menu(position: :right) do |menu|
      menu.trigger_button_content { "Account" }
    end
    component.with_notifications_menu(position: :right) do |menu|
      menu.trigger_button_content { "Notifications" }
    end
    rendered = render_component(component)

    assert_includes rendered, "Account"
    assert_includes rendered, "Notifications"
  end

  test "component inherits from PhlexComponent" do
    component = Decor::Nav::TopNavbar.new

    assert component.is_a?(Decor::PhlexComponent)
  end

  test "renders with correct HTML structure" do
    component = Decor::Nav::TopNavbar.new
    fragment = render_fragment(component)

    navbar = fragment.at_css(".navbar")
    assert_not_nil navbar
    assert_includes navbar["class"], "decor--nav--top-navbar"
  end

  test "supports custom CSS classes" do
    component = Decor::Nav::TopNavbar.new(html_options: {class: "custom-navbar"})
    rendered = render_component(component)

    assert_includes rendered, "custom-navbar"
    assert_includes rendered, "navbar"
  end

  test "renders without slots when none provided" do
    component = Decor::Nav::TopNavbar.new
    rendered = render_component(component)

    assert_includes rendered, "navbar"
    assert_includes rendered, "decor--nav--top-navbar"
  end

  test "applies responsive navbar styling" do
    component = Decor::Nav::TopNavbar.new
    rendered = render_component(component)

    assert_includes rendered, "navbar"
    assert_includes rendered, "bg-base-100"
  end

  test "supports shadow styling" do
    component = Decor::Nav::TopNavbar.new
    rendered = render_component(component)

    assert_includes rendered, "shadow-lg"
  end

  test "renders search functionality by default" do
    component = Decor::Nav::TopNavbar.new
    rendered = render_component(component)

    assert_includes rendered, "search-input"
    assert_includes rendered, "form-control"
  end

  test "can disable search functionality" do
    component = Decor::Nav::TopNavbar.new(has_search: false)
    rendered = render_component(component)

    assert_not_includes rendered, "search-input"
  end

  test "includes mobile menu button" do
    component = Decor::Nav::TopNavbar.new
    component.with_nav_items do
      # Add some nav items to trigger mobile menu button
    end
    rendered = render_component(component)

    assert_includes rendered, "lg:hidden"
    assert_includes rendered, "Open sidebar"
  end

  test "has navbar structure sections" do
    component = Decor::Nav::TopNavbar.new
    rendered = render_component(component)

    assert_includes rendered, "navbar-start"
    assert_includes rendered, "navbar-center"
    assert_includes rendered, "navbar-end"
  end
end
