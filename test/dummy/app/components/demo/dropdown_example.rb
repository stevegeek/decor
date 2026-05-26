# frozen_string_literal: true

# Composes a Suite::Dropdown in a Phlex context (its trigger/menu slots take
# blocks, which compose in Phlex but not in ERB), so the overlays demo can
# render a real, fully-populated dropdown for the system test to drive.
class Demo::DropdownExample < Phlex::HTML
  def view_template
    dropdown = ::Decor::Suite::Dropdown.new(menu_position: :aligned_to_left)
    dropdown.trigger_button_content { plain "Open menu" }
    dropdown.with_menu_item(text: "Edit", href: "#")
    dropdown.with_menu_item(text: "Duplicate", href: "#")
    dropdown.with_menu_item(separator: true)
    dropdown.with_menu_item(text: "Delete", href: "#", danger: true)
    render dropdown
  end
end
