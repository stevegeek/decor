# @label Stat
class ::Decor::StatPreview < ::Lookbook::Preview
  # Stat
  # ----
  #
  # A Stat component displays statistical information in a structured, visually appealing format.
  # Perfect for dashboards, analytics displays, and anywhere numerical data needs to be prominently featured.
  # Supports icons, descriptions, actions, and various color themes.
  #
  # @group Examples
  # @label Basic Stat
  def basic_stat
    render ::Decor::Stats.new do |el|
      el.render ::Decor::Stat.new(
        title: "Total Revenue",
        value: "$45,231",
        description: "+20.1% from last month"
      )
    end
  end

  # @group Examples
  # @label Stat with Icon
  def stat_with_icon
    render ::Decor::Stats.new do |el|
      el.render ::Decor::Stat.new(
        title: "Active Users",
        value: "2,847",
        description: "Currently online",
        color: :success,
        icon: "users"
      )
    end
  end

  # @group Examples
  # @label Multiple Stats
  def multiple_stats
    render ::Decor::Stats.new(orientation: :horizontal) do |el|
      el.render ::Decor::Stat.new(
        title: "Downloads",
        value: "31K",
        description: "Total downloads",
        icon: "download"
      )
      el.render ::Decor::Stat.new(
        title: "New Users",
        value: "4,200",
        description: "↗︎ 400 (22%)",
        color: :success,
        icon: "users"
      )
      el.render ::Decor::Stat.new(
        title: "Active Sessions",
        value: "1,250",
        description: "Currently active",
        color: :primary,
        icon: "eye"
      )
    end
  end

  # @group Playground
  # @param title text
  # @param value text
  # @param description text
  # @param icon select [~, chart-bar, users, heart, download, eye, star, currency-dollar]
  # @param icon_color select [~, primary, secondary, accent, success, error, warning, info]
  # @param centered toggle
  # @param orientation select [horizontal, vertical]
  # @param shadow toggle
  # @param responsive toggle
  # @param size [Symbol] select [~, xs, sm, md, lg, xl]
  # @param color [Symbol] select [~, base, primary, secondary, accent, neutral, success, error, warning, info]
  # @param style [Symbol] select [~, filled, outlined, ghost]
  def playground(
    title: "Total Page Views",
    value: "89,400",
    description: "21% more than last month",
    icon: nil,
    icon_color: nil,
    centered: false,
    orientation: :horizontal,
    shadow: true,
    responsive: false,
    size: nil,
    color: nil,
    style: nil
  )
    render ::Decor::Stats.new(orientation: orientation.to_sym, shadow: shadow, responsive: responsive) do |el|
      el.render ::Decor::Stat.new(
        title: title,
        value: value,
        description: description,
        icon: icon,
        icon_color: icon_color&.to_sym,
        centered: centered,
        size: size,
        color: color,
        style: style
      )
    end
  end

  # @group Alignment
  # @label Left Aligned (Default)
  def align_left
    render ::Decor::Stats.new do |el|
      el.render ::Decor::Stat.new(
        title: "Total Downloads",
        value: "31K",
        description: "From January 1st to February 1st",
        centered: false
      )
    end
  end

  # @group Alignment
  # @label Center Aligned
  def align_center
    render ::Decor::Stats.new do |el|
      el.render ::Decor::Stat.new(
        title: "Downloads",
        value: "31K",
        description: "From January 1st to February 1st",
        centered: true
      )
    end
  end

  # @group Colors
  # @label Primary Color
  def color_primary
    render ::Decor::Stats.new do |el|
      el.render ::Decor::Stat.new(
        title: "Revenue",
        value: "$89,400",
        description: "12% increase from last quarter",
        color: :primary
      )
    end
  end

  # @group Colors
  # @label Success Color
  def color_success
    render ::Decor::Stats.new do |el|
      el.render ::Decor::Stat.new(
        title: "Completed Tasks",
        value: "147",
        description: "All goals achieved",
        color: :success,
        icon: "check-circle"
      )
    end
  end

  # @group Colors
  # @label Error Color
  def color_error
    render ::Decor::Stats.new do |el|
      el.render ::Decor::Stat.new(
        title: "Failed Requests",
        value: "23",
        description: "5% error rate",
        color: :error,
        icon: "exclamation-triangle"
      )
    end
  end

  # @group Colors
  # @label Warning Color
  def color_warning
    render ::Decor::Stats.new do |el|
      el.render ::Decor::Stat.new(
        title: "Pending Reviews",
        value: "12",
        description: "Requires attention",
        color: :warning,
        icon: "clock"
      )
    end
  end

  # @group Icons
  # @label Chart Icon
  def icon_chart
    render ::Decor::Stats.new do |el|
      el.render ::Decor::Stat.new(
        title: "Analytics",
        value: "89.4%",
        description: "Conversion rate",
        color: :info,
        icon: "chart-bar"
      )
    end
  end

  # @group Icons
  # @label Users Icon
  def icon_users
    render ::Decor::Stats.new do |el|
      el.render ::Decor::Stat.new(
        title: "Active Users",
        value: "2,847",
        description: "Currently online",
        color: :success,
        icon: "users"
      )
    end
  end

  # @group Icons
  # @label Download Icon
  def icon_download
    render ::Decor::Stats.new do |el|
      el.render ::Decor::Stat.new(
        title: "Total Downloads",
        value: "1.2M",
        description: "All time",
        color: :primary,
        icon: "download"
      )
    end
  end

  # @group Icons
  # @label Different Icon Color
  def icon_different_color
    render ::Decor::Stats.new do |el|
      el.render ::Decor::Stat.new(
        title: "Premium Users",
        value: "567",
        description: "Subscribed members",
        color: :primary,
        icon: "star",
        icon_color: :warning
      )
    end
  end

  # @group Layouts
  # @label Horizontal Layout
  def layout_horizontal
    render ::Decor::Stats.new(orientation: :horizontal) do |el|
      el.render ::Decor::Stat.new(
        title: "Total Page Views",
        value: "89,400",
        description: "21% more than last month"
      )
      el.render ::Decor::Stat.new(
        title: "Total Likes",
        value: "25.6K",
        description: "21% more than last month",
        color: :primary
      )
      el.render ::Decor::Stat.new(
        title: "Downloads",
        value: "31K",
        description: "From January 1st to February 1st",
        color: :success
      )
    end
  end

  # @group Layouts
  # @label Vertical Layout
  def layout_vertical
    render ::Decor::Stats.new(orientation: :vertical) do |el|
      el.render ::Decor::Stat.new(
        title: "Downloads",
        value: "31K",
        description: "Jan 1st - Feb 1st"
      )
      el.render ::Decor::Stat.new(
        title: "New Users",
        value: "4,200",
        description: "↗︎ 400 (22%)",
        color: :success
      )
      el.render ::Decor::Stat.new(
        title: "Active Sessions",
        value: "1,250",
        description: "Currently active",
        color: :primary
      )
    end
  end

  # @group Layouts
  # @label Responsive Layout
  def layout_responsive
    render ::Decor::Stats.new(responsive: true) do |el|
      el.render ::Decor::Stat.new(
        title: "Account Balance",
        value: "$89,400",
        description: "Available funds",
        color: :success
      )
      el.render ::Decor::Stat.new(
        title: "Pending Transactions",
        value: "12",
        description: "Awaiting approval",
        color: :warning
      )
      el.render ::Decor::Stat.new(
        title: "Monthly Spending",
        value: "$2,847",
        description: "This month",
        color: :primary
      )
    end
  end

  # @group With Custom Content
  # @label With Figure Block
  def custom_figure_block
    render ::Decor::Stats.new do |el|
      el.render ::Decor::Stat.new(
        title: "Active Users",
        value: "86%",
        description: "31 tasks remaining",
        color: :primary
      ) do |stat|
        stat.figure do
          div(class: "avatar online") do
            div(class: "w-16 rounded-full") do
              img(src: "https://i.pravatar.cc/150", alt: "User avatar")
            end
          end
        end
      end
    end
  end

  # @group With Custom Content
  # @label With Actions
  def custom_with_actions
    render ::Decor::Stats.new do |el|
      el.render ::Decor::Stat.new(
        title: "Account Balance",
        value: "$89,400",
        description: "Available funds"
      ) do |stat|
        stat.actions do
          render ::Decor::Button.new(
            label: "Add funds",
            size: :small,
            color: :primary
          )
        end
      end
    end
  end

  # @group With Custom Content
  # @label Complex Dashboard Stats
  def custom_dashboard
    render ::Decor::Stats.new(responsive: true) do |el|
      el.render ::Decor::Stat.new(
        title: "Revenue",
        value: "$45,231",
        description: "+20.1% from last month",
        color: :success,
        icon: "currency-dollar"
      )
      el.render ::Decor::Stat.new(
        title: "Orders",
        value: "1,234",
        description: "+15% from last week",
        color: :primary,
        icon: "shopping-cart"
      )
      el.render ::Decor::Stat.new(
        title: "Customers",
        value: "567",
        description: "↗︎ 90 (12%)",
        color: :info,
        icon: "users"
      )
      el.render ::Decor::Stat.new(
        title: "Conversion",
        value: "12.5%",
        description: "↘︎ -2.3% from last month",
        color: :warning,
        icon: "chart-bar"
      )
    end
  end

  # @group Styling Options
  # @label Without Shadow
  def styling_no_shadow
    render ::Decor::Stats.new(shadow: false) do |el|
      el.render ::Decor::Stat.new(
        title: "Clean Look",
        value: "42",
        description: "No shadow styling"
      )
    end
  end

  # @group Styling Options
  # @label With Background
  def styling_with_background
    render ::Decor::Stats.new(background: true) do |el|
      el.render ::Decor::Stat.new(
        title: "Highlighted",
        value: "256",
        description: "With background color",
        color: :primary
      )
    end
  end

  # @group Styling Options
  # @label Combined Styling
  def styling_combined
    render ::Decor::Stats.new(shadow: true, background: true) do |el|
      el.render ::Decor::Stat.new(
        title: "Premium Stats",
        value: "1,337",
        description: "Shadow + background",
        color: :accent,
        icon: "star"
      )
    end
  end

  # @group With Custom Content
  # @label Custom Value Content
  def custom_value_content
    render ::Decor::Stats.new do |el|
      el.render ::Decor::Stat.new(
        title: "Complex Metric",
        description: "Multiple components"
      ) do |stat|
        stat.span(class: "text-3xl font-bold text-primary") { "$12,345" }
        stat.span(class: "text-sm text-success ml-2") { "+15%" }
      end
    end
  end

  # @group With Custom Content
  # @label Full Custom Content
  def custom_full_content
    render ::Decor::Stats.new do |el|
      el.render ::Decor::Stat.new(centered: true) do |stat|
        stat.div(class: "stat-title") { "Custom Layout" }
        stat.div(class: "stat-value text-secondary") { "∞" }
        stat.div(class: "stat-desc") { "Unlimited possibilities" }
      end
    end
  end

  # @group Examples
  # @label E-commerce Dashboard
  def ecommerce_dashboard
    render ::Decor::Stats.new(responsive: true, shadow: true) do |el|
      el.render ::Decor::Stat.new(
        title: "Total Sales",
        value: "$54,239",
        description: "+12% from last month",
        color: :success,
        icon: "currency-dollar"
      )
      el.render ::Decor::Stat.new(
        title: "Orders",
        value: "1,423",
        description: "This month",
        color: :primary,
        icon: "shopping-bag"
      )
      el.render ::Decor::Stat.new(
        title: "Customers",
        value: "892",
        description: "Active users",
        color: :info,
        icon: "users"
      )
      el.render ::Decor::Stat.new(
        title: "Conversion Rate",
        value: "2.4%",
        description: "↗︎ +0.3% this week",
        color: :warning,
        icon: "presentation-chart-line"
      )
    end
  end

  # @group Examples
  # @label Website Analytics
  def website_analytics
    render ::Decor::Stats.new(orientation: :vertical, shadow: true) do |el|
      el.render ::Decor::Stat.new(
        title: "Page Views",
        value: "125,847",
        description: "Last 30 days",
        color: :primary,
        icon: "eye"
      )
      el.render ::Decor::Stat.new(
        title: "Unique Visitors",
        value: "23,456",
        description: "Monthly unique users",
        color: :info,
        icon: "users"
      )
      el.render ::Decor::Stat.new(
        title: "Bounce Rate",
        value: "24.3%",
        description: "↘︎ -5.2% improvement",
        color: :success,
        icon: "chart-bar"
      )
      el.render ::Decor::Stat.new(
        title: "Average Session",
        value: "4m 32s",
        description: "Time on site",
        color: :accent,
        icon: "clock"
      )
    end
  end
end
