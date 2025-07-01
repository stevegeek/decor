require "test_helper"

class Decor::PaginationTest < ActiveSupport::TestCase
  TestCollection = Struct.new(:page, :page_size, :total_count, :current_page, :total_pages, :first_page?, :last_page?, :prev_page, :next_page)

  def setup
    @collection = TestCollection.new(
      1,      # page
      10,     # page_size
      100,    # total_count
      1,      # current_page
      10,     # total_pages
      true,   # first_page?
      false,  # last_page?
      nil,    # prev_page
      2       # next_page
    )
  end

  test "renders successfully with valid attributes" do
    component = Decor::Pagination.new(collection: @collection)
    rendered = render_component(component)

    assert_includes rendered, "Previous"
    assert_includes rendered, "Next"
  end

  test "computes correct start index for page 1" do
    collection = OpenStruct.new(page: 1, page_size: 2, total_count: 5, current_page: 1)
    component = Decor::Pagination.new(collection: collection)

    assert_equal 1, component.send(:start_index)
  end

  test "computes correct start index for page 2" do
    collection = OpenStruct.new(page: 2, page_size: 2, total_count: 5, current_page: 2)
    component = Decor::Pagination.new(collection: collection)

    assert_equal 3, component.send(:start_index)
  end

  test "computes correct end index" do
    collection = OpenStruct.new(page: 1, page_size: 2, total_count: 5, current_page: 1)
    component = Decor::Pagination.new(collection: collection)

    assert_equal 2, component.send(:end_index)
  end

  test "computes correct end index at limit" do
    collection = OpenStruct.new(page: 3, page_size: 2, total_count: 5, current_page: 3)
    component = Decor::Pagination.new(collection: collection)

    assert_equal 5, component.send(:end_index)
  end

  test "returns page size options" do
    collection = OpenStruct.new(page: 1, page_size: 6, total_count: 50, current_page: 1)
    component = Decor::Pagination.new(collection: collection, page_size: 6)
    sizes = [5, 6, 10, 20, 50, 100, 200]

    assert_equal sizes, component.send(:page_sizes)
  end

  test "renders page size selector when enabled" do
    component = Decor::Pagination.new(collection: @collection, page_size_selector: true)
    rendered = render_component(component)

    assert_includes rendered, "Items per page"
  end

  test "displays current page information" do
    collection = OpenStruct.new(
      page: 2,
      page_size: 10,
      total_count: 25,
      current_page: 2,
      total_pages: 3
    )
    component = Decor::Pagination.new(collection: collection)
    rendered = render_component(component)

    assert_includes rendered, "11"  # start index
    assert_includes rendered, "20"  # end index
    assert_includes rendered, "25"  # total count
  end

  test "uses nokogiri for parsing" do
    component = Decor::Pagination.new(collection: @collection)
    fragment = render_fragment(component)

    nav = fragment.at_css("nav")
    assert_not_nil nav
    assert_includes nav["aria-label"], "Pagination"

    prev_link = fragment.at_css('a[aria-label="Previous page"]')
    assert_not_nil prev_link
  end
end
