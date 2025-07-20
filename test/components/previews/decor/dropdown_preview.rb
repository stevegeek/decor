# @label Dropdown
class ::Decor::DropdownPreview < ::Lookbook::Preview
  # Dropdown
  # -------
  #
  # A dropdown is a menu that displays when a target button is clicked.
  # Now supports modern DaisyUI attributes for consistent styling.
  #
  # @label Playground
  # @param size select [xs, sm, md, lg, xl]
  # @param color select [base, primary, secondary, accent, success, error, warning, info, neutral]
  # @param variant select [default, bordered, filled]
  # @param position select [left, right, top, bottom, end, center, start]
  # @param trigger select [click, hover, focus] "Interaction mode"
  # @param force_open select [auto, open, closed] "Force open/closed state"
  # @param button_active_classes [Array] text "Legacy button classes (for backward compatibility)"
  def playground(size: :md, color: :base, variant: :default, position: :left, trigger: :click, force_open: :auto, button_active_classes: [])
    render ::Decor::Dropdown.new(
      size: size,
      color: color,
      variant: variant,
      position: position,
      trigger: trigger,
      force_open: force_open,
      button_active_classes: button_active_classes
    ) do |dropdown|
      dropdown.trigger_button_content do
        "Options"
      end

      dropdown.menu_item(::Decor::DropdownItem.new(text: "Menu Item 1", href: "#"))
      dropdown.menu_item(::Decor::DropdownItem.new(text: "Menu Item 2", href: "#"))
      dropdown.menu_item(::Decor::DropdownItem.new(text: "Menu Item 3", href: "#"))
    end
  end

  # @group Examples
  # @label With Avatar Button
  def example_avatar_button
    render ::Decor::Dropdown.new(
      position: :right # Example of using modern position attribute
    ) do |dropdown|
      dropdown.trigger_button_content do
        # Using a div with DaisyUI classes for the button content
        div(class: "btn btn-circle btn-ghost") do
          render ::Decor::Avatar.new(src: "/images/pic.jpg", alt: "User avatar", size: :sm)
        end
      end

      dropdown.menu_item(::Decor::DropdownItem.new(text: "Profile", href: "#", icon_name: "user"))
      dropdown.menu_item(::Decor::DropdownItem.new(text: "Settings", href: "#", icon_name: "cog-6-tooth"))
      dropdown.menu_item(::Decor::DropdownItem.new(separator: true))
      dropdown.menu_item(::Decor::DropdownItem.new(text: "Sign out", href: "#", icon_name: "arrow-right-on-rectangle"))
    end
  end

  # @group Examples
  # @label With Item Actions
  def example_item_actions
    render ::Decor::Dropdown.new(color: :primary, variant: :bordered) do |dropdown| # Example using modern attributes
      dropdown.trigger_button_content do
        plain "Actions"
        render ::Decor::Icon.new(name: "chevron-down", html_options: {class: "ml-2 -mr-1 h-4 w-4"})
      end

      dropdown.menu_item(::Decor::DropdownItem.new(text: "Edit", href: "#", icon_name: "pencil"))
      dropdown.menu_item(::Decor::DropdownItem.new(text: "Duplicate", href: "#", icon_name: "document-duplicate"))
      dropdown.menu_item(::Decor::DropdownItem.new(separator: true))
      dropdown.menu_item(::Decor::DropdownItem.new(text: "Archive", href: "#", icon_name: "archive-box"))
      dropdown.menu_item(::Decor::DropdownItem.new(text: "Delete", href: "#", icon_name: "trash", http_method: :delete))
    end
  end

  # @group Examples
  # @label With Header
  def example_with_header
    render ::Decor::Dropdown.new(color: :secondary) do |dropdown| # Example using modern attributes
      dropdown.trigger_button_content do
        plain "User Menu"
        render ::Decor::Icon.new(name: "chevron-down", html_options: {class: "ml-2 -mr-1 h-4 w-4"})
      end

      dropdown.menu_header do
        div(class: "px-4 py-3 border-b border-base-200") do # DaisyUI classes for header
          p(class: "text-sm font-medium") { "John Doe" }
          p(class: "text-sm opacity-70") { "john@example.com" }
        end
      end

      dropdown.menu_item(::Decor::DropdownItem.new(text: "Your Profile", href: "#", icon_name: "user"))
      dropdown.menu_item(::Decor::DropdownItem.new(text: "Settings", href: "#", icon_name: "cog-6-tooth"))
      dropdown.menu_item(::Decor::DropdownItem.new(text: "Billing", href: "#", icon_name: "credit-card"))
      dropdown.menu_item(::Decor::DropdownItem.new(separator: true))
      dropdown.menu_item(::Decor::DropdownItem.new(text: "Sign out", href: "#", icon_name: "arrow-right-on-rectangle"))
    end
  end

  # @group Examples
  # @label Custom Button
  def example_custom_button
    render ::Decor::Dropdown.new do |dropdown|
      dropdown.trigger_button do
        # Custom button can still be used, ensure it has necessary DaisyUI classes or your own styling
        button(
          type: "button",
          class: "btn btn-accent" # Example DaisyUI classes
        ) do
          plain "Custom Button"
          render ::Decor::Icon.new(name: "chevron-down", html_options: {class: "ml-2 -mr-1 h-4 w-4"})
        end
      end

      dropdown.menu_item(::Decor::DropdownItem.new(text: "Option 1", href: "#"))
      dropdown.menu_item(::Decor::DropdownItem.new(text: "Option 2", href: "#"))
      dropdown.menu_item(::Decor::DropdownItem.new(text: "Option 3", href: "#"))
    end
  end

  # @group Sizes
  # @label XS Size
  def size_xs
    render ::Decor::Dropdown.new(size: :xs, color: :primary) do |dropdown|
      dropdown.trigger_button_content { "XS Button" }
      dropdown.menu_item(::Decor::DropdownItem.new(text: "Menu Item 1", href: "#"))
      dropdown.menu_item(::Decor::DropdownItem.new(text: "Menu Item 2", href: "#"))
    end
  end

  # @group Sizes
  # @label SM Size
  def size_sm
    render ::Decor::Dropdown.new(size: :sm, color: :primary) do |dropdown|
      dropdown.trigger_button_content { "SM Button" }
      dropdown.menu_item(::Decor::DropdownItem.new(text: "Menu Item 1", href: "#"))
      dropdown.menu_item(::Decor::DropdownItem.new(text: "Menu Item 2", href: "#"))
    end
  end

  # @group Sizes
  # @label MD Size (Default)
  def size_md
    render ::Decor::Dropdown.new(size: :md, color: :primary) do |dropdown|
      dropdown.trigger_button_content { "MD Button" }
      dropdown.menu_item(::Decor::DropdownItem.new(text: "Menu Item 1", href: "#"))
      dropdown.menu_item(::Decor::DropdownItem.new(text: "Menu Item 2", href: "#"))
    end
  end

  # @group Sizes
  # @label LG Size
  def size_lg
    render ::Decor::Dropdown.new(size: :lg, color: :primary) do |dropdown|
      dropdown.trigger_button_content { "LG Button" }
      dropdown.menu_item(::Decor::DropdownItem.new(text: "Menu Item 1", href: "#"))
      dropdown.menu_item(::Decor::DropdownItem.new(text: "Menu Item 2", href: "#"))
    end
  end

  # @group Sizes
  # @label XL Size
  def size_xl
    render ::Decor::Dropdown.new(size: :xl, color: :primary) do |dropdown|
      dropdown.trigger_button_content { "XL Button" }
      dropdown.menu_item(::Decor::DropdownItem.new(text: "Menu Item 1", href: "#"))
      dropdown.menu_item(::Decor::DropdownItem.new(text: "Menu Item 2", href: "#"))
    end
  end

  # @group Colors
  # @label Primary Color
  def color_primary
    render ::Decor::Dropdown.new(color: :primary) do |dropdown|
      dropdown.trigger_button_content { "Primary" }
      dropdown.menu_item(::Decor::DropdownItem.new(text: "Menu Item 1", href: "#"))
      dropdown.menu_item(::Decor::DropdownItem.new(text: "Menu Item 2", href: "#"))
    end
  end

  # @group Colors
  # @label Secondary Color
  def color_secondary
    render ::Decor::Dropdown.new(color: :secondary) do |dropdown|
      dropdown.trigger_button_content { "Secondary" }
      dropdown.menu_item(::Decor::DropdownItem.new(text: "Menu Item 1", href: "#"))
      dropdown.menu_item(::Decor::DropdownItem.new(text: "Menu Item 2", href: "#"))
    end
  end

  # @group Colors
  # @label Accent Color
  def color_accent
    render ::Decor::Dropdown.new(color: :accent) do |dropdown|
      dropdown.trigger_button_content { "Accent" }
      dropdown.menu_item(::Decor::DropdownItem.new(text: "Menu Item 1", href: "#"))
      dropdown.menu_item(::Decor::DropdownItem.new(text: "Menu Item 2", href: "#"))
    end
  end

  # @group Colors
  # @label Success Color
  def color_success
    render ::Decor::Dropdown.new(color: :success) do |dropdown|
      dropdown.trigger_button_content { "Success" }
      dropdown.menu_item(::Decor::DropdownItem.new(text: "Menu Item 1", href: "#"))
      dropdown.menu_item(::Decor::DropdownItem.new(text: "Menu Item 2", href: "#"))
    end
  end

  # @group Colors
  # @label Error Color
  def color_error
    render ::Decor::Dropdown.new(color: :error) do |dropdown|
      dropdown.trigger_button_content { "Error" }
      dropdown.menu_item(::Decor::DropdownItem.new(text: "Menu Item 1", href: "#"))
      dropdown.menu_item(::Decor::DropdownItem.new(text: "Menu Item 2", href: "#"))
    end
  end

  # @group Colors
  # @label Warning Color
  def color_warning
    render ::Decor::Dropdown.new(color: :warning) do |dropdown|
      dropdown.trigger_button_content { "Warning" }
      dropdown.menu_item(::Decor::DropdownItem.new(text: "Menu Item 1", href: "#"))
      dropdown.menu_item(::Decor::DropdownItem.new(text: "Menu Item 2", href: "#"))
    end
  end

  # @group Colors
  # @label Info Color
  def color_info
    render ::Decor::Dropdown.new(color: :info) do |dropdown|
      dropdown.trigger_button_content { "Info" }
      dropdown.menu_item(::Decor::DropdownItem.new(text: "Menu Item 1", href: "#"))
      dropdown.menu_item(::Decor::DropdownItem.new(text: "Menu Item 2", href: "#"))
    end
  end

  # @group Colors
  # @label Neutral Color
  def color_neutral
    render ::Decor::Dropdown.new(color: :neutral) do |dropdown|
      dropdown.trigger_button_content { "Neutral" }
      dropdown.menu_item(::Decor::DropdownItem.new(text: "Menu Item 1", href: "#"))
      dropdown.menu_item(::Decor::DropdownItem.new(text: "Menu Item 2", href: "#"))
    end
  end

  # @group Variants
  # @label Default Variant
  def variant_default
    render ::Decor::Dropdown.new(variant: :default, color: :primary) do |dropdown|
      dropdown.trigger_button_content { "Default Style" }
      dropdown.menu_item(::Decor::DropdownItem.new(text: "Menu Item 1", href: "#"))
      dropdown.menu_item(::Decor::DropdownItem.new(text: "Menu Item 2", href: "#"))
    end
  end

  # @group Variants
  # @label Bordered Variant
  def variant_bordered
    render ::Decor::Dropdown.new(variant: :bordered, color: :primary) do |dropdown|
      dropdown.trigger_button_content { "Bordered Style" }
      dropdown.menu_item(::Decor::DropdownItem.new(text: "Menu Item 1", href: "#"))
      dropdown.menu_item(::Decor::DropdownItem.new(text: "Menu Item 2", href: "#"))
    end
  end

  # @group Variants
  # @label Filled Variant
  def variant_filled
    render ::Decor::Dropdown.new(variant: :filled, color: :primary) do |dropdown|
      dropdown.trigger_button_content { "Filled Style" }
      dropdown.menu_item(::Decor::DropdownItem.new(text: "Menu Item 1", href: "#"))
      dropdown.menu_item(::Decor::DropdownItem.new(text: "Menu Item 2", href: "#"))
    end
  end

  # @group Positions
  # @label Left Position (Default)
  def position_left
    render ::Decor::Dropdown.new(position: :left, color: :accent) do |dropdown|
      dropdown.trigger_button_content { "Left Position" }
      dropdown.menu_item(::Decor::DropdownItem.new(text: "Menu Item 1", href: "#"))
      dropdown.menu_item(::Decor::DropdownItem.new(text: "Menu Item 2", href: "#"))
    end
  end

  # @group Positions
  # @label Right Position
  def position_right
    render ::Decor::Dropdown.new(position: :right, color: :accent) do |dropdown|
      dropdown.trigger_button_content { "Right Position" }
      dropdown.menu_item(::Decor::DropdownItem.new(text: "Menu Item 1", href: "#"))
      dropdown.menu_item(::Decor::DropdownItem.new(text: "Menu Item 2", href: "#"))
    end
  end

  # @group Positions
  # @label Top Position
  def position_top
    render ::Decor::Dropdown.new(position: :top, color: :accent) do |dropdown|
      dropdown.trigger_button_content { "Top Position" }
      dropdown.menu_item(::Decor::DropdownItem.new(text: "Menu Item 1", href: "#"))
      dropdown.menu_item(::Decor::DropdownItem.new(text: "Menu Item 2", href: "#"))
    end
  end

  # @group Positions
  # @label Bottom Position
  def position_bottom
    render ::Decor::Dropdown.new(position: :bottom, color: :accent) do |dropdown|
      dropdown.trigger_button_content { "Bottom Position" }
      dropdown.menu_item(::Decor::DropdownItem.new(text: "Menu Item 1", href: "#"))
      dropdown.menu_item(::Decor::DropdownItem.new(text: "Menu Item 2", href: "#"))
    end
  end

  # @group Positions
  # @label End Position
  def position_end
    render ::Decor::Dropdown.new(position: :end, color: :accent) do |dropdown|
      dropdown.trigger_button_content { "End Position" }
      dropdown.menu_item(::Decor::DropdownItem.new(text: "Menu Item 1", href: "#"))
      dropdown.menu_item(::Decor::DropdownItem.new(text: "Menu Item 2", href: "#"))
    end
  end

  # @group Positions
  # @label Center Position
  def position_center
    render ::Decor::Dropdown.new(position: :center, color: :accent) do |dropdown|
      dropdown.trigger_button_content { "Center Position" }
      dropdown.menu_item(::Decor::DropdownItem.new(text: "Menu Item 1", href: "#"))
      dropdown.menu_item(::Decor::DropdownItem.new(text: "Menu Item 2", href: "#"))
    end
  end

  # @group Positions
  # @label Start Position
  def position_start
    render ::Decor::Dropdown.new(position: :start, color: :accent) do |dropdown|
      dropdown.trigger_button_content { "Start Position" }
      dropdown.menu_item(::Decor::DropdownItem.new(text: "Menu Item 1", href: "#"))
      dropdown.menu_item(::Decor::DropdownItem.new(text: "Menu Item 2", href: "#"))
    end
  end

  # @group Examples
  # @label Modern User Profile
  def example_user_profile
    render ::Decor::Dropdown.new(
      position: :end,
      color: :primary,
      variant: :bordered
    ) do |dropdown|
      dropdown.trigger_button_content do
        div(class: "flex items-center gap-2") do
          render ::Decor::Avatar.new(src: "/images/pic.jpg", alt: "User avatar", size: :sm)
          span(class: "hidden sm:inline") { "John Doe" }
        end
      end

      dropdown.menu_header do
        div(class: "px-4 py-3 border-b border-base-200") do
          p(class: "text-sm font-medium") { "John Doe" }
          p(class: "text-sm opacity-70") { "john@example.com" }
        end
      end

      dropdown.menu_item(::Decor::DropdownItem.new(text: "Profile", href: "#", icon_name: "user"))
      dropdown.menu_item(::Decor::DropdownItem.new(text: "Settings", href: "#", icon_name: "cog-6-tooth"))
      dropdown.menu_item(::Decor::DropdownItem.new(text: "Billing", href: "#", icon_name: "credit-card"))
      dropdown.menu_item(::Decor::DropdownItem.new(separator: true))
      dropdown.menu_item(::Decor::DropdownItem.new(text: "Sign out", href: "#", icon_name: "arrow-right-on-rectangle"))
    end
  end

  # @group Examples
  # @label Large Menu
  def example_large_menu
    render ::Decor::Dropdown.new(
      size: :lg,
      color: :secondary,
      variant: :filled
    ) do |dropdown|
      dropdown.trigger_button_content do
        div(class: "flex items-center gap-2") do
          render ::Decor::Icon.new(name: "ellipsis-vertical", html_options: {class: "h-5 w-5"})
          span { "Actions" }
        end
      end

      dropdown.menu_item(::Decor::DropdownItem.new(text: "Edit", href: "#", icon_name: "pencil"))
      dropdown.menu_item(::Decor::DropdownItem.new(text: "Duplicate", href: "#", icon_name: "document-duplicate"))
      dropdown.menu_item(::Decor::DropdownItem.new(text: "Share", href: "#", icon_name: "share"))
      dropdown.menu_item(::Decor::DropdownItem.new(separator: true))
      dropdown.menu_item(::Decor::DropdownItem.new(text: "Move to folder", href: "#", icon_name: "folder"))
      dropdown.menu_item(::Decor::DropdownItem.new(text: "Download", href: "#", icon_name: "arrow-down-tray"))
      dropdown.menu_item(::Decor::DropdownItem.new(separator: true))
      dropdown.menu_item(::Decor::DropdownItem.new(text: "Archive", href: "#", icon_name: "archive-box"))
      dropdown.menu_item(::Decor::DropdownItem.new(text: "Delete", href: "#", icon_name: "trash", http_method: :delete))
    end
  end

  # @group Trigger Modes
  # @label Click Trigger (Default)
  def trigger_click
    render ::Decor::Dropdown.new(trigger: :click, color: :primary) do |dropdown|
      dropdown.trigger_button_content { "Click to Open" }
      dropdown.menu_item(::Decor::DropdownItem.new(text: "Menu Item 1", href: "#"))
      dropdown.menu_item(::Decor::DropdownItem.new(text: "Menu Item 2", href: "#"))
    end
  end

  # @group Trigger Modes
  # @label Hover Trigger
  def trigger_hover
    render ::Decor::Dropdown.new(trigger: :hover, color: :secondary) do |dropdown|
      dropdown.trigger_button_content { "Hover to Open" }
      dropdown.menu_item(::Decor::DropdownItem.new(text: "Menu Item 1", href: "#"))
      dropdown.menu_item(::Decor::DropdownItem.new(text: "Menu Item 2", href: "#"))
    end
  end

  # @group Trigger Modes
  # @label Focus Trigger
  def trigger_focus
    render ::Decor::Dropdown.new(trigger: :focus, color: :accent) do |dropdown|
      dropdown.trigger_button_content { "Focus to Open" }
      dropdown.menu_item(::Decor::DropdownItem.new(text: "Menu Item 1", href: "#"))
      dropdown.menu_item(::Decor::DropdownItem.new(text: "Menu Item 2", href: "#"))
    end
  end

  # @group Force States
  # @label Force Open
  def force_open
    render ::Decor::Dropdown.new(force_open: :open, color: :info) do |dropdown|
      dropdown.trigger_button_content { "Always Open" }
      dropdown.menu_item(::Decor::DropdownItem.new(text: "Menu Item 1", href: "#"))
      dropdown.menu_item(::Decor::DropdownItem.new(text: "Menu Item 2", href: "#"))
    end
  end

  # @group Card Content
  # @label Simple Card
  def card_simple
    render ::Decor::Dropdown.new(
      color: :primary,
      position: :end
    ) do |dropdown|
      dropdown.trigger_button_content { "Card Dropdown" }

      dropdown.card_content do
        div(class: "card card-compact w-64 bg-base-100 shadow") do
          div(class: "card-body") do
            h3(class: "card-title") { "Card Title" }
            p { "This is card content inside a dropdown. Cards can contain any content you need." }
            div(class: "card-actions justify-end") do
              button(class: "btn btn-primary btn-sm") { "Action" }
            end
          end
        end
      end
    end
  end

  # @group Card Content
  # @label Profile Card
  def card_profile
    render ::Decor::Dropdown.new(
      color: :secondary,
      position: :end,
      trigger: :hover
    ) do |dropdown|
      dropdown.trigger_button_content do
        div(class: "flex items-center gap-2") do
          div(class: "avatar") do
            div(class: "w-8 rounded-full") do
              img(src: "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=32&h=32&fit=crop&crop=face", alt: "User")
            end
          end
          span { "Profile" }
        end
      end

      dropdown.card_content do
        div(class: "card card-compact w-80 bg-base-100 shadow-xl") do
          figure do
            img(src: "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=320&h=160&fit=crop", alt: "Profile banner", class: "h-20 w-full object-cover")
          end
          div(class: "card-body") do
            div(class: "flex items-center gap-3") do
              div(class: "avatar") do
                div(class: "w-12 rounded-full") do
                  img(src: "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=48&h=48&fit=crop&crop=face", alt: "User")
                end
              end
              div do
                h3(class: "card-title text-sm") { "Sarah Johnson" }
                p(class: "text-sm opacity-60") { "Product Designer" }
              end
            end
            p(class: "text-sm mt-2") { "Passionate about creating beautiful and functional user experiences." }
            div(class: "card-actions justify-between mt-4") do
              button(class: "btn btn-ghost btn-sm") { "View Profile" }
              button(class: "btn btn-primary btn-sm") { "Message" }
            end
          end
        end
      end
    end
  end

  # @group Card Content
  # @label Notification Card
  def card_notifications
    render ::Decor::Dropdown.new(
      color: :info,
      position: :end
    ) do |dropdown|
      dropdown.trigger_button_content do
        div(class: "flex items-center gap-2") do
          render ::Decor::Icon.new(name: "bell", html_options: {class: "h-5 w-5"})
          span(class: "badge badge-error badge-sm") { "3" }
        end
      end

      dropdown.card_content do
        div(class: "card card-compact w-96 bg-base-100 shadow-xl") do
          div(class: "card-body") do
            h3(class: "card-title text-base") { "Notifications" }

            div(class: "divider my-2") {}

            div(class: "space-y-3") do
              [
                {title: "New message from John", time: "2 min ago", type: "message"},
                {title: "Task deadline approaching", time: "1 hour ago", type: "warning"},
                {title: "Project completed successfully", time: "3 hours ago", type: "success"}
              ].each do |notification|
                div(class: "flex items-start gap-3 p-2 rounded-lg hover:bg-base-200") do
                  div(class: "flex-shrink-0 mt-1") do
                    case notification[:type]
                    when "message"
                      render ::Decor::Icon.new(name: "envelope", html_options: {class: "h-4 w-4 text-info"})
                    when "warning"
                      render ::Decor::Icon.new(name: "exclamation-triangle", html_options: {class: "h-4 w-4 text-warning"})
                    when "success"
                      render ::Decor::Icon.new(name: "check-circle", html_options: {class: "h-4 w-4 text-success"})
                    end
                  end
                  div(class: "flex-1 min-w-0") do
                    p(class: "text-sm font-medium") { notification[:title] }
                    p(class: "text-xs opacity-60") { notification[:time] }
                  end
                end
              end
            end

            div(class: "card-actions justify-end mt-4") do
              button(class: "btn btn-ghost btn-sm") { "Mark all read" }
              button(class: "btn btn-primary btn-sm") { "View all" }
            end
          end
        end
      end
    end
  end

  # @group Custom Content
  # @label Custom HTML Content
  def custom_content_example
    render ::Decor::Dropdown.new(
      color: :accent,
      position: :center
    ) do |dropdown|
      dropdown.trigger_button_content { "Custom Content" }

      dropdown.custom_content do
        div(class: "p-6 bg-base-100 rounded-box shadow w-80") do
          h3(class: "text-lg font-semibold mb-4") { "Custom Dropdown Content" }

          div(class: "form-control") do
            label(class: "label") do
              span(class: "label-text") { "Quick Search" }
            end
            input(type: "text", class: "input input-bordered w-full", placeholder: "Type to search...")
          end

          div(class: "mt-4") do
            h4(class: "font-medium mb-2") { "Recent Items" }
            div(class: "space-y-1") do
              %w[Documents Photos Videos Music].each do |item|
                div(class: "flex items-center justify-between p-2 rounded hover:bg-base-200") do
                  span(class: "text-sm") { item }
                  render ::Decor::Icon.new(name: "chevron-right", html_options: {class: "h-4 w-4 opacity-50"})
                end
              end
            end
          end

          div(class: "mt-4 pt-4 border-t border-base-300") do
            button(class: "btn btn-accent btn-block btn-sm") { "View All Items" }
          end
        end
      end
    end
  end
end
