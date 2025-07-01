require "test_helper"

class Decor::DropdownTest < ActiveSupport::TestCase
  test "renders successfully with valid attributes" do
    rendered = render_component(Decor::Dropdown.new) do |dropdown|
      dropdown.menu_item(::Decor::DropdownItem.new(text: "Item 1"))
    end

    assert_includes rendered, "Item 1"
  end

  test "renders dropdown with button content" do
    rendered = render_component(Decor::Dropdown.new) do |dropdown|
      dropdown.trigger_button_content do
        "Click me"
      end
      dropdown.menu_item(::Decor::DropdownItem.new(text: "Menu Item"))
    end

    assert_includes rendered, "Click me"
    assert_includes rendered, "Menu Item"
  end

  test "renders multiple menu items" do
    rendered = render_component(Decor::Dropdown.new) do |dropdown|
      dropdown.menu_item(::Decor::DropdownItem.new(text: "Item 1"))
      dropdown.menu_item(::Decor::DropdownItem.new(text: "Item 2"))
      dropdown.menu_item(::Decor::DropdownItem.new(text: "Item 3"))
    end

    assert_includes rendered, "Item 1"
    assert_includes rendered, "Item 2"
    assert_includes rendered, "Item 3"
  end

  test "applies correct position classes" do
    rendered = render_component(Decor::Dropdown.new(position: :right)) do |dropdown|
      dropdown.menu_item(::Decor::DropdownItem.new(text: "Item 1"))
    end

    assert_includes rendered, "dropdown-end"
  end

  test "applies menu classes" do
    rendered = render_component(Decor::Dropdown.new(color: :primary, variant: :filled)) do |dropdown|
      dropdown.menu_item(::Decor::DropdownItem.new(text: "Item 1"))
    end

    assert_includes rendered, "bg-primary"
    assert_includes rendered, "text-primary-content"
  end

  test "renders menu header" do
    rendered = render_component(Decor::Dropdown.new) do |dropdown|
      dropdown.menu_header do
        div(class: "px-4 py-2") { "Header Content" }
      end
      dropdown.menu_item(::Decor::DropdownItem.new(text: "Item 1"))
    end

    assert_includes rendered, "Header Content"
  end

  test "renders custom button" do
    rendered = render_component(Decor::Dropdown.new) do |dropdown|
      dropdown.trigger_button do
        button(type: "button", class: "custom-button") { "Custom" }
      end
      dropdown.menu_item(::Decor::DropdownItem.new(text: "Item 1"))
    end

    assert_includes rendered, "custom-button"
    assert_includes rendered, "Custom"
  end

  test "uses nokogiri for parsing" do
    fragment = render_fragment(Decor::Dropdown.new) do |dropdown|
      dropdown.trigger_button_content { "Test Button" }
      dropdown.menu_item(::Decor::DropdownItem.new(text: "Test Item"))
    end

    button = fragment.at_css("button")
    assert_not_nil button
    assert_includes button.text, "Test Button"

    menu_item = fragment.at_css('a[role="menuitem"]')
    assert_not_nil menu_item
    assert_includes menu_item.text, "Test Item"
  end

  test "applies button active classes" do
    rendered = render_component(Decor::Dropdown.new(button_active_classes: ["bg-blue-100"])) do |dropdown|
      dropdown.trigger_button_content { "Button" }
      dropdown.menu_item(::Decor::DropdownItem.new(text: "Item 1"))
    end

    # The active classes are applied via Stimulus controller, so we check they're in the data attributes
    assert_includes rendered, "bg-blue-100"
  end

  # Modern attribute tests
  test "applies modern size classes" do
    rendered = render_component(Decor::Dropdown.new(size: :lg)) do |dropdown|
      dropdown.trigger_button_content { "Large Button" }
      dropdown.menu_item(::Decor::DropdownItem.new(text: "Item 1"))
    end

    assert_includes rendered, "btn-lg"
  end

  test "applies modern color classes" do
    rendered = render_component(Decor::Dropdown.new(color: :primary)) do |dropdown|
      dropdown.trigger_button_content { "Primary Button" }
      dropdown.menu_item(::Decor::DropdownItem.new(text: "Item 1"))
    end

    assert_includes rendered, "btn-primary"
  end

  test "applies modern variant classes" do
    rendered = render_component(Decor::Dropdown.new(variant: :bordered)) do |dropdown|
      dropdown.trigger_button_content { "Bordered Button" }
      dropdown.menu_item(::Decor::DropdownItem.new(text: "Item 1"))
    end

    assert_includes rendered, "btn-outline"
  end

  test "applies modern position classes" do
    rendered = render_component(Decor::Dropdown.new(position: :right)) do |dropdown|
      dropdown.trigger_button_content { "Right Positioned" }
      dropdown.menu_item(::Decor::DropdownItem.new(text: "Item 1"))
    end

    assert_includes rendered, "dropdown-end"
  end

  test "applies DaisyUI dropdown structure" do
    fragment = render_fragment(Decor::Dropdown.new) do |dropdown|
      dropdown.trigger_button_content { "Modern Dropdown" }
      dropdown.menu_item(::Decor::DropdownItem.new(text: "Test Item"))
    end

    # Check for DaisyUI dropdown container
    dropdown_container = fragment.at_css(".dropdown")
    assert_not_nil dropdown_container

    # Check for DaisyUI dropdown content
    dropdown_content = fragment.at_css(".dropdown-content")
    assert_not_nil dropdown_content

    # Check for DaisyUI menu
    menu = fragment.at_css(".menu")
    assert_not_nil menu
  end

  test "applies custom button classes" do
    rendered = render_component(Decor::Dropdown.new(
      position: :right,
      button_classes: ["custom-button"]
    )) do |dropdown|
      dropdown.trigger_button_content { "Custom Dropdown" }
      dropdown.menu_item(::Decor::DropdownItem.new(text: "Item 1"))
    end

    assert_includes rendered, "custom-button"
    assert_includes rendered, "dropdown-end"
  end

  test "combines color and button_classes correctly" do
    rendered = render_component(Decor::Dropdown.new(
      color: :primary,
      button_classes: ["custom-button"]
    )) do |dropdown|
      dropdown.trigger_button_content { "Mixed Attributes" }
      dropdown.menu_item(::Decor::DropdownItem.new(text: "Item 1"))
    end

    # Both color classes and custom button classes should be applied
    assert_includes rendered, "custom-button"
    assert_includes rendered, "btn-primary"
  end
end
