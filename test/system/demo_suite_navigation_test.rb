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

  test "top navbar hamburger opens the mobile drawer" do
    current_window.resize_to(390, 844)
    visit demo_suite_navigation_path
    assert hidden?(MOBILE), "drawer should start hidden"

    find("button[data-action*='nav--top-navbar#toggleMobileMenu']", match: :first).click
    sleep 0.2
    refute hidden?(MOBILE), "the top-navbar hamburger should open the drawer"
  end

  test "desktop rail collapses and expands" do
    current_window.resize_to(1400, 1000)
    visit demo_suite_navigation_path
    assert page.evaluate_script("document.querySelector('#{DESKTOP}').classList.contains('decor:lg:w-64')")

    find("#side-navbar-desktop-collapse-button").click
    sleep 0.2
    assert page.evaluate_script("document.querySelector('#{DESKTOP}').classList.contains('decor:lg:w-20')"),
      "rail should collapse to w-20"
  end

  test "collapsing shifts the page content and persists across reload" do
    current_window.resize_to(1400, 1000)
    visit demo_suite_navigation_path
    content_pl = lambda do
      page.evaluate_script(
        "parseInt(getComputedStyle(document.querySelector('.decor--side-navbar-content')).paddingLeft)"
      )
    end
    assert_operator content_pl.call, :>, 240, "content should be inset by the expanded rail width"

    find("#side-navbar-desktop-collapse-button").click
    sleep 0.4
    assert_operator content_pl.call, :<, 120, "content should shift left to the collapsed rail width"

    # Reload: the cookie should restore the collapsed state (no flash).
    visit demo_suite_navigation_path
    sleep 0.3
    assert page.evaluate_script("document.querySelector('#side-navbar-desktop').classList.contains('decor:lg:w-20')"),
      "collapsed state should persist across reload (cookie)"
    assert_operator content_pl.call, :<, 120, "content should still be collapsed-width after reload"
  end

  test "dark variant renders Navigo's dark rail" do
    current_window.resize_to(1400, 1000)
    visit demo_suite_navigation_path(dark: 1)
    bg = page.evaluate_script("getComputedStyle(document.querySelector('#side-navbar-desktop > div')).backgroundColor")
    assert_equal "rgb(26, 31, 41)", bg, "dark rail should use Navigo's #1a1f29"
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
