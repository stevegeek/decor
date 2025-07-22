# @label Page
class ::Decor::PagePreview < ::Lookbook::Preview
  # Page
  # -------
  #
  # A page component that provides a structured layout with header, content sections,
  # and customizable spacing, padding, and background options.
  #
  # @group Examples
  # @label Basic Page
  def basic_page
    render ::Decor::Page.new do |page|
      page.with_header do
        ::Decor::PageHeader.new(
          title: "Welcome to Our Application",
          subtitle: "Get started with the basics",
          description: "This is a simple page example showing the default configuration."
        )
      end

      page.div(class: "prose") do
        page.h2 { "Getting Started" }
        page.p { "This is your basic page content. You can add any content here." }
      end
    end
  end

  # @group Examples
  # @label Page with Hero
  def page_with_hero
    render ::Decor::Page.new(
      background: :hero,
      padding: :lg
    ) do |page|
      page.with_hero do
        page.div(class: "hero min-h-[200px] bg-gradient-to-r from-primary to-secondary rounded-lg") do
          page.div(class: "hero-content text-center text-primary-content") do
            page.div(class: "max-w-md") do
              page.h1(class: "text-5xl font-bold") { "Welcome!" }
              page.p(class: "py-6") { "Build amazing applications with our tools." }
              render ::Decor::Button.new(label: "Get Started", style: :filled)
            end
          end
        end
      end

      page.with_header do
        ::Decor::PageHeader.new(
          title: "Featured Section",
          subtitle: "Discover what's new"
        )
      end

      page.div(class: "grid grid-cols-1 md:grid-cols-2 gap-4") do
        page.div(class: "card bg-base-100 shadow-lg p-6") do
          page.h3(class: "text-lg font-semibold mb-2") { "Feature One" }
          page.p { "Description of the first feature." }
        end
        page.div(class: "card bg-base-100 shadow-lg p-6") do
          page.h3(class: "text-lg font-semibold mb-2") { "Feature Two" }
          page.p { "Description of the second feature." }
        end
      end
    end
  end

  # @group Examples
  # @label Page with Tabs
  def page_with_tabs
    render ::Decor::Page.new do |page|
      page.with_header do
        header = ::Decor::PageHeader.new(
          title: "Dashboard",
          subtitle: "Monitor your application",
          description: "View analytics and manage your resources."
        )
        header.with_badge(label: "Pro", color: :accent)
        header.with_actions do
          render ::Decor::Button.new(label: "Export", icon: "download", style: :outlined)
        end
        header
      end

      page.with_tabs do
        render ::Decor::Tabs.new do |tabs|
          tabs.with_tab(label: "Overview", active: true, href: "#overview")
          tabs.with_tab(label: "Analytics", href: "#analytics")
          tabs.with_tab(label: "Reports", href: "#reports")
          tabs.with_tab(label: "Settings", href: "#settings")
        end
      end

      page.div(class: "prose") do
        page.h3 { "Overview" }
        page.p { "This is the overview content for your dashboard." }
      end
    end
  end

  # @group Examples
  # @label Full Featured Page
  def full_featured_page
    render ::Decor::Page.new(
      size: :lg,
      background: :hero,
      padding: :lg,
      spacing: :lg,
      cta_snap_large: true
    ) do |page|
      page.with_hero do
        page.div(class: "hero min-h-[300px] bg-gradient-to-r from-primary to-secondary rounded-lg") do
          page.div(class: "hero-content text-center text-primary-content") do
            page.div(class: "max-w-md") do
              page.h1(class: "text-5xl font-bold") { "Premium Features" }
              page.p(class: "py-6") { "Everything you need in one place." }
              page.div(class: "flex gap-2 justify-center") do
                render ::Decor::Button.new(label: "Start Free Trial", color: :primary, size: :lg)
                render ::Decor::Button.new(label: "View Pricing", style: :outlined, size: :lg)
              end
            end
          end
        end
      end

      page.with_header do
        header = ::Decor::PageHeader.new(
          title: "Complete Solution",
          subtitle: "All features demonstrated",
          description: "This example shows how all page components work together.",
          size: :lg,
          layout: :page_like,
          cta_snap_large: true
        )
        header.with_badge(label: "New", color: :success)
        header.with_badge(label: "Popular", color: :warning)
        header.with_tag(label: "Enterprise", color: :primary, icon: "building-office")
        header.with_cta do
          page.div(class: "flex gap-2") do
            render ::Decor::Button.new(label: "Contact Sales", color: :primary)
          end
        end
        header
      end

      page.with_tabs do
        render ::Decor::Tabs.new do |tabs|
          tabs.with_tab(label: "Features", active: true, href: "#features")
          tabs.with_tab(label: "Pricing", href: "#pricing")
          tabs.with_tab(label: "Docs", href: "#docs")
          tabs.with_tab(label: "Support", href: "#support")
        end
      end

      page.div(class: "grid grid-cols-1 lg:grid-cols-3 gap-6") do
        3.times do |i|
          page.div(class: "card bg-base-100 shadow-xl") do
            page.div(class: "card-body") do
              page.h2(class: "card-title") { "Feature #{i + 1}" }
              page.p { "Comprehensive description of feature number #{i + 1}." }
              page.div(class: "card-actions justify-end") do
                render ::Decor::Button.new(label: "Learn More", style: :ghost)
              end
            end
          end
        end
      end
    end
  end

  # @group Playground
  # @param title text
  # @param subtitle text
  # @param description text
  # @param include_flash toggle
  # @param show_hero_slot toggle
  # @param show_example_tag toggle
  # @param show_example_badge toggle
  # @param background select [default, primary, secondary, hero, neutral]
  # @param padding select [none, sm, md, lg, xl]
  # @param spacing select [none, sm, md, lg, xl]
  # @param cta_snap_large toggle
  # @param full_height toggle
  # @param size [Symbol] select [~, xs, sm, md, lg, xl]
  # @param color [Symbol] select [~, base, primary, secondary, accent, neutral, success, error, warning, info]
  # @param style [Symbol] select [~, filled, outlined, ghost]
  def playground(
    title: "Page title",
    subtitle: "Subtitle",
    description: "Page description",
    include_flash: true,
    show_hero_slot: false,
    show_example_tag: true,
    show_example_badge: true,
    background: :default,
    padding: :md,
    spacing: :md,
    cta_snap_large: false,
    full_height: false,
    size: nil,
    color: nil,
    style: nil
  )
    render_with_template(
      locals: {
        show_hero_slot: show_hero_slot,
        title: title,
        subtitle: subtitle,
        description: description,
        include_flash: include_flash,
        show_example_tag: show_example_tag,
        show_example_badge: show_example_badge,
        size: size,
        color: color,
        style: style,
        background: background,
        padding: padding,
        spacing: spacing,
        cta_snap_large: cta_snap_large,
        full_height: full_height
      }
    )
  end

  # @group Sizes
  # @label XS Size
  def size_xs
    render ::Decor::Page.new(
      size: :xs,
      spacing: :sm
    ) do |page|
      page.with_header do
        header = ::Decor::PageHeader.new(
          title: "Extra Small Page",
          subtitle: "Compact layout",
          size: :xs
        )
        header.with_badge(label: "XS", color: :primary, size: :xs)
        header
      end

      page.div(class: "prose prose-sm") do
        page.p { "This page uses the smallest text sizes and minimal spacing." }
      end
    end
  end

  # @group Sizes
  # @label SM Size
  def size_sm
    render ::Decor::Page.new(
      size: :sm
    ) do |page|
      page.with_header do
        ::Decor::PageHeader.new(
          title: "Small Page",
          subtitle: "Reduced sizing",
          size: :sm
        )
      end

      page.div(class: "prose prose-sm") do
        page.p { "Small size page with compact elements." }
      end
    end
  end

  # @group Sizes
  # @label MD Size (Default)
  def size_md
    render ::Decor::Page.new(
      size: :md
    ) do |page|
      page.with_header do
        ::Decor::PageHeader.new(
          title: "Medium Page",
          subtitle: "Default sizing",
          description: "This is the standard size for most use cases.",
          size: :md
        )
      end

      page.div(class: "prose") do
        page.p { "Medium size provides a balanced layout." }
      end
    end
  end

  # @group Sizes
  # @label LG Size
  def size_lg
    render ::Decor::Page.new(
      size: :lg,
      spacing: :lg
    ) do |page|
      page.with_header do
        header = ::Decor::PageHeader.new(
          title: "Large Page Layout",
          subtitle: "Spacious design",
          description: "Larger text and increased spacing for better readability.",
          size: :lg
        )
        header.with_actions do
          render ::Decor::Button.new(label: "Action", size: :lg, color: :primary)
        end
        header
      end

      page.div(class: "prose prose-lg") do
        page.p { "Large page with generous spacing." }
      end
    end
  end

  # @group Sizes
  # @label XL Size
  def size_xl
    render ::Decor::Page.new(
      size: :xl,
      spacing: :xl
    ) do |page|
      page.with_header do
        ::Decor::PageHeader.new(
          title: "Extra Large Page",
          subtitle: "Maximum size",
          description: "Largest available text and spacing options.",
          size: :xl
        )
      end

      page.div(class: "prose prose-xl") do
        page.p { "Extra large page for maximum visual impact." }
      end
    end
  end

  # @group Backgrounds
  # @label Default Background
  def background_default
    render ::Decor::Page.new(
      background: :default
    ) do |page|
      page.with_header do
        ::Decor::PageHeader.new(
          title: "Default Background",
          description: "Standard base-100 background color."
        )
      end

      page.div(class: "p-4 rounded bg-base-200") do
        page.p { "Content stands out against the default background." }
      end
    end
  end

  # @group Backgrounds
  # @label Hero Background
  def background_hero
    render ::Decor::Page.new(
      background: :hero
    ) do |page|
      page.with_header do
        ::Decor::PageHeader.new(
          title: "Hero Background",
          description: "Subtle base-200 background for visual separation."
        )
      end

      page.div(class: "card bg-base-100 shadow p-4") do
        page.p { "Cards pop against the hero background." }
      end
    end
  end

  # @group Backgrounds
  # @label Primary Background
  def background_primary
    render ::Decor::Page.new(
      background: :primary
    ) do |page|
      page.with_header do
        ::Decor::PageHeader.new(
          title: "Primary Background",
          description: "Subtle primary color tint."
        )
      end

      page.div(class: "alert alert-info") do
        page.p { "Primary themed background." }
      end
    end
  end

  # @group Padding
  # @label No Padding
  def padding_none
    render ::Decor::Page.new(
      padding: :none
    ) do |page|
      page.with_header do
        ::Decor::PageHeader.new(
          title: "No Padding",
          description: "Content flush with edges"
        )
      end

      page.div(class: "bg-primary/10 p-4") do
        page.p { "This shows the page has no padding." }
      end
    end
  end

  # @group Padding
  # @label SM Padding
  def padding_sm
    render ::Decor::Page.new(
      padding: :sm
    ) do |page|
      page.with_header do
        ::Decor::PageHeader.new(
          title: "Small Padding",
          description: "Minimal internal padding"
        )
      end

      page.div(class: "bg-secondary/10 p-4") do
        page.p { "Small padding for compact layouts." }
      end
    end
  end

  # @group Padding
  # @label MD Padding (Default)
  def padding_md
    render ::Decor::Page.new(
      padding: :md
    ) do |page|
      page.with_header do
        ::Decor::PageHeader.new(
          title: "Medium Padding",
          description: "Standard padding amount"
        )
      end

      page.div(class: "bg-accent/10 p-4") do
        page.p { "Default medium padding." }
      end
    end
  end

  # @group Padding
  # @label LG Padding
  def padding_lg
    render ::Decor::Page.new(
      padding: :lg
    ) do |page|
      page.with_header do
        ::Decor::PageHeader.new(
          title: "Large Padding",
          description: "Generous internal spacing"
        )
      end

      page.div(class: "bg-info/10 p-4") do
        page.p { "Large padding for spacious feel." }
      end
    end
  end

  # @group Padding
  # @label XL Padding
  def padding_xl
    render ::Decor::Page.new(
      padding: :xl
    ) do |page|
      page.with_header do
        ::Decor::PageHeader.new(
          title: "Extra Large Padding",
          description: "Maximum internal spacing"
        )
      end

      page.div(class: "bg-warning/10 p-4") do
        page.p { "Extra large padding for maximum space." }
      end
    end
  end

  # @group Spacing
  # @label No Spacing
  def spacing_none
    render ::Decor::Page.new(
      spacing: :none
    ) do |page|
      page.with_header do
        ::Decor::PageHeader.new(
          title: "No Spacing",
          description: "Elements packed together"
        )
      end

      page.div(class: "bg-base-200 p-2") { "Block 1" }
      page.div(class: "bg-base-300 p-2") { "Block 2" }
      page.div(class: "bg-base-200 p-2") { "Block 3" }
    end
  end

  # @group Spacing
  # @label SM Spacing
  def spacing_sm
    render ::Decor::Page.new(
      spacing: :sm
    ) do |page|
      page.with_header do
        ::Decor::PageHeader.new(
          title: "Small Spacing",
          description: "Minimal gaps between elements"
        )
      end

      page.div(class: "card bg-base-100 shadow p-4") { "Card 1" }
      page.div(class: "card bg-base-100 shadow p-4") { "Card 2" }
    end
  end

  # @group Spacing
  # @label MD Spacing (Default)
  def spacing_md
    render ::Decor::Page.new(
      spacing: :md
    ) do |page|
      page.with_header do
        ::Decor::PageHeader.new(
          title: "Medium Spacing",
          description: "Standard gaps between elements"
        )
      end

      page.div(class: "card bg-base-100 shadow p-4") { "Card 1" }
      page.div(class: "card bg-base-100 shadow p-4") { "Card 2" }
    end
  end

  # @group Spacing
  # @label LG Spacing
  def spacing_lg
    render ::Decor::Page.new(
      spacing: :lg
    ) do |page|
      page.with_header do
        ::Decor::PageHeader.new(
          title: "Large Spacing",
          description: "Generous gaps between elements"
        )
      end

      page.div(class: "card bg-base-100 shadow p-4") { "Card 1" }
      page.div(class: "card bg-base-100 shadow p-4") { "Card 2" }
    end
  end

  # @group Spacing
  # @label XL Spacing
  def spacing_xl
    render ::Decor::Page.new(
      spacing: :xl
    ) do |page|
      page.with_header do
        ::Decor::PageHeader.new(
          title: "Extra Large Spacing",
          description: "Maximum gaps between elements"
        )
      end

      page.div(class: "card bg-base-100 shadow p-4") { "Card 1" }
      page.div(class: "card bg-base-100 shadow p-4") { "Card 2" }
    end
  end

  # @group Full Height
  # @label With Full Height
  def with_full_height
    render ::Decor::Page.new(
      full_height: true,
      padding: :lg
    ) do |page|
      page.with_header do
        ::Decor::PageHeader.new(
          title: "Full Height Page",
          description: "Uses full viewport height"
        )
      end

      page.div(class: "flex items-center justify-center bg-neutral/10 rounded-lg h-64") do
        page.div(class: "text-center") do
          page.h3(class: "text-xl font-semibold mb-2") { "Full Height" }
          page.p { "This page takes up the full screen height." }
        end
      end
    end
  end

  # @group Full Height
  # @label Without Full Height
  def without_full_height
    render ::Decor::Page.new(
      full_height: false
    ) do |page|
      page.with_header do
        ::Decor::PageHeader.new(
          title: "Natural Height Page",
          description: "Uses content height"
        )
      end

      page.div(class: "bg-warning/10 p-6 rounded-lg") do
        page.p { "This page only takes the space needed for content." }
      end
    end
  end
end