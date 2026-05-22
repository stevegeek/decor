# frozen_string_literal: true

require "test_helper"

class ::Decor::Suite::SettingsListTest < ActiveSupport::TestCase
  Row = ::Decor::Components::SettingsList::Row
  Group = ::Decor::Components::SettingsList::Group
  ScopeInfo = ::Decor::Components::SettingsList::ScopeInfo

  test "raises when both groups and rows are provided" do
    assert_raises(ArgumentError) do
      ::Decor::Suite::SettingsList.new(rows: [], groups: [])
    end
  end

  test "raises when neither groups nor rows is provided" do
    assert_raises(ArgumentError) do
      ::Decor::Suite::SettingsList.new
    end
  end

  test "renders a card with suite tokens around the body" do
    html = render_component(::Decor::Suite::SettingsList.new(rows: [Row.new(title: "X", value: "1", active: true)]))
    assert_includes html, "decor:max-w-2xl"
    assert_includes html, "decor:bg-white"
    assert_includes html, "decor:border-suite-hairline"
    assert_includes html, "decor:rounded-suite-card"
  end

  test "renders the optional title strip with suite-section-title typography" do
    html = render_component(::Decor::Suite::SettingsList.new(
      title: "General settings",
      rows: [Row.new(title: "Setting", value: "value", active: true)]
    ))
    assert_includes html, "General settings"
    assert_includes html, "decor:suite-section-title"
  end

  test "renders an anonymous group with no section header when rows: is given" do
    html = render_component(::Decor::Suite::SettingsList.new(
      rows: [Row.new(title: "S", value: "v", active: false)]
    ))
    refute_includes html, "__anonymous__"
    refute_includes html, "decor:suite-caption"
  end

  test "renders a section header with caption typography and row count for named groups" do
    group = Group.new(name: "Pricing", icon: "currency-dollar", rows: [
      Row.new(title: "Tax rate", value: "10%", active: true),
      Row.new(title: "Currency", value: "USD", active: true)
    ])
    html = render_component(::Decor::Suite::SettingsList.new(groups: [group]))
    assert_includes html, "Pricing"
    assert_includes html, "decor:suite-caption"
    assert_includes html, "2 settings"
    assert_includes html, "tabler-currency-dollar"
    assert_includes html, "decor:text-suite-primary-600"
  end

  test "renders a row with dense-body title and tabular-nums value" do
    html = render_component(::Decor::Suite::SettingsList.new(
      rows: [Row.new(title: "Min order", value: "$25.00", active: true)]
    ))
    assert_includes html, "Min order"
    assert_includes html, "$25.00"
    assert_includes html, "decor:suite-dense-body"
    assert_includes html, "decor:tabular-nums"
  end

  test "renders an em-dash when row value is nil" do
    html = render_component(::Decor::Suite::SettingsList.new(
      rows: [Row.new(title: "Unset", value: nil, active: false)]
    ))
    assert_includes html, "—"
  end

  test "renders the state pill as a Suite Badge with success+dot when active" do
    html = render_component(::Decor::Suite::SettingsList.new(
      rows: [Row.new(title: "On", active: true)]
    ))
    assert_includes html, "Active"
    assert_includes html, "decor:bg-suite-success-500"
  end

  test "renders the state pill as neutral when inactive" do
    html = render_component(::Decor::Suite::SettingsList.new(
      rows: [Row.new(title: "Off row", active: false)]
    ))
    assert_includes html, "Off"
  end

  test "rows with a description are wrapped in a per-row stimulus controller" do
    html = render_component(::Decor::Suite::SettingsList.new(
      rows: [Row.new(title: "S", description: "Helper text", active: true)]
    ))
    assert_includes html, "decor--suite--settings-list--row"
    assert_includes html, "Helper text"
    assert_includes html, "decor:suite-description"
  end

  test "non-expandable rows render plainly with no toggle wiring" do
    html = render_component(::Decor::Suite::SettingsList.new(
      rows: [Row.new(title: "Plain", value: "1", active: true)]
    ))
    refute_includes html, "decor--suite--settings-list--row"
    refute_includes html, "aria-expanded"
  end

  test "rows with edit_path render a suite-styled edit link" do
    html = render_component(::Decor::Suite::SettingsList.new(
      rows: [Row.new(title: "Editable", value: "x", active: true, edit_path: "/edit/1")]
    ))
    assert_includes html, "href=\"/edit/1\""
    assert_includes html, "Edit"
    assert_includes html, "decor:text-suite-primary-700"
    assert_includes html, "decor:border-suite-primary-200"
  end

  test "edit_label prop overrides the default edit affordance text" do
    html = render_component(::Decor::Suite::SettingsList.new(
      edit_label: "Change",
      rows: [Row.new(title: "X", active: true, edit_path: "/x")]
    ))
    assert_includes html, "Change"
  end

  test "scope_info renders as an inline chip linking out when link_path is set" do
    scope = ScopeInfo.new(label: "From parent", tooltip: "Inherited from parent catalog", link_path: "/parent")
    html = render_component(::Decor::Suite::SettingsList.new(
      rows: [Row.new(title: "Inherited", value: "v", active: true, scope_info: scope)]
    ))
    assert_includes html, "From parent"
    assert_includes html, "href=\"/parent\""
    assert_includes html, "Inherited from parent catalog"
    assert_includes html, "decor:rounded-suite-control"
  end

  test "scope_info without link_path renders as a non-linked chip" do
    scope = ScopeInfo.new(label: "Local", tooltip: "Set on this record")
    html = render_component(::Decor::Suite::SettingsList.new(
      rows: [Row.new(title: "Local row", active: true, scope_info: scope)]
    ))
    assert_includes html, "Local"
    refute_includes html, "href=\""
  end

  test "row hover uses suite-gray-25 (no daisy semantic bg)" do
    html = render_component(::Decor::Suite::SettingsList.new(
      rows: [Row.new(title: "Hov", description: "x", active: true)]
    ))
    assert_includes html, "decor:hover:bg-suite-gray-25"
    refute_includes html, "decor:hover:bg-base-200"
  end

  test "group section header uses gray surface + suite hairline divider" do
    group = Group.new(name: "Section", rows: [Row.new(title: "R", active: true)])
    html = render_component(::Decor::Suite::SettingsList.new(groups: [group]))
    assert_includes html, "decor:bg-gray-50"
    assert_includes html, "decor:border-suite-hairline"
  end

  test "empty groups are filtered out of the render" do
    groups = [
      Group.new(name: "Empty", rows: []),
      Group.new(name: "Has rows", rows: [Row.new(title: "R", active: true)])
    ]
    html = render_component(::Decor::Suite::SettingsList.new(groups: groups))
    refute_includes html, "Empty"
    assert_includes html, "Has rows"
  end

  test "renders a value object that responds to render_in" do
    value = ::Decor::Suite::Badge.new(label: "Custom", color: :primary, size: :sm)
    html = render_component(::Decor::Suite::SettingsList.new(
      rows: [Row.new(title: "Rich value", value: value, active: true)]
    ))
    assert_includes html, "Custom"
    assert_includes html, "decor:bg-suite-primary-50"
  end

  test "rows with edit_path render a ModalOpenButton when modal: is supplied" do
    modal = ::Decor::Suite::Modals::Form.new(title: "Edit", id: "edit-modal")
    html = render_component(::Decor::Suite::SettingsList.new(
      modal: modal,
      rows: [Row.new(title: "Editable", value: "x", active: true, edit_path: "/edit/1")]
    ))
    assert_includes html, "decor--suite--modals--modal-open-button"
    assert_includes html, "modal-open-button-modal-id-value=\"edit-modal\""
    assert_includes html, "/edit/1"
    refute_includes html, "href=\"/edit/1\""
  end

  test "Edit ModalOpenButton's content_href appends form_id when modal responds to form_id" do
    modal = ::Decor::Suite::Modals::Form.new(title: "Edit")
    html = render_component(::Decor::Suite::SettingsList.new(
      modal: modal,
      rows: [Row.new(title: "Editable", value: "x", active: true, edit_path: "/edit/1")]
    ))
    assert_includes html, "/edit/1?form_id=#{modal.form_id}"
  end

  test "Edit ModalOpenButton preserves existing query params when appending form_id" do
    modal = ::Decor::Suite::Modals::Form.new(title: "Edit")
    html = render_component(::Decor::Suite::SettingsList.new(
      modal: modal,
      rows: [Row.new(title: "Editable", value: "x", active: true, edit_path: "/edit/1?context=global")]
    ))
    # Phlex escapes & to &amp; in HTML attribute output.
    assert_includes html, "/edit/1?context=global"
    assert_includes html, "form_id=#{modal.form_id}"
  end
end
