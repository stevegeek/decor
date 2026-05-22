# @label DropdownItem
class ::Decor::Suite::DropdownItemPreview < ::Lookbook::Preview
  # @group Variants
  # @label Default item
  def default_item
    render ::Decor::Suite::DropdownItem.new(text: "Menu item")
  end

  # @group Variants
  # @label With icon
  def with_icon
    render ::Decor::Suite::DropdownItem.new(text: "Settings", icon_name: "settings")
  end

  # @group Variants
  # @label With shortcut
  def with_shortcut
    render ::Decor::Suite::DropdownItem.new(text: "Save", icon_name: "save", shortcut: "Cmd+S")
  end

  # @group Variants
  # @label Danger
  def danger_item
    render ::Decor::Suite::DropdownItem.new(text: "Delete", icon_name: "trash", danger: true)
  end

  # @group Variants
  # @label Separator
  def separator_item
    render ::Decor::Suite::DropdownItem.new(separator: true)
  end

  # @group Variants
  # @label Section label
  def section_label_item
    render ::Decor::Suite::DropdownItem.new(section_label: true, text: "Account")
  end

  # @group Playground
  # @param text text
  # @param icon_name text
  # @param shortcut text
  # @param danger toggle
  # @param separator toggle
  # @param section_label toggle
  def playground(text: "Item", icon_name: nil, shortcut: nil, danger: false, separator: false, section_label: false)
    render ::Decor::Suite::DropdownItem.new(
      text: text,
      icon_name: icon_name.presence,
      shortcut: shortcut.presence,
      danger: danger,
      separator: separator,
      section_label: section_label
    )
  end
end
