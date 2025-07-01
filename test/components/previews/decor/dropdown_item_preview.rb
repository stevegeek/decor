# @label Dropdown Item
class ::Decor::DropdownItemPreview < ::Lookbook::Preview
  # Dropdown Item
  # -------
  #
  # A dropdown item represents a single menu item within a dropdown component.
  # Can display text, icons, and act as separators.
  #
  # @label Playground
  # @param text [String] text
  # @param href [String] text
  # @param icon_name [String] text
  # @param separator [Boolean] toggle
  # @param http_method select [get, post, patch, delete]
  def playground(text: "Menu Item", href: "#", icon_name: nil, separator: false, http_method: :get)
    render ::Decor::DropdownItem.new(
      text: text,
      href: href,
      icon_name: icon_name,
      separator: separator,
      http_method: http_method
    )
  end

  # @label Basic Item
  def basic_item
    render ::Decor::DropdownItem.new(
      text: "Basic Menu Item",
      href: "#"
    )
  end

  # @label With Icon
  def with_icon
    render ::Decor::DropdownItem.new(
      text: "Settings",
      href: "#",
      icon_name: "cog"
    )
  end

  # @label Separator
  def separator
    render ::Decor::Element.new do |el|
      el.render ::Decor::DropdownItem.new(text: "Item 1", href: "#")
      el.render ::Decor::DropdownItem.new(separator: true)
      el.render ::Decor::DropdownItem.new(text: "Item 2", href: "#")
    end
  end

  # @label Multiple Items
  def multiple_items
    render ::Decor::Element.new do |el|
      el.render ::Decor::DropdownItem.new(text: "Profile", href: "#", icon_name: "user")
      el.render ::Decor::DropdownItem.new(text: "Settings", href: "#", icon_name: "cog")
      el.render ::Decor::DropdownItem.new(separator: true)
      el.render ::Decor::DropdownItem.new(text: "Sign out", href: "#", icon_name: "logout", http_method: :delete)
    end
  end
end
