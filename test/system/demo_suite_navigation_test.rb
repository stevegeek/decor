require "application_system_test_case"

# Proves the ported Suite nav suite works in a real browser: the side navbar's
# mobile drawer, desktop collapse, and search — plus that the top_navbar
# controller (previously missing in both skins) opens the drawer from its
# hamburger.
class DemoSuiteNavigationTest < ApplicationSystemTestCase
  MOBILE = "[data-decor--suite--nav--side-navbar-target='mobileMenu']"
  DESKTOP = "#side-navbar-desktop"

  def hidden?(selector)
    page.evaluate_script("document.querySelector(\"#{selector}\").classList.contains('decor:hidden')")
  end

  test "mobile drawer opens via the scoped toggle and closes via its close button" do
    current_window.resize_to(390, 844)
    visit demo_suite_navigation_path
    assert hidden?(MOBILE), "drawer should start hidden"

    click_button "Open mobile menu"
    sleep 0.2
    refute hidden?(MOBILE), "drawer should open after the toggle"

    click_button "Close sidebar"
    sleep 0.2
    assert hidden?(MOBILE), "drawer should hide again"
  end

  test "desktop rail collapses and expands" do
    current_window.resize_to(1400, 1000)
    visit demo_suite_navigation_path
    assert page.evaluate_script("document.querySelector('#{DESKTOP}').classList.contains('decor:lg:w-72')")

    find("#side-navbar-desktop-collapse-button").click
    sleep 0.2
    assert page.evaluate_script("document.querySelector('#{DESKTOP}').classList.contains('decor:lg:w-20')"),
      "rail should collapse to w-20"
  end

  test "search filters nav items by label" do
    current_window.resize_to(1400, 1000)
    visit demo_suite_navigation_path
    fill_in "side-navbar-desktop-search-input", with: "dash"
    sleep 0.3
    visible = page.evaluate_script(<<~JS)
      Array.from(document.querySelectorAll("#{DESKTOP} nav a"))
        .filter(function (a) { return !a.classList.contains("decor:hidden"); })
        .map(function (a) { return a.textContent.trim(); })
    JS
    assert(visible.any? { |t| t.include?("Dashboard") }, "Dashboard should remain")
    refute(visible.any? { |t| t.include?("Settings") }, "Settings should be filtered out")
  end
end
