# @label PanelGroup
class ::Decor::PanelGroupPreview < ::Lookbook::Preview
  # PanelGroup
  # -------
  #
  # A panel group is a box with a title and a description and a list of panels which are displayed in a grid
  # and contain information.
  # The panels of information are rendered as a list of `Decor::Panel` components, but to avoid
  # managing a list of lists of slots, we prepare these as an array of options and content block pairs, which
  # are then used by PanelGroup to render the panels.
  #
  # @label Playground
  # @param title text
  # @param description text
  # @param show_cta toggle
  def playground(title: "Box title", description: "My description", show_cta: true)
    # render ::Decor::PanelGroup.new(
    #   title: title,
    #   description: description,
    #   panels: [
    #     [
    #       ::Decor::Panel.new(
    #         title: "Panel 1"
    #       ) { |p| p.plain("Panel 1 content") },
    #       ::Decor::Panel.new(
    #         title: "Panel 2"
    #       ) { |p| p.plain("Panel 2 content") }
    #     ],
    #     [
    #       ::Decor::Panel.new(
    #         title: "Panel 3"
    #       ) { |p| p.plain("Panel 3 content") },
    #       ::Decor::Panel.new(
    #         title: "Panel 4"
    #       ) { |p| p.plain("Panel 4 content") },
    #     ]
    #   ]
    # ) do |panel_group|
    #   puts "Call stack her"
    #   puts "**********"
    #   puts panel_group.class.name
    #   if show_cta
    #     panel_group.with_cta do
    #       panel_group.render ::Decor::Button.new(label: "Button")
    #     end
    #   end
    # end
    render ::Decor::PanelGroup.new(
      title: title,
      description: description
    ) do |group|
      group.panels do
        [
          group.panel(title: "Panel 1") { |p| p.plain("Panel 1 content") },
          group.panel(title: "Panel 2") { |p| p.plain("Panel 2 content") }
        ]
      end
      group.panels do
        [
          group.panel(title: "Panel 3") { |p| p.plain("Panel 3 content") },
          group.panel(title: "Panel 4") { |p| p.plain("Panel 4 content") }
        ]
      end
      if show_cta
        group.cta do
          render ::Decor::Button.new(label: "Button")
        end
      end
    end
  end

  # @!group Examples

  def dashboard_metrics
    render ::Decor::PanelGroup.new(
      title: "Dashboard Overview",
      description: "Key performance metrics and statistics for your application"
    ) do |group|
      group.panels do
        [
          group.panel(title: "Active Users", icon: "users") { |p| p.plain("1,234") },
          group.panel(title: "Total Revenue", icon: "currency-dollar") { |p| p.plain("$45,678") },
          group.panel(title: "Conversion Rate", icon: "chart-bar") { |p| p.plain("3.2%") }
        ]
      end
      group.panels do
        [
          group.panel(title: "Page Views", icon: "eye") { |p| p.plain("87,654") },
          group.panel(title: "Bounce Rate", icon: "arrow-trending-down") { |p| p.plain("24.1%") }
        ]
      end
      group.cta do
        render ::Decor::Button.new(color: :primary, size: :sm) { "Refresh Data" }
        render ::Decor::Button.new(variant: :outlined, size: :sm) { "Export Report" }
      end
    end
  end

  def user_profile_settings
    render ::Decor::PanelGroup.new(
      title: "Account Settings",
      description: "Manage your profile information and preferences"
    ) do |group|
      group.panels do
        [
          group.panel(title: "Personal Information") do |p|
            p.plain("Name: John Doe")
            p.br
            p.plain("Email: john@example.com")
            p.br
            p.plain("Phone: (555) 123-4567")
          end,
          group.panel(title: "Account Status", icon: "shield-check") do |p|
            p.plain("✅ Verified Account")
            p.br
            p.plain("Member since: January 2023")
            p.br
            p.plain("Last login: 2 hours ago")
          end
        ]
      end
      group.panels do
        [
          group.panel(title: "Preferences", icon: "cog") do |p|
            p.plain("Notifications: Enabled")
            p.br
            p.plain("Theme: Dark Mode")
            p.br
            p.plain("Language: English")
          end
        ]
      end
      group.cta do
        render ::Decor::Button.new(color: :primary) { "Edit Profile" }
      end
    end
  end

  def system_status
    render ::Decor::PanelGroup.new(
      title: "System Health",
      description: "Real-time monitoring of application components and services"
    ) do |group|
      group.panels do
        [
          group.panel(title: "Database", icon: "circle-stack") do |p|
            p.plain("🟢 Operational")
            p.br
            p.plain("Response: 12ms")
            p.br
            p.plain("Connections: 45/100")
          end,
          group.panel(title: "API Gateway", icon: "globe") do |p|
            p.plain("🟢 Healthy")
            p.br
            p.plain("Requests/min: 1,247")
            p.br
            p.plain("Uptime: 99.9%")
          end,
          group.panel(title: "Cache Layer", icon: "cpu-chip") do |p|
            p.plain("🟡 Warning")
            p.br
            p.plain("Hit ratio: 87%")
            p.br
            p.plain("Memory: 8.2GB/10GB")
          end
        ]
      end
      group.panels do
        [
          group.panel(title: "Background Jobs", icon: "clock") do |p|
            p.plain("🟢 Processing")
            p.br
            p.plain("Queue size: 23")
            p.br
            p.plain("Failed: 0")
          end,
          group.panel(title: "Storage", icon: "server") do |p|
            p.plain("🟢 Available")
            p.br
            p.plain("Used: 2.1TB/5TB")
            p.br
            p.plain("Growth: +12GB/day")
          end
        ]
      end
      group.cta do
        render ::Decor::Button.new(variant: :outlined, size: :sm) { "View Logs" }
        render ::Decor::Button.new(variant: :outlined, size: :sm) { "Run Diagnostics" }
      end
    end
  end

  # @label Size Variants
  def size_variants
    render ::Decor::PanelGroup.new(
      title: "Extra Large Panel Group",
      description: "Showcasing XL size variant",
      size: :xl
    ) do |group|
      group.panels do
        [
          group.panel(title: "Large Panel") { |p| p.plain("Content in XL group") }
        ]
      end
    end
  end

  # @label Color Variants
  def color_variants
    render ::Decor::PanelGroup.new(
      title: "Primary Color Panel Group",
      description: "Showcasing primary color variant",
      color: :primary
    ) do |group|
      group.panels do
        [
          group.panel(title: "Primary Panel") { |p| p.plain("Content in primary color") }
        ]
      end
    end
  end

  # @label Variant Types
  def variant_types
    render ::Decor::PanelGroup.new(
      title: "Ghost Variant Panel Group",
      description: "Showcasing ghost variant",
      variant: :ghost
    ) do |group|
      group.panels do
        [
          group.panel(title: "Ghost Panel") { |p| p.plain("Content in ghost variant") }
        ]
      end
    end
  end

  def financial_summary
    render ::Decor::PanelGroup.new(
      title: "Financial Overview",
      description: "Monthly financial performance and key business metrics"
    ) do |group|
      group.panels do
        [
          group.panel(title: "Revenue This Month", icon: "banknotes") do |p|
            p.plain("$127,456")
            p.br
            p.span(class: "text-green-600") { "↗ +12.3% from last month" }
          end
        ]
      end
      group.panels do
        [
          group.panel(title: "New Customers", icon: "user-plus") do |p|
            p.plain("89")
            p.br
            p.span(class: "text-blue-600") { "Target: 75 ✓" }
          end,
          group.panel(title: "Average Order Value", icon: "calculator") do |p|
            p.plain("$156.78")
            p.br
            p.span(class: "text-green-600") { "↗ +5.2%" }
          end
        ]
      end
      group.panels do
        [
          group.panel(title: "Operating Expenses", icon: "receipt-percent") do |p|
            p.plain("$45,230")
            p.br
            p.span(class: "text-orange-600") { "→ -2.1% vs budget" }
          end,
          group.panel(title: "Profit Margin", icon: "chart-pie") do |p|
            p.plain("28.4%")
            p.br
            p.span(class: "text-green-600") { "↗ +1.8%" }
          end,
          group.panel(title: "Cash Flow", icon: "arrows-right-left") do |p|
            p.plain("$82,226")
            p.br
            p.span(class: "text-green-600") { "Positive" }
          end
        ]
      end
      group.cta do
        render ::Decor::Button.new(color: :primary) { "Download Report" }
        render ::Decor::Button.new(variant: :outlined, color: :secondary) { "View Details" }
      end
    end
  end

  def project_overview
    render ::Decor::PanelGroup.new(
      title: "Project Status",
      description: "Current progress and key metrics for active development projects"
    ) do |group|
      group.panels do
        [
          group.panel(title: "Frontend Redesign", icon: "paint-brush") do |p|
            p.plain("Progress: 75%")
            p.br
            p.plain("Due: Next Friday")
            p.br
            p.plain("Team: 4 developers")
          end,
          group.panel(title: "API Migration", icon: "arrow-path") do |p|
            p.plain("Progress: 45%")
            p.br
            p.plain("Due: End of month")
            p.br
            p.plain("Team: 2 developers")
          end
        ]
      end
      group.panels do
        [
          group.panel(title: "Mobile App", icon: "device-phone-mobile") do |p|
            p.plain("Progress: 90%")
            p.br
            p.plain("Due: This week")
            p.br
            p.plain("Team: 3 developers")
          end,
          group.panel(title: "Database Optimization", icon: "cog") do |p|
            p.plain("Progress: 30%")
            p.br
            p.plain("Due: Next month")
            p.br
            p.plain("Team: 1 developer")
          end
        ]
      end
      group.cta do
        render ::Decor::Button.new(color: :primary) { "View All Projects" }
      end
    end
  end

  def simple_info_cards
    render ::Decor::PanelGroup.new(
      title: "Quick Stats"
    ) do |group|
      group.panels do
        [
          group.panel(title: "Downloads") { |p| p.plain("12,345") },
          group.panel(title: "Active Users") { |p| p.plain("8,901") },
          group.panel(title: "Reviews") { |p| p.plain("4.8/5") }
        ]
      end
    end
  end

  def single_panel_example
    render ::Decor::PanelGroup.new(
      title: "Server Information",
      description: "Current server status and configuration details"
    ) do |group|
      group.panels do
        [
          group.panel(title: "Primary Server", icon: "server") do |p|
            p.plain("Status: Online")
            p.br
            p.plain("CPU: 45% utilization")
            p.br
            p.plain("Memory: 6.2GB / 16GB")
            p.br
            p.plain("Disk: 120GB / 500GB")
            p.br
            p.plain("Uptime: 24 days")
          end
        ]
      end
      group.cta do
        render ::Decor::Button.new(variant: :outlined, size: :sm) { "Restart Server" }
      end
    end
  end

  # @!endgroup
end
