# @label Tag
class ::Decor::TagPreview < ::Lookbook::Preview
  # Tag
  # -------
  #
  # A modern tag/badge component built with DaisyUI styling. Tags can display simple labels,
  # include icons, and optionally show a close button for removal functionality.
  #
  # ## Features
  # - **DaisyUI Integration**: Uses DaisyUI badge classes for consistent theming
  # - **Icon Support**: Optional leading icons using Decor::Icon
  # - **Removable Tags**: Optional close button (removal logic handled by parent components)
  # - **Multiple Styles**: Filled, outlined, and ghost styles
  # - **Semantic Colors**: Full DaisyUI color palette support
  # - **Size Options**: 4 sizes from xs to lg
  #
  # ## Note on Removable Tags
  # When `removable: true`, the tag renders a close button with an X icon. The actual removal
  # logic should be handled by parent components or separate controllers, not by the Tag itself.
  #
  # @group Examples
  # @label Outline with Icon
  def combo_outline_icon
    render ::Decor::Tag.new(
      label: "Featured",
      icon: "star",
      color: :accent,
      style: :outlined
    )
  end

  # @group Examples
  # @label Outline with Icon and Removable
  def combo_outline_icon_removable
    render ::Decor::Tag.new(
      label: "Draft",
      icon: "document",
      color: :warning,
      style: :outlined,
      removable: true
    )
  end

  # @group Examples
  # @label Large Filled Removable
  def combo_large_filled_removable
    render ::Decor::Tag.new(
      label: "Important",
      icon: "exclamation-triangle",
      color: :error,
      style: :filled,
      size: :lg,
      removable: true
    )
  end

  # @group Examples
  # @label Category Tag
  def example_category
    render ::Decor::Tag.new(
      label: "Technology",
      color: :info,
      icon: "tag",
      removable: true
    )
  end

  # @group Examples
  # @label Priority Tag
  def example_priority
    render ::Decor::Tag.new(
      label: "High Priority",
      color: :error,
      style: :outlined,
      size: :lg
    )
  end

  # @group Examples
  # @label User Role
  def example_user_role
    render ::Decor::Tag.new(
      label: "Moderator",
      color: :accent,
      icon: "user",
      style: :filled
    )
  end

  # @group Examples
  # @label Filter Tag
  def example_filter
    render ::Decor::Tag.new(
      label: "JavaScript",
      color: :warning,
      removable: true
    )
  end

  # @group Examples
  # @label Product Labels
  def usecase_product_labels
    render ::Decor::Tag.new(
      label: "Best Seller",
      color: :success,
      icon: "star",
      style: :filled
    )
  end

  # @group Examples
  # @label Notification Badge
  def usecase_notification
    render ::Decor::Tag.new(
      label: "New",
      color: :error,
      size: :xs,
      style: :filled
    )
  end

  # @group Examples
  # @label Skill Tag
  def usecase_skill
    render ::Decor::Tag.new(
      label: "Ruby on Rails",
      color: :accent,
      style: :outlined,
      removable: true
    )
  end

  # @group Playground
  # @param label text
  # @param icon select [~, check-circle, x-mark, check, star, heart, user, tag]
  # @param size [Symbol] select [~, xs, sm, md, lg, xl]
  # @param color [Symbol] select [~, base, primary, secondary, accent, neutral, success, error, warning, info]
  # @param style [Symbol] select [~, ghost, bordered, lifted, boxed]
  # @param removable toggle
  def playground(
    label: "Sample Tag",
    icon: nil,
    size: :md,
    color: :primary,
    style: :filled,
    removable: false
  )
    render ::Decor::Tag.new(
      label: label,
      icon: icon,
      size: size,
      color: color,
      style: style,
      removable: removable
    )
  end

  # @group Colors
  # @label Primary Color
  def color_primary
    render ::Decor::Tag.new(label: "Primary", color: :primary)
  end

  # @group Colors
  # @label Secondary Color
  def color_secondary
    render ::Decor::Tag.new(label: "Secondary", color: :secondary)
  end

  # @group Colors
  # @label Accent Color
  def color_accent
    render ::Decor::Tag.new(label: "Accent", color: :accent)
  end

  # @group Colors
  # @label Success Color
  def color_success
    render ::Decor::Tag.new(label: "Success", color: :success)
  end

  # @group Colors
  # @label Error Color
  def color_error
    render ::Decor::Tag.new(label: "Error", color: :error)
  end

  # @group Colors
  # @label Warning Color
  def color_warning
    render ::Decor::Tag.new(label: "Warning", color: :warning)
  end

  # @group Colors
  # @label Info Color
  def color_info
    render ::Decor::Tag.new(label: "Info", color: :info)
  end

  # @group Colors
  # @label Neutral Color
  def color_neutral
    render ::Decor::Tag.new(label: "Neutral", color: :neutral)
  end

  # @group Sizes
  # @label Extra Small
  def size_xs
    render ::Decor::Tag.new(icon: "heart", label: "XS Tag", size: :xs, removable: true)
  end

  # @group Sizes
  # @label Small
  def size_sm
    render ::Decor::Tag.new(icon: "heart", label: "Small Tag", size: :sm, removable: true)
  end

  # @group Sizes
  # @label Medium (Default)
  def size_md
    render ::Decor::Tag.new(icon: "heart", label: "Medium Tag", size: :md, removable: true)
  end

  # @group Sizes
  # @label Large
  def size_lg
    render ::Decor::Tag.new(icon: "heart", label: "Large Tag", size: :lg, removable: true)
  end

  # @group Sizes
  # @label Extra Large
  def size_xl
    render ::Decor::Tag.new(icon: "heart", label: "XL Tag", size: :xl, removable: true)
  end

  # @group Styles
  # @label Filled (Default)
  def style_filled
    render ::Decor::Tag.new(label: "Filled Tag", color: :primary, style: :filled)
  end

  # @group Styles
  # @label Outlined
  def style_outlined
    render ::Decor::Tag.new(label: "Outline Tag", color: :primary, style: :outlined)
  end

  # @group Styles
  # @label Ghost
  def style_ghost
    render ::Decor::Tag.new(label: "Ghost Tag", color: :primary, style: :ghost)
  end

  # @group With Icons
  # @label Basic Icon
  def icon_basic
    render ::Decor::Tag.new(label: "Tagged", icon: "tag", color: :info)
  end

  # @group With Icons
  # @label Success with Check
  def icon_success_check
    render ::Decor::Tag.new(label: "Verified", icon: "check-circle", color: :success)
  end

  # @group With Icons
  # @label Star Rating
  def icon_star
    render ::Decor::Tag.new(label: "Favorite", icon: "star", color: :warning)
  end

  # @group With Icons
  # @label User Tag
  def icon_user
    render ::Decor::Tag.new(label: "Admin", icon: "user", color: :accent)
  end

  # @group Removable Tags
  # @label Basic Removable
  def removable_basic
    render ::Decor::Tag.new(
      label: "Remove Me",
      color: :primary,
      removable: true
    )
  end

  # @group Removable Tags
  # @label Removable with Icon
  def removable_with_icon
    render ::Decor::Tag.new(
      label: "Category",
      icon: "tag",
      color: :accent,
      removable: true
    )
  end

  # @group Removable Tags
  # @label Different Colors Removable
  def removable_colors
    render ::Decor::Tag.new(
      label: "Success Tag",
      color: :success,
      removable: true
    )
  end

  # @group Removable Tags
  # @label Error Tag Removable
  def removable_error
    render ::Decor::Tag.new(
      label: "Error Tag",
      color: :error,
      removable: true
    )
  end

  # @group Removable Tags
  # @label Large Removable
  def removable_large
    render ::Decor::Tag.new(
      label: "Large Removable",
      color: :warning,
      size: :lg,
      removable: true
    )
  end
end
