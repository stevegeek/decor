# @label TopNavbar
class ::Decor::Nav::TopNavbarPreview < ::Lookbook::Preview
  # @param has_search toggle
  def playground(has_search: true)
    render ::Decor::Nav::TopNavbar.new(has_search: has_search) do |navbar|
      navbar.with_account_menu(menu_position: :aligned_to_right, html_options: {class: "ml-3"}) do |menu|
        menu.with_button_content do
          menu.render ::Decor::Avatar.new(initials: "C C")
        end
        menu.with_menu_item(
          text: "Account menu here", href: "#", actions: [[:click, menu.default_controller_path, :hide]]
        )
      end

      navbar.with_notifications_menu(
        button_classes: [
          "bg-white", "p-1", "rounded-full", "text-gray-400", "hover:text-gray-500", "focus:outline-none", "focus:ring-2", "focus:ring-offset-2", "focus:ring-indigo-500"
        ],
        menu_position: :aligned_to_right,
        html_options: {class: "ml-4 flex items-center md:ml-6"}
      ) do |menu|
        menu.with_button_content do
          "<span class=\"sr-only\">View notifications</span>".html_safe + menu.render(
            ::Decor::Icon.new(name: "bell", html_options: {class: "h-6 w-6"})
          )
        end
        menu.with_menu_item(
          text: "Notifications!", href: "#", actions: [[:click, menu.default_controller_path, :hide]]
        )
      end
    end
  end
end
