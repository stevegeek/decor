# @label Side Navbar Item
class ::Decor::Nav::SideNavbarItemPreview < ::Lookbook::Preview
  # Side Navbar Item
  # -------
  #
  # A navigation item that can either be a simple link or an expandable item
  # with sub-items. Supports icons, counters, and selection states.
  #
  # @label Playground
  # @param title [String] text
  # @param icon [String] text
  # @param path [String] text
  # @param counter [Integer] number
  # @param selected [Boolean] checkbox
  # @param has_sub_items [Boolean] checkbox
  def playground(
    title: "Dashboard",
    icon: "home",
    path: "/dashboard",
    counter: nil,
    selected: false,
    has_sub_items: false
  )
    content_tag :div, class: "bg-gray-800 w-64 p-4" do
      content_tag :nav, class: "space-y-1" do
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
    end
  end

  # @label Simple Link Item
  def simple_link_item
    content_tag :div, class: "bg-gray-800 w-64 p-4" do
      content_tag :nav, class: "space-y-1" do
        render ::Decor::Nav::SideNavbarItem.new(
          title: "Dashboard",
          icon: "home",
          path: "/dashboard"
        )
      end
    end
  end

  # @label Selected Item
  def selected_item
    content_tag :div, class: "bg-gray-800 w-64 p-4" do
      content_tag :nav, class: "space-y-1" do
        render ::Decor::Nav::SideNavbarItem.new(
          title: "Users",
          icon: "users",
          path: "/users",
          selected: true
        )
      end
    end
  end

  # @label Item with Counter
  def item_with_counter
    content_tag :div, class: "bg-gray-800 w-64 p-4" do
      content_tag :nav, class: "space-y-1" do
        render ::Decor::Nav::SideNavbarItem.new(
          title: "Notifications",
          icon: "bell",
          path: "/notifications",
          counter: 5
        )
      end
    end
  end

  # @label Expandable Item with Sub-items
  def expandable_item
    content_tag :div, class: "bg-gray-800 w-64 p-4" do
      content_tag :nav, class: "space-y-1" do
        render ::Decor::Nav::SideNavbarItem.new(
          title: "Settings",
          icon: "cog",
          selected: false
        ) do |item|
          item.with_sub_item(title: "General", path: "/settings/general")
          item.with_sub_item(title: "Security", path: "/settings/security", selected: true)
          item.with_sub_item(title: "Billing", path: "/settings/billing")
          item.with_sub_item(title: "Team", path: "/settings/team")
        end
      end
    end
  end

  # @label Expanded Item (Selected)
  def expanded_item_selected
    content_tag :div, class: "bg-gray-800 w-64 p-4" do
      content_tag :nav, class: "space-y-1" do
        render ::Decor::Nav::SideNavbarItem.new(
          title: "Projects",
          icon: "folder",
          selected: true
        ) do |item|
          item.with_sub_item(title: "All Projects", path: "/projects")
          item.with_sub_item(title: "Active", path: "/projects/active", selected: true)
          item.with_sub_item(title: "Archived", path: "/projects/archived")
          item.with_sub_item(title: "Templates", path: "/projects/templates")
        end
      end
    end
  end

  # @label Item Without Icon
  def item_without_icon
    content_tag :div, class: "bg-gray-800 w-64 p-4" do
      content_tag :nav, class: "space-y-1" do
        render ::Decor::Nav::SideNavbarItem.new(
          title: "Documentation",
          path: "/docs"
        )
      end
    end
  end

  # @label Multiple Navigation Items
  def multiple_items
    content_tag :div, class: "bg-gray-800 w-64 p-4" do
      content_tag :nav, class: "space-y-1" do
        concat(
          render(::Decor::Nav::SideNavbarItem.new(
            title: "Dashboard",
            icon: "home",
            path: "/dashboard",
            selected: true
          ))
        )
        concat(
          render(::Decor::Nav::SideNavbarItem.new(
            title: "Projects",
            icon: "folder",
            selected: false
          )) do |item|
            item.with_sub_item(title: "All Projects", path: "/projects")
            item.with_sub_item(title: "Active", path: "/projects/active")
            item.with_sub_item(title: "Archived", path: "/projects/archived")
          end
        )
        concat(
          render(::Decor::Nav::SideNavbarItem.new(
            title: "Team",
            icon: "users",
            path: "/team"
          ))
        )
        concat(
          render(::Decor::Nav::SideNavbarItem.new(
            title: "Messages",
            icon: "mail",
            path: "/messages",
            counter: 12
          ))
        )
        concat(
          render(::Decor::Nav::SideNavbarItem.new(
            title: "Settings",
            icon: "cog"
          )) do |item|
            item.with_sub_item(title: "General", path: "/settings/general")
            item.with_sub_item(title: "Security", path: "/settings/security")
            item.with_sub_item(title: "Billing", path: "/settings/billing")
          end
        )
      end
    end
  end

  # @label Item States Comparison
  def item_states_comparison
    content_tag :div, class: "bg-gray-800 w-64 p-4" do
      content_tag :nav, class: "space-y-4" do
        concat content_tag(:h4, "Normal", class: "text-gray-400 text-xs uppercase tracking-wider font-semibold")
        concat(
          render(::Decor::Nav::SideNavbarItem.new(
            title: "Analytics",
            icon: "chart-bar",
            path: "/analytics"
          ))
        )

        concat content_tag(:h4, "Selected", class: "text-gray-400 text-xs uppercase tracking-wider font-semibold mt-4")
        concat(
          render(::Decor::Nav::SideNavbarItem.new(
            title: "Reports",
            icon: "document-report",
            path: "/reports",
            selected: true
          ))
        )

        concat content_tag(:h4, "With Counter", class: "text-gray-400 text-xs uppercase tracking-wider font-semibold mt-4")
        concat(
          render(::Decor::Nav::SideNavbarItem.new(
            title: "Alerts",
            icon: "exclamation",
            path: "/alerts",
            counter: 3
          ))
        )

        concat content_tag(:h4, "Expandable", class: "text-gray-400 text-xs uppercase tracking-wider font-semibold mt-4")
        concat(
          render(::Decor::Nav::SideNavbarItem.new(
            title: "Admin",
            icon: "shield-check"
          )) do |item|
            item.with_sub_item(title: "Users", path: "/admin/users")
            item.with_sub_item(title: "Roles", path: "/admin/roles")
          end
        )
      end
    end
  end
end
