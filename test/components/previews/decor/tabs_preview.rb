# @label Tabs
class ::Decor::TabsPreview < ::Lookbook::Preview
  # Tabs Playground
  # ----
  #
  # Interactive playground for testing tabs with all available options.
  # Tabs can be configured with various sizes, colors, variants, and features.
  #
  # @param selected_link number
  # @param status text
  # @param size select { choices: [xs, sm, md, lg, xl] }
  # @param color select { choices: [base, primary, secondary, accent, success, error, warning, info, neutral] }
  # @param variant select { choices: [ghost, bordered, lifted, boxed] }
  def playground(selected_link: 1, status: "Optional status text", size: :md, color: :base, variant: :bordered)
    links = [
      {title: "Dashboard", href: "/dashboard", icon: "home"},
      {title: "Messages", href: "/messages", icon: "envelope", badge_text: "3", badge_color: :error},
      {title: "Settings", href: "/settings", icon: "cog"},
      {title: "Disabled", href: "#", disabled: true}
    ]
    links[selected_link - 1][:active] = true if links[selected_link - 1]
    render ::Decor::Tabs.new(links: links, status: status, size: size.to_sym, color: color.to_sym, variant: variant.to_sym)
  end

  # Basic Tabs
  # ----
  #
  # Simple tabs with text-only links.
  def basic
    links = [
      {title: "Home", href: "/", active: true},
      {title: "About", href: "/about"},
      {title: "Contact", href: "/contact"}
    ]
    render ::Decor::Tabs.new(links: links)
  end

  # @group Icons
  # @label Icons Before Text
  def icons_before
    links = [
      {title: "Dashboard", href: "/dashboard", icon: "chart-bar", icon_position: :before, active: true},
      {title: "Users", href: "/users", icon: "user-group", icon_position: :before},
      {title: "Settings", href: "/settings", icon: "cog", icon_position: :before}
    ]
    render ::Decor::Tabs.new(links: links)
  end

  # @group Icons
  # @label Icons After Text
  def icons_after
    links = [
      {title: "Export", href: "/export", icon: "arrow-down-tray", icon_position: :after, active: true},
      {title: "Share", href: "/share", icon: "share", icon_position: :after},
      {title: "Print", href: "/print", icon: "printer", icon_position: :after}
    ]
    render ::Decor::Tabs.new(links: links)
  end

  # @group Icons
  # @label Icon Only
  def icons_only
    links = [
      {title: "Home", href: "/home", icon: "home", icon_position: :only, active: true},
      {title: "Search", href: "/search", icon: "magnifying-glass", icon_position: :only},
      {title: "Profile", href: "/profile", icon: "user", icon_position: :only}
    ]
    render ::Decor::Tabs.new(links: links)
  end

  # @group Features
  # @label With Badges
  def with_badges
    links = [
      {title: "Inbox", href: "/inbox", icon: "inbox", badge_text: "12", badge_color: :primary, active: true},
      {title: "Alerts", href: "/alerts", icon: "bell", badge_text: "3", badge_color: :error},
      {title: "Archive", href: "/archive", icon: "archive-box"},
      {title: "Spam", href: "/spam", icon: "ban", badge_text: "99+", badge_color: :warning}
    ]
    render ::Decor::Tabs.new(links: links)
  end

  # @group Sizes
  # @label Extra Small Size
  def size_xs
    links = [
      {title: "Tab One", href: "#", active: true, icon: "cog"},
      {title: "Tab Two", href: "#", icon: "bell"},
      {title: "Tab Three", href: "#"}
    ]
    render ::Decor::Tabs.new(links: links, size: :xs)
  end

  # @group Sizes
  # @label Small Size
  def size_sm
    links = [
      {title: "Tab One", href: "#", active: true, icon: "cog"},
      {title: "Tab Two", href: "#", icon: "heart"},
      {title: "Tab Three", href: "#"}
    ]
    render ::Decor::Tabs.new(links: links, size: :sm)
  end

  # @group Sizes
  # @label Medium Size
  def size_md
    links = [
      {title: "Tab One", href: "#", active: true, icon: "cog"},
      {title: "Tab Two", href: "#", icon: "inbox"},
      {title: "Tab Three", href: "#"}
    ]
    render ::Decor::Tabs.new(links: links, size: :md)
  end

  # @group Sizes
  # @label Large Size
  def size_lg
    links = [
      {title: "Tab One", href: "#", active: true, icon: "cog"},
      {title: "Tab Two", href: "#", icon: "user"},
      {title: "Tab Three", href: "#"}
    ]
    render ::Decor::Tabs.new(links: links, size: :lg)
  end

  # @group Sizes
  # @label Extra Large Size
  def size_xl
    links = [
      {title: "Tab One", href: "#", active: true, icon: "cog"},
      {title: "Tab Two", href: "#", icon: "heart"},
      {title: "Tab Three", href: "#"}
    ]
    render ::Decor::Tabs.new(links: links, size: :xl)
  end

  # @group Variants
  # @label Ghost Variant
  def variant_ghost
    links = [
      {title: "Dashboard", href: "#", active: true},
      {title: "Analytics", href: "#"},
      {title: "Reports", href: "#"}
    ]
    render ::Decor::Tabs.new(links: links, variant: :ghost)
  end

  # @group Variants
  # @label Bordered Variant
  def variant_bordered
    links = [
      {title: "Dashboard", href: "#", active: true},
      {title: "Analytics", href: "#"},
      {title: "Reports", href: "#"}
    ]
    render ::Decor::Tabs.new(links: links, variant: :bordered)
  end

  # @group Variants
  # @label Lifted Variant
  def variant_lifted
    links = [
      {title: "Dashboard", href: "#", active: true},
      {title: "Analytics", href: "#"},
      {title: "Reports", href: "#"}
    ]
    render ::Decor::Tabs.new(links: links, variant: :lifted)
  end

  # @group Variants
  # @label Boxed Variant
  def variant_boxed
    links = [
      {title: "Dashboard", href: "#", active: true},
      {title: "Analytics", href: "#"},
      {title: "Reports", href: "#"}
    ]
    render ::Decor::Tabs.new(links: links, variant: :boxed)
  end

  # @group Colors
  # @label Base Color
  def color_base
    links = [
      {title: "Active Tab", href: "#", active: true},
      {title: "Regular Tab", href: "#"},
      {title: "Another Tab", href: "#"}
    ]
    render ::Decor::Tabs.new(links: links, color: :base)
  end

  # @group Colors
  # @label Primary Color
  def color_primary
    links = [
      {title: "Active Tab", href: "#", active: true},
      {title: "Regular Tab", href: "#"},
      {title: "Another Tab", href: "#"}
    ]
    render ::Decor::Tabs.new(links: links, color: :primary)
  end

  # @group Colors
  # @label Secondary Color
  def color_secondary
    links = [
      {title: "Active Tab", href: "#", active: true},
      {title: "Regular Tab", href: "#"},
      {title: "Another Tab", href: "#"}
    ]
    render ::Decor::Tabs.new(links: links, color: :secondary)
  end

  # @group Colors
  # @label Accent Color
  def color_accent
    links = [
      {title: "Active Tab", href: "#", active: true},
      {title: "Regular Tab", href: "#"},
      {title: "Another Tab", href: "#"}
    ]
    render ::Decor::Tabs.new(links: links, color: :accent)
  end

  # @group Colors
  # @label Success Color
  def color_success
    links = [
      {title: "Active Tab", href: "#", active: true},
      {title: "Regular Tab", href: "#"},
      {title: "Another Tab", href: "#"}
    ]
    render ::Decor::Tabs.new(links: links, color: :success)
  end

  # @group Colors
  # @label Error Color
  def color_error
    links = [
      {title: "Active Tab", href: "#", active: true},
      {title: "Regular Tab", href: "#"},
      {title: "Another Tab", href: "#"}
    ]
    render ::Decor::Tabs.new(links: links, color: :error)
  end

  # @group Colors
  # @label Warning Color
  def color_warning
    links = [
      {title: "Active Tab", href: "#", active: true},
      {title: "Regular Tab", href: "#"},
      {title: "Another Tab", href: "#"}
    ]
    render ::Decor::Tabs.new(links: links, color: :warning)
  end

  # @group Colors
  # @label Info Color
  def color_info
    links = [
      {title: "Active Tab", href: "#", active: true},
      {title: "Regular Tab", href: "#"},
      {title: "Another Tab", href: "#"}
    ]
    render ::Decor::Tabs.new(links: links, color: :info)
  end

  # @group Colors
  # @label Neutral Color
  def color_neutral
    links = [
      {title: "Active Tab", href: "#", active: true},
      {title: "Regular Tab", href: "#"},
      {title: "Another Tab", href: "#"}
    ]
    render ::Decor::Tabs.new(links: links, color: :neutral)
  end

  # @group Features
  # @label Mobile Responsive
  def mobile_responsive
    links = [
      {title: "Home", href: "/", active: true},
      {title: "Products", href: "/products"},
      {title: "Services", href: "/services"},
      {title: "About", href: "/about"},
      {title: "Contact", href: "/contact"},
      {title: "Blog", href: "/blog"},
      {title: "Support", href: "/support"}
    ]
    render ::Decor::Tabs.new(links: links, status: "7 total sections")
  end

  # @group States
  # @label Disabled States
  def disabled_states
    links = [
      {title: "Available", href: "/available", active: true},
      {title: "Coming Soon", href: "#", disabled: true},
      {title: "Maintenance", href: "#", disabled: true, icon: "wrench"},
      {title: "Active", href: "/active"}
    ]
    render ::Decor::Tabs.new(links: links)
  end

  # @group Features
  # @label With Status Text
  def with_status
    links = [
      {title: "All Items", href: "/all", active: true, badge_text: "247"},
      {title: "Active", href: "/active", badge_text: "198", badge_color: :success},
      {title: "Pending", href: "/pending", badge_text: "49", badge_color: :warning}
    ]
    render ::Decor::Tabs.new(links: links, status: "Last updated 2 min ago")
  end

  # @group Slot API
  # @label Custom Tab Buttons
  def slot_custom_buttons
    render ::Decor::Tabs.new(variant: :boxed, size: :lg) do |component|
      component.with_tab_buttons do
        button(role: "tab", class: "tab tab-active") do
          svg(class: "w-5 h-5 mr-2", fill: "currentColor", viewBox: "0 0 20 20") do |s|
            s.path(d: "M3 4a1 1 0 011-1h12a1 1 0 011 1v2a1 1 0 01-1 1H4a1 1 0 01-1-1V4zM3 10a1 1 0 011-1h6a1 1 0 011 1v6a1 1 0 01-1 1H4a1 1 0 01-1-1v-6zM14 9a1 1 0 00-1 1v6a1 1 0 001 1h2a1 1 0 001-1v-6a1 1 0 00-1-1h-2z")
          end
          plain "Dashboard"
        end
        button(role: "tab", class: "tab") do
          svg(class: "w-5 h-5 mr-2", fill: "currentColor", viewBox: "0 0 20 20") do |s|
            s.path(d: "M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z")
          end
          plain "Tasks"
          span(class: "badge badge-primary badge-sm ml-2") { "5" }
        end
        button(role: "tab", class: "tab") { "Reports" }
      end
    end
  end

  # @group Slot API
  # @label With Content Panels
  def slot_with_content
    render ::Decor::Tabs.new(variant: :lifted, color: :primary) do |component|
      component.with_tab_buttons do
        button(role: "tab", class: "tab tab-active") { "Overview" }
        button(role: "tab", class: "tab") { "Details" }
        button(role: "tab", class: "tab") { "Settings" }
      end
      component.with_tab_content do
        div(class: "mt-6 p-6 bg-base-100 rounded-lg border") do
          h4(class: "text-lg font-medium mb-3") { "Content Panel" }
          p(class: "text-base-content/70") { "This demonstrates tab content using the slot-based API. You can put any content here." }
        end
      end
    end
  end

  # @group Slot API
  # @label Minimal Slot Example
  def slot_minimal
    render ::Decor::Tabs.new(size: :sm) do |component|
      component.with_tab_buttons do
        a(role: "tab", class: "tab tab-active", href: "#tab1") { "Simple" }
        a(role: "tab", class: "tab", href: "#tab2") { "Clean" }
        a(role: "tab", class: "tab", href: "#tab3") { "Minimal" }
      end
    end
  end

  # @group Examples
  # @label Complex Example
  def complex_example
    links = [
      {
        title: "Dashboard",
        href: "/dashboard",
        icon: "chart-bar",
        icon_position: :before,
        active: true
      },
      {
        title: "Messages",
        href: "/messages",
        icon: "envelope",
        icon_position: :before,
        badge_text: "5",
        badge_color: :error
      },
      {
        title: "Tasks",
        href: "/tasks",
        icon: "check-circle",
        icon_position: :before,
        badge_text: "12",
        badge_color: :warning
      },
      {
        title: "Settings",
        href: "/settings",
        icon: "cog",
        icon_position: :before
      },
      {
        title: "Help",
        href: "/help",
        icon: "question-mark-circle",
        icon_position: :before
      }
    ]
    render ::Decor::Tabs.new(
      links: links,
      size: :lg,
      variant: :lifted,
      color: :primary,
      status: "5 notifications pending"
    )
  end
end
