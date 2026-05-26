# frozen_string_literal: true

# Composes a Daisy SideNavbar (sections/items use block slots — Phlex context)
# so the navigation demo can render a real, populated sidebar for the system
# test to drive (mobile drawer, desktop collapse, search filter).
class Demo::SidebarExample < Phlex::HTML
  # 1x1 transparent gif so the logo <img> doesn't fire a stray request.
  LOGO = "data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw=="

  def view_template
    navbar = ::Decor::Daisy::Nav::SideNavbar.new(
      app_title: "Demo App",
      landscape_logo_url: LOGO,
      avatar_logo_url: LOGO
    )
    navbar.with_section(title: "Main") do |section|
      section.with_item(title: "Dashboard", path: "/")
      section.with_item(title: "Reports", path: "#")
      section.with_item(title: "Settings", path: "#")
    end
    render navbar
  end
end
