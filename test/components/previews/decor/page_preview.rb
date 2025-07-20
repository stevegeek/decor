# @label Page
class ::Decor::PagePreview < ::Lookbook::Preview
  # @param title text
  # @param subtitle text
  # @param description text
  # @param include_flash toggle
  # @param show_hero_slot toggle
  # @param show_example_tag toggle
  # @param show_example_badge toggle
  # @param size select { choices: [xs, sm, md, lg, xl] }
  # @param background select { choices: [default, primary, secondary, hero, neutral] }
  # @param padding select { choices: [none, sm, md, lg, xl] }
  # @param spacing select { choices: [none, sm, md, lg, xl] }
  # @param cta_snap_large toggle
  # @param full_height toggle
  def playground(
    title: "Page title",
    subtitle: "Subtitle",
    description: "Page description",
    include_flash: true,
    show_hero_slot: false,
    show_example_tag: true,
    show_example_badge: true,
    size: :md,
    background: :default,
    padding: :md,
    spacing: :md,
    cta_snap_large: false,
    full_height: false
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
        background: background,
        padding: padding,
        spacing: spacing,
        cta_snap_large: cta_snap_large,
        full_height: full_height
      }
    )
  end

  # @!group Sizes

  def extra_small
    render ::Decor::Page.new(
      size: :xs,
      spacing: :sm
    ) do |page|
      page.with_header do
        header = ::Decor::PageHeader.new(
          title: "Extra Small Page",
          subtitle: "Compact layout",
          description: "This page uses the smallest text sizes and spacing.",
          size: :xs,
          layout: :page_like
        )
        header.with_badge(label: "XS Size", color: :primary)
        header.with_tag(label: "Compact", color: :info, size: :xs)
        header.with_cta do
          render ::Decor::Button.new(label: "Action", size: :sm, color: :primary)
        end
        header
      end

      page.div(class: "prose prose-sm") do
        page.p { "This is example content in an extra small page layout." }
      end
    end
  end

  def large
    render ::Decor::Page.new(
      size: :lg,
      spacing: :lg
    ) do |page|
      page.with_header do
        header = ::Decor::PageHeader.new(
          title: "Large Page Layout",
          subtitle: "Spacious design",
          description: "This page uses larger text sizes and increased spacing between elements.",
          size: :lg
        )
        header.with_badge(label: "Premium", color: :accent)
        header.with_tag(label: "Featured", color: :warning)
        header.with_cta do
          render ::Decor::Button.new(label: "Get Started", size: :lg, color: :primary)
        end
        header
      end

      page.div(class: "prose prose-lg") do
        page.p { "This is example content in a large page layout with increased spacing." }
      end
    end
  end

  # @!endgroup

  # @!group Backgrounds

  def hero_background
    render ::Decor::Page.new(
      background: :hero
    ) do |page|
      page.with_hero do
        page.div(class: "text-center py-12") do
          page.h1(class: "text-4xl font-bold mb-4") { "Welcome to Our Platform" }
          page.p(class: "text-lg") { "This hero section adapts to the page background setting." }
        end
      end

      page.with_header do
        header = ::Decor::PageHeader.new(
          title: "Hero Background Page",
          subtitle: "Subtle background styling",
          description: "This page uses a hero background color for subtle visual separation."
        )
        header.with_badge(label: "New", color: :success)
        header
      end

      page.div(class: "grid grid-cols-1 md:grid-cols-2 gap-6") do
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

  def primary_background
    render ::Decor::Page.new(
      background: :primary,
      padding: :lg
    ) do |page|
      page.with_header do
        header = ::Decor::PageHeader.new(
          title: "Primary Themed Page",
          subtitle: "Brand-colored background",
          description: "Uses a subtle primary color background tint."
        )
        header.with_badge(label: "Featured", color: :primary, variant: :filled)
        header.with_tag(label: "Popular", color: :warning)
        header
      end

      page.div(class: "alert alert-info") do
        page.p { "This page demonstrates the primary background theme." }
      end
    end
  end

  # @!endgroup

  # @!group Complex Examples

  def with_tabs
    render ::Decor::Page.new(
      size: :lg
    ) do |page|
      page.with_header do
        header = ::Decor::PageHeader.new(
          title: "Page with Tabs",
          subtitle: "Tabbed navigation example",
          description: "Demonstrates how tabs integrate with the page header.",
          size: :lg
        )
        header.with_badge(label: "Beta", color: :info)
        header
      end

      page.with_tabs do
        render ::Decor::Tabs.new do |tabs|
          tabs.with_tab(label: "Overview", active: true, href: "#overview")
          tabs.with_tab(label: "Settings", href: "#settings")
          tabs.with_tab(label: "Analytics", href: "#analytics")
        end
      end

      page.div(class: "prose") do
        page.h3 { "Overview Content" }
        page.p { "This content appears under the Overview tab." }
      end
    end
  end

  def full_featured
    render ::Decor::Page.new(
      size: :lg,
      background: :hero,
      padding: :lg,
      spacing: :lg
    ) do |page|
      page.with_hero do
        page.div(class: "hero min-h-[200px] bg-gradient-to-r from-primary to-secondary rounded-lg") do
          page.div(class: "hero-content text-center text-primary-content") do
            page.div(class: "max-w-md") do
              page.h1(class: "text-5xl font-bold") { "Hello there" }
              page.p(class: "py-6") { "This is a full-featured page with all options enabled." }
              render ::Decor::Button.new(label: "Get Started", color: :primary, variant: :filled)
            end
          end
        end
      end

      page.with_header do
        header = ::Decor::PageHeader.new(
          title: "Full-Featured Page",
          subtitle: "All components demonstrated",
          description: "This example shows all available page features working together.",
          size: :lg,
          cta_snap_large: true
        )
        header.with_badge(label: "Pro", color: :accent)
        header.with_badge(label: "New", color: :success)
        header.with_tag(label: "Featured", color: :warning, icon: "star")
        header.with_tag(label: "Popular", color: :info, icon: "trending-up")
        header.with_cta do
          page.div(class: "flex gap-2") do
            render ::Decor::Button.new(label: "Secondary", variant: :outlined, color: :secondary)
            render ::Decor::Button.new(label: "Primary Action", color: :primary)
          end
        end
        header
      end

      page.with_tabs do
        render ::Decor::Tabs.new do |tabs|
          tabs.with_tab(label: "Dashboard", active: true, href: "#dashboard")
          tabs.with_tab(label: "Projects", href: "#projects")
          tabs.with_tab(label: "Team", href: "#team")
          tabs.with_tab(label: "Reports", href: "#reports")
        end
      end

      page.div(class: "grid grid-cols-1 lg:grid-cols-3 gap-6") do
        3.times do |i|
          page.div(class: "card bg-base-100 shadow-xl") do
            page.div(class: "card-body") do
              page.h2(class: "card-title") { "Card #{i + 1}" }
              page.p { "This is example content for card number #{i + 1}." }
              page.div(class: "card-actions justify-end") do
                render ::Decor::Button.new(label: "View", size: :sm, variant: :text)
              end
            end
          end
        end
      end
    end
  end

  # @!endgroup

  # @!group Spacing Variations

  def no_spacing
    render ::Decor::Page.new(
      spacing: :none,
      padding: :none
    ) do |page|
      page.with_header do
        ::Decor::PageHeader.new(
          title: "Compact Page",
          description: "Minimal spacing between elements"
        )
      end

      page.div { "First content block" }
      page.div { "Second content block" }
      page.div { "Third content block" }
    end
  end

  def extra_large_spacing
    render ::Decor::Page.new(
      spacing: :xl,
      padding: :xl
    ) do |page|
      page.with_header do
        ::Decor::PageHeader.new(
          title: "Spacious Page",
          description: "Maximum spacing for better visual separation"
        )
      end

      page.div(class: "card bg-base-100 shadow p-6") { "First section with extra spacing" }
      page.div(class: "card bg-base-100 shadow p-6") { "Second section with extra spacing" }
    end
  end

  # @!endgroup

  # @!group Padding Examples

  def no_padding
    render ::Decor::Page.new(
      padding: :none
    ) do |page|
      page.with_header do
        ::Decor::PageHeader.new(
          title: "No Padding Page",
          description: "Page with no internal padding"
        )
      end

      page.div(class: "bg-primary/10 p-4 rounded") { "This content shows the page has no padding around it." }
    end
  end

  def small_padding
    render ::Decor::Page.new(
      padding: :sm
    ) do |page|
      page.with_header do
        ::Decor::PageHeader.new(
          title: "Small Padding",
          description: "Minimal padding for compact layouts"
        )
      end

      page.div(class: "bg-secondary/10 p-4 rounded") { "Small padding around the page content." }
    end
  end

  def large_padding
    render ::Decor::Page.new(
      padding: :lg
    ) do |page|
      page.with_header do
        ::Decor::PageHeader.new(
          title: "Large Padding",
          description: "Generous padding for spacious layouts"
        )
      end

      page.div(class: "bg-accent/10 p-4 rounded") { "Large padding creates more breathing room." }
    end
  end

  def extra_large_padding
    render ::Decor::Page.new(
      padding: :xl
    ) do |page|
      page.with_header do
        ::Decor::PageHeader.new(
          title: "Extra Large Padding",
          description: "Maximum padding for very spacious layouts"
        )
      end

      page.div(class: "bg-info/10 p-4 rounded") { "Extra large padding for maximum visual space." }
    end
  end

  # @!endgroup

  # @!group Full Height Examples

  def with_full_height
    render ::Decor::Page.new(
      full_height: true,
      padding: :lg
    ) do |page|
      page.with_header do
        ::Decor::PageHeader.new(
          title: "Full Height Page",
          description: "This page uses the full viewport height"
        )
      end

      page.div(class: "flex items-center justify-center bg-neutral/10 rounded-lg h-64") do
        page.div(class: "text-center") do
          page.h3(class: "text-xl font-semibold mb-2") { "Full Height Layout" }
          page.p { "This page will take up the full screen height." }
        end
      end
    end
  end

  def without_full_height
    render ::Decor::Page.new(
      full_height: false,
      padding: :lg
    ) do |page|
      page.with_header do
        ::Decor::PageHeader.new(
          title: "Normal Height Page",
          description: "This page uses natural content height (default)"
        )
      end

      page.div(class: "bg-warning/10 p-6 rounded-lg") do
        page.h3(class: "text-lg font-semibold mb-2") { "Natural Height" }
        page.p { "This page only takes up the space needed for its content." }
      end
    end
  end

  # @!endgroup
end
