# @label Side Navbar Section
class ::Decor::Nav::SideNavbarSectionPreview < ::Lookbook::Preview
  # Side Navbar Section
  # -------
  #
  # A navigation section that groups related navigation items together
  # with an optional title. Commonly used in sidebar navigation.
  #
  # @label Playground
  # @param title [String] text
  # @param items_count [Integer] number
  def playground(title: "Main", items_count: 3)
    content_tag :div, class: "bg-gray-800 w-64 p-4" do
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
  end

  # @label Section with Title
  def section_with_title
    content_tag :div, class: "bg-gray-800 w-64 p-4" do
      render ::Decor::Nav::SideNavbarSection.new(title: "Main Navigation") do |section|
        section.with_item(title: "Dashboard", icon: "home", path: "/dashboard", selected: true)
        section.with_item(title: "Projects", icon: "folder", path: "/projects")
        section.with_item(title: "Team", icon: "users", path: "/team")
        section.with_item(title: "Reports", icon: "chart-bar", path: "/reports")
      end
    end
  end

  # @label Section without Title
  def section_without_title
    content_tag :div, class: "bg-gray-800 w-64 p-4" do
      render ::Decor::Nav::SideNavbarSection.new do |section|
        section.with_item(title: "Settings", icon: "cog", path: "/settings")
        section.with_item(title: "Help", icon: "question-mark-circle", path: "/help")
        section.with_item(title: "Logout", icon: "logout", path: "/logout")
      end
    end
  end

  # @label Section with Expandable Items
  def section_with_expandable_items
    content_tag :div, class: "bg-gray-800 w-64 p-4" do
      render ::Decor::Nav::SideNavbarSection.new(title: "Administration") do |section|
        section.with_item(title: "Users", icon: "users") do |item|
          item.with_sub_item(title: "All Users", path: "/admin/users")
          item.with_sub_item(title: "Roles", path: "/admin/roles")
          item.with_sub_item(title: "Permissions", path: "/admin/permissions")
        end

        section.with_item(title: "System", icon: "cog") do |item|
          item.with_sub_item(title: "Configuration", path: "/admin/config")
          item.with_sub_item(title: "Logs", path: "/admin/logs")
          item.with_sub_item(title: "Monitoring", path: "/admin/monitoring")
        end

        section.with_item(title: "Billing", icon: "credit-card", path: "/admin/billing")
      end
    end
  end

  # @label Section with Counters
  def section_with_counters
    content_tag :div, class: "bg-gray-800 w-64 p-4" do
      render ::Decor::Nav::SideNavbarSection.new(title: "Activity") do |section|
        section.with_item(title: "Inbox", icon: "inbox", path: "/inbox", counter: 12)
        section.with_item(title: "Notifications", icon: "bell", path: "/notifications", counter: 5)
        section.with_item(title: "Messages", icon: "mail", path: "/messages", counter: 28)
        section.with_item(title: "Alerts", icon: "exclamation", path: "/alerts", counter: 3)
      end
    end
  end

  # @label Multiple Sections
  def multiple_sections
    content_tag :div, class: "bg-gray-800 w-64 p-4" do
      content_tag :nav do
        concat(
          render(::Decor::Nav::SideNavbarSection.new(title: "Main")) do |section|
            section.with_item(title: "Dashboard", icon: "home", path: "/dashboard", selected: true)
            section.with_item(title: "Projects", icon: "folder", path: "/projects")
            section.with_item(title: "Analytics", icon: "chart-bar", path: "/analytics")
          end
        )

        concat(
          render(::Decor::Nav::SideNavbarSection.new(title: "Management")) do |section|
            section.with_item(title: "Team", icon: "users") do |item|
              item.with_sub_item(title: "Members", path: "/team/members")
              item.with_sub_item(title: "Roles", path: "/team/roles")
            end
            section.with_item(title: "Billing", icon: "credit-card", path: "/billing")
            section.with_item(title: "Settings", icon: "cog", path: "/settings")
          end
        )

        concat(
          render(::Decor::Nav::SideNavbarSection.new(title: "Support")) do |section|
            section.with_item(title: "Help Center", icon: "question-mark-circle", path: "/help")
            section.with_item(title: "Contact", icon: "mail", path: "/contact")
            section.with_item(title: "Feedback", icon: "chat", path: "/feedback", counter: 2)
          end
        )
      end
    end
  end

  # @label Section with Mixed Items
  def section_with_mixed_items
    content_tag :div, class: "bg-gray-800 w-64 p-4" do
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
  end

  # @label Empty Section
  def empty_section
    content_tag :div, class: "bg-gray-800 w-64 p-4" do
      render ::Decor::Nav::SideNavbarSection.new(title: "Empty Section")
    end
  end

  # @label Section Title Variations
  def section_title_variations
    content_tag :div, class: "bg-gray-800 w-64 p-4 space-y-2" do
      concat(
        render(::Decor::Nav::SideNavbarSection.new(title: "Short")) do |section|
          section.with_item(title: "Item 1", path: "/item1")
        end
      )

      concat(
        render(::Decor::Nav::SideNavbarSection.new(title: "Medium Length Title")) do |section|
          section.with_item(title: "Item 2", path: "/item2")
        end
      )

      concat(
        render(::Decor::Nav::SideNavbarSection.new(title: "Very Long Section Title That Tests Wrapping")) do |section|
          section.with_item(title: "Item 3", path: "/item3")
        end
      )
    end
  end
end
