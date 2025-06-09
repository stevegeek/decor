# @label Link
class ::Decor::LinkPreview < ::ViewComponent::Preview
  # Link
  # -------
  #
  # A styled anchor link component with daisyUI btn-link styling.
  # Supports different themes for color, sizes, and disabled state.
  #
  # @label Playground
  # @param label text
  # @param href text
  # @param theme select {choices: [primary, secondary, danger, warning, neutral]}
  # @param size select {choices: [large, medium, small, micro]}
  # @param disabled toggle
  # @param icon text
  def playground(label: "Click me", href: "#", theme: :primary, size: :medium, disabled: false, icon: nil)
    render ::Decor::Link.new(
      label: label,
      href: href,
      theme: theme.to_sym,
      size: size.to_sym,
      disabled: disabled,
      icon: icon.present? ? icon : nil
    )
  end

  # @label All Themes
  def all_themes
    content_tag :div, class: "space-y-4" do
      [:primary, :secondary, :danger, :warning, :neutral].map do |theme|
        content_tag(:div, class: "flex items-center space-x-4") do
          content_tag(:span, "#{theme.to_s.capitalize}:", class: "w-20 font-medium") +
          render(::Decor::Link.new(label: "Sample Link", href: "#", theme: theme))
        end
      end.join.html_safe
    end
  end

  # @label All Sizes
  def all_sizes
    content_tag :div, class: "space-y-4" do
      [:large, :medium, :small, :micro].map do |size|
        content_tag(:div, class: "flex items-center space-x-4") do
          content_tag(:span, "#{size.to_s.capitalize}:", class: "w-20 font-medium") +
          render(::Decor::Link.new(label: "Sample Link", href: "#", size: size))
        end
      end.join.html_safe
    end
  end

  # @label With Icons
  def with_icons
    content_tag :div, class: "space-y-4" do
      render(::Decor::Link.new(label: "Link with icon", href: "#", icon: "star")) +
      render(::Decor::Link.new(label: "Large with icon", href: "#", icon: "heart", size: :large)) +
      render(::Decor::Link.new(label: "Small with icon", href: "#", icon: "bell", size: :small))
    end
  end

  # @label Disabled States
  def disabled_states
    content_tag :div, class: "space-y-4" do
      [:primary, :secondary, :danger].map do |theme|
        content_tag(:div, class: "flex items-center space-x-4") do
          content_tag(:span, "#{theme.to_s.capitalize}:", class: "w-20 font-medium") +
          render(::Decor::Link.new(label: "Disabled Link", href: "#", theme: theme, disabled: true))
        end
      end.join.html_safe
    end
  end

  # @label External Links
  def external_links
    content_tag :div, class: "space-y-4" do
      render(::Decor::Link.new(label: "External Link", href: "https://example.com", target: "_blank")) +
      render(::Decor::Link.new(label: "Email Link", href: "mailto:test@example.com")) +
      render(::Decor::Link.new(label: "Phone Link", href: "tel:+1234567890"))
    end
  end
end