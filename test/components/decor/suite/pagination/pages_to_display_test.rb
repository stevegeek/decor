# frozen_string_literal: true

require "test_helper"

class ::Decor::Suite::Pagination::PagesToDisplayTest < ActiveSupport::TestCase
  def build(current, total)
    ::Decor::Suite::Pagination::PagesToDisplay.new(current, total) { |page| "/items?page=#{page}" }
  end

  test "inherits behaviour from the abstract base" do
    assert_operator ::Decor::Suite::Pagination::PagesToDisplay, :<, ::Decor::Components::Pagination::PagesToDisplay
  end

  test "exposes current_page, total_page_count and url_for_page from the initializer" do
    instance = build(3, 10)
    assert_equal 3, instance.current_page
    assert_equal 10, instance.total_page_count
    assert_equal "/items?page=7", instance.url_for_page.call(7)
  end

  test "single page renders just the current page entry" do
    pages = build(1, 1).indicies_and_ellipses
    assert_equal 1, pages.size
    assert_equal({index: 1, current: true, path: "/items?page=1"}, pages.first)
  end

  test "marks only the current page as current" do
    pages = build(2, 3).indicies_and_ellipses.select { |entry| entry.key?(:current) }
    currents = pages.select { |entry| entry[:current] }
    assert_equal 1, currents.size
    assert_equal 2, currents.first[:index]
  end

  test "path is generated via the block for each page" do
    pages = build(2, 3).indicies_and_ellipses
    pages.each do |entry|
      next unless entry.key?(:path)
      assert_equal "/items?page=#{entry[:index]}", entry[:path]
    end
  end

  test "small page count renders consecutive pages without ellipsis dropdowns" do
    pages = build(3, 5).indicies_and_ellipses
    refute pages.any? { |entry| entry.key?(:list_of_pages_for_dropdown) }
    assert_equal [1, 2, 3, 4, 5], pages.map { |entry| entry[:index] }
  end

  test "current page in the middle of a large set inserts ellipsis dropdowns on both sides" do
    pages = build(50, 100).indicies_and_ellipses
    ellipses = pages.select { |entry| entry.key?(:list_of_pages_for_dropdown) }
    assert_equal 2, ellipses.size
  end

  test "ellipsis dropdown exposes start, end and sub-page entries" do
    pages = build(50, 100).indicies_and_ellipses
    dropdown = pages.find { |entry| entry.key?(:list_of_pages_for_dropdown) }
    assert dropdown[:start].is_a?(Integer)
    assert dropdown[:end].is_a?(Integer)
    assert_operator dropdown[:end], :>=, dropdown[:start]
    sub_pages = dropdown[:list_of_pages_for_dropdown]
    assert_equal (dropdown[:start]..dropdown[:end]).to_a, sub_pages.map { |entry| entry[:index] }
    sub_pages.each { |entry| assert_equal "/items?page=#{entry[:index]}", entry[:path] }
  end

  test "ellipsis dropdown size is bounded by MAX_LINKS_UNDER_ELLIPSIS" do
    pages = build(500, 1000).indicies_and_ellipses
    ellipses = pages.select { |entry| entry.key?(:list_of_pages_for_dropdown) }
    cap = ::Decor::Components::Pagination::PagesToDisplay::MAX_LINKS_UNDER_ELLIPSIS
    ellipses.each do |entry|
      span = entry[:end] - entry[:start] + 1
      # Algorithm caps range_end at initial_links + 1 + MAX_LINKS_UNDER_ELLIPSIS,
      # which yields at most MAX_LINKS_UNDER_ELLIPSIS + 1 inclusive entries.
      assert_operator span, :<=, cap + 1
    end
  end

  test "current page near the end still surfaces the first page link" do
    pages = build(99, 100).indicies_and_ellipses
    assert_equal 1, pages.first[:index]
    assert_equal "/items?page=1", pages.first[:path]
  end

  test "current page near the start still surfaces the last page link" do
    pages = build(2, 100).indicies_and_ellipses
    assert_equal 100, pages.last[:index]
    assert_equal "/items?page=100", pages.last[:path]
  end

  test "always includes the current page somewhere in the output" do
    pages = build(50, 100).indicies_and_ellipses
    flat_indices = pages.flat_map do |entry|
      if entry.key?(:list_of_pages_for_dropdown)
        entry[:list_of_pages_for_dropdown].map { |sub| sub[:index] }
      else
        [entry[:index]]
      end
    end
    assert_includes flat_indices, 50
  end
end
