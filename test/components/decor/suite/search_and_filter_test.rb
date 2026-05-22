# frozen_string_literal: true

require "test_helper"

class ::Decor::Suite::SearchAndFilterTest < ActiveSupport::TestCase
  def search(value: "")
    ::Decor::Suite::SearchAndFilter::Search.new(name: "q", label: "Search", value: value)
  end

  def select_filter(value: "")
    ::Decor::Suite::SearchAndFilter::Filter.new(
      type: :select,
      name: "category",
      label: "Category",
      value: value,
      options: [["", "All"], ["electronics", "Electronics"]]
    )
  end

  def checkbox_filter(value: "")
    ::Decor::Suite::SearchAndFilter::Filter.new(
      type: :checkbox,
      name: "in_stock",
      label: "In stock",
      value: value
    )
  end

  def date_range_filter(value: "")
    ::Decor::Suite::SearchAndFilter::Filter.new(
      type: :date_range,
      name: "created_at",
      label: "Created at",
      value: value
    )
  end

  test "renders the combined pill with suite hairline-strong border + rounded-suite-control" do
    html = render_component(::Decor::Suite::SearchAndFilter.new(url: "/x", search: search))
    assert_includes html, "decor:border-suite-hairline-strong"
    assert_includes html, "decor:rounded-suite-control"
    assert_includes html, "decor:bg-white"
  end

  test "renders the search input with the configured name + value + placeholder" do
    html = render_component(::Decor::Suite::SearchAndFilter.new(url: "/x", search: search(value: "abc")))
    assert_includes html, 'name="q"'
    assert_includes html, 'value="abc"'
    assert_includes html, "decor:suite-description"
  end

  test "search input wires the stimulus target + keydown action" do
    html = render_component(::Decor::Suite::SearchAndFilter.new(url: "/x", search: search))
    assert_includes html, "decor--suite--search-and-filter-target=\"searchInput\""
    assert_includes html, "keydown->decor--suite--search-and-filter#handleSearchInputKeydown"
  end

  test "renders the filter toggle button with suite-gray-25 surface + hairline divider" do
    html = render_component(::Decor::Suite::SearchAndFilter.new(url: "/x", search: search, filters: [select_filter]))
    assert_includes html, "decor:bg-suite-gray-25"
    assert_includes html, "decor:border-suite-hairline"
    assert_includes html, ">Filter</span>"
  end

  test "filter toggle button wires the toggle action" do
    html = render_component(::Decor::Suite::SearchAndFilter.new(url: "/x", search: search, filters: [select_filter]))
    assert_includes html, "click->decor--suite--search-and-filter#toggle"
  end

  test "shows the active-filters badge in suite-primary tones when filters are set" do
    html = render_component(::Decor::Suite::SearchAndFilter.new(
      url: "/x",
      search: search,
      filters: [select_filter(value: "electronics"), checkbox_filter(value: "true")]
    ))
    assert_includes html, "decor:bg-suite-primary-100"
    assert_includes html, "decor:text-suite-primary-700"
    assert_includes html, ">2</span>"
  end

  test "omits the active-filters badge when no filters are set" do
    html = render_component(::Decor::Suite::SearchAndFilter.new(url: "/x", search: search, filters: [select_filter]))
    refute_includes html, "decor:bg-suite-primary-100"
  end

  test "renders the filter pill anchor-name style" do
    html = render_component(::Decor::Suite::SearchAndFilter.new(url: "/x", search: search, filters: [select_filter]))
    assert_includes html, "anchor-name: --decor-suite-saf-filter-"
  end

  test "renders the filter dropdown panel via Suite::Dropdown when filters are present" do
    html = render_component(::Decor::Suite::SearchAndFilter.new(url: "/x", search: search, filters: [select_filter]))
    assert_includes html, "decor--suite--dropdown-menu"
    assert_includes html, "popover=\"auto\""
  end

  test "omits the filter dropdown panel entirely when there are no filters" do
    html = render_component(::Decor::Suite::SearchAndFilter.new(url: "/x", search: search))
    refute_includes html, "decor--suite--dropdown-menu"
    refute_includes html, ">Filter</span>"
  end

  test "renders an Apply button in the footer" do
    html = render_component(::Decor::Suite::SearchAndFilter.new(url: "/x", search: search, filters: [select_filter]))
    assert_includes html, "Apply"
    assert_includes html, "click->decor--suite--search-and-filter#handleApply"
  end

  test "renders a Clear filters button only when filters are active" do
    off = render_component(::Decor::Suite::SearchAndFilter.new(url: "/x", search: search, filters: [select_filter]))
    refute_includes off, "Clear filters"

    on = render_component(::Decor::Suite::SearchAndFilter.new(
      url: "/x",
      search: search,
      filters: [select_filter(value: "electronics")]
    ))
    assert_includes on, "Clear filters"
    assert_includes on, "click->decor--suite--search-and-filter#handleClearFilters"
  end

  test "renders a CSV download button when download_path is set" do
    html = render_component(::Decor::Suite::SearchAndFilter.new(
      url: "/x",
      search: search,
      download_path: "/x/export"
    ))
    assert_includes html, "Download CSV"
    assert_includes html, 'href="/x/export"'
    assert_includes html, "decor:border-suite-hairline-strong"
  end

  test "omits the download button when download_path is nil" do
    html = render_component(::Decor::Suite::SearchAndFilter.new(url: "/x", search: search))
    refute_includes html, "Download CSV"
  end

  test "renders actions slot when set via with_actions" do
    component = ::Decor::Suite::SearchAndFilter.new(url: "/x", search: search)
      .with_actions { "<button id='custom-action'>Custom</button>".html_safe }
    html = render_component(component)
    assert_includes html, "id='custom-action'"
    assert_includes html, "Custom"
  end

  test "renders the date-range filter with the focus action wired to the range picker" do
    html = render_component(::Decor::Suite::SearchAndFilter.new(
      url: "/x",
      search: search,
      filters: [date_range_filter]
    ))
    assert_includes html, "focus->decor--suite--search-and-filter#handleRangePicker"
  end

  test "does NOT use daisyUI semantic chrome tokens" do
    html = render_component(::Decor::Suite::SearchAndFilter.new(url: "/x", search: search, filters: [select_filter]))
    refute_includes html, "decor:bg-primary-100"
    refute_includes html, "decor:bg-base-100"
    refute_includes html, "decor:bg-base-200"
    refute_includes html, "decor:rounded-md"
    refute_includes html, "decor:rounded-box"
    refute_includes html, "decor:border-black/10"
  end

  test "uses suite-fast motion token on the filter toggle" do
    html = render_component(::Decor::Suite::SearchAndFilter.new(url: "/x", search: search, filters: [select_filter]))
    assert_includes html, "decor:duration-suite-fast"
  end
end
