# @label Dropdown
class ::Decor::Daisy::DropdownPreview < ::Lookbook::Preview
  # Dropdown
  # -------
  #
  # A dropdown is a menu that displays when a target button is clicked.
  # Now supports modern DaisyUI attributes for consistent styling.
  #
  # @group Examples
  # @label With Avatar Button
  def example_avatar_button
    render ::Decor::Daisy::Dropdown.new(
      position: :right # Example of using modern position attribute
    ) do |dropdown|
      dropdown.trigger_button_content do
        # Using a div with DaisyUI classes for the button content
        div(class: "decor:d-btn decor:d-btn-circle decor:d-btn-ghost") do
          render ::Decor::Daisy::Avatar.new(src: "/images/pic.jpg", alt: "User avatar", size: :sm)
        end
      end

      dropdown.menu_item(::Decor::Daisy::DropdownItem.new(text: "Profile", href: "#", icon_name: "user"))
      dropdown.menu_item(::Decor::Daisy::DropdownItem.new(text: "Settings", href: "#", icon_name: "cog-6-tooth"))
      dropdown.menu_item(::Decor::Daisy::DropdownItem.new(separator: true))
      dropdown.menu_item(::Decor::Daisy::DropdownItem.new(text: "Sign out", href: "#", icon_name: "arrow-right-on-rectangle"))
    end
  end

  # @group Examples
  # @label With Item Actions
  def example_item_actions
    render ::Decor::Daisy::Dropdown.new(color: :primary, style: :outlined) do |dropdown| # Example using modern attributes
      dropdown.trigger_button_content do
        plain "Actions"
        render ::Decor::Daisy::Icon.new(name: "chevron-down", html_options: {class: "decor:ml-2 decor:-mr-1 decor:h-4 decor:w-4"})
      end

      dropdown.menu_item(::Decor::Daisy::DropdownItem.new(text: "Edit", href: "#", icon_name: "pencil"))
      dropdown.menu_item(::Decor::Daisy::DropdownItem.new(text: "Duplicate", href: "#", icon_name: "document-duplicate"))
      dropdown.menu_item(::Decor::Daisy::DropdownItem.new(separator: true))
      dropdown.menu_item(::Decor::Daisy::DropdownItem.new(text: "Archive", href: "#", icon_name: "archive-box"))
      dropdown.menu_item(::Decor::Daisy::DropdownItem.new(text: "Delete", href: "#", icon_name: "trash", http_method: :delete))
    end
  end

  # @group Examples
  # @label With Header
  def example_with_header
    render ::Decor::Daisy::Dropdown.new(color: :secondary) do |dropdown| # Example using modern attributes
      dropdown.trigger_button_content do
        plain "User Menu"
        render ::Decor::Daisy::Icon.new(name: "chevron-down", html_options: {class: "decor:ml-2 decor:-mr-1 decor:h-4 decor:w-4"})
      end

      dropdown.menu_header do
        div(class: "decor:px-4 decor:py-3 decor:border-b decor:border-base-200") do # DaisyUI classes for header
          p(class: "decor:text-sm decor:font-medium") { "John Doe" }
          p(class: "decor:text-sm decor:opacity-70") { "john@example.com" }
        end
      end

      dropdown.menu_item(::Decor::Daisy::DropdownItem.new(text: "Your Profile", href: "#", icon_name: "user"))
      dropdown.menu_item(::Decor::Daisy::DropdownItem.new(text: "Settings", href: "#", icon_name: "cog-6-tooth"))
      dropdown.menu_item(::Decor::Daisy::DropdownItem.new(text: "Billing", href: "#", icon_name: "credit-card"))
      dropdown.menu_item(::Decor::Daisy::DropdownItem.new(separator: true))
      dropdown.menu_item(::Decor::Daisy::DropdownItem.new(text: "Sign out", href: "#", icon_name: "arrow-right-on-rectangle"))
    end
  end

  # @group Examples
  # @label Custom Button
  def example_custom_button
    render ::Decor::Daisy::Dropdown.new do |dropdown|
      dropdown.trigger_button do
        # Custom button can still be used, ensure it has necessary DaisyUI classes or your own styling
        button(
          type: "button",
          class: "decor:d-btn decor:d-btn-accent" # Example DaisyUI classes
        ) do
          plain "Custom Button"
          render ::Decor::Daisy::Icon.new(name: "chevron-down", html_options: {class: "decor:ml-2 decor:-mr-1 decor:h-4 decor:w-4"})
        end
      end

      dropdown.menu_item(::Decor::Daisy::DropdownItem.new(text: "Option 1", href: "#"))
      dropdown.menu_item(::Decor::Daisy::DropdownItem.new(text: "Option 2", href: "#"))
      dropdown.menu_item(::Decor::Daisy::DropdownItem.new(text: "Option 3", href: "#"))
    end
  end

  # @group Playground
  # @param size [Symbol] select [~, xs, sm, md, lg, xl]
  # @param color [Symbol] select [~, base, primary, secondary, accent, neutral, success, error, warning, info]
  # @param style [Symbol] select [~, filled, outlined]
  # @param position select [Symbol] [left, right, top, bottom, end, center, start]
  # @param trigger select [Symbol] [click, hover, focus]
  # @param force_open select [Symbol] [auto, open, closed]
  # @param button_active_classes text
  def playground(size: nil, color: nil, style: nil, position: :left, trigger: :click, force_open: :auto, button_active_classes: [])
    render ::Decor::Daisy::Dropdown.new(
      size: size,
      color: color,
      style: style,
      position: position,
      trigger: trigger,
      force_open: force_open,
      button_active_classes: button_active_classes
    ) do |dropdown|
      dropdown.trigger_button_content do
        "Options"
      end

      dropdown.menu_item(::Decor::Daisy::DropdownItem.new(text: "Menu Item 1", href: "#"))
      dropdown.menu_item(::Decor::Daisy::DropdownItem.new(text: "Menu Item 2", href: "#"))
      dropdown.menu_item(::Decor::Daisy::DropdownItem.new(text: "Menu Item 3", href: "#"))
    end
  end

  # @group Sizes
  # @label XS Size
  def size_xs
    render ::Decor::Daisy::Dropdown.new(size: :xs, color: :primary) do |dropdown|
      dropdown.trigger_button_content { "XS Button" }
      dropdown.menu_item(::Decor::Daisy::DropdownItem.new(text: "Menu Item 1", href: "#"))
      dropdown.menu_item(::Decor::Daisy::DropdownItem.new(text: "Menu Item 2", href: "#"))
    end
  end

  # @group Sizes
  # @label SM Size
  def size_sm
    render ::Decor::Daisy::Dropdown.new(size: :sm, color: :primary) do |dropdown|
      dropdown.trigger_button_content { "SM Button" }
      dropdown.menu_item(::Decor::Daisy::DropdownItem.new(text: "Menu Item 1", href: "#"))
      dropdown.menu_item(::Decor::Daisy::DropdownItem.new(text: "Menu Item 2", href: "#"))
    end
  end

  # @group Sizes
  # @label MD Size (Default)
  def size_md
    render ::Decor::Daisy::Dropdown.new(size: :md, color: :primary) do |dropdown|
      dropdown.trigger_button_content { "MD Button" }
      dropdown.menu_item(::Decor::Daisy::DropdownItem.new(text: "Menu Item 1", href: "#"))
      dropdown.menu_item(::Decor::Daisy::DropdownItem.new(text: "Menu Item 2", href: "#"))
    end
  end

  # @group Sizes
  # @label LG Size
  def size_lg
    render ::Decor::Daisy::Dropdown.new(size: :lg, color: :primary) do |dropdown|
      dropdown.trigger_button_content { "LG Button" }
      dropdown.menu_item(::Decor::Daisy::DropdownItem.new(text: "Menu Item 1", href: "#"))
      dropdown.menu_item(::Decor::Daisy::DropdownItem.new(text: "Menu Item 2", href: "#"))
    end
  end

  # @group Sizes
  # @label XL Size
  def size_xl
    render ::Decor::Daisy::Dropdown.new(size: :xl, color: :primary) do |dropdown|
      dropdown.trigger_button_content { "XL Button" }
      dropdown.menu_item(::Decor::Daisy::DropdownItem.new(text: "Menu Item 1", href: "#"))
      dropdown.menu_item(::Decor::Daisy::DropdownItem.new(text: "Menu Item 2", href: "#"))
    end
  end

  # @group Colors
  # @label Primary Color
  def color_primary
    render ::Decor::Daisy::Dropdown.new(color: :primary) do |dropdown|
      dropdown.trigger_button_content { "Primary" }
      dropdown.menu_item(::Decor::Daisy::DropdownItem.new(text: "Menu Item 1", href: "#"))
      dropdown.menu_item(::Decor::Daisy::DropdownItem.new(text: "Menu Item 2", href: "#"))
    end
  end

  # @group Colors
  # @label Secondary Color
  def color_secondary
    render ::Decor::Daisy::Dropdown.new(color: :secondary) do |dropdown|
      dropdown.trigger_button_content { "Secondary" }
      dropdown.menu_item(::Decor::Daisy::DropdownItem.new(text: "Menu Item 1", href: "#"))
      dropdown.menu_item(::Decor::Daisy::DropdownItem.new(text: "Menu Item 2", href: "#"))
    end
  end

  # @group Colors
  # @label Accent Color
  def color_accent
    render ::Decor::Daisy::Dropdown.new(color: :accent) do |dropdown|
      dropdown.trigger_button_content { "Accent" }
      dropdown.menu_item(::Decor::Daisy::DropdownItem.new(text: "Menu Item 1", href: "#"))
      dropdown.menu_item(::Decor::Daisy::DropdownItem.new(text: "Menu Item 2", href: "#"))
    end
  end

  # @group Colors
  # @label Success Color
  def color_success
    render ::Decor::Daisy::Dropdown.new(color: :success) do |dropdown|
      dropdown.trigger_button_content { "Success" }
      dropdown.menu_item(::Decor::Daisy::DropdownItem.new(text: "Menu Item 1", href: "#"))
      dropdown.menu_item(::Decor::Daisy::DropdownItem.new(text: "Menu Item 2", href: "#"))
    end
  end

  # @group Colors
  # @label Error Color
  def color_error
    render ::Decor::Daisy::Dropdown.new(color: :error) do |dropdown|
      dropdown.trigger_button_content { "Error" }
      dropdown.menu_item(::Decor::Daisy::DropdownItem.new(text: "Menu Item 1", href: "#"))
      dropdown.menu_item(::Decor::Daisy::DropdownItem.new(text: "Menu Item 2", href: "#"))
    end
  end

  # @group Colors
  # @label Warning Color
  def color_warning
    render ::Decor::Daisy::Dropdown.new(color: :warning) do |dropdown|
      dropdown.trigger_button_content { "Warning" }
      dropdown.menu_item(::Decor::Daisy::DropdownItem.new(text: "Menu Item 1", href: "#"))
      dropdown.menu_item(::Decor::Daisy::DropdownItem.new(text: "Menu Item 2", href: "#"))
    end
  end

  # @group Colors
  # @label Info Color
  def color_info
    render ::Decor::Daisy::Dropdown.new(color: :info) do |dropdown|
      dropdown.trigger_button_content { "Info" }
      dropdown.menu_item(::Decor::Daisy::DropdownItem.new(text: "Menu Item 1", href: "#"))
      dropdown.menu_item(::Decor::Daisy::DropdownItem.new(text: "Menu Item 2", href: "#"))
    end
  end

  # @group Colors
  # @label Neutral Color
  def color_neutral
    render ::Decor::Daisy::Dropdown.new(color: :neutral) do |dropdown|
      dropdown.trigger_button_content { "Neutral" }
      dropdown.menu_item(::Decor::Daisy::DropdownItem.new(text: "Menu Item 1", href: "#"))
      dropdown.menu_item(::Decor::Daisy::DropdownItem.new(text: "Menu Item 2", href: "#"))
    end
  end

  # @group Styles
  # @label Filled Style
  def style_filled
    render ::Decor::Daisy::Dropdown.new(style: :filled, color: :primary) do |dropdown|
      dropdown.trigger_button_content { "Filled Style" }
      dropdown.menu_item(::Decor::Daisy::DropdownItem.new(text: "Menu Item 1", href: "#"))
      dropdown.menu_item(::Decor::Daisy::DropdownItem.new(text: "Menu Item 2", href: "#"))
    end
  end

  # @group Styles
  # @label Outlined Style
  def style_outlined
    render ::Decor::Daisy::Dropdown.new(style: :outlined, color: :primary) do |dropdown|
      dropdown.trigger_button_content { "Outlined Style" }
      dropdown.menu_item(::Decor::Daisy::DropdownItem.new(text: "Menu Item 1", href: "#"))
      dropdown.menu_item(::Decor::Daisy::DropdownItem.new(text: "Menu Item 2", href: "#"))
    end
  end

  # @group Positions
  # @label Left Position (Default)
  def position_left
    render ::Decor::Daisy::Dropdown.new(position: :left, color: :accent) do |dropdown|
      dropdown.trigger_button_content { "Left Position" }
      dropdown.menu_item(::Decor::Daisy::DropdownItem.new(text: "Menu Item 1", href: "#"))
      dropdown.menu_item(::Decor::Daisy::DropdownItem.new(text: "Menu Item 2", href: "#"))
    end
  end

  # @group Positions
  # @label Right Position
  def position_right
    render ::Decor::Daisy::Dropdown.new(position: :right, color: :accent) do |dropdown|
      dropdown.trigger_button_content { "Right Position" }
      dropdown.menu_item(::Decor::Daisy::DropdownItem.new(text: "Menu Item 1", href: "#"))
      dropdown.menu_item(::Decor::Daisy::DropdownItem.new(text: "Menu Item 2", href: "#"))
    end
  end

  # @group Positions
  # @label Top Position
  def position_top
    render ::Decor::Daisy::Dropdown.new(position: :top, color: :accent) do |dropdown|
      dropdown.trigger_button_content { "Top Position" }
      dropdown.menu_item(::Decor::Daisy::DropdownItem.new(text: "Menu Item 1", href: "#"))
      dropdown.menu_item(::Decor::Daisy::DropdownItem.new(text: "Menu Item 2", href: "#"))
    end
  end

  # @group Positions
  # @label Bottom Position
  def position_bottom
    render ::Decor::Daisy::Dropdown.new(position: :bottom, color: :accent) do |dropdown|
      dropdown.trigger_button_content { "Bottom Position" }
      dropdown.menu_item(::Decor::Daisy::DropdownItem.new(text: "Menu Item 1", href: "#"))
      dropdown.menu_item(::Decor::Daisy::DropdownItem.new(text: "Menu Item 2", href: "#"))
    end
  end

  # @group Positions
  # @label End Position
  def position_end
    render ::Decor::Daisy::Dropdown.new(position: :end, color: :accent) do |dropdown|
      dropdown.trigger_button_content { "End Position" }
      dropdown.menu_item(::Decor::Daisy::DropdownItem.new(text: "Menu Item 1", href: "#"))
      dropdown.menu_item(::Decor::Daisy::DropdownItem.new(text: "Menu Item 2", href: "#"))
    end
  end

  # @group Positions
  # @label Center Position
  def position_center
    render ::Decor::Daisy::Dropdown.new(position: :center, color: :accent) do |dropdown|
      dropdown.trigger_button_content { "Center Position" }
      dropdown.menu_item(::Decor::Daisy::DropdownItem.new(text: "Menu Item 1", href: "#"))
      dropdown.menu_item(::Decor::Daisy::DropdownItem.new(text: "Menu Item 2", href: "#"))
    end
  end

  # @group Positions
  # @label Start Position
  def position_start
    render ::Decor::Daisy::Dropdown.new(position: :start, color: :accent) do |dropdown|
      dropdown.trigger_button_content { "Start Position" }
      dropdown.menu_item(::Decor::Daisy::DropdownItem.new(text: "Menu Item 1", href: "#"))
      dropdown.menu_item(::Decor::Daisy::DropdownItem.new(text: "Menu Item 2", href: "#"))
    end
  end

  # @group Examples
  # @label Modern User Profile
  def example_user_profile
    render ::Decor::Daisy::Dropdown.new(
      position: :end,
      color: :primary,
      style: :outlined
    ) do |dropdown|
      dropdown.trigger_button_content do
        div(class: "decor:flex decor:items-center decor:gap-2") do
          render ::Decor::Daisy::Avatar.new(src: "/images/pic.jpg", alt: "User avatar", size: :sm)
          span(class: "decor:hidden decor:sm:inline") { "John Doe" }
        end
      end

      dropdown.menu_header do
        div(class: "decor:px-4 decor:py-3 decor:border-b decor:border-base-200") do
          p(class: "decor:text-sm decor:font-medium") { "John Doe" }
          p(class: "decor:text-sm decor:opacity-70") { "john@example.com" }
        end
      end

      dropdown.menu_item(::Decor::Daisy::DropdownItem.new(text: "Profile", href: "#", icon_name: "user"))
      dropdown.menu_item(::Decor::Daisy::DropdownItem.new(text: "Settings", href: "#", icon_name: "cog-6-tooth"))
      dropdown.menu_item(::Decor::Daisy::DropdownItem.new(text: "Billing", href: "#", icon_name: "credit-card"))
      dropdown.menu_item(::Decor::Daisy::DropdownItem.new(separator: true))
      dropdown.menu_item(::Decor::Daisy::DropdownItem.new(text: "Sign out", href: "#", icon_name: "arrow-right-on-rectangle"))
    end
  end

  # @group Examples
  # @label Large Menu
  def example_large_menu
    render ::Decor::Daisy::Dropdown.new(
      size: :lg,
      color: :secondary,
      style: :filled
    ) do |dropdown|
      dropdown.trigger_button_content do
        div(class: "decor:flex decor:items-center decor:gap-2") do
          render ::Decor::Daisy::Icon.new(name: "ellipsis-vertical", html_options: {class: "decor:h-5 decor:w-5"})
          span { "Actions" }
        end
      end

      dropdown.menu_item(::Decor::Daisy::DropdownItem.new(text: "Edit", href: "#", icon_name: "pencil"))
      dropdown.menu_item(::Decor::Daisy::DropdownItem.new(text: "Duplicate", href: "#", icon_name: "document-duplicate"))
      dropdown.menu_item(::Decor::Daisy::DropdownItem.new(text: "Share", href: "#", icon_name: "share"))
      dropdown.menu_item(::Decor::Daisy::DropdownItem.new(separator: true))
      dropdown.menu_item(::Decor::Daisy::DropdownItem.new(text: "Move to folder", href: "#", icon_name: "folder"))
      dropdown.menu_item(::Decor::Daisy::DropdownItem.new(text: "Download", href: "#", icon_name: "arrow-down-tray"))
      dropdown.menu_item(::Decor::Daisy::DropdownItem.new(separator: true))
      dropdown.menu_item(::Decor::Daisy::DropdownItem.new(text: "Archive", href: "#", icon_name: "archive-box"))
      dropdown.menu_item(::Decor::Daisy::DropdownItem.new(text: "Delete", href: "#", icon_name: "trash", http_method: :delete))
    end
  end

  # @group Trigger Modes
  # @label Click Trigger (Default)
  def trigger_click
    render ::Decor::Daisy::Dropdown.new(trigger: :click, color: :primary) do |dropdown|
      dropdown.trigger_button_content { "Click to Open" }
      dropdown.menu_item(::Decor::Daisy::DropdownItem.new(text: "Menu Item 1", href: "#"))
      dropdown.menu_item(::Decor::Daisy::DropdownItem.new(text: "Menu Item 2", href: "#"))
    end
  end

  # @group Trigger Modes
  # @label Hover Trigger
  def trigger_hover
    render ::Decor::Daisy::Dropdown.new(trigger: :hover, color: :secondary) do |dropdown|
      dropdown.trigger_button_content { "Hover to Open" }
      dropdown.menu_item(::Decor::Daisy::DropdownItem.new(text: "Menu Item 1", href: "#"))
      dropdown.menu_item(::Decor::Daisy::DropdownItem.new(text: "Menu Item 2", href: "#"))
    end
  end

  # @group Trigger Modes
  # @label Focus Trigger
  def trigger_focus
    render ::Decor::Daisy::Dropdown.new(trigger: :focus, color: :accent) do |dropdown|
      dropdown.trigger_button_content { "Focus to Open" }
      dropdown.menu_item(::Decor::Daisy::DropdownItem.new(text: "Menu Item 1", href: "#"))
      dropdown.menu_item(::Decor::Daisy::DropdownItem.new(text: "Menu Item 2", href: "#"))
    end
  end

  # @group Force States
  # @label Force Open
  def force_open
    render ::Decor::Daisy::Dropdown.new(force_open: :open, color: :info) do |dropdown|
      dropdown.trigger_button_content { "Always Open" }
      dropdown.menu_item(::Decor::Daisy::DropdownItem.new(text: "Menu Item 1", href: "#"))
      dropdown.menu_item(::Decor::Daisy::DropdownItem.new(text: "Menu Item 2", href: "#"))
    end
  end

  # @group Card Content
  # @label Simple Card
  def card_simple
    render ::Decor::Daisy::Dropdown.new(
      color: :primary,
      position: :end
    ) do |dropdown|
      dropdown.trigger_button_content { "Card Dropdown" }

      dropdown.card_content do
        div(class: "decor:d-card decor:d-card-compact decor:w-64 decor:bg-base-100 decor:shadow") do
          div(class: "decor:d-card-body") do
            h3(class: "decor:d-card-title") { "Card Title" }
            p { "This is card content inside a dropdown. Cards can contain any content you need." }
            div(class: "decor:d-card-actions decor:justify-end") do
              button(class: "decor:d-btn decor:d-btn-primary decor:d-btn-sm") { "Action" }
            end
          end
        end
      end
    end
  end

  # @group Card Content
  # @label Profile Card
  def card_profile
    render ::Decor::Daisy::Dropdown.new(
      color: :secondary,
      position: :end,
      trigger: :hover
    ) do |dropdown|
      dropdown.trigger_button_content do
        div(class: "decor:flex decor:items-center decor:gap-2") do
          div(class: "decor:d-avatar") do
            div(class: "decor:w-8 decor:rounded-full") do
              img(src: "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=32&h=32&fit=crop&crop=face", alt: "User")
            end
          end
          span { "Profile" }
        end
      end

      dropdown.card_content do
        div(class: "decor:d-card decor:d-card-compact decor:w-80 decor:bg-base-100 decor:shadow-xl") do
          figure do
            img(src: "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=320&h=160&fit=crop", alt: "Profile banner", class: "decor:h-20 decor:w-full decor:object-cover")
          end
          div(class: "decor:d-card-body") do
            div(class: "decor:flex decor:items-center decor:gap-3") do
              div(class: "decor:d-avatar") do
                div(class: "decor:w-12 decor:rounded-full") do
                  img(src: "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=48&h=48&fit=crop&crop=face", alt: "User")
                end
              end
              div do
                h3(class: "decor:d-card-title decor:text-sm") { "Sarah Johnson" }
                p(class: "decor:text-sm decor:opacity-60") { "Product Designer" }
              end
            end
            p(class: "decor:text-sm decor:mt-2") { "Passionate about creating beautiful and functional user experiences." }
            div(class: "decor:d-card-actions decor:justify-between decor:mt-4") do
              button(class: "decor:d-btn decor:d-btn-ghost decor:d-btn-sm") { "View Profile" }
              button(class: "decor:d-btn decor:d-btn-primary decor:d-btn-sm") { "Message" }
            end
          end
        end
      end
    end
  end

  # @group Card Content
  # @label Notification Card
  def card_notifications
    render ::Decor::Daisy::Dropdown.new(
      color: :info,
      position: :end
    ) do |dropdown|
      dropdown.trigger_button_content do
        div(class: "decor:flex decor:items-center decor:gap-2") do
          render ::Decor::Daisy::Icon.new(name: "bell", html_options: {class: "decor:h-5 decor:w-5"})
          span(class: "decor:d-badge decor:d-badge-error decor:d-badge-sm") { "3" }
        end
      end

      dropdown.card_content do
        div(class: "decor:d-card decor:d-card-compact decor:w-96 decor:bg-base-100 decor:shadow-xl") do
          div(class: "decor:d-card-body") do
            h3(class: "decor:d-card-title decor:text-base") { "Notifications" }

            div(class: "decor:d-divider decor:my-2") {}

            div(class: "decor:space-y-3") do
              [
                {title: "New message from John", time: "2 min ago", type: "message"},
                {title: "Task deadline approaching", time: "1 hour ago", type: "warning"},
                {title: "Project completed successfully", time: "3 hours ago", type: "success"}
              ].each do |notification|
                div(class: "decor:flex decor:items-start decor:gap-3 decor:p-2 decor:rounded-lg decor:hover:bg-base-200") do
                  div(class: "decor:flex-shrink-0 decor:mt-1") do
                    case notification[:type]
                    when "message"
                      render ::Decor::Daisy::Icon.new(name: "envelope", html_options: {class: "decor:h-4 decor:w-4 decor:text-info"})
                    when "warning"
                      render ::Decor::Daisy::Icon.new(name: "exclamation-triangle", html_options: {class: "decor:h-4 decor:w-4 decor:text-warning"})
                    when "success"
                      render ::Decor::Daisy::Icon.new(name: "check-circle", html_options: {class: "decor:h-4 decor:w-4 decor:text-success"})
                    end
                  end
                  div(class: "decor:flex-1 decor:min-w-0") do
                    p(class: "decor:text-sm decor:font-medium") { notification[:title] }
                    p(class: "decor:text-xs decor:opacity-60") { notification[:time] }
                  end
                end
              end
            end

            div(class: "decor:d-card-actions decor:justify-end decor:mt-4") do
              button(class: "decor:d-btn decor:d-btn-ghost decor:d-btn-sm") { "Mark all read" }
              button(class: "decor:d-btn decor:d-btn-primary decor:d-btn-sm") { "View all" }
            end
          end
        end
      end
    end
  end

  # @group Examples
  # @label Custom HTML Content
  def custom_content_example
    render ::Decor::Daisy::Dropdown.new(
      color: :accent,
      position: :center
    ) do |dropdown|
      dropdown.trigger_button_content { "Custom Content" }

      dropdown.custom_content do
        div(class: "decor:p-6 decor:bg-base-100 decor:rounded-box decor:shadow decor:w-80") do
          h3(class: "decor:text-lg decor:font-semibold decor:mb-4") { "Custom Dropdown Content" }

          div(class: "decor:form-control") do
            label(class: "decor:d-label") do
              span(class: "decor:d-label-text") { "Quick Search" }
            end
            input(type: "text", class: "decor:d-input decor:d-input-bordered decor:w-full", placeholder: "Type to search...")
          end

          div(class: "decor:mt-4") do
            h4(class: "decor:font-medium decor:mb-2") { "Recent Items" }
            div(class: "decor:space-y-1") do
              %w[Documents Photos Videos Music].each do |item|
                div(class: "decor:flex decor:items-center decor:justify-between decor:p-2 decor:rounded decor:hover:bg-base-200") do
                  span(class: "decor:text-sm") { item }
                  render ::Decor::Daisy::Icon.new(name: "chevron-right", html_options: {class: "decor:h-4 decor:w-4 decor:opacity-50"})
                end
              end
            end
          end

          div(class: "decor:mt-4 decor:pt-4 decor:border-t decor:border-base-300") do
            button(class: "decor:d-btn decor:d-btn-accent decor:d-btn-block decor:d-btn-sm") { "View All Items" }
          end
        end
      end
    end
  end
end
