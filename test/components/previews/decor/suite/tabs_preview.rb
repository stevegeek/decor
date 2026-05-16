# @label Tabs
class ::Decor::Suite::TabsPreview < ::Lookbook::Preview
  TabInfo = ::Decor::Components::Tabs::TabInfo

  # @group Examples
  # @label Default
  def example_default
    render ::Decor::Suite::Tabs.new(
      links: [
        TabInfo.new(title: "Overview", href: "#overview", active: true),
        TabInfo.new(title: "Activity", href: "#activity"),
        TabInfo.new(title: "Settings", href: "#settings")
      ]
    )
  end

  # @group Examples
  # @label With badges
  def example_with_badges
    render ::Decor::Suite::Tabs.new(
      links: [
        TabInfo.new(title: "Inbox", href: "#inbox", active: true, badge_text: "12"),
        TabInfo.new(title: "Drafts", href: "#drafts", badge_text: "3"),
        TabInfo.new(title: "Archive", href: "#archive")
      ]
    )
  end

  # @group Examples
  # @label With status
  def example_with_status
    render ::Decor::Suite::Tabs.new(
      links: [
        TabInfo.new(title: "Daily", href: "#daily", active: true),
        TabInfo.new(title: "Weekly", href: "#weekly"),
        TabInfo.new(title: "Monthly", href: "#monthly")
      ],
      status: "Updated 5 minutes ago"
    )
  end

  # @group States
  # @label Disabled tab
  def state_disabled
    render ::Decor::Suite::Tabs.new(
      links: [
        TabInfo.new(title: "Available", href: "#available", active: true),
        TabInfo.new(title: "Coming soon", disabled: true)
      ]
    )
  end

  # @group States
  # @label Non-link tab (no href)
  def state_no_href
    render ::Decor::Suite::Tabs.new(
      links: [
        TabInfo.new(title: "Active", href: "#active", active: true),
        TabInfo.new(title: "Info only")
      ]
    )
  end

  # @group States
  # @label Overflowing strip (scrolls horizontally)
  def state_overflowing
    render ::Decor::Suite::Tabs.new(
      links: (1..14).map { |i|
        TabInfo.new(title: "Section #{i}", href: "#sec-#{i}", active: i == 1)
      }
    )
  end

  # @group Playground
  # @param status text
  def playground(status: "Updated just now")
    render ::Decor::Suite::Tabs.new(
      links: [
        TabInfo.new(title: "One", href: "#one", active: true, badge_text: "4"),
        TabInfo.new(title: "Two", href: "#two"),
        TabInfo.new(title: "Three", href: "#three", badge_text: "12"),
        TabInfo.new(title: "Disabled", disabled: true)
      ],
      status: status
    )
  end
end
