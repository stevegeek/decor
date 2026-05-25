# frozen_string_literal: true

require "test_helper"

class ::Decor::Suite::Tables::BulkActionsBarTest < ActiveSupport::TestCase
  BulkAction = Struct.new(
    :name, :label, :icon, :icon_variant, :style, :confirm,
    :disabled, :visible, :url, :http_method, :inline, :modal,
    keyword_init: true
  ) do
    def initialize(**attrs)
      super(icon: nil,
            icon_variant: :outline,
            style: :primary,
            confirm: nil,
            disabled: false,
            visible: nil,
            url: nil,
            http_method: :post,
            inline: false,
            modal: false, **attrs)
    end
  end

  def archive_action(**overrides)
    BulkAction.new(name: :archive, label: "Archive", **overrides)
  end

  test "is hidden by default via inline display:none so TailwindMerge can't drop the flex utility" do
    html = render_component(::Decor::Suite::Tables::BulkActionsBar.new(form_url: "/x"))
    assert_includes html, "style=\"display: none;\""
    assert_includes html, "decor:flex"
  end

  test "renders the selection count text with a stimulus target" do
    html = render_component(::Decor::Suite::Tables::BulkActionsBar.new(selection_count: 3, form_url: "/x"))
    assert_includes html, "3 items selected"
    assert_match(/data-decor--suite--tables--bulk-actions-bar-target="selectionCount"/, html)
  end

  test "singularises the count label for 1 item" do
    html = render_component(::Decor::Suite::Tables::BulkActionsBar.new(selection_count: 1, form_url: "/x"))
    assert_includes html, "1 item selected"
  end

  test "uses Suite primary tokens for the band chrome" do
    html = render_component(::Decor::Suite::Tables::BulkActionsBar.new(form_url: "/x"))
    assert_includes html, "decor:bg-suite-primary-50"
    assert_includes html, "decor:border-suite-primary-200"
    assert_includes html, "decor:text-suite-primary-700"
  end

  test "renders inline actions as their own <form> with a hidden selected_ids container target" do
    html = render_component(::Decor::Suite::Tables::BulkActionsBar.new(
      form_url: "/orders/bulk",
      bulk_actions: [archive_action(inline: true)]
    ))
    assert_match(/<form[^>]*action="\/orders\/bulk"/, html)
    assert_match(/data-decor--suite--tables--bulk-actions-bar-target="selectedIdsContainer"/, html)
  end

  test "tunnels non-GET/POST http_method via Rails-style _method override" do
    html = render_component(::Decor::Suite::Tables::BulkActionsBar.new(
      form_url: "/orders/bulk",
      bulk_actions: [archive_action(inline: true, http_method: :delete)]
    ))
    assert_match(/<form[^>]*method="post"/i, html)
    assert_match(/<input[^>]*name="_method"[^>]*value="delete"/, html)
  end

  test "renders the dropdown trigger when there are non-inline actions" do
    html = render_component(::Decor::Suite::Tables::BulkActionsBar.new(
      form_url: "/orders/bulk",
      bulk_actions: [archive_action(inline: false)]
    ))
    assert_includes html, "Actions"
    assert_includes html, "dots-vertical"
  end

  test "dropdown action item carries the handle_dropdown_action stimulus action + per-action metadata" do
    html = render_component(::Decor::Suite::Tables::BulkActionsBar.new(
      form_url: "/orders/bulk",
      bulk_actions: [archive_action(inline: false, confirm: "Archive {count}?", modal: false)]
    ))
    assert_match(/data-action="[^"]*handleDropdownAction[^"]*"/, html)
    assert_includes html, "data-action-name=\"archive\""
    assert_includes html, "data-bulk-confirm=\"Archive {count}?\""
  end

  test "dropdown action emits a hidden companion <form> tagged as a dropdownForm target with action_name input" do
    html = render_component(::Decor::Suite::Tables::BulkActionsBar.new(
      form_url: "/orders/bulk",
      bulk_actions: [archive_action(inline: false)]
    ))
    assert_match(/data-decor--suite--tables--bulk-actions-bar-target="[^"]*dropdownForm/, html)
    assert_match(/<input[^>]*name="action_name"[^>]*value="archive"/, html)
  end

  test "filters actions whose visible Proc returns false" do
    invisible = archive_action(inline: true, visible: -> { false })
    visible = BulkAction.new(name: :delete, label: "Delete", inline: true, visible: -> { true })
    html = render_component(::Decor::Suite::Tables::BulkActionsBar.new(
      form_url: "/orders/bulk",
      bulk_actions: [invisible, visible]
    ))
    refute_includes html, "Archive"
    assert_includes html, "Delete"
  end

  test "danger style on a dropdown item picks up suite-danger tokens" do
    html = render_component(::Decor::Suite::Tables::BulkActionsBar.new(
      form_url: "/orders/bulk",
      bulk_actions: [archive_action(inline: false, style: :danger, icon: "trash")]
    ))
    assert_includes html, "decor:text-suite-danger-700"
    assert_includes html, "decor:text-suite-danger-600"
  end

  test "Clear selection button wires clear_selection action" do
    html = render_component(::Decor::Suite::Tables::BulkActionsBar.new(form_url: "/x"))
    assert_includes html, "Clear selection"
    assert_match(/data-action="[^"]*clearSelection[^"]*"/, html)
  end

  test "emits the selected_ids_field_name stimulus value" do
    html = render_component(::Decor::Suite::Tables::BulkActionsBar.new(
      form_url: "/x",
      selected_ids_field_name: "order_ids"
    ))
    assert_match(/data-decor--suite--tables--bulk-actions-bar-selected-ids-field-name-value="order_ids"/, html)
  end

  test "renders the lazy placeholder modal with the expected id suffix" do
    bar = ::Decor::Suite::Tables::BulkActionsBar.new(form_url: "/x")
    html = render_component(bar)
    assert_match(/id="#{Regexp.escape(bar.id)}-bulk-modal"/, html)
  end

  test "uses the Suite controller path (no Daisy leakage)" do
    html = render_component(::Decor::Suite::Tables::BulkActionsBar.new(form_url: "/x"))
    assert_includes html, "decor--suite--tables--bulk-actions-bar"
    refute_includes html, "decor--daisy--tables--bulk-actions-bar"
  end
end
