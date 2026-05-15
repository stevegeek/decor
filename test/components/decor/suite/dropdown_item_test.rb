# frozen_string_literal: true

require "test_helper"

class Decor::Suite::DropdownItemTest < ActiveSupport::TestCase
  test "renders an anchor menuitem with text" do
    rendered = render_component(Decor::Suite::DropdownItem.new(text: "Edit"))

    assert_includes rendered, "<a"
    assert_includes rendered, "role=\"menuitem\""
    assert_includes rendered, "Edit"
    assert_includes rendered, "decor:suite-description"
    assert_includes rendered, "decor:rounded-suite-control"
    assert_includes rendered, "decor:duration-suite-fast"
  end

  test "renders custom href" do
    rendered = render_component(Decor::Suite::DropdownItem.new(text: "Go", href: "/somewhere"))

    assert_includes rendered, "href=\"/somewhere\""
  end

  test "defaults href to #" do
    rendered = render_component(Decor::Suite::DropdownItem.new(text: "x"))

    assert_includes rendered, "href=\"#\""
  end

  test "default tabindex is -1" do
    rendered = render_component(Decor::Suite::DropdownItem.new(text: "x"))

    assert_includes rendered, "tabindex=\"-1\""
  end

  test "renders icon via Decor::Icon when icon_name is set" do
    rendered = render_component(Decor::Suite::DropdownItem.new(text: "Settings", icon_name: "settings"))

    assert_includes rendered, "settings"
    assert_includes rendered, "decor:w-[14px]"
  end

  test "omits icon when icon_name is nil" do
    rendered = render_component(Decor::Suite::DropdownItem.new(text: "x"))

    refute_includes rendered, "decor:w-[14px]"
  end

  test "renders a separator div with hairline background" do
    rendered = render_component(Decor::Suite::DropdownItem.new(separator: true))

    assert_includes rendered, "decor:bg-suite-hairline"
    assert_includes rendered, "decor:h-px"
    refute_includes rendered, "<a"
  end

  test "renders a section_label as a non-anchor div with caption typography" do
    rendered = render_component(Decor::Suite::DropdownItem.new(section_label: true, text: "GROUP NAME"))

    assert_includes rendered, "decor:suite-caption"
    assert_includes rendered, "GROUP NAME"
    refute_includes rendered, "<a"
    refute_includes rendered, "role=\"menuitem\""
  end

  test "applies danger styling when :danger is true" do
    rendered = render_component(Decor::Suite::DropdownItem.new(text: "Delete", danger: true))

    assert_includes rendered, "decor:text-suite-danger-700"
    assert_includes rendered, "decor:hover:bg-suite-danger-50"
  end

  test "danger items use danger token for icon color" do
    rendered = render_component(Decor::Suite::DropdownItem.new(text: "Delete", danger: true, icon_name: "trash"))

    assert_includes rendered, "decor:text-suite-danger-600"
  end

  test "renders a shortcut on the right when supplied" do
    rendered = render_component(Decor::Suite::DropdownItem.new(text: "Save", shortcut: "Cmd+S"))

    assert_includes rendered, "Cmd+S"
    assert_includes rendered, "decor:ml-auto"
    assert_includes rendered, "decor:font-mono"
  end

  test "emits both UJS and Turbo data-method attrs when http_method is set" do
    rendered = render_component(Decor::Suite::DropdownItem.new(text: "Delete", http_method: :delete))

    assert_includes rendered, "data-method=\"delete\""
    assert_includes rendered, "data-turbo-method=\"delete\""
  end

  test "merges arbitrary :data and mirrors data-confirm to data-turbo-confirm" do
    rendered = render_component(Decor::Suite::DropdownItem.new(text: "Delete", data: {confirm: "Sure?"}))

    assert_includes rendered, "data-confirm=\"Sure?\""
    assert_includes rendered, "data-turbo-confirm=\"Sure?\""
  end

  test "does NOT include daisy class hooks" do
    rendered = render_component(Decor::Suite::DropdownItem.new(text: "x"))

    refute_includes rendered, "decor:d-menu"
    refute_includes rendered, "menu-divider"
  end
end
