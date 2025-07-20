## @label Title
class ::Decor::TitlePreview < ::Lookbook::Preview
  # Title
  # -------
  #
  # A reusable title component with configurable size, optional icon, description, and CTA area.
  # Used across PanelGroup, Panel, and other components for consistent title styling.
  #
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
        title.render ::Decor::Button.new(variant: :outlined, size: :micro) { "Action" }
      end
    end
  end

  # @!group Examples

  def all_sizes
    render ::Decor::Box.new do |box|
      [:xs, :sm, :md, :lg, :xl].each do |size|
        box.render ::Decor::Title.new(
          title: "#{size.to_s.upcase} Title Size",
          description: "Description text for #{size} size",
          size: size,
          icon: "academic-cap"
        ) do |title|
          title.render ::Decor::Button.new(variant: :outlined, size: button_size_for(size)) { "Action" }
        end

        # Add spacing between examples
        box.div(class: "my-6") unless size == :xl
      end
    end
  end

  def with_icons
    render ::Decor::Box.new do |box|
      [:sm, :md, :lg].each do |size|
        box.render ::Decor::Title.new(
          title: "Title with Icon",
          description: "Shows how icons scale with different sizes",
          icon: "star",
          size: size
        )

        box.div(class: "my-4") unless size == :lg
      end
    end
  end

  def simple_titles
    render ::Decor::Box.new do |box|
      box.render ::Decor::Title.new(title: "Simple Title Only", size: :lg)

      box.div(class: "my-4")

      box.render ::Decor::Title.new(
        title: "Title with Description",
        description: "No icon or actions, just title and description",
        size: :md
      )
    end
  end

  def with_different_actions
    render ::Decor::Box.new do |box|
      box.render ::Decor::Title.new(
        title: "Multiple Actions",
        description: "Example with multiple CTA elements",
        size: :md
      ) do |title|
        title.render ::Decor::Button.new(variant: :text, size: :large) { "Secondary" }
        title.render ::Decor::Button.new(variant: :outlined, size: :large) { "Primary" }
      end

      box.div(class: "my-6")

      box.render ::Decor::Title.new(
        title: "Custom Action Content",
        description: "Using badges and other components as actions",
        size: :md
      ) do |title|
        title.render ::Decor::Badge.new(style: :success) { "Active" }
        title.render ::Decor::Badge.new(style: :info) { "New" }
      end
    end
  end

  def page_headers
    render ::Decor::Box.new do |box|
      box.render ::Decor::Title.new(
        title: "Page Header",
        description: "Main page title with large size",
        size: :xl
      ) do |title|
        title.render ::Decor::Button.new(color: :primary) { "Create New" }
      end

      box.div(class: "my-8")

      box.render ::Decor::Title.new(
        title: "Section Header",
        description: "Secondary section with medium size",
        size: :lg
      ) do |title|
        title.render ::Decor::Button.new(variant: :outlined) { "Edit Section" }
      end
    end
  end

  def details_box_style
    render ::Decor::Title.new(
      title: "User Profile Settings",
      description: "Manage your account preferences and personal information",
      size: :md
    ) do |title|
      title.render ::Decor::Button.new(color: :primary, size: :small) { "Edit Profile" }
      title.render ::Decor::Button.new(variant: :text, size: :small) { "Export Data" }
    end
  end

  def panel_style
    render ::Decor::Box.new do |box|
      box.render ::Decor::Title.new(
        title: "Active Users",
        icon: "users",
        size: :sm
      )

      box.div(class: "mt-2 text-2xl font-bold text-primary") { "1,234" }
      box.div(class: "text-sm text-base-content/70") { "↗ 12% from last month" }
    end
  end

  # @!endgroup

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
      :micro
    when :md
      :small
    when :lg, :xl
      :large
    end
  end
end
