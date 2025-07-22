# @label Panel
class ::Decor::PanelPreview < ::Lookbook::Preview
  # Panel
  # --------
  #
  # A simple panel component for displaying titled content sections,
  # typically used within details boxes or cards. Panels provide a clean way
  # to organize related content with an optional icon and title.
  #
  # @group Examples
  # @label Basic Panel
  def basic_panel
    render ::Decor::Panel.new(title: "Account Settings") do
      "Manage your account preferences and security settings."
    end
  end

  # @group Examples
  # @label Panel with Icon
  def panel_with_icon
    render ::Decor::Panel.new(title: "Notifications", icon: "bell") do
      content_tag :div, class: "space-y-2" do
        safe_join([
          content_tag(:p, "Email notifications: Enabled"),
          content_tag(:p, "Push notifications: Disabled"),
          content_tag(:p, "SMS alerts: Enabled")
        ])
      end
    end
  end

  # @group Examples
  # @label System Status Panel
  def system_status
    render ::Decor::Panel.new(title: "System Status", icon: "server") do
      content_tag :div, class: "space-y-2" do
        safe_join([
          content_tag(:div, class: "flex justify-between") do
            safe_join([
              content_tag(:span, "API Status:"),
              content_tag(:span, "Operational", class: "text-success font-medium")
            ])
          end,
          content_tag(:div, class: "flex justify-between") do
            safe_join([
              content_tag(:span, "Database:"),
              content_tag(:span, "Connected", class: "text-success font-medium")
            ])
          end,
          content_tag(:div, class: "flex justify-between") do
            safe_join([
              content_tag(:span, "Cache:"),
              content_tag(:span, "Active", class: "text-success font-medium")
            ])
          end,
          content_tag(:div, class: "flex justify-between") do
            safe_join([
              content_tag(:span, "Uptime:"),
              content_tag(:span, "99.9%", class: "font-medium")
            ])
          end
        ])
      end
    end
  end

  # @group Examples
  # @label Contact Information
  def contact_info
    render ::Decor::Panel.new(title: "Contact Details", icon: "mail") do
      content_tag :address, class: "space-y-1 not-italic" do
        safe_join([
          content_tag(:p, class: "font-medium") { "John Doe" },
          content_tag(:p) { "123 Main Street" },
          content_tag(:p) { "New York, NY 10001" },
          content_tag(:p, class: "mt-2") do
            safe_join([
              content_tag(:span, "Email: "),
              content_tag(:a, "john@example.com", href: "mailto:john@example.com", class: "link link-primary")
            ])
          end,
          content_tag(:p) do
            safe_join([
              content_tag(:span, "Phone: "),
              content_tag(:a, "+1 (555) 123-4567", href: "tel:+15551234567", class: "link link-primary")
            ])
          end
        ])
      end
    end
  end

  # @group Playground
  # @param title text
  # @param icon select [~, check-circle, x, check, download, play]
  # @param size [Symbol] select [~, xs, sm, md, lg, xl]
  # @param color [Symbol] select [~, base, primary, secondary, accent, neutral, success, error, warning, info]
  # @param style [Symbol] select [~, filled, outlined, ghost]
  def playground(title: "Panel Title", icon: nil, size: nil, color: nil, style: nil)
    render ::Decor::Panel.new(title: title, icon: icon, size: size, color: color, style: style) do
      "This is the panel content that appears below the title."
    end
  end

  # @group Icons
  # @label User Icon
  def icon_user
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

  # @group Icons
  # @label Settings Icon
  def icon_settings
    render ::Decor::Panel.new(title: "Preferences", icon: "cog") do
      "Configure your application preferences and defaults."
    end
  end

  # @group Icons
  # @label Check Icon
  def icon_check
    render ::Decor::Panel.new(title: "Completed Tasks", icon: "check-circle") do
      content_tag :ul, class: "space-y-1" do
        safe_join([
          content_tag(:li, "✓ Database backup completed"),
          content_tag(:li, "✓ Security scan passed"),
          content_tag(:li, "✓ Updates installed")
        ])
      end
    end
  end

  # @group Content Types
  # @label Text Content
  def content_text
    render ::Decor::Panel.new(title: "Description") do
      "This panel contains simple text content. It's perfect for descriptions, summaries, or any other textual information that needs to be displayed in a structured way."
    end
  end

  # @group Content Types
  # @label List Content
  def content_list
    render ::Decor::Panel.new(title: "Features", icon: "star") do
      content_tag :ul, class: "list-disc list-inside space-y-1" do
        safe_join([
          content_tag(:li, "Fast performance"),
          content_tag(:li, "Secure by default"),
          content_tag(:li, "Easy to customize"),
          content_tag(:li, "Mobile responsive")
        ])
      end
    end
  end

  # @group Content Types
  # @label Form Content
  def content_form
    render ::Decor::Panel.new(title: "Quick Settings", icon: "adjustments") do
      content_tag :div, class: "space-y-3" do
        safe_join([
          content_tag(:div, class: "form-control") do
            safe_join([
              content_tag(:label, "Enable notifications", class: "label"),
              content_tag(:input, nil, type: "checkbox", class: "toggle toggle-primary", checked: true)
            ])
          end,
          content_tag(:div, class: "form-control") do
            safe_join([
              content_tag(:label, "Auto-save drafts", class: "label"),
              content_tag(:input, nil, type: "checkbox", class: "toggle toggle-primary")
            ])
          end
        ])
      end
    end
  end
end
