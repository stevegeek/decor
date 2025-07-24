# @label PageHeader
class ::Decor::PageHeaderPreview < ::Lookbook::Preview
  # PageHeader
  # -----------
  #
  # A flexible page header component for displaying page titles and metadata.
  # Supports various layouts, backgrounds, and content slots for breadcrumbs,
  # avatars, actions, and custom content areas.
  #
  # @group Examples
  # @label Basic Page Header
  def basic_page_header
    render ::Decor::PageHeader.new(
      title: "User Profile",
      subtitle: "Manage your account settings"
    )
  end

  # @group Examples
  # @label Page Header with Actions
  def page_header_with_actions
    render ::Decor::PageHeader.new(
      title: "Project Dashboard",
      subtitle: "Track your project progress"
    ) do |header|
      header.with_actions do
        header.render ::Decor::Button.new(label: "Edit", color: :primary)
        header.render ::Decor::Button.new(label: "Share", style: :outlined)
      end
    end
  end

  # @group Examples
  # @label Full Featured Header
  def full_featured_header
    render ::Decor::PageHeader.new(
      title: "Team Overview",
      subtitle: "Collaborate with your team",
      description: "View team members, projects, and recent activity."
    ) do |header|
      header.with_breadcrumbs do
        header.render ::Decor::Nav::Breadcrumbs.new(
          breadcrumbs: [
            {name: "Home", path: "/"},
            {name: "Teams", path: "/teams"},
            {name: "Engineering", path: "/teams/engineering", current: true}
          ]
        )
      end

      header.with_avatar do
        header.render ::Decor::Avatar.new(initials: "ENG", size: :lg)
      end

      header.with_actions do
        header.render ::Decor::Button.new(label: "Add Member", color: :primary, icon: "plus")
      end
    end
  end

  # @group Examples
  # @label Hero Style Header
  def hero_style_header
    render ::Decor::PageHeader.new(
      title: "Welcome to Our Platform",
      subtitle: "Build amazing applications with our comprehensive toolkit",
      description: "Join thousands of developers who are already using our platform.",
      layout: :hero,
      size: :xl,
      background: :gradient,
      border: false
    ) do |header|
      header.with_actions do
        header.render ::Decor::Button.new(label: "Get Started", color: :primary, size: :lg)
        header.render ::Decor::Button.new(label: "Learn More", style: :outlined, size: :lg)
      end
    end
  end

  # @group Examples
  # @label Profile Header
  def profile_header
    render ::Decor::PageHeader.new(
      title: "John Doe",
      subtitle: "Software Engineer at Example Corp",
      description: "Passionate about building beautiful and functional web applications.",
      layout: :centered,
      size: :lg
    ) do |header|
      header.with_avatar do
        header.render ::Decor::Avatar.new(
          initials: "JD",
          size: :xl,
          url: "https://i.pravatar.cc/300"
        )
      end

      header.with_meta_content do
        header.div(class: "flex justify-center gap-3") do
          header.render ::Decor::Badge.new(label: "Available", color: :success)
          header.render ::Decor::Tag.new(label: "React", color: :info)
          header.render ::Decor::Tag.new(label: "Rails", color: :error)
        end
      end

      header.with_actions do
        header.render ::Decor::Button.new(label: "Contact", color: :primary, icon: "mail")
        header.render ::Decor::Button.new(label: "Follow", style: :outlined, icon: "plus")
      end
    end
  end

  # @group Examples
  # @label Custom Title Content
  def custom_title_content
    render ::Decor::PageHeader.new(
      title: "Original Title"  # This will be overridden
    ) do |header|
      header.with_title_content do
        header.div(class: "flex items-center gap-3") do
          header.h1(class: "text-2xl font-bold") { "Custom Title with Icon" }
          header.render ::Decor::Icon.new(name: "star", html_options: {class: "w-6 h-6 text-yellow-500"})
        end
      end

      header.with_actions do
        header.render ::Decor::Button.new(label: "Edit", style: :outlined)
      end
    end
  end

  # @group Examples
  # @label Rich Meta Content
  def rich_meta_content
    render ::Decor::PageHeader.new(
      title: "Project Dashboard",
      subtitle: "Track your project progress and team performance"
    ) do |header|
      header.with_meta_content do
        header.div(class: "flex flex-wrap items-center gap-4 text-sm") do
          header.div(class: "flex items-center gap-2") do
            header.render ::Decor::Icon.new(name: "calendar", html_options: {class: "w-4 h-4"})
            header.span { "Due: Dec 31, 2024" }
          end

          header.div(class: "flex items-center gap-2") do
            header.render ::Decor::Icon.new(name: "users", html_options: {class: "w-4 h-4"})
            header.span { "5 team members" }
          end

          header.div(class: "flex items-center gap-2") do
            header.span { "50% complete" }
          end
        end
      end

      header.with_actions do
        header.render ::Decor::Button.new(label: "View Details", color: :primary)
      end
    end
  end

  # @group Playground
  # @param title text
  # @param subtitle text
  # @param description textarea
  # @param layout select [Symbol] [default, centered, minimal, hero, compact]
  # @param background select [Symbol] [default, hero, gradient, transparent]
  # @param border toggle
  # @param show_avatar toggle
  # @param show_actions toggle
  # @param show_breadcrumbs toggle
  # @param size [Symbol] select [~, xs, sm, md, lg, xl]
  # @param color [Symbol] select [~, base, primary, secondary, accent, neutral, success, error, warning, info]
  # @param style [Symbol] select [~, filled, outlined, ghost]
  def playground(
    title: "Interactive Page Header",
    subtitle: "Customize this header using the controls",
    description: "This playground allows you to test different configurations and see how they look.",
    layout: :default,
    background: :default,
    border: true,
    show_avatar: true,
    show_actions: true,
    show_breadcrumbs: false,
    size: nil,
    color: nil,
    style: nil
  )
    render ::Decor::PageHeader.new(
      title: title,
      subtitle: subtitle,
      description: description,
      layout: layout.to_sym,
      background: background.to_sym,
      border: border,
      size: size,
      color: color,
      style: style
    ) do |header|
      if show_breadcrumbs
        header.with_breadcrumbs do
          header.render ::Decor::Nav::Breadcrumbs.new(
            breadcrumbs: [
              {name: "Home", path: "/"},
              {name: "Current", path: "/current", current: true}
            ]
          )
        end
      end

      if show_avatar
        header.with_avatar do
          header.render ::Decor::Avatar.new(
            initials: "PH",
            size: (layout.to_sym == :compact) ? :sm : :lg
          )
        end
      end

      header.with_meta_content do
        div(class: "flex flex-wrap gap-2") do
          header.render ::Decor::Badge.new(label: "Live", style: :success)
          header.render ::Decor::Tag.new(label: "Interactive", color: :primary)
        end
      end

      if show_actions
        header.with_actions do
          header.render ::Decor::Button.new(label: "Primary Action", color: :primary)
          header.render ::Decor::Button.new(label: "Secondary", style: :outlined)
        end
      end
    end
  end

  # @group Layouts
  # @label Default Layout
  def layout_default
    render ::Decor::PageHeader.new(
      title: "Default Layout Header",
      subtitle: "Standard left-aligned layout",
      description: "This is the most common layout for page headers.",
      layout: :default
    )
  end

  # @group Layouts
  # @label Centered Layout
  def layout_centered
    render ::Decor::PageHeader.new(
      title: "Centered Layout",
      subtitle: "Everything is center-aligned",
      description: "Perfect for profile pages and feature announcements.",
      layout: :centered
    )
  end

  # @group Layouts
  # @label Minimal Layout
  def layout_minimal
    render ::Decor::PageHeader.new(
      title: "Minimal Layout",
      layout: :minimal
    ) do |header|
      header.with_actions do
        header.render ::Decor::Button.new(label: "Action", color: :primary)
      end
    end
  end

  # @group Layouts
  # @label Hero Layout
  def layout_hero
    render ::Decor::PageHeader.new(
      title: "Hero Layout",
      subtitle: "Large, centered hero section",
      description: "Ideal for landing pages and major announcements.",
      layout: :hero,
      size: :xl
    )
  end

  # @group Layouts
  # @label Compact Layout
  def layout_compact
    render ::Decor::PageHeader.new(
      title: "Compact Layout",
      layout: :compact
    ) do |header|
      header.with_avatar do
        header.render ::Decor::Avatar.new(initials: "CL", size: :sm)
      end
    end
  end

  # @group Sizes
  # @label XS Size
  def size_xs
    render ::Decor::PageHeader.new(
      title: "Extra Small Header",
      subtitle: "Minimal space usage",
      size: :xs
    )
  end

  # @group Sizes
  # @label SM Size
  def size_sm
    render ::Decor::PageHeader.new(
      title: "Small Header",
      subtitle: "Compact but readable",
      size: :sm
    )
  end

  # @group Sizes
  # @label MD Size (Default)
  def size_md
    render ::Decor::PageHeader.new(
      title: "Medium Header",
      subtitle: "Standard size for most use cases",
      description: "This is the default size.",
      size: :md
    )
  end

  # @group Sizes
  # @label LG Size
  def size_lg
    render ::Decor::PageHeader.new(
      title: "Large Header",
      subtitle: "More prominent presence",
      description: "Good for important sections.",
      size: :lg
    )
  end

  # @group Sizes
  # @label XL Size
  def size_xl
    render ::Decor::PageHeader.new(
      title: "Extra Large Header",
      subtitle: "Maximum visual impact",
      description: "Perfect for hero sections and landing pages.",
      size: :xl
    )
  end

  # @group Backgrounds
  # @label Default Background
  def background_default
    render ::Decor::PageHeader.new(
      title: "Default Background",
      subtitle: "Standard base-100 background",
      background: :default
    )
  end

  # @group Backgrounds
  # @label Hero Background
  def background_hero
    render ::Decor::PageHeader.new(
      title: "Hero Background",
      subtitle: "Uses base-200 for subtle contrast",
      background: :hero
    )
  end

  # @group Backgrounds
  # @label Gradient Background
  def background_gradient
    render ::Decor::PageHeader.new(
      title: "Gradient Background",
      subtitle: "Eye-catching gradient effect",
      background: :gradient,
      border: false
    )
  end

  # @group Backgrounds
  # @label Transparent Background
  def background_transparent
    render ::Decor::PageHeader.new(
      title: "Transparent Background",
      subtitle: "Blends with parent container",
      background: :transparent,
      border: false
    )
  end

  # @group Padding
  # @label No Padding
  def padding_none
    render ::Decor::PageHeader.new(
      title: "No Padding Header",
      subtitle: "Flush with container edges",
      padding: :none
    )
  end

  # @group Padding
  # @label Small Padding
  def padding_sm
    render ::Decor::PageHeader.new(
      title: "Small Padding",
      subtitle: "Minimal spacing",
      padding: :sm
    )
  end

  # @group Padding
  # @label Medium Padding (Default)
  def padding_md
    render ::Decor::PageHeader.new(
      title: "Medium Padding",
      subtitle: "Standard spacing",
      padding: :md
    )
  end

  # @group Padding
  # @label Large Padding
  def padding_lg
    render ::Decor::PageHeader.new(
      title: "Large Padding",
      subtitle: "Generous spacing",
      padding: :lg
    )
  end

  # @group Padding
  # @label XL Padding
  def padding_xl
    render ::Decor::PageHeader.new(
      title: "Extra Large Padding",
      subtitle: "Maximum breathing room",
      padding: :xl
    )
  end

  # @group Border
  # @label With Border
  def with_border
    render ::Decor::PageHeader.new(
      title: "Header with Border",
      subtitle: "Bottom border for separation",
      border: true
    )
  end

  # @group Border
  # @label Without Border
  def without_border
    render ::Decor::PageHeader.new(
      title: "Header without Border",
      subtitle: "Clean edge without separation",
      border: false
    )
  end
end
