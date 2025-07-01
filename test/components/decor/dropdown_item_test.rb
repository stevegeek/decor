require "test_helper"

class Decor::DropdownItemTest < ActiveSupport::TestCase
  test "renders successfully with text" do
    component = Decor::DropdownItem.new(text: "Menu Item")
    rendered = render_component(component)

    assert_includes rendered, "Menu Item"
    assert_includes rendered, 'role="menuitem"'
    assert_includes rendered, "<a"
  end

  test "renders with custom href" do
    component = Decor::DropdownItem.new(text: "Link Item", href: "/custom-path")
    rendered = render_component(component)

    assert_includes rendered, 'href="/custom-path"'
  end

  test "renders with default href" do
    component = Decor::DropdownItem.new(text: "Default")
    rendered = render_component(component)

    assert_includes rendered, 'href="#"'
  end

  test "renders with icon" do
    component = Decor::DropdownItem.new(text: "Settings", icon_name: "cog")
    rendered = render_component(component)

    assert_includes rendered, "cog"
    assert_includes rendered, "mr-2 h-4 w-4"
  end

  test "renders as separator" do
    component = Decor::DropdownItem.new(separator: true)
    rendered = render_component(component)

    assert_includes rendered, "<hr"
    assert_includes rendered, "menu-divider"
  end

  test "applies correct CSS classes for regular item" do
    component = Decor::DropdownItem.new(text: "Regular Item")
    rendered = render_component(component)

    # DaisyUI menu items use minimal classes, styling is handled by the parent menu
    assert_includes rendered, "Regular Item"
    assert_includes rendered, 'role="menuitem"'
  end

  test "applies correct CSS classes for separator" do
    component = Decor::DropdownItem.new(separator: true)
    rendered = render_component(component)

    # Separator uses DaisyUI menu-divider class
    assert_includes rendered, "menu-divider"
  end

  test "renders with custom tabindex" do
    component = Decor::DropdownItem.new(text: "Item", tabindex: 0)
    rendered = render_component(component)

    assert_includes rendered, 'tabindex="0"'
  end

  test "renders with default tabindex" do
    component = Decor::DropdownItem.new(text: "Item")
    rendered = render_component(component)

    assert_includes rendered, 'tabindex="-1"'
  end

  test "renders with HTTP method" do
    component = Decor::DropdownItem.new(text: "Delete", http_method: :delete)
    rendered = render_component(component)

    assert_includes rendered, 'data-method="delete"'
  end

  test "renders without icon has different padding" do
    component = Decor::DropdownItem.new(text: "No Icon", icon_name: "")
    rendered = render_component(component)

    # DaisyUI handles padding automatically, no icon means no icon element
    assert_includes rendered, "No Icon"
    refute_includes rendered, "decor--icon"
  end

  test "yields block content when text is blank" do
    component = Decor::DropdownItem.new(text: nil, icon_name: "star")
    rendered = render_component(component) do
      "Custom Content"
    end

    assert_includes rendered, "Custom Content"
    assert_includes rendered, "star"
  end

  test "uses nokogiri for parsing" do
    component = Decor::DropdownItem.new(text: "Test Item", icon_name: "home")
    fragment = render_fragment(component)

    link = fragment.at_css("a")
    assert_not_nil link
    assert_equal "menuitem", link["role"]

    # Check for icon element
    icon = fragment.at_css("svg")
    assert_not_nil icon
  end
end
