require "test_helper"

class Decor::Daisy::SearchResultsDropdownTest < ActiveSupport::TestCase
  def setup
    @nav_element = Decor::Daisy::Nav::TopNavbar.new
  end

  test "renders successfully with nav element" do
    component = Decor::Daisy::SearchResultsDropdown.new(nav_element: @nav_element)
    rendered = render_component(component)

    assert_includes rendered, "decor:hidden decor:absolute decor:top-full"
    assert_includes rendered, "decor:h-[375px]"
    assert_includes rendered, "decor:border-l decor:border-r decor:border-b decor:border-gray-200"
  end

  test "includes shadow element" do
    component = Decor::Daisy::SearchResultsDropdown.new(nav_element: @nav_element)
    rendered = render_component(component)

    assert_includes rendered, "decor:absolute decor:inset-0 decor:top-1/2 decor:bg-white decor:shadow-xl"
    assert_includes rendered, 'aria-hidden="true"'
  end

  test "includes spinner element with nav element target" do
    component = Decor::Daisy::SearchResultsDropdown.new(nav_element: @nav_element)
    rendered = render_component(component)

    assert_includes rendered, "decor:flex decor:items-center decor:h-full"
    assert_includes rendered, 'data-decor--daisy--nav--top-navbar-target="searchSpinner"'
  end

  test "includes search dropdown content area" do
    component = Decor::Daisy::SearchResultsDropdown.new(nav_element: @nav_element)
    rendered = render_component(component)

    assert_includes rendered, "decor:hidden decor:max-w-7xl decor:mx-auto decor:px-8 decor:h-full decor:overflow-y-scroll decor:lg:overflow-auto"
    assert_includes rendered, 'data-decor--daisy--nav--top-navbar-target="searchDropdownContent"'
  end

  test "renders spinner component" do
    component = Decor::Daisy::SearchResultsDropdown.new(nav_element: @nav_element)
    rendered = render_component(component)

    assert_includes rendered, "decor:d-loading"
    assert_includes rendered, "decor:d-loading-spinner"
    assert_includes rendered, "decor:mx-auto"
  end

  test "applies correct CSS classes" do
    component = Decor::Daisy::SearchResultsDropdown.new(nav_element: @nav_element)
    rendered = render_component(component)

    assert_includes rendered, "decor:text-sm decor:text-gray-500"
    assert_includes rendered, "decor:relative decor:bg-white decor:h-full decor:overflow-hidden"
  end

  test "nav element targets are properly assigned" do
    component = Decor::Daisy::SearchResultsDropdown.new(nav_element: @nav_element)
    rendered = render_component(component)

    assert_includes rendered, 'data-decor--daisy--nav--top-navbar-target="searchSpinner"'
    assert_includes rendered, 'data-decor--daisy--nav--top-navbar-target="searchDropdownContent"'
  end

  test "uses nokogiri for parsing" do
    component = Decor::Daisy::SearchResultsDropdown.new(nav_element: @nav_element)
    fragment = render_fragment(component)

    dropdown = fragment.at_css('[class~="decor:hidden"][class~="decor:absolute"][class~="decor:top-full"]')
    assert_not_nil dropdown
    assert_includes dropdown["class"], "decor:h-[375px]"

    shadow = fragment.at_css('[class~="decor:absolute"][class~="decor:inset-0"][class~="decor:top-1/2"]')
    assert_not_nil shadow
    assert_equal "true", shadow["aria-hidden"]

    spinner_container = fragment.at_css('[data-decor--daisy--nav--top-navbar-target="searchSpinner"]')
    assert_not_nil spinner_container
    assert_includes spinner_container["class"], "decor:flex decor:items-center decor:h-full"

    content_area = fragment.at_css('[data-decor--daisy--nav--top-navbar-target="searchDropdownContent"]')
    assert_not_nil content_area
    assert_includes content_area["class"], "decor:hidden"
  end
end
