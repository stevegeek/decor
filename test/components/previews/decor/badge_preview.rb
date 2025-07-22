# @label Badge
class ::Decor::BadgePreview < ::Lookbook::Preview
  # Badge
  # -------
  #
  # A Badge is a small rectangular element which can be used to label sections of the view.
  # Supports icons, avatars, different styles, sizes, and variants.
  #
  # @group Examples
  # @label Example Badge
  def status_online
    render ::Decor::Badge.new(label: "Online", color: :success, style: :filled, icon: "check-circle")
  end

  # @group Examples
  # @label Outlined Badge
  def status_offline
    render ::Decor::Badge.new(label: "Offline", color: :neutral, style: :outlined)
  end

  # @group Examples
  # @label Dashed Badge
  def status_pending
    render ::Decor::Badge.new(label: "Pending", color: :warning, style: :outlined, dashed: true)
  end

  # @group Examples
  # @label Bagde with Icon
  def status_error
    render ::Decor::Badge.new(label: "Error", color: :error, style: :filled, icon: "x")
  end

  # @group Examples
  # @label Filled Success with Icon
  def combo_filled_success_icon
    render ::Decor::Badge.new(
      label: "Approved",
      icon: "check-circle",
      color: :success,
      style: :filled
    )
  end

  # @group Examples
  # @label Outlined Error Large
  def combo_outlined_error_large
    render ::Decor::Badge.new(
      label: "Critical Issue",
      color: :error,
      style: :outlined,
      size: :lg,
      icon: "x"
    )
  end

  # @group Examples
  # @label Dashed Warning with Avatar
  def combo_dashed_warning_avatar
    render ::Decor::Badge.new(
      label: "Needs Review",
      color: :warning,
      style: :outlined,
      dashed: true,
      initials: "NR"
    )
  end

  # @group Playground
  # @param label text
  # @param icon select [~, check-circle, x, check, download, play]
  # @param style select [outlined, filled, ghost]
  # @param color select [base, primary, secondary, accent, neutral, success, error, warning, info]
  # @param size select [xs, sm, md, lg, xl]
  # @param dashed toggle
  # @param image select [~, "https://i.pravatar.cc/300", "https://cataas.com/cat"]
  # @param initials text
  def playground(label: "My Badge", size: :md, icon: nil, color: :info, style: :outlined, image: nil, initials: nil, dashed: false)
    render ::Decor::Badge.new(label: label, icon: icon, size: size, color: color, style: style, url: image, initials: initials, dashed: dashed)
  end

  # @group Colors
  # @label Neutral Color
  def color_neutral
    render ::Decor::Badge.new(label: "Neutral Badge", color: :neutral)
  end

  # @group Colors
  # @label Success Color
  def color_success
    render ::Decor::Badge.new(label: "Success Badge", color: :success)
  end

  # @group Colors
  # @label Error Color
  def color_error
    render ::Decor::Badge.new(label: "Error Badge", color: :error)
  end

  # @group Colors
  # @label Warning Color
  def color_warning
    render ::Decor::Badge.new(label: "Warning Badge", color: :warning)
  end

  # @group Colors
  # @label Info Color
  def color_info
    render ::Decor::Badge.new(label: "Info Badge", color: :info)
  end

  # @group Styles
  # @label Outlined Style
  def style_outlined
    render ::Decor::Badge.new(label: "Outlined Badge", style: :outlined)
  end

  # @group Styles
  # @label Filled Style
  def style_filled
    render ::Decor::Badge.new(label: "Filled Badge", style: :filled)
  end

  # @group Styles
  # @label Dashed Outlined
  def style_dashed
    render ::Decor::Badge.new(label: "Dashed Badge", style: :outlined, dashed: true)
  end

  # @group Sizes
  # @label Extra Small Size
  def size_xs
    render ::Decor::Badge.new(label: "XS Badge", size: :xs)
  end

  # @group Sizes
  # @label Small Size
  def size_small
    render ::Decor::Badge.new(label: "Small Badge", size: :sm)
  end

  # @group Sizes
  # @label Medium Size
  def size_medium
    render ::Decor::Badge.new(label: "Medium Badge", size: :md)
  end

  # @group Sizes
  # @label Large Size
  def size_large
    render ::Decor::Badge.new(label: "Large Badge", size: :lg)
  end

  # @group Sizes
  # @label Extra Large Size
  def size_xl
    render ::Decor::Badge.new(label: "XL Badge", size: :xl)
  end

  # @group With Icons
  # @label Basic Icon
  def icon_basic
    render ::Decor::Badge.new(label: "Badge with icon", icon: "check")
  end

  # @group With Icons
  # @label Success with Check
  def icon_success_check
    render ::Decor::Badge.new(label: "Completed", icon: "check-circle", color: :success)
  end

  # @group With Icons
  # @label Error with X
  def icon_error_x
    render ::Decor::Badge.new(label: "Failed", icon: "x", color: :error)
  end

  # @group With Icons
  # @label Warning with Alert
  def icon_warning_alert
    render ::Decor::Badge.new(label: "Warning", icon: "exclamation-triangle", color: :warning)
  end

  # @group With Icons
  # @label Small with Icon
  def icon_small
    render ::Decor::Badge.new(label: "Small", icon: "star", size: :sm)
  end

  # @group With Icons
  # @label Large with Icon
  def icon_large
    render ::Decor::Badge.new(label: "Large", icon: "heart", size: :lg)
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
  # @label Extra Small with Avatar
  def avatar_xsmall
    render ::Decor::Badge.new(label: "Small User", initials: "SU", size: :xs)
  end

  # @group With Avatars
  # @label Small with Avatar
  def avatar_small
    render ::Decor::Badge.new(label: "Small User", initials: "SU", size: :sm)
  end
  # @group With Avatars
  # @label Medium with Avatar
  def avatar_medium
    render ::Decor::Badge.new(label: "Large User", initials: "LU", size: :md)
  end

  # @group With Avatars
  # @label Large with Avatar
  def avatar_large
    render ::Decor::Badge.new(label: "Large User", initials: "LU", size: :lg)
  end

  # @group With Avatars
  # @label Extra Large with Avatar
  def avatar_xlarge
    render ::Decor::Badge.new(label: "Large User", initials: "LU", size: :xl)
  end
end