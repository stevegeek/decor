require "test_helper"

class Decor::PaginationTest < ActiveSupport::TestCase
  class TestCollection < Quo::CollectionBackedQuery
    def collection
      (1..100).to_a
    end
  end

  def setup
    @collection = TestCollection.new(total_count: 100, page: 1, page_size: 10)
  end

  test "renders successfully with valid attributes" do
    component = Decor::Pagination.new(collection: @collection, path: "/items")
    rendered = render_component(component)

    assert_includes rendered, "Previous"
    assert_includes rendered, "Next"
  end

  test "computes correct start index for page 1" do
    collection = TestCollection.new(page: 1, page_size: 2, total_count: 5)
    component = Decor::Pagination.new(collection: collection, path: "/items")

    assert_equal 1, component.send(:start_index)
  end

  test "computes correct start index for page 2" do
    collection = TestCollection.new(page: 2, page_size: 2, total_count: 5)
    component = Decor::Pagination.new(collection: collection, path: "/items")

    assert_equal 3, component.send(:start_index)
  end

  test "computes correct end index" do
    collection = TestCollection.new(page: 1, page_size: 2, total_count: 5)
    component = Decor::Pagination.new(collection: collection, path: "/items")

    assert_equal 2, component.send(:end_index)
  end

  test "computes correct end index at limit" do
    collection = TestCollection.new(page: 3, page_size: 2, total_count: 5)
    component = Decor::Pagination.new(collection: collection, path: "/items")

    assert_equal 5, component.send(:end_index)
  end

  test "returns page size options" do
    collection = TestCollection.new(page: 1, page_size: 6, total_count: 50)
    component = Decor::Pagination.new(collection: collection, page_size: 6)
    sizes = [5, 6, 10, 20, 50, 100, 200]

    assert_equal sizes, component.send(:page_sizes)
  end

  test "renders page size selector when enabled" do
    component = Decor::Pagination.new(collection: @collection, page_size_selector: true, path: "/items")
    rendered = render_component(component)

    assert_includes rendered, "Per page:"
  end

  test "displays current page information" do
    collection = TestCollection.new(
      page: 2,
      page_size: 10,
      total_count: 25
    )
    component = Decor::Pagination.new(collection: collection, path: "/items")
    rendered = render_component(component)

    assert_includes rendered, "11"  # start index
    assert_includes rendered, "20"  # end index
    assert_includes rendered, "25"  # total count
  end

  test "uses nokogiri for parsing" do
    component = Decor::Pagination.new(collection: @collection, path: "/items")
    fragment = render_fragment(component)

    # Test that we can find the pagination container
    pagination_div = fragment.at_css(".decor--pagination")
    assert_not_nil pagination_div

    # Test that we can find links with the join pattern
    join_div = fragment.at_css(".join")
    assert_not_nil join_div

    # Test that we can find page number links
    page_links = fragment.css("a.join-item")
    assert page_links.length > 0
  end
end
