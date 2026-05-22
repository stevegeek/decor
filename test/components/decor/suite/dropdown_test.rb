# frozen_string_literal: true

require "test_helper"

class Decor::Suite::DropdownTest < ActiveSupport::TestCase
  test "renders trigger button and menu by default" do
    rendered = render_component(Decor::Suite::Dropdown.new) do |d|
      d.trigger_button_content { "Options" }
    end

    assert_includes rendered, "<button"
    assert_includes rendered, "popovertarget="
    assert_includes rendered, "popover=\"auto\""
    assert_includes rendered, "role=\"menu\""
    assert_includes rendered, "Options"
  end

  test "applies Suite chrome tokens to the menu surface" do
    rendered = render_component(Decor::Suite::Dropdown.new) do |d|
      d.trigger_button_content { "x" }
    end

    assert_includes rendered, "decor:bg-white"
    assert_includes rendered, "decor:border-suite-hairline-strong"
    assert_includes rendered, "decor:rounded-suite-control"
    assert_includes rendered, "decor:shadow-suite-popover"
    refute_includes rendered, "decor:rounded-md"
    refute_includes rendered, "decor:rounded-box"
  end

  test "wires anchor-name on internal trigger button" do
    rendered = render_component(Decor::Suite::Dropdown.new) do |d|
      d.trigger_button_content { "x" }
    end

    assert_includes rendered, "anchor-name:"
    assert_includes rendered, "--decor-suite-dropdown-anchor-"
  end

  test "respects a consumer-supplied :anchor_name" do
    rendered = render_component(Decor::Suite::Dropdown.new(anchor_name: "--my-anchor")) do |d|
      d.trigger_button_content { "x" }
    end

    assert_includes rendered, "anchor-name: --my-anchor;"
    assert_includes rendered, "--decor-suite-dropdown-anchor: --my-anchor;"
  end

  test "menu carries the position data attribute" do
    rendered_left = render_component(Decor::Suite::Dropdown.new(menu_position: :aligned_to_left)) do |d|
      d.trigger_button_content { "x" }
    end
    rendered_right = render_component(Decor::Suite::Dropdown.new(menu_position: :aligned_to_right)) do |d|
      d.trigger_button_content { "x" }
    end

    assert_includes rendered_left, "data-position=\"aligned_to_left\""
    assert_includes rendered_right, "data-position=\"aligned_to_right\""
  end

  test "menu uses the dropdown-menu class hook for CSS anchor positioning" do
    rendered = render_component(Decor::Suite::Dropdown.new) { |d| d.trigger_button_content { "x" } }

    assert_includes rendered, "decor--suite--dropdown-menu"
  end

  test "renders menu items via with_menu_item" do
    rendered = render_component(Decor::Suite::Dropdown.new) do |d|
      d.trigger_button_content { "x" }
      d.menu_item(::Decor::Suite::DropdownItem.new(text: "Item one"))
      d.menu_item(::Decor::Suite::DropdownItem.new(text: "Item two"))
    end

    assert_includes rendered, "Item one"
    assert_includes rendered, "Item two"
  end

  test "with_menu_item accepts kwargs and builds a Suite DropdownItem" do
    rendered = render_component(Decor::Suite::Dropdown.new) do |d|
      d.trigger_button_content { "x" }
      d.with_menu_item(text: "Kwarg item", href: "/k")
    end

    assert_includes rendered, "Kwarg item"
    assert_includes rendered, "href=\"/k\""
  end

  test "with_button / with_button_content / with_menu_header / with_menu_content aliases" do
    rendered = render_component(Decor::Suite::Dropdown.new) do |d|
      d.with_button_content { "ALIAS-TRIGGER" }
      d.with_menu_header { "ALIAS-HEADER" }
      d.with_menu_content { "ALIAS-FOOTER" }
      d.with_menu_item(text: "ALIAS-ITEM")
    end

    assert_includes rendered, "ALIAS-TRIGGER"
    assert_includes rendered, "ALIAS-HEADER"
    assert_includes rendered, "ALIAS-FOOTER"
    assert_includes rendered, "ALIAS-ITEM"
  end

  test "renders menu header and content blocks" do
    rendered = render_component(Decor::Suite::Dropdown.new) do |d|
      d.trigger_button_content { "x" }
      d.menu_header { "HEADER-X" }
      d.menu_content { "FOOTER-X" }
    end

    assert_includes rendered, "HEADER-X"
    assert_includes rendered, "FOOTER-X"
  end

  test "renders a fully custom trigger when trigger_button slot is set" do
    rendered = render_component(Decor::Suite::Dropdown.new) do |d|
      d.trigger_button { "CUSTOM-TRIGGER" }
    end

    assert_includes rendered, "CUSTOM-TRIGGER"
    refute_includes rendered, "Open menu"
  end

  test "trigger_attributes hash exposes popovertarget, anchor-name and stimulus target" do
    component = Decor::Suite::Dropdown.new
    attrs = component.trigger_attributes

    assert_match(/-menu\z/, attrs[:popovertarget])
    assert_match(/-menu-button\z/, attrs[:id])
    assert_match(/anchor-name:/, attrs[:style])
    assert attrs[:data].is_a?(Hash)
  end

  test "stimulus data attributes wire button/menu targets and the beforetoggle action" do
    rendered = render_component(Decor::Suite::Dropdown.new) { |d| d.trigger_button_content { "x" } }

    assert_includes rendered, "decor--suite--dropdown"
    assert_includes rendered, "decor--suite--dropdown-target"
    assert_includes rendered, "beforetoggle->decor--suite--dropdown#handleBeforeToggle"
  end

  test "passes content_href and placeholder values to stimulus" do
    rendered = render_component(
      Decor::Suite::Dropdown.new(content_href: "/lazy.html", placeholder: "loading...")
    ) { |d| d.trigger_button_content { "x" } }

    assert_includes rendered, "content-href-value=\"/lazy.html\""
    assert_includes rendered, "placeholder-value=\"loading...\""
  end

  test "applies custom button_classes" do
    rendered = render_component(Decor::Suite::Dropdown.new(button_classes: ["custom-btn"])) do |d|
      d.trigger_button_content { "x" }
    end

    assert_includes rendered, "custom-btn"
  end

  test "converts button_active_classes into aria-expanded variants" do
    rendered = render_component(Decor::Suite::Dropdown.new(button_active_classes: ["bg-gray-100"])) do |d|
      d.trigger_button_content { "x" }
    end

    assert_includes rendered, "aria-expanded:bg-gray-100"
  end

  test "applies custom menu_classes" do
    rendered = render_component(Decor::Suite::Dropdown.new(menu_classes: ["extra-menu-class"])) do |d|
      d.trigger_button_content { "x" }
    end

    assert_includes rendered, "extra-menu-class"
  end

  test "uses dropdown_size_classes when provided, falling back to w-auto/max-h-80" do
    default = render_component(Decor::Suite::Dropdown.new) { |d| d.trigger_button_content { "x" } }
    sized = render_component(Decor::Suite::Dropdown.new(dropdown_size_classes: ["decor:w-64"])) do |d|
      d.trigger_button_content { "x" }
    end

    assert_includes default, "decor:w-auto"
    assert_includes default, "decor:max-h-80"
    assert_includes sized, "decor:w-64"
    refute_includes sized, "decor:w-auto"
  end

  test "does NOT use daisyUI semantic chrome" do
    rendered = render_component(Decor::Suite::Dropdown.new) { |d| d.trigger_button_content { "x" } }

    refute_includes rendered, "decor:d-dropdown"
    refute_includes rendered, "decor:d-menu"
    refute_includes rendered, "decor:bg-base-100"
    refute_includes rendered, "decor:bg-base-200"
  end
end
