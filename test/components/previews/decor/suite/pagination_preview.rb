# @label Pagination
class ::Decor::Suite::PaginationPreview < ::Lookbook::Preview
  # Pagination (Suite)
  # ------------------
  #
  # Compact admin-style pagination row. Renders a results summary, optional
  # per-page selector, and numbered page navigation with prev/next chevrons.
  # Uses Suite design tokens — suite-hairline divider, suite-gray-25 surface,
  # rounded-suite-control hit targets, and tabular numerals for stable widths.

  # @group Examples
  # @label Few pages (10 items)
  def few_pages
    @collection = ::ApplicationCollectionBackedQuery.wrap((1..10).to_a).new(page: 1, page_size: 5)

    render ::Decor::Suite::Pagination.new(
      current_page: 1,
      page_size: 5,
      path: "/items",
      collection: @collection
    )
  end

  # @group Examples
  # @label Hundred items
  def hundred_items
    @collection = ::ApplicationCollectionBackedQuery.wrap((1..100).to_a).new(page: 3, page_size: 20)

    render ::Decor::Suite::Pagination.new(
      current_page: 3,
      page_size: 20,
      path: "/items",
      collection: @collection
    )
  end

  # @group Examples
  # @label Thousand items (with ellipsis)
  def thousand_items
    @collection = ::ApplicationCollectionBackedQuery.wrap((1..1000).to_a).new(page: 25, page_size: 20)

    render ::Decor::Suite::Pagination.new(
      current_page: 25,
      page_size: 20,
      path: "/items",
      collection: @collection
    )
  end

  # @group Examples
  # @label With page-size selector
  def with_page_size_selector
    @collection = ::ApplicationCollectionBackedQuery.wrap((1..250).to_a).new(page: 2, page_size: 25)

    render ::Decor::Suite::Pagination.new(
      current_page: 2,
      page_size: 25,
      path: "/items",
      page_size_selector: true,
      collection: @collection
    )
  end

  # @group States
  # @label First page (Previous disabled)
  def first_page
    @collection = ::ApplicationCollectionBackedQuery.wrap((1..100).to_a).new(page: 1, page_size: 10)

    render ::Decor::Suite::Pagination.new(
      current_page: 1,
      page_size: 10,
      path: "/",
      collection: @collection
    )
  end

  # @group States
  # @label Last page (Next disabled)
  def last_page
    @collection = ::ApplicationCollectionBackedQuery.wrap((1..100).to_a).new(page: 10, page_size: 10)

    render ::Decor::Suite::Pagination.new(
      current_page: 10,
      page_size: 10,
      path: "/",
      collection: @collection
    )
  end

  # @group States
  # @label Single page (no navigation needed)
  def single_page
    @collection = ::ApplicationCollectionBackedQuery.wrap((1..8).to_a).new(page: 1, page_size: 20)

    render ::Decor::Suite::Pagination.new(
      current_page: 1,
      page_size: 20,
      path: "/",
      page_size_selector: true,
      collection: @collection
    )
  end

  # @group Page Sizes
  # @label Custom page sizes
  def custom_page_sizes
    @collection = ::ApplicationCollectionBackedQuery.wrap((1..500).to_a).new(page: 1, page_size: 30)

    render ::Decor::Suite::Pagination.new(
      current_page: 1,
      page_size: 30,
      path: "/",
      page_size_selector: true,
      custom_page_sizes: [15, 30, 60, 120],
      collection: @collection
    )
  end

  # @group Playground
  # @param current_page number
  # @param number_of_items number
  # @param per_page number
  # @param page_size_selector toggle
  def playground(
    current_page: 3,
    number_of_items: 250,
    per_page: 20,
    page_size_selector: true
  )
    fake_items = (1..number_of_items.clamp(0, 10_000)).to_a
    @collection = ::ApplicationCollectionBackedQuery.wrap(fake_items).new(
      page: current_page,
      page_size: per_page || 20
    )

    render ::Decor::Suite::Pagination.new(
      current_page: current_page,
      page_size: per_page,
      path: "/items",
      page_size_selector: page_size_selector,
      collection: @collection
    )
  end
end
