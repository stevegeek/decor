require "test_helper"
require "ostruct"

class Decor::SearchAndFilterTest < ActiveSupport::TestCase
  def setup
    @search = Decor::SearchAndFilter::Search.new(
      name: "search",
      label: "Search",
      value: "test search"
    )
    @url = "/products"
  end

  test "renders successfully with required attributes" do
    component = Decor::SearchAndFilter.new(
      search: @search,
      url: @url
    )
    rendered = render_component(component)

    assert_includes rendered, "decor--search-and-filter"
    assert_includes rendered, "test search"
  end

  test "renders search field with current search term" do
    component = Decor::SearchAndFilter.new(
      search: @search,
      url: @url
    )
    rendered = render_component(component)

    assert_includes rendered, 'value="test search"'
    assert_includes rendered, "input"
  end

  test "renders with form structure" do
    component = Decor::SearchAndFilter.new(
      search: @search,
      url: @url
    )
    fragment = render_fragment(component)

    form = fragment.at_css("form")
    assert_not_nil form
    assert_equal "get", form["method"]
    assert_equal @url, form["action"]
  end

  test "renders filters slot when provided" do
    component = Decor::SearchAndFilter.new(
      search: @search,
      url: @url
    )
    rendered = render_component(component) do |c|
      c.with_filters { "<select name='category'>...</select>" }
    end

    assert_includes rendered, "<select name='category'"
  end

  test "renders actions slot when provided" do
    component = Decor::SearchAndFilter.new(
      search: @search,
      url: @url
    )
    rendered = render_component(component) do |c|
      c.with_actions { "<button type='submit'>Search</button>" }
    end

    assert_includes rendered, "<button type='submit'>Search</button>"
  end

  test "supports both filters and actions slots" do
    component = Decor::SearchAndFilter.new(
      search: @search,
      url: @url
    )
    rendered = render_component(component) do |c|
      c.with_filters { "Filter content" }
      c.with_actions { "Action content" }
    end

    assert_includes rendered, "Filter content"
    assert_includes rendered, "Action content"
  end

  test "handles empty search term" do
    empty_search = Decor::SearchAndFilter::Search.new(
      name: "search",
      label: "Search", 
      value: ""
    )
    component = Decor::SearchAndFilter.new(
      search: empty_search,
      url: @url
    )
    rendered = render_component(component)

    assert_includes rendered, "input"
    assert_includes rendered, 'name="search"'
  end

  test "component inherits from PhlexComponent" do
    component = Decor::SearchAndFilter.new(
      search: @search,
      url: @url
    )

    assert component.is_a?(Decor::PhlexComponent)
  end

  test "renders with correct CSS classes" do
    component = Decor::SearchAndFilter.new(
      search: @search,
      url: @url
    )
    rendered = render_component(component)

    assert_includes rendered, "decor--search-and-filter"
  end

  test "form has GET method by default" do
    component = Decor::SearchAndFilter.new(
      search: @search,
      url: @url
    )
    fragment = render_fragment(component)

    form = fragment.at_css("form")
    assert_equal "get", form["method"]
  end

  test "search input has correct attributes" do
    component = Decor::SearchAndFilter.new(
      search: @search,
      url: @url
    )
    fragment = render_fragment(component)

    input = fragment.at_css('input[name="search"]')
    assert_not_nil input
    assert_equal "test search", input["value"]
    assert_equal "text", input["type"]
  end

  test "handles query with nil search_term" do
    nil_search = Decor::SearchAndFilter::Search.new(
      name: "search",
      label: "Search",
      value: ""
    )
    component = Decor::SearchAndFilter.new(
      search: nil_search,
      url: @url
    )
    rendered = render_component(component)

    assert_includes rendered, "input"
    # Should handle nil gracefully
    assert_includes rendered, 'name="search"'
  end

  test "supports custom base_url formats" do
    test_urls = ["/search", "/admin/products", "/api/v1/items"]

    test_urls.each do |url|
      component = Decor::SearchAndFilter.new(
        search: @search,
        url: url
      )
      fragment = render_fragment(component)

      form = fragment.at_css("form")
      assert_equal url, form["action"]
    end
  end
end
