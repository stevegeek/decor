require "test_helper"

class Decor::SearchResultsDropdownTest < ActiveSupport::TestCase
  def setup
    # Create a simple object that responds to the methods we need
    @nav_element = Object.new
    def @nav_element.as_target(target_name)
      {"data-target" => "nav--#{target_name}"}
    end

    def @nav_element.parse_targets(targets)
      {controller: "nav", targets: targets}
    end

    def @nav_element.build_target_data_attributes(attrs)
      result = {}
      attrs[:targets]&.each do |target|
        result[:target] = "nav--#{target}"
      end
      result
    end

    # Pretend it's the right type for testing purposes
    def @nav_element.is_a?(klass)
      klass == Vident::RootComponent || super
    end

    def @nav_element.kind_of?(klass)
      klass == Vident::RootComponent || super
    end
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
    assert_includes rendered, 'data-target="nav--search_spinner"'
  end

  test "includes search dropdown content area" do
    component = Decor::SearchResultsDropdown.new(nav_element: @nav_element)
    rendered = render_component(component)

    assert_includes rendered, "hidden max-w-7xl mx-auto px-8 h-full overflow-y-scroll lg:overflow-auto"
    assert_includes rendered, 'data-target="nav--search_dropdown_content"'
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
    assert_includes rendered, 'data-target="nav--search_spinner"'
    assert_includes rendered, 'data-target="nav--search_dropdown_content"'
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
    spinner_container = fragment.at_css('[data-target="nav--search_spinner"]')
    assert_not_nil spinner_container
    assert_includes spinner_container["class"], "flex items-center h-full"

    # Check content area
    content_area = fragment.at_css('[data-target="nav--search_dropdown_content"]')
    assert_not_nil content_area
    assert_includes content_area["class"], "hidden"
  end
end
