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
  # @param separator [Boolean] checkbox
  # @param http_method select [get, post, patch, delete]
  def playground(text: "Menu Item", href: "#", icon_name: nil, separator: false, http_method: :get)
    content_tag :div, class: "bg-white border rounded-lg shadow-lg w-64 py-1" do
      render ::Decor::DropdownItem.new(
        text: text,
        href: href,
        icon_name: icon_name,
        separator: separator,
        http_method: http_method
      )
    end
  end

  # @label Basic Item
  def basic_item
    content_tag :div, class: "bg-white border rounded-lg shadow-lg w-64 py-1" do
      render ::Decor::DropdownItem.new(
        text: "Basic Menu Item",
        href: "#"
      )
    end
  end

  # @label With Icon
  def with_icon
    content_tag :div, class: "bg-white border rounded-lg shadow-lg w-64 py-1" do
      render ::Decor::DropdownItem.new(
        text: "Settings",
        href: "#",
        icon_name: "cog"
      )
    end
  end

  # @label Separator
  def separator
    content_tag :div, class: "bg-white border rounded-lg shadow-lg w-64 py-1" do
      concat render(::Decor::DropdownItem.new(text: "Item 1", href: "#"))
      concat render(::Decor::DropdownItem.new(separator: true))
      concat render(::Decor::DropdownItem.new(text: "Item 2", href: "#"))
    end
  end

  # @label Multiple Items
  def multiple_items
    content_tag :div, class: "bg-white border rounded-lg shadow-lg w-64 py-1" do
      concat render(::Decor::DropdownItem.new(text: "Profile", href: "#", icon_name: "user"))
      concat render(::Decor::DropdownItem.new(text: "Settings", href: "#", icon_name: "cog"))
      concat render(::Decor::DropdownItem.new(separator: true))
      concat render(::Decor::DropdownItem.new(text: "Sign out", href: "#", icon_name: "logout", http_method: :delete))
    end
  end
end
