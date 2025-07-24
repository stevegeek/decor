# @label Side Navbar Sub Item
# A sub-navigation item that appears under expandable navigation items in the side navbar.
# Typically used as a child of SideNavbarItem components for nested navigation.
class ::Decor::Nav::SideNavbarSubItemPreview < ::Lookbook::Preview
  # @group Examples

  # @label Basic Sub Item
  def basic_sub_item
    render ::Decor::Nav::SideNavbarSubItem.new(
      title: "Overview",
      path: "/dashboard/overview"
    )
  end

  # @label Selected Sub Item
  def selected_sub_item
    render ::Decor::Nav::SideNavbarSubItem.new(
      title: "Analytics",
      path: "/dashboard/analytics",
      selected: true
    )
  end

  # @label Sub Item with Icon
  def sub_item_with_icon
    render ::Decor::Nav::SideNavbarSubItem.new(
      title: "Settings",
      icon: "cog",
      path: "/dashboard/settings"
    )
  end

  # @label Multiple Sub Items
  def multiple_sub_items
    render ::Decor::Element.new do |el|
      el.render ::Decor::Nav::SideNavbarSubItem.new(
        title: "All Projects",
        path: "/projects"
      )
      el.render ::Decor::Nav::SideNavbarSubItem.new(
        title: "Active",
        path: "/projects/active",
        selected: true
      )
      el.render ::Decor::Nav::SideNavbarSubItem.new(
        title: "Completed",
        path: "/projects/completed"
      )
      el.render ::Decor::Nav::SideNavbarSubItem.new(
        title: "Archived",
        path: "/projects/archived"
      )
    end
  end

  # @endgroup

  # @group Playground

  # @label Playground
  # @param title [String] text
  # @param icon [String] text
  # @param path [String] text
  # @param selected [Boolean] checkbox
  def playground(title: "Sub Item", icon: nil, path: "/sub-item", selected: false)
    render ::Decor::Nav::SideNavbarSubItem.new(
      title: title,
      icon: icon.present? ? icon : nil,
      path: path,
      selected: selected
    )
  end

  # @endgroup

  # @group States

  # @label Sub Item States
  def sub_item_states
    render ::Decor::Element.new html_options: {class: "space-y-4"} do |el|
      el.h4 "Normal State", class: "text-gray-400 text-xs uppercase tracking-wider font-semibold"
      el.div class: "pl-8" do |sub|
        sub.render ::Decor::Nav::SideNavbarSubItem.new(
          title: "Normal Sub Item",
          path: "/normal"
        )
      end

      el.h4 "Selected State", class: "text-gray-400 text-xs uppercase tracking-wider font-semibold"
      el.div class: "pl-8" do |sub|
        sub.render ::Decor::Nav::SideNavbarSubItem.new(
          title: "Selected Sub Item",
          path: "/selected",
          selected: true
        )
      end

      el.h4 "With Icon", class: "text-gray-400 text-xs uppercase tracking-wider font-semibold"
      el.div class: "pl-8" do |sub|
        sub.render ::Decor::Nav::SideNavbarSubItem.new(
          title: "Sub Item with Icon",
          icon: "document",
          path: "/with-icon"
        )
      end

      el.h4 "Selected with Icon", class: "text-gray-400 text-xs uppercase tracking-wider font-semibold"
      el.div class: "pl-8" do |sub|
        sub.render ::Decor::Nav::SideNavbarSubItem.new(
          title: "Selected with Icon",
          icon: "star",
          path: "/selected-with-icon",
          selected: true
        )
      end
    end
  end

  # @endgroup

  # @group Icons

  # @label Sub Items with Icons
  def sub_items_with_icons
    render ::Decor::Element.new do |el|
      el.render ::Decor::Nav::SideNavbarSubItem.new(
        title: "Profile",
        icon: "user",
        path: "/settings/profile"
      )
      el.render ::Decor::Nav::SideNavbarSubItem.new(
        title: "Security",
        icon: "shield-check",
        path: "/settings/security",
        selected: true
      )
      el.render ::Decor::Nav::SideNavbarSubItem.new(
        title: "Notifications",
        icon: "bell",
        path: "/settings/notifications"
      )
      el.render ::Decor::Nav::SideNavbarSubItem.new(
        title: "Billing",
        icon: "credit-card",
        path: "/settings/billing"
      )
    end
  end

  # @endgroup

  # @group Text Handling

  # @label Long Title Handling
  def long_title_handling
    render ::Decor::Element.new html_options: {class: "space-y-4"} do |el|
      el.render ::Decor::Nav::SideNavbarSubItem.new(
        title: "Short",
        path: "/short"
      )
      el.render ::Decor::Nav::SideNavbarSubItem.new(
        title: "Medium Length Title",
        path: "/medium"
      )
      el.render ::Decor::Nav::SideNavbarSubItem.new(
        title: "Very Long Sub Item Title That Tests Text Wrapping",
        path: "/very-long",
        selected: true
      )
      el.render ::Decor::Nav::SideNavbarSubItem.new(
        title: "Extremely Long Sub Navigation Item Title That Really Tests The Limits",
        icon: "document",
        path: "/extremely-long"
      )
    end
  end

  # @endgroup
end
