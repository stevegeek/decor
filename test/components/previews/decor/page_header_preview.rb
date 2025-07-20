# @label PageHeader
class ::Decor::PageHeaderPreview < ::Lookbook::Preview
  # @!group Layout Examples

  # Default layout with all features
  def default_layout
    render ::Decor::PageHeader.new(
      title: "User Profile",
      subtitle: "Manage your account settings and preferences",
      description: "Update your personal information, change your password, and customize your experience."
    ) do |header|
      header.with_breadcrumbs do
        render ::Decor::Nav::Breadcrumbs.new(
          breadcrumbs: [
            {name: "Dashboard", path: "/dashboard"},
            {name: "Users", path: "/users"},
            {name: "Profile", path: "/profile", current: true}
          ]
        )
      end

      header.with_avatar do
        render ::Decor::Avatar.new(
          initials: "JD",
          size: :xl,
          url: "https://i.pravatar.cc/300"
        )
      end

      header.with_meta_content do
        div(class: "flex flex-wrap gap-2") do
          render ::Decor::Badge.new(label: "Active", style: :success)
          render ::Decor::Badge.new(label: "Premium", style: :standard)
          render ::Decor::Tag.new(label: "Admin", color: :warning)
        end
      end

      header.with_actions do
        render ::Decor::Button.new(label: "Edit Profile", color: :primary, icon: "edit")
        render ::Decor::Button.new(label: "Settings", variant: :outlined, icon: "cog")
      end

      header.with_secondary_actions do
        render ::Decor::Button.new(label: "Share", variant: :text, icon: "share")
      end
    end
  end

  # Centered layout for profile pages
  def centered_layout
    render ::Decor::PageHeader.new(
      title: "John Doe",
      subtitle: "Software Engineer at Example Corp",
      description: "Passionate about building beautiful and functional web applications with modern technologies.",
      layout: :centered,
      size: :lg
    ) do |header|
      header.with_avatar do
        render ::Decor::Avatar.new(
          initials: "JD",
          size: :xxl,
          url: "https://i.pravatar.cc/300"
        )
      end

      header.with_meta_content do
        div(class: "flex justify-center gap-3") do
          render ::Decor::Badge.new(label: "Available", style: :success)
          render ::Decor::Tag.new(label: "React", color: :info)
          render ::Decor::Tag.new(label: "TypeScript", color: :info)
          render ::Decor::Tag.new(label: "Rails", color: :error)
        end
      end

      header.with_actions do
        render ::Decor::Button.new(label: "Contact", color: :primary, icon: "mail")
        render ::Decor::Button.new(label: "Follow", variant: :outlined, icon: "plus")
      end

      header.with_status do
        div(class: "alert alert-info") do
          span { "Profile verification pending" }
        end
      end
    end
  end

  # Minimal layout for admin interfaces
  def minimal_layout
    render ::Decor::PageHeader.new(
      title: "User Management",
      layout: :minimal
    ) do |header|
      header.with_actions do
        render ::Decor::Button.new(label: "Add User", color: :primary, icon: "plus")
      end
    end
  end

  # Hero layout for landing pages
  def hero_layout
    render ::Decor::PageHeader.new(
      title: "Welcome to Our Platform",
      subtitle: "Build amazing applications with our comprehensive toolkit",
      description: "Join thousands of developers who are already using our platform to create beautiful, scalable applications that delight users and drive business growth.",
      layout: :hero,
      size: :xl,
      background: :gradient,
      border: false
    ) do |header|
      header.with_actions do
        render ::Decor::Button.new(label: "Get Started", color: :primary, size: :lg)
        render ::Decor::Button.new(label: "Learn More", variant: :outlined, size: :lg)
      end

      header.with_meta_content do
        div(class: "flex justify-center gap-2 text-primary-content/80") do
          render ::Decor::Badge.new(label: "New", style: :standard)
          span(class: "text-sm") { "Over 10,000 happy customers" }
        end
      end
    end
  end

  # Compact layout for dense interfaces
  def compact_layout
    render ::Decor::PageHeader.new(
      title: "Project: E-commerce Redesign",
      layout: :compact
    ) do |header|
      header.with_avatar do
        render ::Decor::Avatar.new(
          initials: "ER",
          size: :sm
        )
      end

      header.with_actions do
        render ::Decor::Button.new(label: "Edit", size: :sm, variant: :outlined)
      end
    end
  end

  # @!endgroup
  # @!group Size Variations

  # Small size header
  def small_size
    render ::Decor::PageHeader.new(
      title: "Small Header",
      subtitle: "This is a smaller version",
      size: :sm
    ) do |header|
      header.with_actions do
        render ::Decor::Button.new(label: "Action", size: :sm)
      end
    end
  end

  # Large size header
  def large_size
    render ::Decor::PageHeader.new(
      title: "Large Header",
      subtitle: "This is a larger version with more presence",
      description: "Perfect for important pages that need to make a statement.",
      size: :lg
    ) do |header|
      header.with_actions do
        render ::Decor::Button.new(label: "Primary Action", size: :lg, color: :primary)
      end
    end
  end

  # Extra large size header
  def extra_large_size
    render ::Decor::PageHeader.new(
      title: "Extra Large Header",
      subtitle: "Maximum impact for hero sections",
      description: "This size is perfect for landing pages and major section headers that need to capture attention.",
      size: :xl,
      layout: :centered
    ) do |header|
      header.with_actions do
        render ::Decor::Button.new(label: "Get Started", size: :lg, color: :primary)
        render ::Decor::Button.new(label: "Learn More", size: :lg, variant: :outlined)
      end
    end
  end

  # @!endgroup
  # @!group Background Variations

  # Hero background
  def hero_background
    render ::Decor::PageHeader.new(
      title: "Hero Background",
      subtitle: "Uses base-200 background for subtle contrast",
      background: :hero
    )
  end

  # Gradient background
  def gradient_background
    render ::Decor::PageHeader.new(
      title: "Gradient Background",
      subtitle: "Eye-catching gradient from primary to secondary",
      background: :gradient,
      border: false
    ) do |header|
      header.with_actions do
        render ::Decor::Button.new(label: "Action", color: :accent)
      end
    end
  end

  # Transparent background
  def transparent_background
    render ::Decor::PageHeader.new(
      title: "Transparent Background",
      subtitle: "Blends seamlessly with parent container",
      background: :transparent,
      border: false
    )
  end

  # @!endgroup
  # @!group Content Area Examples

  # Custom title content
  def custom_title_content
    render ::Decor::PageHeader.new(
      title: "Original Title"  # This will be overridden
    ) do |header|
      header.with_title_content do
        div(class: "flex items-center gap-3") do
          h1(class: "text-2xl font-bold") { "Custom Title with Icon" }
          render ::Decor::Icon.new(name: "star", html_options: {class: "w-6 h-6 text-yellow-500"})
        end
      end

      header.with_actions do
        render ::Decor::Button.new(label: "Edit", variant: :outlined)
      end
    end
  end

  # Rich meta content
  def rich_meta_content
    render ::Decor::PageHeader.new(
      title: "Project Dashboard",
      subtitle: "Track your project progress and team performance"
    ) do |header|
      header.with_meta_content do
        div(class: "flex flex-wrap items-center gap-4 text-sm") do
          div(class: "flex items-center gap-2") do
            render ::Decor::Icon.new(name: "calendar", html_options: {class: "w-4 h-4"})
            span { "Due: Dec 31, 2024" }
          end

          div(class: "flex items-center gap-2") do
            render ::Decor::Icon.new(name: "users", html_options: {class: "w-4 h-4"})
            span { "5 team members" }
          end

          div(class: "flex items-center gap-2") do
            render ::Decor::Progress.new(
              steps: [
                {label_key: "planning"},
                {label_key: "development"},
                {label_key: "testing"},
                {label_key: "deployment"}
              ],
              current_step: 2,
              variant: :progress,
              size: :sm
            )
            span { "50% complete" }
          end
        end
      end

      header.with_actions do
        render ::Decor::Button.new(label: "View Details", color: :primary)
      end
    end
  end

  # Complex actions layout
  def complex_actions
    render ::Decor::PageHeader.new(
      title: "Content Management",
      subtitle: "Manage your articles, pages, and media"
    ) do |header|
      header.with_actions do
        render ::Decor::Button.new(label: "New Article", color: :primary, icon: "plus")
        render ::Decor::Button.new(label: "Import", variant: :outlined, icon: "upload")
      end

      header.with_secondary_actions do
        render ::Decor::Button.new(label: "Export", variant: :text, icon: "download")
        render ::Decor::Button.new(label: "Settings", variant: :text, icon: "cog")
      end
    end
  end

  # @!endgroup
  # @!group Responsive Examples

  # Mobile-optimized layout
  def mobile_optimized
    render ::Decor::PageHeader.new(
      title: "Mobile-First Design",
      subtitle: "This header adapts beautifully to mobile screens",
      description: "Notice how the layout stacks vertically on mobile and arranges horizontally on larger screens."
    ) do |header|
      header.with_avatar do
        render ::Decor::Avatar.new(initials: "MF", size: :lg)
      end

      header.with_meta_content do
        div(class: "flex flex-wrap gap-2") do
          render ::Decor::Badge.new(label: "Mobile", style: :standard)
          render ::Decor::Badge.new(label: "Responsive", style: :success)
        end
      end

      header.with_actions do
        render ::Decor::Button.new(label: "Primary", color: :primary, full_width: false)
        render ::Decor::Button.new(label: "Secondary", variant: :outlined, full_width: false)
      end
    end
  end

  # @!endgroup
  # @!group Integration Examples

  # Integration with other Decor components
  def with_navigo_components
    render ::Decor::PageHeader.new(
      title: "Dashboard",
      subtitle: "Welcome back to your workspace"
    ) do |header|
      header.with_breadcrumbs do
        render ::Decor::Nav::Breadcrumbs.new(
          breadcrumbs: [
            {name: "Home", path: "/", icon: "home"},
            {name: "Workspace", path: "/workspace"},
            {name: "Dashboard", path: "/dashboard", current: true}
          ]
        )
      end

      header.with_meta_content do
        div(class: "text-sm text-base-content/70") do
          span { "Last updated: 2 minutes ago" }
        end
      end

      header.with_actions do
        render ::Decor::Button.new(label: "Refresh", color: :primary, icon: "refresh")
      end
    end
  end

  # @!endgroup
  # @!group Playground

  # Interactive playground for testing
  # @param title text "Page title"
  # @param subtitle text "Page subtitle"
  # @param description textarea "Page description"
  # @param layout select { choices: [default, centered, minimal, hero, compact] } "Layout pattern"
  # @param size select { choices: [sm, md, lg, xl] } "Title size"
  # @param background select { choices: [default, hero, gradient, transparent] } "Background style"
  # @param show_avatar toggle "Show avatar"
  # @param show_actions toggle "Show actions"
  # @param show_breadcrumbs toggle "Show breadcrumbs"
  # @param border toggle "Show border"
  def playground(
    title: "Interactive Page Header",
    subtitle: "Customize this header using the controls",
    description: "This playground allows you to test different configurations and see how they look.",
    layout: :default,
    size: :md,
    background: :default,
    show_avatar: true,
    show_actions: true,
    show_breadcrumbs: false,
    border: true
  )
    render ::Decor::PageHeader.new(
      title: title,
      subtitle: subtitle,
      description: description,
      layout: layout.to_sym,
      size: size.to_sym,
      background: background.to_sym,
      border: border
    ) do |header|
      if show_breadcrumbs
        header.with_breadcrumbs do
          render ::Decor::Nav::Breadcrumbs.new(
            breadcrumbs: [
              {name: "Home", path: "/"},
              {name: "Current", path: "/current", current: true}
            ]
          )
        end
      end

      if show_avatar
        header.with_avatar do
          render ::Decor::Avatar.new(
            initials: "PH",
            size: (layout.to_sym == :compact) ? :sm : :lg
          )
        end
      end

      header.with_meta_content do
        div(class: "flex flex-wrap gap-2") do
          render ::Decor::Badge.new(label: "Live", style: :success)
          render ::Decor::Tag.new(label: "Interactive", color: :primary)
        end
      end

      if show_actions
        header.with_actions do
          render ::Decor::Button.new(label: "Primary Action", color: :primary)
          render ::Decor::Button.new(label: "Secondary", variant: :outlined)
        end
      end
    end
  end

  # @!endgroup
end
