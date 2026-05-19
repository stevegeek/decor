# frozen_string_literal: true

require "test_helper"

class ::Decor::Suite::SettingsList::RowTest < ActiveSupport::TestCase
  RowData = ::Decor::Components::SettingsList::Row
  ScopeInfo = ::Decor::Components::SettingsList::ScopeInfo

  def build(**props)
    ::Decor::Suite::SettingsList::Row.new(
      row: RowData.new(**props)
    )
  end

  test "wraps the row in the per-row stimulus controller" do
    html = render_component(build(title: "S", description: "Helper text", active: true))

    assert_includes html, "data-controller=\"decor--suite--settings-list--row\""
    assert_includes html, "Helper text"
    assert_includes html, "decor:suite-description"
    assert_includes html, "aria-expanded=\"false\""
  end

  test "renders the row title, value, and stimulus wiring even without a description" do
    html = render_component(build(title: "Plain", value: "1", active: true))

    assert_includes html, "Plain"
    assert_includes html, ">1<"
    assert_includes html, "aria-expanded=\"false\""
    assert_includes html, "data-controller=\"decor--suite--settings-list--row\""
  end

  test "renders a row container with suite-hairline divider on top" do
    html = render_component(build(title: "S", value: "1", active: true))

    assert_includes html, "decor:border-suite-hairline"
    assert_includes html, "decor:first:border-t-0"
  end

  test "renders the title with dense-body typography" do
    html = render_component(build(title: "Min order", value: "$25.00", active: true))

    assert_includes html, "Min order"
    assert_includes html, "$25.00"
    assert_includes html, "decor:suite-dense-body"
    assert_includes html, "decor:tabular-nums"
  end

  test "renders an em-dash when value is nil" do
    html = render_component(build(title: "Unset", value: nil, active: false))

    assert_includes html, "—"
  end

  test "renders the state pill as a Suite Badge with success+dot when active" do
    html = render_component(build(title: "On", active: true))

    assert_includes html, "Active"
    assert_includes html, "decor:bg-suite-success-500"
  end

  test "renders the state pill as neutral when inactive" do
    html = render_component(build(title: "Off row", active: false))

    assert_includes html, "Off"
  end

  test "row hover uses suite-gray-25" do
    html = render_component(build(title: "Hov", description: "x", active: true))

    assert_includes html, "decor:hover:bg-suite-gray-25"
    refute_includes html, "decor:hover:bg-base-200"
  end

  test "renders the chevron glyph in the summary" do
    html = render_component(build(title: "E", description: "d", active: true))

    assert_includes html, "▶"
  end

  test "summary button wires the toggle action and aria-controls the detail" do
    html = render_component(build(title: "E", description: "d", active: true))

    assert_includes html, "data-action=\"click->decor--suite--settings-list--row#toggle\""
    assert_includes html, "aria-controls="
    assert_includes html, "data-decor--suite--settings-list--row-target=\"summary\""
  end

  test "detail panel is hidden by default and wired as the detail target" do
    html = render_component(build(title: "E", description: "Detail text", active: true))

    assert_includes html, "data-decor--suite--settings-list--row-target=\"detail\""
    assert_includes html, "hidden"
    assert_includes html, "Detail text"
  end

  test "renders edit_path as a suite-styled anchor with the default label" do
    html = render_component(build(title: "Editable", value: "x", active: true, edit_path: "/edit/1"))

    assert_includes html, "href=\"/edit/1\""
    assert_includes html, "Edit"
    assert_includes html, "decor:text-suite-primary-700"
    assert_includes html, "decor:border-suite-primary-200"
    assert_includes html, "decor:rounded-suite-control"
  end

  test "edit_label prop overrides the default edit affordance text" do
    component = ::Decor::Suite::SettingsList::Row.new(
      row: RowData.new(title: "X", active: true, edit_path: "/x"),
      edit_label: "Change"
    )
    html = render_component(component)

    assert_includes html, "Change"
    refute_includes html, ">Edit<"
  end

  test "scope_info renders as a linked chip when link_path is set" do
    scope = ScopeInfo.new(label: "From parent", tooltip: "Inherited from parent catalog", link_path: "/parent")
    html = render_component(build(title: "Inherited", value: "v", active: true, scope_info: scope))

    assert_includes html, "From parent"
    assert_includes html, "href=\"/parent\""
    assert_includes html, "Inherited from parent catalog"
    assert_includes html, "decor:rounded-suite-control"
  end

  test "scope_info renders as a non-linked chip when link_path is nil" do
    scope = ScopeInfo.new(label: "Local", tooltip: "Set on this record")
    html = render_component(build(title: "Local row", active: true, scope_info: scope))

    assert_includes html, "Local"
    assert_includes html, "Set on this record"
    refute_includes html, "href=\""
  end

  test "renders a value object that responds to render_in" do
    badge = ::Decor::Suite::Badge.new(label: "Custom", color: :primary, size: :sm)
    html = render_component(build(title: "Rich value", value: badge, active: true))

    assert_includes html, "Custom"
    assert_includes html, "decor:bg-suite-primary-50"
  end

  test "open value is seeded false" do
    html = render_component(build(title: "E", description: "x", active: true))

    assert_includes html, "data-decor--suite--settings-list--row-open-value=\"false\""
  end
end
