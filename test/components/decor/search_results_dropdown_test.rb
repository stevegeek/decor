require "test_helper"

class Decor::SearchResultsDropdownTest < ActiveSupport::TestCase
  def setup
    # Create a proper vident component for testing
    @nav_element = Decor::Nav::TopNavbar.new
  end

  test "renders successfully with nav element" do
    component = Decor::SearchResultsDropdown.new(nav_element: @nav_element)
    rendered = render_component(component)

    assert_includes rendered, "hidden absolute top-full"
    assert_includes rendered, "h-[375px]"
    assert_includes rendered, "border-l border-r border-b border-gray-200"
  end

  test "includes shadow element" do
    component = Decor::SearchResultsDropdown.new(nav_element: @nav_element)
    rendered = render_component(component)

    assert_includes rendered, "absolute inset-0 top-1/2 bg-white shadow-xl"
    assert_includes rendered, 'aria-hidden="true"'
  end

  test "includes spinner element with nav element target" do
    component = Decor::SearchResultsDropdown.new(nav_element: @nav_element)
    rendered = render_component(component)

    assert_includes rendered, "flex items-center h-full"
    assert_includes rendered, 'data-decor--nav--top-navbar-target="searchSpinner"'
  end

  test "includes search dropdown content area" do
    component = Decor::SearchResultsDropdown.new(nav_element: @nav_element)
    rendered = render_component(component)

    assert_includes rendered, "hidden max-w-7xl mx-auto px-8 h-full overflow-y-scroll lg:overflow-auto"
    assert_includes rendered, 'data-decor--nav--top-navbar-target="searchDropdownContent"'
  end

  test "renders spinner component" do
    component = Decor::SearchResultsDropdown.new(nav_element: @nav_element)
    rendered = render_component(component)

    assert_includes rendered, "loading"
    assert_includes rendered, "loading-spinner"
    assert_includes rendered, "mx-auto"
  end

  test "applies correct CSS classes" do
    component = Decor::SearchResultsDropdown.new(nav_element: @nav_element)
    rendered = render_component(component)

    assert_includes rendered, "text-sm text-gray-500"
    assert_includes rendered, "relative bg-white h-full overflow-hidden"
  end

  test "nav element targets are properly assigned" do
    component = Decor::SearchResultsDropdown.new(nav_element: @nav_element)
    rendered = render_component(component)

    # Verify the nav element target method was called with correct parameters
    assert_includes rendered, 'data-decor--nav--top-navbar-target="searchSpinner"'
    assert_includes rendered, 'data-decor--nav--top-navbar-target="searchDropdownContent"'
  end

  test "uses nokogiri for parsing" do
    component = Decor::SearchResultsDropdown.new(nav_element: @nav_element)
    fragment = render_fragment(component)

    # Check the main dropdown container
    dropdown = fragment.at_css(".hidden.absolute.top-full")
    assert_not_nil dropdown
    assert_includes dropdown["class"], "h-[375px]"

    # Check shadow element
    shadow = fragment.at_css('.absolute.inset-0.top-1\\/2')
    assert_not_nil shadow
    assert_equal "true", shadow["aria-hidden"]

    # Check spinner container
    spinner_container = fragment.at_css('[data-decor--nav--top-navbar-target="searchSpinner"]')
    assert_not_nil spinner_container
    assert_includes spinner_container["class"], "flex items-center h-full"

    # Check content area
    content_area = fragment.at_css('[data-decor--nav--top-navbar-target="searchDropdownContent"]')
    assert_not_nil content_area
    assert_includes content_area["class"], "hidden"
  end
end
