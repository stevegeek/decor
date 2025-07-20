# @label SideNavbar
# @display margin none
class ::Decor::Nav::SideNavbarPreview < ::Lookbook::Preview
  # Page::SideNavbar
  # -------
  #
  # The SideNavbar is a navigation component that is placed on the side of the page.
  # On desktop is expanded by default and can be collapsed to an icon only form by clicking
  # on the hamburger icon.
  # On mobile the SideNavbar is always collapsed.
  #
  # @label Playground
  # @param start_collapsed toggle
  def playground(start_collapsed: false)
    render ::Decor::Nav::SideNavbar.new(
      landscape_logo_url: "https://via.placeholder.com/220x64/570DF8/FFFFFF.png?text=DaisyUI+Menu",
      avatar_logo_url: "https://via.placeholder.com/64x64/570DF8/FFFFFF.png?text=DM",
      collapsed: start_collapsed
    ) do |navbar|
      # Dashboard section
      navbar.with_section do |section|
        section.with_item(
          title: "Dashboard",
          icon: "home",
          path: "/dashboard",
          selected: true
        )
        section.with_item(
          title: "Analytics",
          icon: "chart-bar",
          path: "/analytics",
          counter: 12
        )
      end

      # Navigation section
      navbar.with_section(title: "Navigation") do |section|
        section.with_item(
          title: "Users",
          icon: "users",
          path: "/users",
          counter: 23
        ) do |item|
          item.with_sub_item(title: "All Users", path: "/users", selected: true)
          item.with_sub_item(title: "Add User", path: "/users/new")
          item.with_sub_item(title: "User Roles", path: "/users/roles", counter: 5)
        end

        section.with_item(
          title: "Settings",
          icon: "cog",
          path: "/settings"
        ) do |item|
          item.with_sub_item(title: "General", path: "/settings/general")
          item.with_sub_item(title: "Security", path: "/settings/security")
          item.with_sub_item(title: "Notifications", path: "/settings/notifications")
        end
      end

      # Content section
      navbar.with_section(title: "Content Management") do |section|
        section.with_item(
          title: "Posts",
          icon: "document-text",
          path: "/posts",
          counter: 156
        )
        section.with_item(
          title: "Media",
          icon: "photograph",
          path: "/media"
        )
      end
    end
  end

  # @!group DaisyUI Styling Examples

  # @label DaisyUI Menu Components
  def expanded_daisyui
    render ::Decor::Element.new(root_element_attributes: {element_tag: :div, html_root_element_attributes: {class: "flex h-screen"}}) do
      render ::Decor::Nav::SideNavbar.new(
        landscape_logo_url: "https://via.placeholder.com/200x50/00D7FF/FFFFFF?text=DaisyUI",
        avatar_logo_url: "https://via.placeholder.com/50x50/00D7FF/FFFFFF?text=D",
        collapsed: false
      ) do |navbar|
        navbar.with_section(title: "Dashboard") do |section|
          section.with_item(title: "Home", icon: "home", path: "#", selected: true)
          section.with_item(title: "Analytics", icon: "chart-bar", path: "#")
        end

        navbar.with_section(title: "Management") do |section|
          section.with_item(title: "Users", icon: "users", path: "#", counter: 23)
          section.with_item(title: "Settings", icon: "cog") do |item|
            item.with_sub_item(title: "General", path: "#")
            item.with_sub_item(title: "Security", path: "#", selected: true)
            item.with_sub_item(title: "Notifications", path: "#")
          end
        end

        navbar.with_section(title: "Content") do |section|
          section.with_item(title: "Posts", icon: "document-text", counter: 156) do |item|
            item.with_sub_item(title: "All Posts", path: "#")
            item.with_sub_item(title: "Draft", path: "#")
          end
        end
      end

      render ::Decor::Element.new(root_element_attributes: {element_tag: :main, html_root_element_attributes: {class: "flex-1 p-6 bg-base-100 ml-72"}}) do
        render ::Decor::Element.new(root_element_attributes: {element_tag: :div, html_root_element_attributes: {class: "max-w-4xl"}}) do
          h1(class: "text-3xl font-bold text-base-content mb-4") { "DaisyUI Menu Classes" }

          render ::Decor::Element.new(root_element_attributes: {element_tag: :div, html_root_element_attributes: {class: "alert alert-info mb-6"}}) do
            render ::Decor::Element.new(root_element_attributes: {element_tag: :div}) do
              strong { "DaisyUI Features:" }
              ul(class: "list-disc list-inside mt-2 space-y-1") do
                li { code(class: "bg-base-200 px-2 py-1 rounded text-sm") { "menu" } + " and " + code(class: "bg-base-200 px-2 py-1 rounded text-sm") { "menu-vertical" } + " for structure" }
                li { code(class: "bg-base-200 px-2 py-1 rounded text-sm") { "menu-title" } + " for section headers" }
                li { code(class: "bg-base-200 px-2 py-1 rounded text-sm") { "bg-base-300" } + " and " + code(class: "bg-base-200 px-2 py-1 rounded text-sm") { "text-base-content" } + " for theming" }
                li { code(class: "bg-base-200 px-2 py-1 rounded text-sm") { "badge-primary" } + " for counters" }
                li { code(class: "bg-base-200 px-2 py-1 rounded text-sm") { "active" } + " states with semantic colors" }
              end
            end
          end
        end
      end
    end
  end

  # @label Collapsed Icon-Only Mode
  def collapsed_daisyui
    render ::Decor::Element.new(root_element_attributes: {element_tag: :div, html_root_element_attributes: {class: "flex h-screen"}}) do
      render ::Decor::Nav::SideNavbar.new(
        landscape_logo_url: "https://via.placeholder.com/200x50/00D7FF/FFFFFF?text=DaisyUI",
        avatar_logo_url: "https://via.placeholder.com/50x50/00D7FF/FFFFFF?text=D",
        collapsed: true
      ) do |navbar|
        navbar.with_section do |section|
          section.with_item(title: "Home", icon: "home", path: "#", selected: true)
          section.with_item(title: "Analytics", icon: "chart-bar", path: "#")
          section.with_item(title: "Users", icon: "users", path: "#", counter: 23)
          section.with_item(title: "Settings", icon: "cog", path: "#")
        end
      end

      render ::Decor::Element.new(root_element_attributes: {element_tag: :main, html_root_element_attributes: {class: "flex-1 p-6 bg-base-100 ml-20"}}) do
        h1(class: "text-3xl font-bold text-base-content mb-4") { "Collapsed Sidebar Mode" }
        p(class: "text-base-content/70") { "Icons only, titles appear on hover. Click the expand button to see full menu." }
      end
    end
  end

  # @label Active States and Badges
  def active_states_and_badges
    render ::Decor::Element.new(root_element_attributes: {element_tag: :div, html_root_element_attributes: {class: "flex h-screen"}}) do
      render ::Decor::Nav::SideNavbar.new(
        landscape_logo_url: "https://via.placeholder.com/200x50/570DF8/FFFFFF?text=ACTIVE",
        avatar_logo_url: "https://via.placeholder.com/50x50/570DF8/FFFFFF?text=A",
        collapsed: false
      ) do |navbar|
        navbar.with_section(title: "Navigation Examples") do |section|
          section.with_item(title: "Active Item", icon: "check-circle", path: "#", selected: true)
          section.with_item(title: "Normal Item", icon: "home", path: "#")
          section.with_item(title: "With Badge", icon: "mail", path: "#", counter: 99)
        end

        navbar.with_section(title: "Expanded Section") do |section|
          section.with_item(title: "Parent with Active Child", icon: "folder-open", selected: true) do |item|
            item.with_sub_item(title: "Active Sub-item", path: "#", selected: true)
            item.with_sub_item(title: "Normal Sub-item", path: "#")
          end
          section.with_item(title: "Collapsed Parent", icon: "folder") do |item|
            item.with_sub_item(title: "Hidden Sub-item", path: "#")
          end
        end

        navbar.with_section(title: "Badge Examples") do |section|
          section.with_item(title: "Small Count", icon: "bell", path: "#", counter: 3)
          section.with_item(title: "Large Count", icon: "inbox", path: "#", counter: 1234)
        end
      end

      render ::Decor::Element.new(root_element_attributes: {element_tag: :main, html_root_element_attributes: {class: "flex-1 p-6 bg-base-100 ml-72"}}) do
        render ::Decor::Element.new(root_element_attributes: {element_tag: :div, html_root_element_attributes: {class: "bg-primary text-primary-content p-6 rounded-lg mb-6"}}) do
          h1(class: "text-2xl font-bold") { "Active States & Badge Examples" }
          p(class: "opacity-90 mt-2") { "Demonstrating DaisyUI active states and badge styling" }
        end

        render ::Decor::Element.new(root_element_attributes: {element_tag: :div, html_root_element_attributes: {class: "grid grid-cols-1 lg:grid-cols-3 gap-6 mb-6"}}) do
          render ::Decor::Element.new(root_element_attributes: {element_tag: :div, html_root_element_attributes: {class: "stat bg-base-100 shadow rounded-lg"}}) do
            render ::Decor::Element.new(root_element_attributes: {element_tag: :div, html_root_element_attributes: {class: "stat-title"}}) { "Active Items" }
            render ::Decor::Element.new(root_element_attributes: {element_tag: :div, html_root_element_attributes: {class: "stat-value text-primary"}}) { "2" }
            render ::Decor::Element.new(root_element_attributes: {element_tag: :div, html_root_element_attributes: {class: "stat-desc"}}) { "Currently selected" }
          end

          render ::Decor::Element.new(root_element_attributes: {element_tag: :div, html_root_element_attributes: {class: "stat bg-base-100 shadow rounded-lg"}}) do
            render ::Decor::Element.new(root_element_attributes: {element_tag: :div, html_root_element_attributes: {class: "stat-title"}}) { "Badge Count" }
            render ::Decor::Element.new(root_element_attributes: {element_tag: :div, html_root_element_attributes: {class: "stat-value text-secondary"}}) { "1339" }
            render ::Decor::Element.new(root_element_attributes: {element_tag: :div, html_root_element_attributes: {class: "stat-desc"}}) { "Total notifications" }
          end

          render ::Decor::Element.new(root_element_attributes: {element_tag: :div, html_root_element_attributes: {class: "stat bg-base-100 shadow rounded-lg"}}) do
            render ::Decor::Element.new(root_element_attributes: {element_tag: :div, html_root_element_attributes: {class: "stat-title"}}) { "Menu Items" }
            render ::Decor::Element.new(root_element_attributes: {element_tag: :div, html_root_element_attributes: {class: "stat-value text-accent"}}) { "8" }
            render ::Decor::Element.new(root_element_attributes: {element_tag: :div, html_root_element_attributes: {class: "stat-desc"}}) { "Total available" }
          end
        end

        render ::Decor::Element.new(root_element_attributes: {element_tag: :div, html_root_element_attributes: {class: "space-y-4"}}) do
          h2(class: "text-xl font-semibold text-base-content") { "DaisyUI Features in Action" }

          render ::Decor::Element.new(root_element_attributes: {element_tag: :div, html_root_element_attributes: {class: "grid grid-cols-1 md:grid-cols-2 gap-4"}}) do
            render ::Decor::Element.new(root_element_attributes: {element_tag: :div, html_root_element_attributes: {class: "alert alert-success"}}) do
              strong { "Active States: " }
              plain "Items with "
              code(class: "bg-base-200 px-1 rounded") { "selected: true" }
              plain " get "
              code(class: "bg-base-200 px-1 rounded") { "bg-primary" }
              plain " and "
              code(class: "bg-base-200 px-1 rounded") { "text-primary-content" }
            end

            render ::Decor::Element.new(root_element_attributes: {element_tag: :div, html_root_element_attributes: {class: "alert alert-info"}}) do
              strong { "Badges: " }
              plain "Counter values styled with "
              code(class: "bg-base-200 px-1 rounded") { "badge-primary" }
              plain " class"
            end
          end
        end
      end
    end
  end

  # @!endgroup

  # @!group New Method-Based API Examples

  # @label Fluent Builder API
  def fluent_builder_api
    render_with_template
  end

  # @label Mixed API (Builder + Block)
  def mixed_api_example
    render_with_template
  end

  # @!endgroup
end
