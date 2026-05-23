# frozen_string_literal: true

require "test_helper"

class ::Decor::Daisy::SettingsListTest < ActiveSupport::TestCase
  Row = ::Decor::Components::SettingsList::Row
  Group = ::Decor::Components::SettingsList::Group
  ScopeInfo = ::Decor::Components::SettingsList::ScopeInfo

  test "raises when both groups and rows are provided" do
    assert_raises(ArgumentError) do
      ::Decor::Daisy::SettingsList.new(rows: [], groups: [])
    end
  end

  test "raises when neither groups nor rows is provided" do
    assert_raises(ArgumentError) do
      ::Decor::Daisy::SettingsList.new
    end
  end

  test "renders root with daisy settings-list identifier and centered max-width" do
    html = render_component(::Decor::Daisy::SettingsList.new(rows: [Row.new(title: "X", value: "1", active: true)]))
    assert_includes html, "decor--daisy--settings-list"
    assert_includes html, "decor:max-w-2xl"
    assert_includes html, "decor:mx-auto"
  end

  test "renders the card chrome around the body" do
    html = render_component(::Decor::Daisy::SettingsList.new(rows: [Row.new(title: "X", value: "1", active: true)]))
    assert_includes html, "decor:d-card"
    assert_includes html, "decor:bg-base-100"
    assert_includes html, "decor:border-base-300"
  end

  test "renders the optional title strip" do
    html = render_component(::Decor::Daisy::SettingsList.new(
      title: "General settings",
      rows: [Row.new(title: "Setting", value: "value", active: true)]
    ))
    assert_includes html, "General settings"
    assert_includes html, "<h3"
  end

  test "renders an anonymous group with no section header when rows: is given" do
    html = render_component(::Decor::Daisy::SettingsList.new(
      rows: [Row.new(title: "S", value: "v", active: false)]
    ))
    refute_includes html, "__anonymous__"
    refute_includes html, "decor:uppercase"
  end

  test "renders a section header with icon and row count for named groups" do
    group = Group.new(name: "Pricing", icon: "currency-dollar", rows: [
      Row.new(title: "Tax rate", value: "10%", active: true),
      Row.new(title: "Currency", value: "USD", active: true)
    ])
    html = render_component(::Decor::Daisy::SettingsList.new(groups: [group]))
    assert_includes html, "Pricing"
    assert_includes html, "decor:uppercase"
    assert_includes html, "decor:tracking-wide"
    assert_includes html, "2 settings"
    assert_includes html, "tabler-currency-dollar"
  end

  test "renders a row with tabular-nums value" do
    html = render_component(::Decor::Daisy::SettingsList.new(
      rows: [Row.new(title: "Min order", value: "$25.00", active: true)]
    ))
    assert_includes html, "Min order"
    assert_includes html, "$25.00"
    assert_includes html, "decor:tabular-nums"
  end

  test "renders an em-dash when row value is nil" do
    html = render_component(::Decor::Daisy::SettingsList.new(
      rows: [Row.new(title: "Unset", value: nil, active: false)]
    ))
    assert_includes html, "—"
  end

  test "active row renders a success badge labelled Active" do
    html = render_component(::Decor::Daisy::SettingsList.new(
      rows: [Row.new(title: "On", active: true)]
    ))
    assert_includes html, "Active"
    assert_includes html, "decor:d-badge-success"
  end

  test "inactive row renders a neutral badge labelled Off" do
    html = render_component(::Decor::Daisy::SettingsList.new(
      rows: [Row.new(title: "Off row", active: false)]
    ))
    assert_includes html, "Off"
    assert_includes html, "decor:d-badge-neutral"
  end

  test "rows with a description render as expandable details/summary" do
    html = render_component(::Decor::Daisy::SettingsList.new(
      rows: [Row.new(title: "S", description: "Helper text", active: true)]
    ))
    assert_includes html, "<details"
    assert_includes html, "<summary"
    assert_includes html, "Helper text"
  end

  test "non-expandable rows render plainly as a button with no details" do
    html = render_component(::Decor::Daisy::SettingsList.new(
      rows: [Row.new(title: "Plain", value: "1", active: true)]
    ))
    refute_includes html, "<details"
    assert_includes html, '<button type="button"'
  end

  test "rows with edit_path render an edit link with daisyUI button classes" do
    html = render_component(::Decor::Daisy::SettingsList.new(
      rows: [Row.new(title: "Editable", value: "x", active: true, edit_path: "/edit/1")]
    ))
    assert_includes html, 'href="/edit/1"'
    assert_includes html, "Edit"
    assert_includes html, "decor:d-btn"
    assert_includes html, "decor:d-btn-outline"
  end

  test "edit_label prop overrides the default edit affordance text" do
    html = render_component(::Decor::Daisy::SettingsList.new(
      edit_label: "Change",
      rows: [Row.new(title: "X", active: true, edit_path: "/x")]
    ))
    assert_includes html, "Change"
  end

  test "scope_info renders as an inline chip linking out when link_path is set" do
    scope = ScopeInfo.new(label: "From parent", tooltip: "Inherited", link_path: "/parent")
    html = render_component(::Decor::Daisy::SettingsList.new(
      rows: [Row.new(title: "Inherited", value: "v", active: true, scope_info: scope)]
    ))
    assert_includes html, "From parent"
    assert_includes html, 'href="/parent"'
    assert_includes html, "Inherited"
  end

  test "scope_info without link_path renders as a non-linked chip" do
    scope = ScopeInfo.new(label: "Local", tooltip: "Set on this record")
    html = render_component(::Decor::Daisy::SettingsList.new(
      rows: [Row.new(title: "Local row", active: true, scope_info: scope)]
    ))
    assert_includes html, "Local"
    refute_match(/<a [^>]*href=/, html)
  end

  test "empty groups are filtered out of the render" do
    groups = [
      Group.new(name: "Empty", rows: []),
      Group.new(name: "Has rows", rows: [Row.new(title: "R", active: true)])
    ]
    html = render_component(::Decor::Daisy::SettingsList.new(groups: groups))
    refute_includes html, "Empty"
    assert_includes html, "Has rows"
  end
end
