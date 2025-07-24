# @label Breadcrumbs
class ::Decor::Nav::BreadcrumbsPreview < ::Lookbook::Preview
  # Breadcrumbs
  # -----------
  #
  # Navigation breadcrumbs showing the user's current location within a hierarchy.
  # Supports icons, disabled states, and mobile-responsive display with dropdown selection.
  #
  # @group Examples
  # @label Basic Breadcrumbs
  def default
    render ::Decor::Nav::Breadcrumbs.new(
      breadcrumbs: [
        {name: "Dashboard", path: "/dashboard"},
        {name: "Products", path: "/products"},
        {name: "Current Page", path: "/current", current: true}
      ]
    )
  end

  # @group Examples
  # @label With Icons
  def with_icons
    render ::Decor::Nav::Breadcrumbs.new(
      breadcrumbs: [
        {name: "Dashboard", path: "/dashboard", icon: "home"},
        {name: "Users", path: "/users", icon: "users"},
        {name: "Profile", path: "/profile", icon: "user", current: true}
      ]
    )
  end

  # @group Examples
  # @label Long Trail
  def long_trail
    render ::Decor::Nav::Breadcrumbs.new(
      breadcrumbs: [
        {name: "Level 1", path: "/level1"},
        {name: "Level 2 with Long Name", path: "/level2"},
        {name: "Level 3", path: "/level3"},
        {name: "Level 4 Subsection", path: "/level4"},
        {name: "Level 5", path: "/level5"},
        {name: "Current Very Long Page Name", path: "/current", current: true}
      ]
    )
  end

  # @group Examples
  # @label With Disabled Items
  def with_disabled_items
    render ::Decor::Nav::Breadcrumbs.new(
      breadcrumbs: [
        {name: "Active Page", path: "/active"},
        {name: "Disabled Page", path: "/disabled", disabled: true},
        {name: "Another Active", path: "/another"},
        {name: "Current Page", path: "/current", current: true}
      ]
    )
  end

  # @group Playground
  # @param show_home toggle
  # @param mobile_select toggle
  # @param home_path text
  # @param home_icon text
  # @param size [Symbol] select [~, xs, sm, md, lg, xl]
  # @param color [Symbol] select [~, base, primary, secondary, accent, neutral, success, error, warning, info]
  # @param style [Symbol] select [~, filled, outlined, ghost]
  def playground(
    show_home: true,
    mobile_select: true,
    home_path: "/",
    home_icon: "home",
    size: nil,
    color: nil,
    style: nil
  )
    render ::Decor::Nav::Breadcrumbs.new(
      breadcrumbs: [
        {name: "Home", path: "/", icon: "home"},
        {name: "Products", path: "/products", icon: "shopping-bag"},
        {name: "Electronics", path: "/electronics"},
        {name: "Current Page", path: "/current", current: true}
      ],
      show_home: show_home,
      mobile_select: mobile_select,
      home_path: home_path,
      home_icon: home_icon,
      size: size,
      color: color,
      style: style
    )
  end

  # @group Home Configuration
  # @label Without Home
  def without_home
    render ::Decor::Nav::Breadcrumbs.new(
      breadcrumbs: standard_breadcrumbs,
      show_home: false
    )
  end

  # @group Home Configuration
  # @label Custom Home
  def custom_home
    render ::Decor::Nav::Breadcrumbs.new(
      breadcrumbs: [
        {name: "Settings", path: "/settings"},
        {name: "Account", path: "/account", current: true}
      ],
      home_path: "/dashboard",
      home_icon: "cog"
    )
  end

  # @group Mobile Display
  # @label Mobile Select Enabled
  def mobile_select_enabled
    render ::Decor::Nav::Breadcrumbs.new(
      breadcrumbs: long_breadcrumbs,
      mobile_select: true
    )
  end

  # @group Mobile Display
  # @label Mobile Select Disabled
  def mobile_select_disabled
    render ::Decor::Nav::Breadcrumbs.new(
      breadcrumbs: long_breadcrumbs,
      mobile_select: false
    )
  end

  private

  def standard_breadcrumbs
    [
      {name: "Level 1", path: "/level1"},
      {name: "Level 2", path: "/level2"},
      {name: "Current", path: "/current", current: true}
    ]
  end

  def long_breadcrumbs
    [
      {name: "Dashboard", path: "/dashboard"},
      {name: "Projects", path: "/projects"},
      {name: "Web Development", path: "/web-dev"},
      {name: "React Application", path: "/react-app"},
      {name: "Component Library", path: "/components", current: true}
    ]
  end
end
