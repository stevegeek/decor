# @label Side Navbar Section
class ::Decor::Nav::SideNavbarSectionPreview < ::Lookbook::Preview
  # Groups related navigation items together with an optional title, commonly used within sidebar navigation.
  # @!group Examples

  # @label Basic Section
  def default
    render ::Decor::Nav::SideNavbarSection.new(title: "Main Navigation") do |section|
      section.with_item(title: "Dashboard", icon: "home", path: "/dashboard", selected: true)
      section.with_item(title: "Projects", icon: "folder", path: "/projects")
      section.with_item(title: "Team", icon: "users", path: "/team")
      section.with_item(title: "Reports", icon: "chart-bar", path: "/reports")
    end
  end

  # @label With Expandable Items
  def with_expandable_items
    render ::Decor::Nav::SideNavbarSection.new(title: "Administration") do |section|
      section.with_item(title: "Users", icon: "users") do |item|
        item.with_sub_item(title: "All Users", path: "/admin/users")
        item.with_sub_item(title: "Roles", path: "/admin/roles")
        item.with_sub_item(title: "Permissions", path: "/admin/permissions")
      end

      section.with_item(title: "System", icon: "cog") do |item|
        item.with_sub_item(title: "Configuration", path: "/admin/config")
        item.with_sub_item(title: "Logs", path: "/admin/logs")
      end

      section.with_item(title: "Billing", icon: "credit-card", path: "/admin/billing")
    end
  end

  # @label With Counters
  def with_counters
    render ::Decor::Nav::SideNavbarSection.new(title: "Activity") do |section|
      section.with_item(title: "Inbox", icon: "inbox", path: "/inbox", counter: 12)
      section.with_item(title: "Notifications", icon: "bell", path: "/notifications", counter: 5)
      section.with_item(title: "Messages", icon: "mail", path: "/messages", counter: 28)
      section.with_item(title: "Alerts", icon: "exclamation", path: "/alerts", counter: 3)
    end
  end

  # @label Multiple Sections
  def multiple_sections
    render ::Decor::Element.new html_options: {class: "space-y-4"} do |nav|
      nav.render ::Decor::Nav::SideNavbarSection.new(title: "Main") do |section|
        section.with_item(title: "Dashboard", icon: "home", path: "/dashboard", selected: true)
        section.with_item(title: "Projects", icon: "folder", path: "/projects")
      end

      nav.render ::Decor::Nav::SideNavbarSection.new(title: "Management") do |section|
        section.with_item(title: "Team", icon: "users") do |item|
          item.with_sub_item(title: "Members", path: "/team/members")
          item.with_sub_item(title: "Roles", path: "/team/roles")
        end
        section.with_item(title: "Settings", icon: "cog", path: "/settings")
      end

      nav.render ::Decor::Nav::SideNavbarSection.new do |section|
        section.with_item(title: "Help", icon: "question-mark-circle", path: "/help")
        section.with_item(title: "Logout", icon: "logout", path: "/logout")
      end
    end
  end

  # @!endgroup

  # @!group Playground

  # @label Playground
  # @param title [String] text
  # @param items_count [Integer] number
  def playground(title: "Main", items_count: 3)
    render ::Decor::Nav::SideNavbarSection.new(title: title.present? ? title : nil) do |section|
      (1..items_count).each do |i|
        section.with_item(
          title: "Item #{i}",
          icon: ["home", "users", "cog", "chart-bar", "folder"][i % 5],
          path: "/item-#{i}"
        )
      end
    end
  end

  # @!endgroup

  # @!group Title Variations

  # @label With Title
  def with_title
    render ::Decor::Nav::SideNavbarSection.new(title: "Main Navigation") do |section|
      section.with_item(title: "Dashboard", icon: "home", path: "/dashboard")
      section.with_item(title: "Projects", icon: "folder", path: "/projects")
      section.with_item(title: "Team", icon: "users", path: "/team")
    end
  end

  # @label Without Title
  def without_title
    render ::Decor::Nav::SideNavbarSection.new do |section|
      section.with_item(title: "Settings", icon: "cog", path: "/settings")
      section.with_item(title: "Help", icon: "question-mark-circle", path: "/help")
      section.with_item(title: "Logout", icon: "logout", path: "/logout")
    end
  end

  # @label Empty Section
  def empty_section
    render ::Decor::Nav::SideNavbarSection.new(title: "Empty Section")
  end

  # @!endgroup

  # @!group Item Variations

  # @label Mixed Item Types
  def mixed_items
    render ::Decor::Nav::SideNavbarSection.new(title: "Workspace") do |section|
      # Simple item with icon
      section.with_item(title: "Overview", icon: "home", path: "/overview", selected: true)

      # Item with counter
      section.with_item(title: "Tasks", icon: "clipboard-list", path: "/tasks", counter: 15)

      # Expandable item
      section.with_item(title: "Documents", icon: "document") do |item|
        item.with_sub_item(title: "Recent", path: "/documents/recent")
        item.with_sub_item(title: "Shared", path: "/documents/shared", selected: true)
        item.with_sub_item(title: "Templates", path: "/documents/templates")
      end

      # Simple item without icon
      section.with_item(title: "Calendar", path: "/calendar")

      # Item with icon and counter
      section.with_item(title: "Messages", icon: "chat", path: "/messages", counter: 7)
    end
  end

  # @!endgroup
end
