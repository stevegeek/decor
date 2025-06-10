# @label Badge
class ::Decor::BadgePreview < ::Lookbook::Preview
  # Badge
  # -------
  #
  # A Badge is a small rectangular element which can be used to label sections of the view.
  # Supports icons, avatars, different styles, sizes, and variants.
  #
  # @label Playground
  # @param label text
  # @param icon select [~, check-circle, x, check, download, play]
  # @param variant select [outlined, filled]
  # @param style select [warning, success, error, info, standard]
  # @param size select [small, medium, large]
  # @param dashed toggle
  # @param image select [~, "https://i.pravatar.cc/300", "https://cataas.com/cat"]
  # @param initials text
  def playground(label: "My Badge", size: :medium, icon: nil, style: :info, variant: :outlined, image: nil, initials: nil, dashed: false)
    render ::Decor::Badge.new(label: label, icon: icon, size: size, style: style, variant: variant, url: image, initials: initials, dashed: dashed)
  end

  # @group Styles
  # @label Standard Style
  def style_standard
    render ::Decor::Badge.new(label: "Standard Badge", style: :standard)
  end

  # @group Styles
  # @label Success Style
  def style_success
    render ::Decor::Badge.new(label: "Success Badge", style: :success)
  end

  # @group Styles
  # @label Error Style
  def style_error
    render ::Decor::Badge.new(label: "Error Badge", style: :error)
  end

  # @group Styles
  # @label Warning Style
  def style_warning
    render ::Decor::Badge.new(label: "Warning Badge", style: :warning)
  end

  # @group Styles
  # @label Info Style
  def style_info
    render ::Decor::Badge.new(label: "Info Badge", style: :info)
  end

  # @group Variants
  # @label Outlined Variant
  def variant_outlined
    render ::Decor::Badge.new(label: "Outlined Badge", variant: :outlined)
  end

  # @group Variants
  # @label Filled Variant
  def variant_filled
    render ::Decor::Badge.new(label: "Filled Badge", variant: :filled)
  end

  # @group Variants
  # @label Dashed Outlined
  def variant_dashed
    render ::Decor::Badge.new(label: "Dashed Badge", variant: :outlined, dashed: true)
  end

  # @group Sizes
  # @label Small Size
  def size_small
    render ::Decor::Badge.new(label: "Small Badge", size: :small)
  end

  # @group Sizes
  # @label Medium Size
  def size_medium
    render ::Decor::Badge.new(label: "Medium Badge", size: :medium)
  end

  # @group Sizes
  # @label Large Size
  def size_large
    render ::Decor::Badge.new(label: "Large Badge", size: :large)
  end

  # @group With Icons
  # @label Basic Icon
  def icon_basic
    render ::Decor::Badge.new(label: "Badge with icon", icon: "check")
  end

  # @group With Icons
  # @label Success with Check
  def icon_success_check
    render ::Decor::Badge.new(label: "Completed", icon: "check-circle", style: :success)
  end

  # @group With Icons
  # @label Error with X
  def icon_error_x
    render ::Decor::Badge.new(label: "Failed", icon: "x", style: :error)
  end

  # @group With Icons
  # @label Warning with Alert
  def icon_warning_alert
    render ::Decor::Badge.new(label: "Warning", icon: "exclamation-triangle", style: :warning)
  end

  # @group With Icons
  # @label Small with Icon
  def icon_small
    render ::Decor::Badge.new(label: "Small", icon: "star", size: :small)
  end

  # @group With Icons
  # @label Large with Icon
  def icon_large
    render ::Decor::Badge.new(label: "Large", icon: "heart", size: :large)
  end

  # @group With Avatars
  # @label Avatar with Initials
  def avatar_initials
    render ::Decor::Badge.new(label: "John Doe", initials: "JD")
  end

  # @group With Avatars
  # @label Avatar with Image
  def avatar_image
    render ::Decor::Badge.new(label: "User Profile", url: "https://i.pravatar.cc/300")
  end

  # @group With Avatars
  # @label Small Avatar
  def avatar_small
    render ::Decor::Badge.new(label: "Small User", initials: "SU", size: :small)
  end

  # @group With Avatars
  # @label Large Avatar
  def avatar_large
    render ::Decor::Badge.new(label: "Large User", initials: "LU", size: :large)
  end

  # @group With Avatars
  # @label Avatar Success Style
  def avatar_success
    render ::Decor::Badge.new(label: "Verified User", initials: "VU", style: :success)
  end

  # @group Combinations
  # @label Filled Success with Icon
  def combo_filled_success_icon
    render ::Decor::Badge.new(
      label: "Approved",
      icon: "check-circle",
      style: :success,
      variant: :filled
    )
  end

  # @group Combinations
  # @label Outlined Error Large
  def combo_outlined_error_large
    render ::Decor::Badge.new(
      label: "Critical Issue",
      style: :error,
      variant: :outlined,
      size: :large,
      icon: "x"
    )
  end

  # @group Combinations
  # @label Dashed Warning with Avatar
  def combo_dashed_warning_avatar
    render ::Decor::Badge.new(
      label: "Needs Review",
      style: :warning,
      variant: :outlined,
      dashed: true,
      initials: "NR"
    )
  end

  # @group Status Examples
  # @label Online Status
  def status_online
    render ::Decor::Badge.new(label: "Online", style: :success, variant: :filled, icon: "check-circle")
  end

  # @group Status Examples
  # @label Offline Status
  def status_offline
    render ::Decor::Badge.new(label: "Offline", style: :standard, variant: :outlined)
  end

  # @group Status Examples
  # @label Pending Status
  def status_pending
    render ::Decor::Badge.new(label: "Pending", style: :warning, variant: :outlined, dashed: true)
  end

  # @group Status Examples
  # @label Error Status
  def status_error
    render ::Decor::Badge.new(label: "Error", style: :error, variant: :filled, icon: "x")
  end
end
