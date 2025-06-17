# @label Breadcrumbs
class ::Navigo::BreadcrumbsPreview < ::Lookbook::Preview
  # @!group Basic Examples

  # Default breadcrumbs with hash array
  def default
    render ::Navigo::Breadcrumbs.new(
      breadcrumbs: [
        {name: "Dashboard", path: "/dashboard"},
        {name: "Products", path: "/products"},
        {name: "Current Page", path: "/current", current: true}
      ]
    )
  end

  # Breadcrumbs with icons
  def with_icons
    render ::Navigo::Breadcrumbs.new(
      breadcrumbs: [
        {name: "Dashboard", path: "/dashboard", icon: "home"},
        {name: "Users", path: "/users", icon: "users"},
        {name: "Profile", path: "/profile", icon: "user", current: true}
      ]
    )
  end

  # Breadcrumbs without home link
  def without_home
    render ::Navigo::Breadcrumbs.new(
      breadcrumbs: [
        {name: "Level 1", path: "/level1"},
        {name: "Level 2", path: "/level2"},
        {name: "Current", path: "/current", current: true}
      ],
      show_home: false
    )
  end

  # Custom home configuration
  def custom_home
    render ::Navigo::Breadcrumbs.new(
      breadcrumbs: [
        {name: "Settings", path: "/settings"},
        {name: "Account", path: "/account", current: true}
      ],
      home_path: "/dashboard",
      home_icon: "dashboard"
    )
  end

  # @!endgroup
  # @!group Advanced Examples

  # Breadcrumbs with disabled items
  def with_disabled_items
    render ::Navigo::Breadcrumbs.new(
      breadcrumbs: [
        {name: "Active Page", path: "/active"},
        {name: "Disabled Page", path: "/disabled", disabled: true},
        {name: "Another Active", path: "/another"},
        {name: "Current Page", path: "/current", current: true}
      ]
    )
  end

  # Long breadcrumb trail
  def long_trail
    render ::Navigo::Breadcrumbs.new(
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

  # Using Literal::Data objects directly
  def literal_data_objects
    breadcrumbs = [
      ::Navigo::Breadcrumbs::Breadcrumb.new(name: "Home", path: "/", icon: "home"),
      ::Navigo::Breadcrumbs::Breadcrumb.new(name: "Products", path: "/products", icon: "shopping-bag"),
      ::Navigo::Breadcrumbs::Breadcrumb.new(name: "Electronics", path: "/electronics"),
      ::Navigo::Breadcrumbs::Breadcrumb.new(name: "Laptops", path: "/laptops", current: true)
    ]

    render ::Navigo::Breadcrumbs.new(breadcrumbs: breadcrumbs)
  end

  # Mixed format (backward compatibility)
  def mixed_formats
    breadcrumbs = [
      {name: "Home", path: "/"},
      {label: "Products", href: "/products"}, # Old format
      ::Navigo::Breadcrumbs::Breadcrumb.new(name: "Category", path: "/category"),
      {name: "Current Item", path: "/current", current: true}
    ]

    render ::Navigo::Breadcrumbs.new(breadcrumbs: breadcrumbs)
  end

  # Without mobile select
  def no_mobile_select
    render ::Navigo::Breadcrumbs.new(
      breadcrumbs: [
        {name: "Level 1", path: "/level1"},
        {name: "Level 2", path: "/level2"},
        {name: "Current", path: "/current", current: true}
      ],
      mobile_select: false
    )
  end

  # @!endgroup
  # @!group Responsive Examples

  # Mobile-first breadcrumbs
  def mobile_responsive
    render ::Navigo::Breadcrumbs.new(
      breadcrumbs: [
        {name: "Dashboard", path: "/dashboard"},
        {name: "Projects", path: "/projects"},
        {name: "Web Development", path: "/web-dev"},
        {name: "React Application", path: "/react-app"},
        {name: "Component Library", path: "/components", current: true}
      ],
      mobile_select: true
    )
  end

  # @!endgroup
  # @!group Playground

  # Interactive playground for testing
  def playground
    render ::Navigo::Breadcrumbs.new(
      breadcrumbs: [
        {name: "Home", path: "/", icon: "home"},
        {name: "Products", path: "/products", icon: "shopping-bag"},
        {name: "Electronics", path: "/electronics"},
        {name: "Current Page", path: "/current", current: true}
      ],
      show_home: true,
      mobile_select: true
    )
  end

  # @!endgroup
end