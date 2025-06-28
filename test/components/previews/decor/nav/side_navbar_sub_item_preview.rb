# @label Side Navbar Sub Item
class ::Decor::Nav::SideNavbarSubItemPreview < ::Lookbook::Preview
  # Side Navbar Sub Item
  # -------
  #
  # A sub-navigation item that appears under expandable navigation items.
  # Typically used as a child of SideNavbarItem components.
  #
  # @label Playground
  # @param title [String] text
  # @param icon [String] text
  # @param path [String] text
  # @param selected [Boolean] checkbox
  def playground(title: "Sub Item", icon: nil, path: "/sub-item", selected: false)
    content_tag :div, class: "bg-gray-800 w-64 p-4" do
      content_tag :div, class: "pl-8" do
        render ::Decor::Nav::SideNavbarSubItem.new(
          title: title,
          icon: icon.present? ? icon : nil,
          path: path,
          selected: selected
        )
      end
    end
  end

  # @label Basic Sub Item
  def basic_sub_item
    content_tag :div, class: "bg-gray-800 w-64 p-4" do
      content_tag :div, class: "pl-8" do
        render ::Decor::Nav::SideNavbarSubItem.new(
          title: "Overview",
          path: "/dashboard/overview"
        )
      end
    end
  end

  # @label Selected Sub Item
  def selected_sub_item
    content_tag :div, class: "bg-gray-800 w-64 p-4" do
      content_tag :div, class: "pl-8" do
        render ::Decor::Nav::SideNavbarSubItem.new(
          title: "Analytics",
          path: "/dashboard/analytics",
          selected: true
        )
      end
    end
  end

  # @label Sub Item with Icon
  def sub_item_with_icon
    content_tag :div, class: "bg-gray-800 w-64 p-4" do
      content_tag :div, class: "pl-8" do
        render ::Decor::Nav::SideNavbarSubItem.new(
          title: "Settings",
          icon: "cog",
          path: "/dashboard/settings"
        )
      end
    end
  end

  # @label Multiple Sub Items
  def multiple_sub_items
    content_tag :div, class: "bg-gray-800 w-64 p-4" do
      content_tag :div, class: "pl-8 space-y-1" do
        concat(
          render(::Decor::Nav::SideNavbarSubItem.new(
            title: "All Projects",
            path: "/projects"
          ))
        )
        concat(
          render(::Decor::Nav::SideNavbarSubItem.new(
            title: "Active",
            path: "/projects/active",
            selected: true
          ))
        )
        concat(
          render(::Decor::Nav::SideNavbarSubItem.new(
            title: "Completed",
            path: "/projects/completed"
          ))
        )
        concat(
          render(::Decor::Nav::SideNavbarSubItem.new(
            title: "Archived",
            path: "/projects/archived"
          ))
        )
        concat(
          render(::Decor::Nav::SideNavbarSubItem.new(
            title: "Templates",
            icon: "template",
            path: "/projects/templates"
          ))
        )
      end
    end
  end

  # @label Sub Items with Icons
  def sub_items_with_icons
    content_tag :div, class: "bg-gray-800 w-64 p-4" do
      content_tag :div, class: "pl-8 space-y-1" do
        concat(
          render(::Decor::Nav::SideNavbarSubItem.new(
            title: "Profile",
            icon: "user",
            path: "/settings/profile"
          ))
        )
        concat(
          render(::Decor::Nav::SideNavbarSubItem.new(
            title: "Security",
            icon: "shield-check",
            path: "/settings/security",
            selected: true
          ))
        )
        concat(
          render(::Decor::Nav::SideNavbarSubItem.new(
            title: "Notifications",
            icon: "bell",
            path: "/settings/notifications"
          ))
        )
        concat(
          render(::Decor::Nav::SideNavbarSubItem.new(
            title: "Billing",
            icon: "credit-card",
            path: "/settings/billing"
          ))
        )
      end
    end
  end

  # @label In Context with Parent Item
  def in_context_with_parent
    content_tag :div, class: "bg-gray-800 w-64 p-4" do
      content_tag :nav, class: "space-y-1" do
        # Parent item (mock representation)
        concat(
          content_tag(:button,
            class: "w-full text-gray-300 hover:bg-gray-700 hover:text-white group flex items-center px-2 py-2 text-sm font-medium rounded-md") do
            concat(
              content_tag(:svg,
                class: "text-gray-400 group-hover:text-gray-300 mr-3 flex-shrink-0 h-6 w-6",
                fill: "currentColor",
                viewBox: "0 0 20 20") do
                content_tag(:path, nil, d: "M2 6a2 2 0 012-2h5l2 2h5a2 2 0 012 2v6a2 2 0 01-2 2H4a2 2 0 01-2-2V6z")
              end
            )
            concat content_tag(:span, "Projects", class: "flex-1")
            concat(
              content_tag(:svg,
                class: "flex-shrink-0 w-5 h-5 ml-auto transform duration-150 rotate-180",
                viewBox: "0 0 20 20",
                fill: "none") do
                content_tag(:path, nil, d: "M14 6L10 14L6 6L14 6Z", fill: "currentColor")
              end
            )
          end
        )

        # Sub items
        content_tag(:div, class: "pl-8 space-y-1") do
          concat(
            render(::Decor::Nav::SideNavbarSubItem.new(
              title: "All Projects",
              path: "/projects"
            ))
          )
          concat(
            render(::Decor::Nav::SideNavbarSubItem.new(
              title: "My Projects",
              path: "/projects/mine",
              selected: true
            ))
          )
          concat(
            render(::Decor::Nav::SideNavbarSubItem.new(
              title: "Shared with me",
              path: "/projects/shared"
            ))
          )
          concat(
            render(::Decor::Nav::SideNavbarSubItem.new(
              title: "Archived",
              path: "/projects/archived"
            ))
          )
        end
      end
    end
  end

  # @label Sub Item States
  def sub_item_states
    content_tag :div, class: "bg-gray-800 w-64 p-4" do
      content_tag :div, class: "space-y-4" do
        concat content_tag(:h4, "Normal State", class: "text-gray-400 text-xs uppercase tracking-wider font-semibold")
        concat(
          content_tag(:div, class: "pl-8") do
            render ::Decor::Nav::SideNavbarSubItem.new(
              title: "Normal Sub Item",
              path: "/normal"
            )
          end
        )

        concat content_tag(:h4, "Selected State", class: "text-gray-400 text-xs uppercase tracking-wider font-semibold")
        concat(
          content_tag(:div, class: "pl-8") do
            render ::Decor::Nav::SideNavbarSubItem.new(
              title: "Selected Sub Item",
              path: "/selected",
              selected: true
            )
          end
        )

        concat content_tag(:h4, "With Icon", class: "text-gray-400 text-xs uppercase tracking-wider font-semibold")
        concat(
          content_tag(:div, class: "pl-8") do
            render ::Decor::Nav::SideNavbarSubItem.new(
              title: "Sub Item with Icon",
              icon: "document",
              path: "/with-icon"
            )
          end
        )

        concat content_tag(:h4, "Selected with Icon", class: "text-gray-400 text-xs uppercase tracking-wider font-semibold")
        concat(
          content_tag(:div, class: "pl-8") do
            render ::Decor::Nav::SideNavbarSubItem.new(
              title: "Selected with Icon",
              icon: "star",
              path: "/selected-with-icon",
              selected: true
            )
          end
        )
      end
    end
  end

  # @label Long Title Handling
  def long_title_handling
    content_tag :div, class: "bg-gray-800 w-64 p-4" do
      content_tag :div, class: "pl-8 space-y-1" do
        concat(
          render(::Decor::Nav::SideNavbarSubItem.new(
            title: "Short",
            path: "/short"
          ))
        )
        concat(
          render(::Decor::Nav::SideNavbarSubItem.new(
            title: "Medium Length Title",
            path: "/medium"
          ))
        )
        concat(
          render(::Decor::Nav::SideNavbarSubItem.new(
            title: "Very Long Sub Item Title That Tests Text Wrapping",
            path: "/very-long",
            selected: true
          ))
        )
        concat(
          render(::Decor::Nav::SideNavbarSubItem.new(
            title: "Extremely Long Sub Navigation Item Title That Really Tests The Limits",
            icon: "document",
            path: "/extremely-long"
          ))
        )
      end
    end
  end
end
