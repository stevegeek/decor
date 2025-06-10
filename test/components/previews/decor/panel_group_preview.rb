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
          panel(title: "Panel 1") { |p| p.plain("Panel 1 content") },
          panel(title: "Panel 2") { |p| p.plain("Panel 2 content") }
        ]
      end
      group.panels do
        [
          panel(title: "Panel 3") { |p| p.plain("Panel 3 content") },
          panel(title: "Panel 4") { |p| p.plain("Panel 4 content") }
        ]
      end
      if show_cta
        group.cta do
          render ::Decor::Button.new(label: "Button")
        end
      end
    end
  end
  #
  # # @!group Examples
  #
  # def dashboard_metrics
  #   render ::Decor::PanelGroup.new(
  #     title: "Dashboard Overview",
  #     description: "Key performance metrics and statistics for your application",
  #     panels: [
  #       [
  #         {title: "Active Users", icon: "users", content: "1,234"},
  #         {title: "Total Revenue", icon: "currency-dollar", content: "$45,678"},
  #         {title: "Conversion Rate", icon: "chart-bar", content: "3.2%"}
  #       ],
  #       [
  #         {title: "Page Views", icon: "eye", content: "87,654"},
  #         {title: "Bounce Rate", icon: "arrow-trending-down", content: "24.1%"}
  #       ]
  #     ]
  #   ) do |panel_group|
  #     panel_group.with_cta do
  #       panel_group.render ::Decor::Button.new(theme: :primary, size: :small) { "Refresh Data" }
  #       panel_group.render ::Decor::Button.new(variant: :outlined, size: :small) { "Export Report" }
  #     end
  #   end
  # end
  #
  # def user_profile_settings
  #   render ::Decor::PanelGroup.new(
  #     title: "Account Settings",
  #     description: "Manage your profile information and preferences",
  #     panels: [
  #       [
  #         ::Decor::Panel.new(title: "Personal Information") do
  #           plain("Name: John Doe")
  #           br
  #           plain("Email: john@example.com")
  #           br
  #           plain("Phone: (555) 123-4567")
  #         end,
  #         ::Decor::Panel.new(title: "Account Status", icon: "shield-check") do
  #           plain("✅ Verified Account")
  #           br
  #           plain("Member since: January 2023")
  #           br
  #           plain("Last login: 2 hours ago")
  #         end
  #       ],
  #       [
  #         ::Decor::Panel.new(title: "Preferences", icon: "cog") do
  #           plain("Notifications: Enabled")
  #           br
  #           plain("Theme: Dark Mode")
  #           br
  #           plain("Language: English")
  #         end
  #       ]
  #     ]
  #   ) do |panel_group|
  #     panel_group.with_cta do
  #       panel_group.render ::Decor::Button.new(theme: :primary) { "Edit Profile" }
  #     end
  #   end
  # end
  #
  # def system_status
  #   render ::Decor::PanelGroup.new(
  #     title: "System Health",
  #     description: "Real-time monitoring of application components and services",
  #     panels: [
  #       [
  #         ::Decor::Panel.new(title: "Database", icon: "circle-stack") do
  #           plain("🟢 Operational")
  #           br
  #           plain("Response: 12ms")
  #           br
  #           plain("Connections: 45/100")
  #         end,
  #         ::Decor::Panel.new(title: "API Gateway", icon: "globe") do
  #           plain("🟢 Healthy")
  #           br
  #           plain("Requests/min: 1,247")
  #           br
  #           plain("Uptime: 99.9%")
  #         end,
  #         ::Decor::Panel.new(title: "Cache Layer", icon: "cpu-chip") do
  #           plain("🟡 Warning")
  #           br
  #           plain("Hit ratio: 87%")
  #           br
  #           plain("Memory: 8.2GB/10GB")
  #         end
  #       ],
  #       [
  #         ::Decor::Panel.new(title: "Background Jobs", icon: "clock") do
  #           plain("🟢 Processing")
  #           br
  #           plain("Queue size: 23")
  #           br
  #           plain("Failed: 0")
  #         end,
  #         ::Decor::Panel.new(title: "Storage", icon: "server") do
  #           plain("🟢 Available")
  #           br
  #           plain("Used: 2.1TB/5TB")
  #           br
  #           plain("Growth: +12GB/day")
  #         end
  #       ]
  #     ]
  #   ) do |panel_group|
  #     panel_group.with_cta do
  #       panel_group.render ::Decor::Button.new(variant: :outlined, size: :small) { "View Logs" }
  #       panel_group.render ::Decor::Button.new(variant: :outlined, size: :small) { "Run Diagnostics" }
  #     end
  #   end
  # end
  #
  # def financial_summary
  #   render ::Decor::PanelGroup.new(
  #     title: "Financial Overview",
  #     description: "Monthly financial performance and key business metrics",
  #     panels: [
  #       [
  #         ::Decor::Panel.new(title: "Revenue This Month", icon: "banknotes") do
  #           plain("$127,456")
  #           br
  #           span(class: "text-green-600") { "↗ +12.3% from last month" }
  #         end
  #       ],
  #       [
  #         ::Decor::Panel.new(title: "New Customers", icon: "user-plus") do
  #           plain("89")
  #           br
  #           span(class: "text-blue-600") { "Target: 75 ✓" }
  #         end,
  #         ::Decor::Panel.new(title: "Average Order Value", icon: "calculator") do
  #           plain("$156.78")
  #           br
  #           span(class: "text-green-600") { "↗ +5.2%" }
  #         end
  #       ],
  #       [
  #         ::Decor::Panel.new(title: "Operating Expenses", icon: "receipt-percent") do
  #           plain("$45,230")
  #           br
  #           span(class: "text-orange-600") { "→ -2.1% vs budget" }
  #         end,
  #         ::Decor::Panel.new(title: "Profit Margin", icon: "chart-pie") do
  #           plain("28.4%")
  #           br
  #           span(class: "text-green-600") { "↗ +1.8%" }
  #         end,
  #         ::Decor::Panel.new(title: "Cash Flow", icon: "arrows-right-left") do
  #           plain("$82,226")
  #           br
  #           span(class: "text-green-600") { "Positive" }
  #         end
  #       ]
  #     ]
  #   ) do |panel_group|
  #     panel_group.with_cta do
  #       panel_group.render ::Decor::Button.new(theme: :primary) { "Download Report" }
  #       panel_group.render ::Decor::Button.new(variant: :outlined, theme: :secondary) { "View Details" }
  #     end
  #   end
  # end
  #
  # def project_overview
  #   render ::Decor::PanelGroup.new(
  #     title: "Project Status",
  #     description: "Current progress and key metrics for active development projects",
  #     panels: [
  #       [
  #         ::Decor::Panel.new(title: "Frontend Redesign", icon: "paint-brush") do
  #           plain("Progress: 75%")
  #           br
  #           plain("Due: Next Friday")
  #           br
  #           plain("Team: 4 developers")
  #         end,
  #         ::Decor::Panel.new(title: "API Migration", icon: "arrow-path") do
  #           plain("Progress: 45%")
  #           br
  #           plain("Due: End of month")
  #           br
  #           plain("Team: 2 developers")
  #         end
  #       ],
  #       [
  #         ::Decor::Panel.new(title: "Mobile App", icon: "device-phone-mobile") do
  #           plain("Progress: 90%")
  #           br
  #           plain("Due: This week")
  #           br
  #           plain("Team: 3 developers")
  #         end,
  #         ::Decor::Panel.new(title: "Database Optimization", icon: "cog") do
  #           plain("Progress: 30%")
  #           br
  #           plain("Due: Next month")
  #           br
  #           plain("Team: 1 developer")
  #         end
  #       ]
  #     ]
  #   ) do |panel_group|
  #     panel_group.with_cta do
  #       panel_group.render ::Decor::Button.new(theme: :primary) { "View All Projects" }
  #     end
  #   end
  # end
  #
  # def simple_info_cards
  #   render ::Decor::PanelGroup.new(
  #     title: "Quick Stats",
  #     panels: [
  #       [
  #         {title: "Downloads", content: "12,345"},
  #         {title: "Active Users", content: "8,901"},
  #         {title: "Reviews", content: "4.8/5"}
  #       ]
  #     ]
  #   )
  # end
  #
  # def single_panel_example
  #   render ::Decor::PanelGroup.new(
  #     title: "Server Information",
  #     description: "Current server status and configuration details",
  #     panels: [
  #       [
  #         ::Decor::Panel.new(title: "Primary Server", icon: "server") do
  #           plain("Status: Online")
  #           br
  #           plain("CPU: 45% utilization")
  #           br
  #           plain("Memory: 6.2GB / 16GB")
  #           br
  #           plain("Disk: 120GB / 500GB")
  #           br
  #           plain("Uptime: 24 days")
  #         end
  #       ]
  #     ]
  #   ) do |panel_group|
  #     panel_group.with_cta do
  #       panel_group.render ::Decor::Button.new(variant: :outlined, size: :small) { "Restart Server" }
  #     end
  #   end
  # end

  # @!endgroup
end
