# frozen_string_literal: true

# Composes a Suite::Nav::SideNavbar (slot DSL composes in Phlex, not ERB) so the
# Suite navigation demo can render a real, populated rail — with an expandable
# sub-item group — for the system test to drive.
class Demo::SuiteSidebarExample < Phlex::HTML
  LOGO = "data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw=="

  def view_template
    navbar = ::Decor::Suite::Nav::SideNavbar.new(
      app_title: "Demo App",
      landscape_logo_url: LOGO,
      avatar_logo_url: LOGO
    )
    navbar.with_section(title: "Main") do |section|
      section.with_item(title: "Dashboard", path: "/", icon: "home")
      section.with_item(title: "Reports", path: "#", icon: "chart-bar") do |item|
        item.with_sub_item(title: "Sales", path: "#")
        item.with_sub_item(title: "Traffic", path: "#")
      end
      section.with_item(title: "Settings", path: "#", icon: "settings")
    end
    render navbar
  end
end
