# @label SideNavbar
# @display margin none
class ::Decor::Nav::SideNavbarPreview < ::Lookbook::Preview
  # SideNavbar
  # ----------
  #
  # A collapsible side navigation component that adapts to desktop and mobile views.
  # Supports nested navigation items, counters, and expandable/collapsible states.
  #
  # @group Examples
  # @label Basic Side Navigation
  def default
    render ::Decor::Nav::SideNavbar.new(
      landscape_logo_url: "https://via.placeholder.com/220x64/570DF8/FFFFFF.png?text=Logo",
      avatar_logo_url: "https://via.placeholder.com/64x64/570DF8/FFFFFF.png?text=L"
    ) do |navbar|
      navbar.with_section do |section|
        section.with_item(title: "Dashboard", icon: "home", path: "/dashboard", selected: true)
        section.with_item(title: "Analytics", icon: "chart-bar", path: "/analytics")
      end

      navbar.with_section(title: "Navigation") do |section|
        section.with_item(title: "Users", icon: "users", path: "/users", counter: 23)
        section.with_item(title: "Settings", icon: "cog", path: "/settings")
      end
    end
  end

  # @group Examples
  # @label With Nested Items
  def with_nested_items
    render ::Decor::Nav::SideNavbar.new(
      landscape_logo_url: "https://via.placeholder.com/220x64/570DF8/FFFFFF.png?text=Logo",
      avatar_logo_url: "https://via.placeholder.com/64x64/570DF8/FFFFFF.png?text=L"
    ) do |navbar|
      navbar.with_section(title: "Main") do |section|
        section.with_item(title: "Users", icon: "users", path: "/users") do |item|
          item.with_sub_item(title: "All Users", path: "/users", selected: true)
          item.with_sub_item(title: "Add User", path: "/users/new")
          item.with_sub_item(title: "User Roles", path: "/users/roles", counter: 5)
        end

        section.with_item(title: "Settings", icon: "cog", path: "/settings") do |item|
          item.with_sub_item(title: "General", path: "/settings/general")
          item.with_sub_item(title: "Security", path: "/settings/security")
          item.with_sub_item(title: "Notifications", path: "/settings/notifications")
        end
      end
    end
  end

  # @group Examples
  # @label With Counters
  def with_counters
    render ::Decor::Nav::SideNavbar.new(
      landscape_logo_url: "https://via.placeholder.com/220x64/570DF8/FFFFFF.png?text=Logo",
      avatar_logo_url: "https://via.placeholder.com/64x64/570DF8/FFFFFF.png?text=L"
    ) do |navbar|
      navbar.with_section(title: "Activity") do |section|
        section.with_item(title: "Messages", icon: "mail", path: "/messages", counter: 12)
        section.with_item(title: "Notifications", icon: "bell", path: "/notifications", counter: 99)
        section.with_item(title: "Tasks", icon: "clipboard-list", path: "/tasks", counter: 7)
      end

      navbar.with_section(title: "Content") do |section|
        section.with_item(title: "Posts", icon: "document-text", path: "/posts", counter: 156)
        section.with_item(title: "Comments", icon: "chat", path: "/comments", counter: 23)
      end
    end
  end

  # @group Examples
  # @label Full Featured
  def full_featured
    render ::Decor::Nav::SideNavbar.new(
      landscape_logo_url: "https://via.placeholder.com/220x64/570DF8/FFFFFF.png?text=DaisyUI+Menu",
      avatar_logo_url: "https://via.placeholder.com/64x64/570DF8/FFFFFF.png?text=DM"
    ) do |navbar|
      # Dashboard section
      navbar.with_section do |section|
        section.with_item(title: "Dashboard", icon: "home", path: "/dashboard", selected: true)
        section.with_item(title: "Analytics", icon: "chart-bar", path: "/analytics", counter: 12)
      end

      # Navigation section
      navbar.with_section(title: "Navigation") do |section|
        section.with_item(title: "Users", icon: "users", path: "/users", counter: 23) do |item|
          item.with_sub_item(title: "All Users", path: "/users", selected: true)
          item.with_sub_item(title: "Add User", path: "/users/new")
          item.with_sub_item(title: "User Roles", path: "/users/roles", counter: 5)
        end

        section.with_item(title: "Settings", icon: "cog", path: "/settings") do |item|
          item.with_sub_item(title: "General", path: "/settings/general")
          item.with_sub_item(title: "Security", path: "/settings/security")
          item.with_sub_item(title: "Notifications", path: "/settings/notifications")
        end
      end

      # Content section
      navbar.with_section(title: "Content Management") do |section|
        section.with_item(title: "Posts", icon: "document-text", path: "/posts", counter: 156)
        section.with_item(title: "Media", icon: "photograph", path: "/media")
      end
    end
  end

  # @group Playground
  # @param start_collapsed toggle
  # @param size [Symbol] select [~, xs, sm, md, lg, xl]
  # @param color [Symbol] select [~, base, primary, secondary, accent, neutral, success, error, warning, info]
  # @param style [Symbol] select [~, filled, outlined, ghost]
  def playground(
    start_collapsed: false,
    size: nil,
    color: nil,
    style: nil
  )
    render ::Decor::Nav::SideNavbar.new(
      landscape_logo_url: "https://via.placeholder.com/220x64/570DF8/FFFFFF.png?text=Playground",
      avatar_logo_url: "https://via.placeholder.com/64x64/570DF8/FFFFFF.png?text=P",
      collapsed: start_collapsed,
      size: size,
      color: color,
      style: style
    ) do |navbar|
      navbar.with_section do |section|
        section.with_item(title: "Dashboard", icon: "home", path: "/dashboard", selected: true)
        section.with_item(title: "Analytics", icon: "chart-bar", path: "/analytics", counter: 12)
      end

      navbar.with_section(title: "Navigation") do |section|
        section.with_item(title: "Users", icon: "users", path: "/users", counter: 23) do |item|
          item.with_sub_item(title: "All Users", path: "/users")
          item.with_sub_item(title: "Add User", path: "/users/new")
        end
        section.with_item(title: "Settings", icon: "cog", path: "/settings")
      end
    end
  end

  # @group Collapsed State
  # @label Initially Collapsed
  def collapsed_state
    render ::Decor::Nav::SideNavbar.new(
      landscape_logo_url: "https://via.placeholder.com/220x64/570DF8/FFFFFF.png?text=Logo",
      avatar_logo_url: "https://via.placeholder.com/64x64/570DF8/FFFFFF.png?text=L",
      collapsed: true
    ) do |navbar|
      navbar.with_section do |section|
        section.with_item(title: "Home", icon: "home", path: "#", selected: true)
        section.with_item(title: "Analytics", icon: "chart-bar", path: "#")
        section.with_item(title: "Users", icon: "users", path: "#", counter: 23)
        section.with_item(title: "Settings", icon: "cog", path: "#")
      end
    end
  end

  # @group Search
  # @label With Search
  def with_search
    render ::Decor::Nav::SideNavbar.new(
      landscape_logo_url: "https://via.placeholder.com/220x64/570DF8/FFFFFF.png?text=Logo",
      avatar_logo_url: "https://via.placeholder.com/64x64/570DF8/FFFFFF.png?text=L"
    ) do |navbar|
      navbar.with_section do |section|
        section.with_item(title: "Dashboard", icon: "home", path: "/dashboard")
        section.with_item(title: "Search Results", icon: "search", path: "/search", selected: true)
      end
    end
  end

  # @group Search
  # @label Without Search
  def without_search
    render ::Decor::Nav::SideNavbar.new(
      landscape_logo_url: "https://via.placeholder.com/220x64/570DF8/FFFFFF.png?text=Logo",
      avatar_logo_url: "https://via.placeholder.com/64x64/570DF8/FFFFFF.png?text=L"
    ) do |navbar|
      navbar.with_section do |section|
        section.with_item(title: "Dashboard", icon: "home", path: "/dashboard")
        section.with_item(title: "Analytics", icon: "chart-bar", path: "/analytics")
      end
    end
  end
end
