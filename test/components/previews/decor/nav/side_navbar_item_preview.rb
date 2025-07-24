# Navigation item for side navbar with support for icons, counters, and expandable sub-items
# @label Side Navbar Item
class ::Decor::Nav::SideNavbarItemPreview < ::Lookbook::Preview
  # @group Examples

  # @label Simple Link
  def simple_link
    render ::Decor::Nav::SideNavbarItem.new(
      title: "Dashboard",
      icon: "home",
      path: "/dashboard"
    )
  end

  # @label With Counter
  def with_counter
    render ::Decor::Nav::SideNavbarItem.new(
      title: "Notifications",
      icon: "bell",
      path: "/notifications",
      counter: 5
    )
  end

  # @label Expandable with Sub-items
  def expandable_with_sub_items
    render ::Decor::Nav::SideNavbarItem.new(
      title: "Settings",
      icon: "cog"
    ) do |item|
      item.with_sub_item(title: "General", path: "/settings/general")
      item.with_sub_item(title: "Security", path: "/settings/security", selected: true)
      item.with_sub_item(title: "Billing", path: "/settings/billing")
      item.with_sub_item(title: "Team", path: "/settings/team")
    end
  end

  # @label Complete Navigation
  def complete_navigation
    render ::Decor::Element.new html_options: {class: "space-y-1"} do |nav|
      nav.render ::Decor::Nav::SideNavbarItem.new(
        title: "Dashboard",
        icon: "home",
        path: "/dashboard",
        selected: true
      )
      nav.render ::Decor::Nav::SideNavbarItem.new(
        title: "Projects",
        icon: "folder"
      ) do |item|
        item.with_sub_item(title: "All Projects", path: "/projects")
        item.with_sub_item(title: "Active", path: "/projects/active")
        item.with_sub_item(title: "Archived", path: "/projects/archived")
      end
      nav.render ::Decor::Nav::SideNavbarItem.new(
        title: "Messages",
        icon: "mail",
        path: "/messages",
        counter: 12
      )
      nav.render ::Decor::Nav::SideNavbarItem.new(
        title: "Settings",
        icon: "cog",
        path: "/settings"
      )
    end
  end

  # @endgroup

  # @group Playground

  # @label Playground
  # @param title [String] text
  # @param icon [String] text
  # @param path [String] text
  # @param counter [Integer] number
  # @param selected [Boolean] toggle
  # @param has_sub_items [Boolean] toggle
  def playground(
    title: "Dashboard",
    icon: "home",
    path: "/dashboard",
    counter: nil,
    selected: false,
    has_sub_items: false
  )
    render ::Decor::Nav::SideNavbarItem.new(
      title: title,
      icon: icon.present? ? icon : nil,
      path: has_sub_items ? nil : path,
      counter: counter,
      selected: selected
    ) do |item|
      if has_sub_items
        item.with_sub_item(title: "Overview", path: "#{path}/overview")
        item.with_sub_item(title: "Analytics", path: "#{path}/analytics")
        item.with_sub_item(title: "Reports", path: "#{path}/reports")
      end
    end
  end

  # @endgroup

  # @group States

  # @label Default State
  def state_default
    render ::Decor::Nav::SideNavbarItem.new(
      title: "Analytics",
      icon: "chart-bar",
      path: "/analytics"
    )
  end

  # @label Selected State
  def state_selected
    render ::Decor::Nav::SideNavbarItem.new(
      title: "Reports",
      icon: "document-report",
      path: "/reports",
      selected: true
    )
  end

  # @label Expanded with Selected Sub-item
  def state_expanded_selected
    render ::Decor::Nav::SideNavbarItem.new(
      title: "Projects",
      icon: "folder",
      selected: true
    ) do |item|
      item.with_sub_item(title: "All Projects", path: "/projects")
      item.with_sub_item(title: "Active", path: "/projects/active", selected: true)
      item.with_sub_item(title: "Archived", path: "/projects/archived")
    end
  end

  # @endgroup

  # @group Variations

  # @label Without Icon
  def without_icon
    render ::Decor::Nav::SideNavbarItem.new(
      title: "Documentation",
      path: "/docs"
    )
  end

  # @label With Large Counter
  def with_large_counter
    render ::Decor::Nav::SideNavbarItem.new(
      title: "Inbox",
      icon: "inbox",
      path: "/inbox",
      counter: 99
    )
  end

  # @label Nested Sub-items
  def nested_sub_items
    render ::Decor::Nav::SideNavbarItem.new(
      title: "Admin",
      icon: "shield-check"
    ) do |item|
      item.with_sub_item(title: "Users", path: "/admin/users")
      item.with_sub_item(title: "Roles & Permissions", path: "/admin/roles")
      item.with_sub_item(title: "Audit Log", path: "/admin/audit")
      item.with_sub_item(title: "System Settings", path: "/admin/system")
    end
  end

  # @endgroup
end
