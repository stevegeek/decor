require "application_system_test_case"

# Proves the SideNavbar controller (which previously did not exist — the
# component referenced a controller that was never shipped, so all of this was
# dead) actually drives the mobile drawer, the desktop collapse, and search.
class DemoDaisyNavigationTest < ApplicationSystemTestCase
  MOBILE = "[data-decor--daisy--nav--side-navbar-target='mobileMenu']"
  DESKTOP = "#side-navbar-desktop"

  def hidden?(selector)
    page.evaluate_script("document.querySelector(\"#{selector}\").classList.contains('decor:hidden')")
  end

  test "mobile drawer opens via the scoped toggle event and closes via its close button" do
    # Phone width: the desktop rail is display:none, so the drawer is the nav.
    current_window.resize_to(390, 844)
    visit demo_daisy_navigation_path
    assert hidden?(MOBILE), "drawer should start hidden"

    click_button "Open mobile menu"
    sleep 0.2
    refute hidden?(MOBILE), "drawer should be visible after the toggle event"

    click_button "Close sidebar"
    sleep 0.2
    assert hidden?(MOBILE), "drawer should hide again after its close button"
  end

  test "desktop rail collapses and expands" do
    current_window.resize_to(1400, 1000) # lg: desktop rail visible
    visit demo_daisy_navigation_path
    assert page.evaluate_script("document.querySelector('#{DESKTOP}').classList.contains('decor:lg:w-64')"),
      "rail should start expanded (w-72)"

    find("#side-navbar-desktop-collapse-button").click
    sleep 0.2
    assert page.evaluate_script("document.querySelector('#{DESKTOP}').classList.contains('decor:lg:w-20')"),
      "rail should collapse to w-20"

    find("#side-navbar-desktop-collapse-button").click
    sleep 0.2
    assert page.evaluate_script("document.querySelector('#{DESKTOP}').classList.contains('decor:lg:w-64')"),
      "rail should expand back to w-72"
  end

  test "search filters nav items by label" do
    current_window.resize_to(1400, 1000) # lg: desktop rail (and its search) visible
    visit demo_daisy_navigation_path
    fill_in "side-navbar-desktop-search-input", with: "report"
    sleep 0.3

    visible = page.evaluate_script(<<~JS)
      Array.from(document.querySelectorAll("#{DESKTOP} nav a"))
        .filter(function (a) { return !a.classList.contains("decor:hidden"); })
        .map(function (a) { return a.textContent.trim(); })
    JS
    assert(visible.any? { |t| t.include?("Reports") }, "Reports should remain visible")
    refute(visible.any? { |t| t.include?("Dashboard") }, "Dashboard should be filtered out")
  end
end
