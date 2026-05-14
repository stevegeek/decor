class ::Decor::Daisy::Nav::TopNavbarPreview < ::Lookbook::Preview
  # @label TopNavbar
  # A responsive navigation bar for the top of the page with support for branding, search, navigation items, and dropdown menus

  # @!group Examples

  # Basic navbar with brand only
  def basic
    render ::Decor::Daisy::Nav::TopNavbar.new(
      has_search: false,
      brand_text: "My App"
    )
  end

  # Navbar with search functionality
  def with_search
    render ::Decor::Daisy::Nav::TopNavbar.new(
      has_search: true,
      instant_search_path: "/search",
      brand_text: "Searchable App"
    )
  end

  # Navbar with navigation items
  def with_navigation
    render ::Decor::Daisy::Nav::TopNavbar.new(
      has_search: false,
      brand_text: "Company",
      brand_href: "/"
    ) do |navbar|
      navbar.with_nav_items do
        li { a(href: "/", class: "decor:d-btn decor:d-btn-ghost") { "Home" } }
        li { a(href: "/about", class: "decor:d-btn decor:d-btn-ghost") { "About" } }
        li { a(href: "/services", class: "decor:d-btn decor:d-btn-ghost") { "Services" } }
        li { a(href: "/contact", class: "decor:d-btn decor:d-btn-ghost") { "Contact" } }
      end
    end
  end

  # Full-featured navbar with all components
  def full_featured
    render ::Decor::Daisy::Nav::TopNavbar.new(has_search: true, instant_search_path: "/search") do |navbar|
      # Custom brand with logo
      navbar.with_brand do
        a(href: "/", class: "decor:d-btn decor:d-btn-ghost decor:text-xl decor:font-bold") do
          render ::Decor::Icon.new(name: "cube", classes: "decor:h-8 decor:w-8 decor:mr-2")
          "My App"
        end
      end

      # Navigation items
      navbar.with_nav_items do
        li { a(href: "/dashboard", class: "decor:d-btn decor:d-btn-ghost") { "Dashboard" } }
        li { a(href: "/projects", class: "decor:d-btn decor:d-btn-ghost") { "Projects" } }
        li { a(href: "/team", class: "decor:d-btn decor:d-btn-ghost") { "Team" } }
      end

      # Notifications menu
      navbar.with_notifications_menu(
        position: :right,
        classes: "decor:mr-2"
      ) do |menu|
        menu.trigger_button_content do
          div(class: "decor:d-indicator") do
            span(class: "decor:d-indicator-item decor:d-badge decor:d-badge-secondary decor:d-badge-sm") { "3" }
            render ::Decor::Icon.new(name: "bell", classes: "decor:h-6 decor:w-6")
          end
        end
        menu.menu_item(render(::Decor::Daisy::DropdownItem.new(text: "New message from Sarah", href: "#")))
        menu.menu_item(render(::Decor::Daisy::DropdownItem.new(text: "Deployment completed", href: "#")))
        menu.menu_item(render(::Decor::Daisy::DropdownItem.new(text: "Server alert", href: "#")))
        menu.menu_item(render(::Decor::Daisy::DropdownItem.new(text: "View all notifications", href: "/notifications")))
      end

      # Account menu with avatar
      navbar.with_account_menu(position: :right) do |menu|
        menu.trigger_button_content do
          render ::Decor::Daisy::Avatar.new(
            initials: "JD",
            size: :sm,
            color: :primary
          )
        end
        menu.menu_item(render(::Decor::Daisy::DropdownItem.new(text: "Profile", href: "/profile")))
        menu.menu_item(render(::Decor::Daisy::DropdownItem.new(text: "Account Settings", href: "/settings")))
        menu.menu_item(render(::Decor::Daisy::DropdownItem.new(text: "Billing", href: "/billing")))
        menu.menu_item(render(::Decor::Daisy::DropdownItem.new(text: "Sign out", href: "/logout")))
      end
    end
  end
  # @!endgroup

  # @!group Playground
  # @param has_search toggle
  # @param brand_text text
  # @param brand_href text
  # @param instant_search_path text
  def playground(
    has_search: true,
    brand_text: "My App",
    brand_href: "/",
    instant_search_path: "/search"
  )
    render ::Decor::Daisy::Nav::TopNavbar.new(
      has_search: has_search,
      brand_text: brand_text,
      brand_href: brand_href,
      instant_search_path: instant_search_path
    ) do |navbar|
      # Navigation items
      navbar.with_nav_items do
        li { a(href: "/home", class: "decor:d-btn decor:d-btn-ghost") { "Home" } }
        li { a(href: "/products", class: "decor:d-btn decor:d-btn-ghost") { "Products" } }
        li { a(href: "/about", class: "decor:d-btn decor:d-btn-ghost") { "About" } }
      end

      # Notifications menu
      navbar.with_notifications_menu(
        position: :right,
        classes: "decor:mr-2"
      ) do |menu|
        menu.trigger_button_content do
          span(class: "decor:sr-only") { "View notifications" }
          render ::Decor::Icon.new(name: "bell", classes: "decor:h-6 decor:w-6")
        end
        menu.menu_item(render(::Decor::Daisy::DropdownItem.new(text: "New message from John", href: "#")))
        menu.menu_item(render(::Decor::Daisy::DropdownItem.new(text: "System update available", href: "#")))
        menu.menu_item(render(::Decor::Daisy::DropdownItem.new(text: "View all notifications", href: "#")))
      end

      # Account menu
      navbar.with_account_menu(position: :right, classes: "decor:ml-3") do |menu|
        menu.trigger_button_content do
          render ::Decor::Daisy::Avatar.new(initials: "CC", size: :sm)
        end
        menu.menu_item(render(::Decor::Daisy::DropdownItem.new(text: "Profile", href: "#")))
        menu.menu_item(render(::Decor::Daisy::DropdownItem.new(text: "Settings", href: "#")))
        menu.menu_item(render(::Decor::Daisy::DropdownItem.new(text: "Sign out", href: "#")))
      end
    end
  end
  # @!endgroup

  # @!group Brand Variations

  # Simple text brand
  def brand_text_only
    render ::Decor::Daisy::Nav::TopNavbar.new(
      has_search: false,
      brand_text: "Minimal Brand"
    )
  end

  # Brand with icon and custom styling
  def brand_with_icon
    render ::Decor::Daisy::Nav::TopNavbar.new(has_search: false) do |navbar|
      navbar.with_brand do
        a(href: "/", class: "decor:d-btn decor:d-btn-ghost decor:text-xl") do
          render ::Decor::Icon.new(name: "sparkles", classes: "decor:h-8 decor:w-8 decor:text-accent")
          span(class: "decor:ml-2 decor:font-bold decor:text-gradient decor:bg-gradient-to-r decor:from-primary decor:to-accent") { "Design Co" }
        end
      end
    end
  end
  # @!endgroup

  # @!group Menu Configurations

  # Account menu with login options
  def account_menu_login
    render ::Decor::Daisy::Nav::TopNavbar.new(
      has_search: false,
      brand_text: "Public Site"
    ) do |navbar|
      navbar.with_account_menu(position: :right) do |menu|
        menu.trigger_button_content do
          "Login"
        end
        menu.menu_item(render(::Decor::Daisy::DropdownItem.new(text: "Sign In", href: "/login")))
        menu.menu_item(render(::Decor::Daisy::DropdownItem.new(text: "Sign Up", href: "/register")))
      end
    end
  end

  # Notifications with badge indicator
  def notifications_with_badge
    render ::Decor::Daisy::Nav::TopNavbar.new(
      has_search: false,
      brand_text: "Notify App"
    ) do |navbar|
      navbar.with_notifications_menu(position: :right) do |menu|
        menu.trigger_button_content do
          div(class: "decor:d-indicator") do
            span(class: "decor:d-indicator-item decor:d-badge decor:d-badge-secondary decor:d-badge-sm") { "5" }
            render ::Decor::Icon.new(name: "bell", classes: "decor:h-6 decor:w-6")
          end
        end
        menu.menu_item(render(::Decor::Daisy::DropdownItem.new(text: "5 new notifications", href: "/notifications")))
      end
    end
  end
  # @!endgroup

  # @!group Responsive Examples

  # Mobile view demonstration
  def mobile_responsive
    render ::Decor::Daisy::Element.new(element_tag: :div, classes: "decor:d-mockup-phone") do
      render ::Decor::Daisy::Element.new(element_tag: :div, classes: "decor:camera")
      render ::Decor::Daisy::Element.new(element_tag: :div, classes: "decor:display") do
        render ::Decor::Daisy::Element.new(element_tag: :div, classes: "decor:artboard decor:artboard-demo decor:phone-1") do
          render ::Decor::Daisy::Nav::TopNavbar.new(has_search: true) do |navbar|
            navbar.with_account_menu do |menu|
              menu.trigger_button_content do
                render ::Decor::Daisy::Avatar.new(initials: "U", size: :xs)
              end
              menu.menu_item(render(::Decor::Daisy::DropdownItem.new(text: "Profile", href: "#")))
              menu.menu_item(render(::Decor::Daisy::DropdownItem.new(text: "Logout", href: "#")))
            end
          end
        end
      end
    end
  end
  # @!endgroup
end
