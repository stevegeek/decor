# @label Title
class ::Decor::TitlePreview < ::Lookbook::Preview
  # Title
  # -------
  #
  # A reusable title component with configurable size, optional icon, description, and CTA area.
  # Used across components for consistent title styling.
  #
  # @group Examples
  # @label Basic Title
  def basic_title
    render ::Decor::Title.new(
      title: "Page Title",
      description: "A clear description of what this section contains",
      size: :md
    )
  end

  # @group Examples
  # @label Title with Icon
  def title_with_icon
    render ::Decor::Title.new(
      title: "Settings",
      description: "Manage your application preferences",
      icon: "cog",
      size: :lg
    )
  end

  # @group Examples
  # @label Title with Actions
  def title_with_actions
    render ::Decor::Title.new(
      title: "User Management",
      description: "View and manage all users in your organization",
      icon: "users",
      size: :lg
    ) do |title|
      title.render ::Decor::Button.new(label: "Add User", color: :primary, size: :sm)
    end
  end

  # @group Playground
  # @param size [Symbol] select { choices: [xs, sm, md, lg, xl] }
  # @param include_description [Boolean] toggle
  # @param include_icon [Boolean] toggle
  # @param include_actions [Boolean] toggle
  def playground(size: :md, include_description: true, include_icon: false, include_actions: true)
    render ::Decor::Title.new(
      title: title_for_size(size),
      description: include_description ? "This is a description that explains what this section is about." : nil,
      icon: include_icon ? "academic-cap" : nil,
      size: size
    ) do |title|
      if include_actions
        title.render ::Decor::Button.new(style: :outlined, size: :xs) { "Action" }
      end
    end
  end

  # @group Sizes
  # @label Extra Small
  def size_xs
    render ::Decor::Title.new(
      title: "Extra Small Title",
      description: "XS size for compact areas",
      size: :xs
    )
  end

  # @group Sizes
  # @label Small
  def size_sm
    render ::Decor::Title.new(
      title: "Small Title",
      description: "Small size for secondary sections",
      size: :sm
    )
  end

  # @group Sizes
  # @label Medium (Default)
  def size_md
    render ::Decor::Title.new(
      title: "Medium Title",
      description: "Default size for most use cases",
      size: :md
    )
  end

  # @group Sizes
  # @label Large
  def size_lg
    render ::Decor::Title.new(
      title: "Large Title",
      description: "Large size for main sections",
      size: :lg
    )
  end

  # @group Sizes
  # @label Extra Large
  def size_xl
    render ::Decor::Title.new(
      title: "Extra Large Title",
      description: "XL size for hero sections and page headers",
      size: :xl
    )
  end

  # @group With Icons
  # @label Small with Icon
  def icon_small
    render ::Decor::Title.new(
      title: "Small Title with Icon",
      description: "Icon scales appropriately with size",
      icon: "star",
      size: :sm
    )
  end

  # @group With Icons
  # @label Medium with Icon
  def icon_medium
    render ::Decor::Title.new(
      title: "Medium Title with Icon",
      description: "Icon scales appropriately with size",
      icon: "star",
      size: :md
    )
  end

  # @group With Icons
  # @label Large with Icon
  def icon_large
    render ::Decor::Title.new(
      title: "Large Title with Icon",
      description: "Icon scales appropriately with size",
      icon: "star",
      size: :lg
    )
  end

  # @group Variations
  # @label Title Only
  def title_only
    render ::Decor::Title.new(
      title: "Simple Title Without Description",
      size: :lg
    )
  end

  # @group Variations
  # @label With Multiple Actions
  def multiple_actions
    render ::Decor::Title.new(
      title: "Multiple Actions",
      description: "Example with multiple CTA elements",
      size: :md
    ) do |title|
      title.render ::Decor::Button.new(label: "Secondary", style: :ghost, size: :sm)
      title.render ::Decor::Button.new(label: "Primary", style: :outlined, size: :sm)
    end
  end

  # @group Variations
  # @label With Badge Actions
  def badge_actions
    render ::Decor::Title.new(
      title: "Status Overview",
      description: "Using badges as action elements",
      size: :md
    ) do |title|
      title.render ::Decor::Badge.new(label: "Active", color: :success)
      title.render ::Decor::Badge.new(label: "New", color: :info)
    end
  end

  # @group Examples
  # @label Page Header
  def page_header
    render ::Decor::Title.new(
      title: "Page Header",
      description: "Main page title with large size",
      size: :xl
    ) do |title|
      title.render ::Decor::Button.new(label: "Create New", color: :primary)
    end
  end

  # @group Examples
  # @label Section Header
  def section_header
    render ::Decor::Title.new(
      title: "Section Header",
      description: "Secondary section with medium size",
      size: :lg
    ) do |title|
      title.render ::Decor::Button.new(label: "Edit Section", style: :outlined)
    end
  end

  # @group Examples
  # @label Settings Panel
  def settings_panel
    render ::Decor::Title.new(
      title: "User Profile Settings",
      description: "Manage your account preferences and personal information",
      size: :md
    ) do |title|
      title.render ::Decor::Button.new(label: "Edit Profile", color: :primary, size: :sm)
      title.render ::Decor::Button.new(label: "Export Data", style: :ghost, size: :sm)
    end
  end

  # @group Examples
  # @label Stat Card Title
  def stat_card_title
    render ::Decor::Title.new(
      title: "Active Users",
      icon: "users",
      size: :sm
    )
  end

  private

  def title_for_size(size)
    case size
    when :xs
      "Extra Small Title"
    when :sm
      "Small Title"
    when :md
      "Medium Title Size"
    when :lg
      "Large Title"
    when :xl
      "Extra Large Title"
    end
  end

  def button_size_for(title_size)
    case title_size
    when :xs, :sm
      :xs
    when :md
      :sm
    when :lg, :xl
      :lg
    end
  end
end
