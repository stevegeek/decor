# @label Dropdown
class ::Decor::Suite::DropdownPreview < ::Lookbook::Preview
  # @group Examples
  # @label Basic menu
  def basic_menu
    render ::Decor::Suite::Dropdown.new do |d|
      d.trigger_button_content { "Options" }
      d.menu_item(::Decor::Suite::DropdownItem.new(text: "Edit", icon_name: "pencil"))
      d.menu_item(::Decor::Suite::DropdownItem.new(text: "Duplicate", icon_name: "copy"))
      d.menu_item(::Decor::Suite::DropdownItem.new(separator: true))
      d.menu_item(::Decor::Suite::DropdownItem.new(text: "Delete", icon_name: "trash", danger: true, http_method: :delete))
    end
  end

  # @group Examples
  # @label With section labels
  def with_section_labels
    render ::Decor::Suite::Dropdown.new do |d|
      d.trigger_button_content { "Menu" }
      d.menu_item(::Decor::Suite::DropdownItem.new(section_label: true, text: "Account"))
      d.menu_item(::Decor::Suite::DropdownItem.new(text: "Profile", icon_name: "user"))
      d.menu_item(::Decor::Suite::DropdownItem.new(text: "Settings", icon_name: "settings"))
      d.menu_item(::Decor::Suite::DropdownItem.new(separator: true))
      d.menu_item(::Decor::Suite::DropdownItem.new(section_label: true, text: "Workspace"))
      d.menu_item(::Decor::Suite::DropdownItem.new(text: "Billing", icon_name: "credit-card"))
      d.menu_item(::Decor::Suite::DropdownItem.new(text: "Team", icon_name: "users"))
      d.menu_item(::Decor::Suite::DropdownItem.new(separator: true))
      d.menu_item(::Decor::Suite::DropdownItem.new(text: "Sign out", icon_name: "logout"))
    end
  end

  # @group Examples
  # @label With keyboard shortcuts
  def with_shortcuts
    render ::Decor::Suite::Dropdown.new do |d|
      d.trigger_button_content { "File" }
      d.menu_item(::Decor::Suite::DropdownItem.new(text: "New", icon_name: "plus", shortcut: "Cmd+N"))
      d.menu_item(::Decor::Suite::DropdownItem.new(text: "Open", icon_name: "folder", shortcut: "Cmd+O"))
      d.menu_item(::Decor::Suite::DropdownItem.new(text: "Save", icon_name: "save", shortcut: "Cmd+S"))
    end
  end

  # @group Examples
  # @label Aligned to right
  def aligned_to_right
    render ::Decor::Suite::Dropdown.new(menu_position: :aligned_to_right) do |d|
      d.trigger_button_content { "Right-aligned" }
      d.menu_item(::Decor::Suite::DropdownItem.new(text: "Option A"))
      d.menu_item(::Decor::Suite::DropdownItem.new(text: "Option B"))
      d.menu_item(::Decor::Suite::DropdownItem.new(text: "Option C"))
    end
  end

  # @group Examples
  # @label Lazy-loaded content
  def lazy_loaded
    render ::Decor::Suite::Dropdown.new(content_href: "/some-fragment.html", placeholder: "Loading...") do |d|
      d.trigger_button_content { "Open to load" }
    end
  end

  # @group Examples
  # @label Custom trigger
  def custom_trigger
    render ::Decor::Suite::Dropdown.new do |d|
      d.trigger_button do
        d.send(:button, type: "button", **d.trigger_attributes, class: "decor:px-3 decor:py-1.5 decor:bg-suite-primary-500 decor:text-white decor:rounded-suite-control") do
          d.send(:plain, "Custom")
        end
      end
      d.menu_item(::Decor::Suite::DropdownItem.new(text: "Item 1"))
      d.menu_item(::Decor::Suite::DropdownItem.new(text: "Item 2"))
    end
  end

  # @group Playground
  # @param menu_position select [aligned_to_left, aligned_to_right]
  # @param content_href text
  # @param placeholder text
  def playground(menu_position: :aligned_to_left, content_href: nil, placeholder: nil)
    render ::Decor::Suite::Dropdown.new(
      menu_position: menu_position,
      content_href: content_href.presence,
      placeholder: placeholder.presence
    ) do |d|
      d.trigger_button_content { "Menu" }
      d.menu_item(::Decor::Suite::DropdownItem.new(text: "First", icon_name: "star"))
      d.menu_item(::Decor::Suite::DropdownItem.new(text: "Second", icon_name: "heart"))
      d.menu_item(::Decor::Suite::DropdownItem.new(separator: true))
      d.menu_item(::Decor::Suite::DropdownItem.new(text: "Danger zone", danger: true, icon_name: "trash"))
    end
  end
end
