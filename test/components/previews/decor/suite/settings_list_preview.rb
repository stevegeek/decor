# @label SettingsList
class ::Decor::Suite::SettingsListPreview < ::Lookbook::Preview
  # SettingsList (Suite)
  # --------------------
  #
  # Card-bound list of grouped, optionally-editable settings. Each row
  # carries a title, a current value, and an active/off state pill.
  # Rows with a description or `edit_path` expand to reveal helper text
  # plus an inline Edit link. Designed for admin-style settings pages
  # where editing flows through a per-row form rather than inline edits.
  #
  # @group Examples
  # @label Bare rows
  def bare_rows
    rows = [
      row(title: "Minimum order value", value: "$25.00", active: true),
      row(title: "Auto-accept orders", value: "Off", active: false),
      row(title: "Currency", value: "USD", active: true)
    ]
    render ::Decor::Suite::SettingsList.new(title: "Storefront", rows: rows)
  end

  # @group Examples
  # @label Grouped sections
  def grouped_sections
    pricing = group(
      name: "Pricing & fees",
      icon: "currency-dollar",
      rows: [
        row(title: "Tax rate", value: "10%", active: true, description: "Applied to all line items at checkout."),
        row(title: "Service fee", value: "2.5%", active: true),
        row(title: "Currency", value: "USD", active: true)
      ]
    )
    fulfillment = group(
      name: "Fulfillment",
      icon: "truck",
      rows: [
        row(title: "Lead time", value: "3 days", active: true),
        row(title: "Cut-off time", value: "2 PM ET", active: true, description: "Orders placed after the cut-off ship the next business day."),
        row(title: "Same-day delivery", value: "Off", active: false)
      ]
    )
    render ::Decor::Suite::SettingsList.new(title: "Marketplace defaults", groups: [pricing, fulfillment])
  end

  # @group Examples
  # @label Editable rows with paths
  def editable_rows
    rows = [
      row(title: "Order minimum", value: "$50.00", active: true, description: "Buyers cannot place orders below this amount.", edit_path: "#order-min"),
      row(title: "Free shipping threshold", value: "$250.00", active: true, edit_path: "#free-ship"),
      row(title: "Allow split shipments", value: "Off", active: false, edit_path: "#splits")
    ]
    render ::Decor::Suite::SettingsList.new(title: "Shipping policies", rows: rows)
  end

  # @group Examples
  # @label With scope chips
  def with_scope_chips
    scope_parent = ::Decor::Components::SettingsList::ScopeInfo.new(
      label: "From parent",
      tooltip: "Inherited from the parent catalog",
      link_path: "#parent"
    )
    scope_local = ::Decor::Components::SettingsList::ScopeInfo.new(
      label: "Local",
      tooltip: "Set on this record only"
    )
    rows = [
      row(title: "Tax rate", value: "8.75%", active: true, scope_info: scope_parent),
      row(title: "Cut-off time", value: "1 PM ET", active: true, scope_info: scope_local, description: "Overrides the parent catalog default.")
    ]
    render ::Decor::Suite::SettingsList.new(title: "Mixed scope", rows: rows)
  end

  # @group Examples
  # @label Empty values
  def empty_values
    rows = [
      row(title: "Backorder policy", value: nil, active: false, description: "No backorder policy configured."),
      row(title: "Cancellation window", value: nil, active: false)
    ]
    render ::Decor::Suite::SettingsList.new(title: "Unset settings", rows: rows)
  end

  # @group Playground
  # @param title text
  # @param show_groups toggle
  # @param show_descriptions toggle
  def playground(title: "Storefront settings", show_groups: true, show_descriptions: true)
    description = show_descriptions ? "Detailed helper text revealed when the row is expanded." : nil

    if show_groups
      groups = [
        group(name: "Pricing", icon: "currency-dollar", rows: [
          row(title: "Tax rate", value: "10%", active: true, description: description),
          row(title: "Currency", value: "USD", active: true)
        ]),
        group(name: "Fulfillment", icon: "truck", rows: [
          row(title: "Lead time", value: "3 days", active: true, description: description),
          row(title: "Cut-off", value: "Off", active: false)
        ])
      ]
      render ::Decor::Suite::SettingsList.new(title: title, groups: groups)
    else
      rows = [
        row(title: "Tax rate", value: "10%", active: true, description: description),
        row(title: "Currency", value: "USD", active: true),
        row(title: "Lead time", value: "3 days", active: true)
      ]
      render ::Decor::Suite::SettingsList.new(title: title, rows: rows)
    end
  end

  private

  def row(**attrs)
    ::Decor::Components::SettingsList::Row.new(**attrs)
  end

  def group(**attrs)
    ::Decor::Components::SettingsList::Group.new(**attrs)
  end
end
