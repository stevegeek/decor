# @label Box
class ::Decor::BoxPreview < ::Lookbook::Preview
  # Box
  # -------
  #
  # A daisyUI card-styled box component with title, description, and content areas.
  # Features light grey background for better visual separation.
  #
  # @group Examples
  # @label Simple Box
  def simple_box
    render ::Decor::Box.new(
      title: "Simple Box",
      description: "Just a title and description with light grey background."
    )
  end

  # @group Examples
  # @label Box with Actions
  def with_actions
    render ::Decor::Box.new(
      title: "Box with Actions",
      description: "This box has action buttons in the content area."
    ) do
      content_tag :div, class: "card-actions justify-end" do
        content_tag(:button, "Cancel", class: "btn btn-ghost") +
          content_tag(:button, "Save", class: "btn btn-primary")
      end
    end
  end

  # @group Examples
  # @label Box with Left Slot
  def with_left_slot
    render ::Decor::Box.new(
      title: "Settings",
      description: "Configure your preferences"
    ) do |box|
      box.left do
        content_tag :div, class: "text-4xl" do
          "⚙️"
        end
      end
    end
  end

  # @group Examples
  # @label Box with Right Slot
  def with_right_slot
    render ::Decor::Box.new(
      title: "Notifications",
      description: "You have 3 new messages"
    ) do |box|
      box.right do
        content_tag :div, class: "badge badge-primary" do
          "3"
        end
      end
    end
  end

  # @group Examples
  # @label Box with Both Slots
  def with_both_slots
    render ::Decor::Box.new(
      title: "User Profile",
      description: "John Doe - Software Developer"
    ) do |box|
      box.left do
        content_tag :div, class: "avatar" do
          content_tag :div, class: "w-12 rounded-full bg-primary text-primary-content" do
            content_tag :span, "JD", class: "text-xl"
          end
        end
      end
      box.right do
        content_tag :button, "Edit", class: "btn btn-sm btn-primary"
      end
    end
  end

  # @group Examples
  # @label Card Style Box
  def card_style
    render ::Decor::Box.new(
      title: "Product Card",
      description: "Amazing product with great features",
      style: :filled,
      color: :base
    ) do
      content_tag :div do
        content_tag(:p, "Price: $99.99", class: "text-lg font-bold") +
          content_tag(:div, class: "card-actions justify-end mt-4") do
            content_tag :button, "Add to Cart", class: "btn btn-primary"
          end
      end
    end
  end

  # @group Examples
  # @label Alert Style Box
  def alert_style
    render ::Decor::Box.new(
      title: "Important Notice",
      description: "Please read this carefully",
      color: :warning,
      style: :filled
    ) do |box|
      box.left do
        content_tag :span, "⚠️", class: "text-2xl"
      end
    end
  end

  # @group Examples
  # @label Info Box
  def info_box
    render ::Decor::Box.new(
      title: "Did you know?",
      description: "This component supports multiple styles and colors",
      color: :info,
      style: :outlined
    )
  end

  # @group Playground
  # @param title text
  # @param description text
  # @param show_slots toggle
  # @param size [Symbol] select [~, xs, sm, md, lg, xl]
  # @param color [Symbol] select [~, base, primary, secondary, accent, neutral, success, error, warning, info]
  # @param style [Symbol] select [~, filled, outlined, ghost]
  def playground(
    title: "Box Title",
    description: "A box component has a figure, a body part, and inside body there are title and actions parts",
    show_slots: false,
    size: nil,
    color: nil,
    style: nil
  )
    render ::Decor::Box.new(title: title, description: description, size: size, color: color, style: style) do |box|
      if show_slots
        box.left do
          content_tag :div, "Custom Left Content", class: "font-bold"
        end
        box.right do
          content_tag :div, class: "card-actions justify-end" do
            content_tag :button, "Buy Now", class: "btn btn-primary"
          end
        end
      else
        content_tag :div, class: "card-actions justify-end" do
          content_tag :button, "Buy Now", class: "btn btn-primary"
        end
      end
    end
  end

  # @group Sizes
  # @label XS Size
  def size_xs
    render ::Decor::Box.new(
      title: "Extra Small Box",
      description: "This is an extra small sized box",
      size: :xs
    )
  end

  # @group Sizes
  # @label SM Size
  def size_sm
    render ::Decor::Box.new(
      title: "Small Box",
      description: "This is a small sized box",
      size: :sm
    )
  end

  # @group Sizes
  # @label MD Size (Default)
  def size_md
    render ::Decor::Box.new(
      title: "Medium Box",
      description: "This is a medium sized box (default)",
      size: :md
    )
  end

  # @group Sizes
  # @label LG Size
  def size_lg
    render ::Decor::Box.new(
      title: "Large Box",
      description: "This is a large sized box",
      size: :lg
    )
  end

  # @group Sizes
  # @label XL Size
  def size_xl
    render ::Decor::Box.new(
      title: "Extra Large Box",
      description: "This is an extra large sized box",
      size: :xl
    )
  end

  # @group Colors
  # @label Base Color (Default)
  def color_base
    render ::Decor::Box.new(
      title: "Base Color",
      description: "This is the default base color",
      color: :base
    )
  end

  # @group Colors
  # @label Primary Color
  def color_primary
    render ::Decor::Box.new(
      title: "Primary Color",
      description: "This box uses the primary color",
      color: :primary
    )
  end

  # @group Colors
  # @label Secondary Color
  def color_secondary
    render ::Decor::Box.new(
      title: "Secondary Color",
      description: "This box uses the secondary color",
      color: :secondary
    )
  end

  # @group Colors
  # @label Accent Color
  def color_accent
    render ::Decor::Box.new(
      title: "Accent Color",
      description: "This box uses the accent color",
      color: :accent
    )
  end

  # @group Colors
  # @label Neutral Color
  def color_neutral
    render ::Decor::Box.new(
      title: "Neutral Color",
      description: "This box uses the neutral color",
      color: :neutral
    )
  end

  # @group Colors
  # @label Success Color
  def color_success
    render ::Decor::Box.new(
      title: "Success Color",
      description: "This box uses the success color",
      color: :success
    )
  end

  # @group Colors
  # @label Error Color
  def color_error
    render ::Decor::Box.new(
      title: "Error Color",
      description: "This box uses the error color",
      color: :error
    )
  end

  # @group Colors
  # @label Warning Color
  def color_warning
    render ::Decor::Box.new(
      title: "Warning Color",
      description: "This box uses the warning color",
      color: :warning
    )
  end

  # @group Colors
  # @label Info Color
  def color_info
    render ::Decor::Box.new(
      title: "Info Color",
      description: "This box uses the info color",
      color: :info
    )
  end

  # @group Styles
  # @label Filled Style (Default)
  def style_filled
    render ::Decor::Box.new(
      title: "Filled Style",
      description: "This is the default filled style",
      style: :filled
    )
  end

  # @group Styles
  # @label Outlined Style
  def style_outlined
    render ::Decor::Box.new(
      title: "Outlined Style",
      description: "This box uses the outlined style",
      style: :outlined
    )
  end

  # @group Styles
  # @label Ghost Style
  def style_ghost
    render ::Decor::Box.new(
      title: "Ghost Style",
      description: "This box uses the ghost style",
      style: :ghost
    )
  end
end
