# @label TopNavbar
class ::Decor::Nav::TopNavbarPreview < ::Lookbook::Preview
  # @!group Playground
  # @param has_search toggle
  def playground(has_search: true)
    render ::Decor::Nav::TopNavbar.new(has_search: has_search) do |navbar|
      navbar.with_account_menu(position: :right, html_root_element_attributes: {class: "ml-3"}) do |menu|
        menu.trigger_button_content do
          render ::Decor::Avatar.new(initials: "CC", size: :sm)
        end
        menu.menu_item(render(::Decor::DropdownItem.new(text: "Profile", href: "#")))
        menu.menu_item(render(::Decor::DropdownItem.new(text: "Settings", href: "#")))
        menu.menu_item(render(::Decor::DropdownItem.new(text: "Sign out", href: "#")))
      end

      navbar.with_notifications_menu(
        position: :right,
        html_root_element_attributes: {class: "mr-2"}
      ) do |menu|
        menu.trigger_button_content do
          span(class: "sr-only") { "View notifications" }
          render ::Decor::Icon.new(name: "bell", html_root_element_attributes: {class: "h-6 w-6"})
        end
        menu.menu_item(render(::Decor::DropdownItem.new(text: "New message from John", href: "#")))
        menu.menu_item(render(::Decor::DropdownItem.new(text: "System update available", href: "#")))
        menu.menu_item(render(::Decor::DropdownItem.new(text: "View all notifications", href: "#")))
      end
    end
  end
  # @!endgroup

  # @!group Examples
  def basic_navbar
    render ::Decor::Nav::TopNavbar.new(
      has_search: false,
      brand_text: "My App"
    )
  end

  def with_search_only
    render ::Decor::Nav::TopNavbar.new(has_search: true, instant_search_path: "/search")
  end

  def full_featured
    render ::Decor::Nav::TopNavbar.new(has_search: true, instant_search_path: "/search") do |navbar|
      # Custom brand with logo
      navbar.with_brand do
        a(href: "/", class: "btn btn-ghost text-xl font-bold") do
          render ::Decor::Icon.new(name: "cube", html_root_element_attributes: {class: "h-8 w-8 mr-2"})
          "My App"
        end
      end

      # Navigation items
      navbar.with_nav_items do
        li { a(href: "/dashboard", class: "btn btn-ghost") { "Dashboard" } }
        li { a(href: "/projects", class: "btn btn-ghost") { "Projects" } }
        li { a(href: "/team", class: "btn btn-ghost") { "Team" } }
      end

      # Account menu with avatar
      navbar.with_account_menu(position: :right) do |menu|
        menu.trigger_button_content do
          render ::Decor::Avatar.new(
            initials: "JD",
            size: :sm,
            color: :primary
          )
        end
        menu.menu_item(render(::Decor::DropdownItem.new(text: "👤 Profile", href: "/profile")))
        menu.menu_item(render(::Decor::DropdownItem.new(text: "⚙️ Account Settings", href: "/settings")))
        menu.menu_item(render(::Decor::DropdownItem.new(text: "💰 Billing", href: "/billing")))
        menu.menu_item(render(::Decor::DropdownItem.new(text: "🚪 Sign out", href: "/logout")))
      end

      # Notifications menu
      navbar.with_notifications_menu(
        position: :right,
        html_root_element_attributes: {class: "mr-2"}
      ) do |menu|
        menu.trigger_button_content do
          div(class: "indicator") do
            span(class: "indicator-item badge badge-secondary badge-sm") { "3" }
            render ::Decor::Icon.new(name: "bell", html_root_element_attributes: {class: "h-6 w-6"})
          end
        end
        menu.menu_item(render(::Decor::DropdownItem.new(text: "📧 New message from Sarah", href: "#")))
        menu.menu_item(render(::Decor::DropdownItem.new(text: "🔄 Deployment completed", href: "#")))
        menu.menu_item(render(::Decor::DropdownItem.new(text: "⚠️ Server alert", href: "#")))
        menu.menu_item(render(::Decor::DropdownItem.new(text: "📊 View all notifications", href: "/notifications")))
      end
    end
  end

  def mobile_responsive
    render ::Decor::Element.new(root_element_attributes: {element_tag: :div, html_root_element_attributes: {class: "mockup-phone"}}) do
      render ::Decor::Element.new(root_element_attributes: {element_tag: :div, html_root_element_attributes: {class: "camera"}})
      render ::Decor::Element.new(root_element_attributes: {element_tag: :div, html_root_element_attributes: {class: "display"}}) do
        render ::Decor::Element.new(root_element_attributes: {element_tag: :div, html_root_element_attributes: {class: "artboard artboard-demo phone-1"}}) do
          render ::Decor::Nav::TopNavbar.new(has_search: true) do |navbar|
            navbar.with_account_menu do |menu|
              menu.trigger_button_content do
                render ::Decor::Avatar.new(initials: "U", size: :xs)
              end
              menu.menu_item(render(::Decor::DropdownItem.new(text: "Profile", href: "#")))
              menu.menu_item(render(::Decor::DropdownItem.new(text: "Logout", href: "#")))
            end
          end
        end
      end
    end
  end

  def with_navigation_menu
    render ::Decor::Nav::TopNavbar.new(
      has_search: false,
      brand_text: "Company",
      brand_href: "/"
    ) do |navbar|
      navbar.with_nav_items do
        li { a(href: "/", class: "btn btn-ghost") { "Home" } }
        li { a(href: "/about", class: "btn btn-ghost") { "About" } }
        li { a(href: "/services", class: "btn btn-ghost") { "Services" } }
        li { a(href: "/contact", class: "btn btn-ghost") { "Contact" } }
      end

      navbar.with_account_menu(position: :right) do |menu|
        menu.trigger_button_content do
          "Login"
        end
        menu.menu_item(render(::Decor::DropdownItem.new(text: "Sign In", href: "/login")))
        menu.menu_item(render(::Decor::DropdownItem.new(text: "Sign Up", href: "/register")))
      end
    end
  end

  def with_custom_styling
    render ::Decor::Nav::TopNavbar.new(
      has_search: true,
      brand_text: "Dark Theme"
    ) do |navbar|
      navbar.with_nav_items do
        li { a(href: "/", class: "btn btn-ghost text-primary-content") { "Home" } }
        li { a(href: "/features", class: "btn btn-ghost text-primary-content") { "Features" } }
      end

      navbar.with_account_menu(
        position: :right,
        html_root_element_attributes: {class: "dropdown-end"}
      ) do |menu|
        menu.trigger_button_content do
          render ::Decor::Avatar.new(
            initials: "AD",
            size: :sm,
            color: :accent
          )
        end
        menu.menu_item(render(::Decor::DropdownItem.new(text: "Dashboard", href: "#")))
        menu.menu_item(render(::Decor::DropdownItem.new(text: "Settings", href: "#")))
      end
    end
  end

  def minimal_brand_only
    render ::Decor::Nav::TopNavbar.new(
      has_search: false,
      brand_text: "Minimal"
    )
  end

  def with_icon_brand
    render ::Decor::Nav::TopNavbar.new(has_search: false) do |navbar|
      navbar.with_brand do
        a(href: "/", class: "btn btn-ghost text-xl") do
          render ::Decor::Icon.new(name: "sparkles", html_root_element_attributes: {class: "h-8 w-8 text-accent"})
          span(class: "ml-2 font-bold text-gradient bg-gradient-to-r from-primary to-accent") { "Design Co" }
        end
      end

      navbar.with_nav_items do
        li { a(href: "/portfolio", class: "btn btn-ghost") { "Portfolio" } }
        li { a(href: "/services", class: "btn btn-ghost") { "Services" } }
        li { a(href: "/blog", class: "btn btn-ghost") { "Blog" } }
      end
    end
  end
  # @!endgroup
end
