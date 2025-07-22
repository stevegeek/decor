# @label PanelGroup
class ::Decor::PanelGroupPreview < ::Lookbook::Preview
  # PanelGroup
  # -------
  #
  # A panel group is a box with a title and description that contains a list of panels
  # displayed in a grid layout. Each panel is a Decor::Panel component with its own content.
  #
  # @group Examples
  # @label Simple Stats
  def simple_stats
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

  # @group Examples
  # @label Dashboard Metrics
  def dashboard_metrics
    render ::Decor::PanelGroup.new(
      title: "Dashboard Overview",
      description: "Key performance metrics and statistics"
    ) do |group|
      group.panels do
        [
          group.panel(title: "Active Users", icon: "users") { |p| p.plain("1,234") },
          group.panel(title: "Revenue", icon: "currency-dollar") { |p| p.plain("$45,678") },
          group.panel(title: "Conversion", icon: "chart-bar") { |p| p.plain("3.2%") }
        ]
      end
      group.panels do
        [
          group.panel(title: "Page Views", icon: "eye") { |p| p.plain("87,654") },
          group.panel(title: "Bounce Rate", icon: "arrow-trending-down") { |p| p.plain("24.1%") }
        ]
      end
      group.cta do
        render ::Decor::Button.new(color: :primary, size: :sm) { "Refresh" }
        render ::Decor::Button.new(style: :outlined, size: :sm) { "Export" }
      end
    end
  end

  # @group Examples
  # @label Server Status
  def server_status
    render ::Decor::PanelGroup.new(
      title: "Server Information",
      description: "Current server status and configuration"
    ) do |group|
      group.panels do
        [
          group.panel(title: "Primary Server", icon: "server") do |p|
            p.plain("Status: Online")
            p.br
            p.plain("CPU: 45%")
            p.br
            p.plain("Memory: 6.2GB / 16GB")
            p.br
            p.plain("Uptime: 24 days")
          end
        ]
      end
      group.cta do
        render ::Decor::Button.new(style: :outlined, size: :sm) { "Restart" }
      end
    end
  end

  # @group Examples
  # @label System Health
  def system_health
    render ::Decor::PanelGroup.new(
      title: "System Health",
      description: "Real-time monitoring of application components",
      color: :primary
    ) do |group|
      group.panels do
        [
          group.panel(title: "Database", icon: "circle-stack") do |p|
            p.plain("🟢 Operational")
            p.br
            p.plain("Response: 12ms")
          end,
          group.panel(title: "API Gateway", icon: "globe") do |p|
            p.plain("🟢 Healthy")
            p.br
            p.plain("Uptime: 99.9%")
          end,
          group.panel(title: "Cache", icon: "cpu-chip") do |p|
            p.plain("🟡 Warning")
            p.br
            p.plain("Hit ratio: 87%")
          end
        ]
      end
    end
  end

  # @group Playground
  # @param title text
  # @param description text
  # @param show_cta toggle
  # @param size [Symbol] select [~, xs, sm, md, lg, xl]
  # @param color [Symbol] select [~, base, primary, secondary, accent, neutral, success, error, warning, info]
  # @param style [Symbol] select [~, filled, outlined, ghost]
  def playground(title: "Panel Group Title", description: "Group description", show_cta: true, size: nil, color: nil, style: nil)
    render ::Decor::PanelGroup.new(
      title: title,
      description: description,
      size: size,
      color: color,
      style: style
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
          render ::Decor::Button.new(label: "Action", color: :primary)
        end
      end
    end
  end

  # @group Sizes
  # @label XS Size
  def size_xs
    render ::Decor::PanelGroup.new(
      title: "Extra Small Panel Group",
      size: :xs
    ) do |group|
      group.panels do
        [
          group.panel(title: "XS Panel") { |p| p.plain("Compact content") }
        ]
      end
    end
  end

  # @group Sizes
  # @label SM Size
  def size_sm
    render ::Decor::PanelGroup.new(
      title: "Small Panel Group",
      size: :sm
    ) do |group|
      group.panels do
        [
          group.panel(title: "SM Panel") { |p| p.plain("Small content") }
        ]
      end
    end
  end

  # @group Sizes
  # @label MD Size (Default)
  def size_md
    render ::Decor::PanelGroup.new(
      title: "Medium Panel Group",
      description: "Default size",
      size: :md
    ) do |group|
      group.panels do
        [
          group.panel(title: "MD Panel 1") { |p| p.plain("Medium content") },
          group.panel(title: "MD Panel 2") { |p| p.plain("Standard size") }
        ]
      end
    end
  end

  # @group Sizes
  # @label LG Size
  def size_lg
    render ::Decor::PanelGroup.new(
      title: "Large Panel Group",
      description: "Spacious layout",
      size: :lg
    ) do |group|
      group.panels do
        [
          group.panel(title: "LG Panel") { |p| p.plain("Large content area") }
        ]
      end
    end
  end

  # @group Sizes
  # @label XL Size
  def size_xl
    render ::Decor::PanelGroup.new(
      title: "Extra Large Panel Group",
      description: "Maximum size variant",
      size: :xl
    ) do |group|
      group.panels do
        [
          group.panel(title: "XL Panel") { |p| p.plain("Extra large content") }
        ]
      end
    end
  end

  # @group Colors
  # @label Base Color (Default)
  def color_base
    render ::Decor::PanelGroup.new(
      title: "Base Color Panel Group",
      color: :base
    ) do |group|
      group.panels do
        [
          group.panel(title: "Base Panel") { |p| p.plain("Default color") }
        ]
      end
    end
  end

  # @group Colors
  # @label Primary Color
  def color_primary
    render ::Decor::PanelGroup.new(
      title: "Primary Color Panel Group",
      color: :primary
    ) do |group|
      group.panels do
        [
          group.panel(title: "Primary Panel") { |p| p.plain("Primary themed") }
        ]
      end
    end
  end

  # @group Colors
  # @label Secondary Color
  def color_secondary
    render ::Decor::PanelGroup.new(
      title: "Secondary Color Panel Group",
      color: :secondary
    ) do |group|
      group.panels do
        [
          group.panel(title: "Secondary Panel") { |p| p.plain("Secondary themed") }
        ]
      end
    end
  end

  # @group Colors
  # @label Success Color
  def color_success
    render ::Decor::PanelGroup.new(
      title: "Success Color Panel Group",
      color: :success
    ) do |group|
      group.panels do
        [
          group.panel(title: "Success Panel") { |p| p.plain("Success themed") }
        ]
      end
    end
  end

  # @group Colors
  # @label Error Color
  def color_error
    render ::Decor::PanelGroup.new(
      title: "Error Color Panel Group",
      color: :error
    ) do |group|
      group.panels do
        [
          group.panel(title: "Error Panel") { |p| p.plain("Error themed") }
        ]
      end
    end
  end

  # @group Styles
  # @label Filled Style (Default)
  def style_filled
    render ::Decor::PanelGroup.new(
      title: "Filled Style Panel Group",
      style: :filled
    ) do |group|
      group.panels do
        [
          group.panel(title: "Filled Panel") { |p| p.plain("Default style") }
        ]
      end
    end
  end

  # @group Styles
  # @label Outlined Style
  def style_outlined
    render ::Decor::PanelGroup.new(
      title: "Outlined Style Panel Group",
      style: :outlined
    ) do |group|
      group.panels do
        [
          group.panel(title: "Outlined Panel") { |p| p.plain("Border style") }
        ]
      end
    end
  end

  # @group Styles
  # @label Ghost Style
  def style_ghost
    render ::Decor::PanelGroup.new(
      title: "Ghost Style Panel Group",
      style: :ghost
    ) do |group|
      group.panels do
        [
          group.panel(title: "Ghost Panel") { |p| p.plain("Minimal style") }
        ]
      end
    end
  end

  # @group With CTA
  # @label Single Action
  def with_single_cta
    render ::Decor::PanelGroup.new(
      title: "Panel Group with Action"
    ) do |group|
      group.panels do
        [
          group.panel(title: "Panel 1") { |p| p.plain("Content") },
          group.panel(title: "Panel 2") { |p| p.plain("Content") }
        ]
      end
      group.cta do
        render ::Decor::Button.new(color: :primary) { "Take Action" }
      end
    end
  end

  # @group With CTA
  # @label Multiple Actions
  def with_multiple_ctas
    render ::Decor::PanelGroup.new(
      title: "Panel Group with Multiple Actions"
    ) do |group|
      group.panels do
        [
          group.panel(title: "Panel 1") { |p| p.plain("Content") }
        ]
      end
      group.cta do
        render ::Decor::Button.new(color: :primary) { "Primary" }
        render ::Decor::Button.new(style: :outlined) { "Secondary" }
        render ::Decor::Button.new(style: :ghost) { "Tertiary" }
      end
    end
  end

  # @group Panel Icons
  # @label With Icons
  def panels_with_icons
    render ::Decor::PanelGroup.new(
      title: "Panels with Icons"
    ) do |group|
      group.panels do
        [
          group.panel(title: "Users", icon: "users") { |p| p.plain("1,234") },
          group.panel(title: "Revenue", icon: "currency-dollar") { |p| p.plain("$12,345") },
          group.panel(title: "Orders", icon: "shopping-cart") { |p| p.plain("567") }
        ]
      end
    end
  end

  # @group Panel Icons
  # @label Without Icons
  def panels_without_icons
    render ::Decor::PanelGroup.new(
      title: "Panels without Icons"
    ) do |group|
      group.panels do
        [
          group.panel(title: "Plain Panel 1") { |p| p.plain("Simple content") },
          group.panel(title: "Plain Panel 2") { |p| p.plain("Basic content") }
        ]
      end
    end
  end

  # @group Panel Content
  # @label Rich Content
  def panels_rich_content
    render ::Decor::PanelGroup.new(
      title: "Rich Panel Content"
    ) do |group|
      group.panels do
        [
          group.panel(title: "Status", icon: "signal") do |p|
            p.plain("🟢 All Systems Operational")
            p.br
            p.span(class: "text-sm text-base-content/70") { "Last checked: 5 mins ago" }
          end,
          group.panel(title: "Performance", icon: "chart-bar") do |p|
            p.div(class: "space-y-1") do
              p.div(class: "flex justify-between") do
                p.span { "CPU" }
                p.span(class: "font-medium") { "45%" }
              end
              p.div(class: "flex justify-between") do
                p.span { "Memory" }
                p.span(class: "font-medium") { "72%" }
              end
            end
          end
        ]
      end
    end
  end

  # @group Panel Content
  # @label Simple Content
  def panels_simple_content
    render ::Decor::PanelGroup.new(
      title: "Simple Panel Content"
    ) do |group|
      group.panels do
        [
          group.panel(title: "Value 1") { |p| p.plain("123") },
          group.panel(title: "Value 2") { |p| p.plain("456") },
          group.panel(title: "Value 3") { |p| p.plain("789") }
        ]
      end
    end
  end
end
