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
    assert_includes rendered, "mr-3 h-5 w-5"
  end

  test "renders as separator" do
    component = Decor::DropdownItem.new(separator: true)
    rendered = render_component(component)

    assert_includes rendered, "<hr"
    assert_includes rendered, "bg-gray-100"
    assert_includes rendered, "h-0.5"
    assert_includes rendered, "border-none"
  end

  test "applies correct CSS classes for regular item" do
    component = Decor::DropdownItem.new(text: "Regular Item")
    rendered = render_component(component)

    assert_includes rendered, "text-gray-700"
    assert_includes rendered, "group flex items-center"
    assert_includes rendered, "px-4"
    assert_includes rendered, "py-1.5"
    assert_includes rendered, "text-sm"
  end

  test "applies correct CSS classes for separator" do
    component = Decor::DropdownItem.new(separator: true)
    rendered = render_component(component)

    assert_includes rendered, "block px-0 pb-1.5 pt-2.5"
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

    assert_includes rendered, "pr-4 pl-12"
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
    assert_includes link["class"], "text-gray-700"

    icon = fragment.at_css("svg") || fragment.css("*").find { |el| el.text.include?("home") }
    assert_not_nil icon
  end
end
