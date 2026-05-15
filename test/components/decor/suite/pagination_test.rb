# frozen_string_literal: true

require "test_helper"

class ::Decor::Suite::PaginationTest < ActiveSupport::TestCase
  class TestCollection < Quo::CollectionBackedQuery
    def collection
      (1..total_count_value).to_a
    end

    def total_count_value
      @total_count_value || 100
    end

    def self.with_total(count)
      Class.new(self) do
        define_method(:total_count_value) { count }
      end
    end
  end

  def collection_for(total:, page:, page_size:)
    klass = TestCollection.with_total(total)
    klass.new(page: page, page_size: page_size)
  end

  test "renders the Suite root with hairline divider and gray-25 surface" do
    component = ::Decor::Suite::Pagination.new(
      current_page: 1,
      page_size: 10,
      path: "/items",
      collection: collection_for(total: 100, page: 1, page_size: 10)
    )
    html = render_component(component)

    assert_includes html, "decor:border-suite-hairline"
    assert_includes html, "decor:bg-suite-gray-25"
  end

  test "results summary uses suite-description typography and tabular nums" do
    component = ::Decor::Suite::Pagination.new(
      current_page: 2,
      page_size: 10,
      path: "/items",
      collection: collection_for(total: 25, page: 2, page_size: 10)
    )
    html = render_component(component)

    assert_includes html, "decor:suite-description"
    assert_includes html, "decor:font-tabular-nums"
    assert_includes html, "Showing "
    assert_includes html, "11" # start_index
    assert_includes html, "20" # end_index
    assert_includes html, "25" # total_count
    assert_includes html, "of"
    assert_includes html, "results"
  end

  test "renders prev/next chevron icons (Tabler)" do
    component = ::Decor::Suite::Pagination.new(
      current_page: 5,
      page_size: 10,
      path: "/items",
      collection: collection_for(total: 100, page: 5, page_size: 10)
    )
    html = render_component(component)

    assert_includes html, "tabler-chevron-left"
    assert_includes html, "tabler-chevron-right"
    assert_includes html, "Previous"
    assert_includes html, "Next"
  end

  test "prev button is disabled-styled on the first page" do
    component = ::Decor::Suite::Pagination.new(
      current_page: 1,
      page_size: 10,
      path: "/items",
      collection: collection_for(total: 100, page: 1, page_size: 10)
    )
    html = render_component(component)

    # Disabled visual cues
    assert_includes html, "decor:pointer-events-none"
    assert_includes html, "decor:opacity-40"
    assert_includes html, 'aria-disabled="true"'
  end

  test "next button is disabled-styled on the last page" do
    component = ::Decor::Suite::Pagination.new(
      current_page: 10,
      page_size: 10,
      path: "/items",
      collection: collection_for(total: 100, page: 10, page_size: 10)
    )
    html = render_component(component)

    assert_includes html, "decor:pointer-events-none"
    assert_includes html, "decor:opacity-40"
    assert_includes html, 'aria-disabled="true"'
  end

  test "current page link uses suite-primary palette" do
    component = ::Decor::Suite::Pagination.new(
      current_page: 3,
      page_size: 10,
      path: "/items",
      collection: collection_for(total: 100, page: 3, page_size: 10)
    )
    html = render_component(component)

    assert_includes html, "decor:border-suite-primary-200"
    assert_includes html, "decor:text-suite-primary-700"
    assert_includes html, 'aria-current="page"'
  end

  test "uses suite-control radius on page hit targets" do
    component = ::Decor::Suite::Pagination.new(
      current_page: 2,
      page_size: 10,
      path: "/items",
      collection: collection_for(total: 100, page: 2, page_size: 10)
    )
    html = render_component(component)

    assert_includes html, "decor:rounded-suite-control"
  end

  test "uses suite-fast duration for micro-interactions" do
    component = ::Decor::Suite::Pagination.new(
      current_page: 2,
      page_size: 10,
      path: "/items",
      collection: collection_for(total: 100, page: 2, page_size: 10)
    )
    html = render_component(component)

    assert_includes html, "decor:duration-suite-fast"
  end

  test "renders an ellipsis when there are many pages" do
    component = ::Decor::Suite::Pagination.new(
      current_page: 50,
      page_size: 10,
      path: "/items",
      collection: collection_for(total: 1000, page: 50, page_size: 10)
    )
    html = render_component(component)

    assert_includes html, "…"
  end

  test "no page-size selector rendered by default" do
    component = ::Decor::Suite::Pagination.new(
      current_page: 1,
      page_size: 10,
      path: "/items",
      collection: collection_for(total: 100, page: 1, page_size: 10)
    )
    html = render_component(component)

    refute_includes html, "Per page:"
  end

  test "page-size selector renders chip links when enabled" do
    component = ::Decor::Suite::Pagination.new(
      current_page: 1,
      page_size: 10,
      path: "/items",
      page_size_selector: true,
      collection: collection_for(total: 100, page: 1, page_size: 10)
    )
    html = render_component(component)

    assert_includes html, "Per page:"
    # Each standard page size renders as an anchor (chip) — verify the labels
    # appear inside link tags
    assert_includes html, ">10<"
    assert_includes html, ">20<"
    # Active size carries the suite-primary palette and aria-current
    assert_includes html, 'aria-current="true"'
  end

  test "uses turbo-action=replace on navigation links" do
    component = ::Decor::Suite::Pagination.new(
      current_page: 2,
      page_size: 10,
      path: "/items",
      collection: collection_for(total: 100, page: 2, page_size: 10)
    )
    html = render_component(component)

    assert_includes html, 'data-turbo-action="replace"'
  end

  test "does not delegate to Daisy chrome" do
    component = ::Decor::Suite::Pagination.new(
      current_page: 1,
      page_size: 10,
      path: "/items",
      page_size_selector: true,
      collection: collection_for(total: 100, page: 1, page_size: 10)
    )
    html = render_component(component)

    refute_includes html, "decor:d-join"
    refute_includes html, "decor:d-btn"
    refute_includes html, "decor:bg-base-100"
  end

  test "ten-item dataset renders without ellipsis" do
    component = ::Decor::Suite::Pagination.new(
      current_page: 1,
      page_size: 5,
      path: "/items",
      collection: collection_for(total: 10, page: 1, page_size: 5)
    )
    html = render_component(component)

    refute_includes html, "…"
  end

  test "thousand-item dataset uses ellipsis pages" do
    component = ::Decor::Suite::Pagination.new(
      current_page: 25,
      page_size: 20,
      path: "/items",
      collection: collection_for(total: 1000, page: 25, page_size: 20)
    )
    html = render_component(component)

    assert_includes html, "…"
    # current page marker present
    assert_includes html, 'aria-current="page"'
  end
end
