# frozen_string_literal: true

# @label Card Header
class Decor::CardHeaderPreview < ViewComponent::Preview
  # @label Default
  def default
    render Decor::CardHeader.new(
      title: "Card Title",
      subtitle: "This is a subtitle for the card"
    )
  end

  # @label With Icon
  def with_icon
    render Decor::CardHeader.new(
      title: "Settings",
      subtitle: "Configure your preferences",
      icon: "cog-6-tooth"
    )
  end

  # @label With Actions
  def with_actions
    render Decor::CardHeader.new(
      title: "User Profile",
      subtitle: "Manage your account settings"
    ) do |header|
      header.with_actions do
        render Decor::Button.new(
          label: "Edit",
          size: :sm,
          style: :outlined,
          color: :primary
        )
      end
    end
  end

  # @label With Icon and Actions
  def with_icon_and_actions
    render Decor::CardHeader.new(
      title: "Project Dashboard",
      subtitle: "Overview of your current projects",
      icon: "chart-bar"
    ) do |header|
      header.with_actions do
        render Decor::Button.new(
          label: "New Project",
          size: :sm,
          color: :primary
        )
      end
    end
  end

  # @label With Meta Content
  def with_meta_content
    render Decor::CardHeader.new(
      title: "Team Members",
      subtitle: "Current team composition"
    ) do |header|
      header.with_actions do
        render Decor::Button.new(
          label: "Add Member",
          size: :sm,
          style: :outlined,
          color: :primary
        )
      end

      header.with_meta do
        render Decor::Badge.new(
          label: "5 Active",
          color: :success
        )
      end
    end
  end

  # @label Size Variants
  def size_variants
    [:xs, :sm, :md, :lg, :xl].map do |size|
      render Decor::Card.new(size: size, style: :outlined) do |card|
        card.with_header do
          render Decor::CardHeader.new(
            title: "Size #{size.to_s.upcase}",
            subtitle: "This header uses #{size} sizing",
            icon: "star",
            size: size
          ) do |header|
            header.with_actions do
              render Decor::Button.new(
                label: "Action",
                size: (size == :xl) ? :md : :sm,
                style: :outlined,
                color: :primary
              )
            end
          end
        end
      end
    end.join("\n").html_safe
  end

  # @label In Card Context
  def in_card_context
    render Decor::Card.new(style: :outlined) do |card|
      card.with_header do
        render Decor::CardHeader.new(
          title: "Notification Settings",
          subtitle: "Control how you receive notifications",
          icon: "bell"
        ) do |header|
          header.with_actions do
            render Decor::Button.new(
              label: "Configure",
              size: :sm,
              color: :primary
            )
          end
        end
      end

      # Card content
      div(class: "p-4 space-y-3") do
        div(class: "flex items-center justify-between") do
          span { "Email notifications" }
          render Decor::Toggle.new(
            property_name: "email_notifications",
            model: nil,
            url: "#",
            switch_options: {enabled: true}
          )
        end

        div(class: "flex items-center justify-between") do
          span { "Push notifications" }
          render Decor::Toggle.new(
            property_name: "push_notifications",
            model: nil,
            url: "#",
            switch_options: {enabled: false}
          )
        end
      end
    end
  end

  # @label Multiple Actions
  def multiple_actions
    render Decor::CardHeader.new(
      title: "Document Management",
      subtitle: "Organize and share your files",
      icon: "document-text"
    ) do |header|
      header.with_actions do
        render Decor::Button.new(
          label: "Upload",
          size: :sm,
          style: :outlined,
          color: :primary
        )

        render Decor::Button.new(
          label: "Share",
          size: :sm,
          style: :outlined,
          color: :secondary
        )

        render Decor::Dropdown.new(
          size: :sm,
          style: :outlined,
          color: :base
        ) do |dropdown|
          dropdown.trigger_button_content do
            render Decor::Icon.new(name: "ellipsis-vertical", size: :sm)
          end

          dropdown.menu_item(label: "Export", href: "#")
          dropdown.menu_item(label: "Archive", href: "#")
          dropdown.menu_item(label: "Delete", href: "#")
        end
      end
    end
  end
end
