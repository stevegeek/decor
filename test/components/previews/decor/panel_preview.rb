# frozen_string_literal: true

# @label Panel
class ::Decor::PanelPreview < ::Lookbook::Preview
  # Details Box Panel
  # --------
  #
  # A simple panel component for displaying titled content sections,
  # typically used within details boxes or cards.
  #
  # @label Playground
  # @param title text
  # @param icon select [~, check-circle, x, check, download, play]
  def playground(title: "Panel Title", icon: nil)
    render ::Decor::Panel.new(title: title, icon: icon) do
      "This is the panel content that appears below the title."
    end
  end

  # Panel with icon
  # @label With Icon
  def with_icon
    render ::Decor::Panel.new(title: "Account Information", icon: "user") do
      content_tag :div, class: "space-y-2" do
        safe_join([
          content_tag(:p, "Email: user@example.com"),
          content_tag(:p, "Status: Active"),
          content_tag(:p, "Last login: 2 hours ago")
        ])
      end
    end
  end

  # Panel without icon
  # @label Without Icon
  def without_icon
    render ::Decor::Panel.new(title: "System Status") do
      content_tag :div, class: "space-y-1" do
        safe_join([
          content_tag(:p, "All systems operational", class: "text-green-600"),
          content_tag(:p, "Uptime: 99.9%"),
          content_tag(:p, "Last updated: Just now")
        ])
      end
    end
  end
end
