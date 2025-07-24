# @label Pagination
class ::Decor::PaginationPreview < ::Lookbook::Preview
  # Pagination
  # ----------
  #
  # A DaisyUI-styled pagination component for navigating through pages of data.
  # Supports responsive design, page size selection, result counts, and accessibility features.
  #
  # @group Examples
  # @label Basic Pagination
  def basic_pagination
    @collection = ::ApplicationCollectionBackedQuery.wrap((1..100).to_a).new(page: 3, page_size: 20)

    render ::Decor::Pagination.new(
      current_page: 3,
      page_size: 20,
      path: "/products",
      collection: @collection
    )
  end

  # @group Examples
  # @label With Page Size Selector
  def pagination_with_selector
    @collection = ::ApplicationCollectionBackedQuery.wrap((1..250).to_a).new(page: 2, page_size: 25)

    render ::Decor::Pagination.new(
      current_page: 2,
      page_size: 25,
      path: "/items",
      page_size_selector: true,
      collection: @collection
    )
  end

  # @group Examples
  # @label Large Dataset
  def large_dataset_pagination
    @collection = ::ApplicationCollectionBackedQuery.wrap((1..1000).to_a).new(page: 15, page_size: 50)

    render ::Decor::Pagination.new(
      current_page: 15,
      page_size: 50,
      path: "/records",
      page_size_selector: true,
      custom_page_sizes: [25, 50, 100, 200],
      collection: @collection
    )
  end

  # @group Playground
  # @param current_page number
  # @param number_of_items number
  # @param per_page number
  # @param page_size_selector toggle
  # @param total_count number
  # @param size [Symbol] select [~, xs, sm, md, lg, xl]
  # @param color [Symbol] select [~, base, primary, secondary, accent, neutral, success, error, warning, info]
  # @param style [Symbol] select [~, filled, outlined, ghost]
  def playground(
    current_page: 3,
    number_of_items: 250,
    per_page: 20,
    page_size_selector: true,
    total_count: nil,
    size: nil,
    color: nil,
    style: nil
  )
    fake_items = (1..number_of_items.clamp(0, 10_000)).to_a
    @collection = ::ApplicationCollectionBackedQuery.wrap(fake_items).new(
      page: current_page,
      page_size: per_page || 20
    )

    render ::Decor::Pagination.new(
      current_page: current_page,
      page_size: per_page,
      total_count: total_count,
      path: "/products",
      page_size_selector: page_size_selector,
      collection: @collection,
      size: size,
      color: color,
      style: style
    )
  end

  # @group States
  # @label First Page (Previous Disabled)
  def first_page
    @collection = ::ApplicationCollectionBackedQuery.wrap((1..100).to_a).new(page: 1, page_size: 10)

    render ::Decor::Pagination.new(
      current_page: 1,
      page_size: 10,
      path: "/",
      collection: @collection
    )
  end

  # @group States
  # @label Last Page (Next Disabled)
  def last_page
    @collection = ::ApplicationCollectionBackedQuery.wrap((1..100).to_a).new(page: 10, page_size: 10)

    render ::Decor::Pagination.new(
      current_page: 10,
      page_size: 10,
      path: "/",
      collection: @collection
    )
  end

  # @group States
  # @label Single Page (No Navigation)
  def single_page
    @collection = ::ApplicationCollectionBackedQuery.wrap((1..8).to_a).new(page: 1, page_size: 20)

    render ::Decor::Pagination.new(
      current_page: 1,
      page_size: 20,
      path: "/",
      page_size_selector: true,
      collection: @collection
    )
  end

  # @group Page Counts
  # @label Few Pages
  def few_pages
    @collection = ::ApplicationCollectionBackedQuery.wrap((1..50).to_a).new(page: 2, page_size: 10)

    render ::Decor::Pagination.new(
      current_page: 2,
      page_size: 10,
      path: "/",
      collection: @collection
    )
  end

  # @group Page Counts
  # @label Many Pages (With Ellipsis)
  def many_pages
    fake_items = (1..5000).to_a
    @collection = ::ApplicationCollectionBackedQuery.wrap(fake_items).new(page: 125, page_size: 20)

    render ::Decor::Pagination.new(
      current_page: 125,
      page_size: 20,
      path: "/",
      page_size_selector: true,
      collection: @collection
    )
  end

  # @group Page Size Options
  # @label Default Page Sizes
  def default_page_sizes
    @collection = ::ApplicationCollectionBackedQuery.wrap((1..300).to_a).new(page: 1, page_size: 20)

    render ::Decor::Pagination.new(
      current_page: 1,
      page_size: 20,
      path: "/",
      page_size_selector: true,
      collection: @collection
    )
  end

  # @group Page Size Options
  # @label Custom Page Sizes
  def custom_page_sizes
    @collection = ::ApplicationCollectionBackedQuery.wrap((1..500).to_a).new(page: 1, page_size: 30)

    render ::Decor::Pagination.new(
      current_page: 1,
      page_size: 30,
      path: "/",
      page_size_selector: true,
      custom_page_sizes: [15, 30, 60, 120],
      collection: @collection
    )
  end

  # @group Styles
  # @label Filled Style (Default)
  def style_filled
    @collection = ::ApplicationCollectionBackedQuery.wrap((1..100).to_a).new(page: 3, page_size: 10)

    render ::Decor::Pagination.new(
      current_page: 3,
      page_size: 10,
      path: "/products",
      style: :filled,
      collection: @collection
    )
  end

  # @group Styles
  # @label Outlined Style
  def style_outlined
    @collection = ::ApplicationCollectionBackedQuery.wrap((1..100).to_a).new(page: 3, page_size: 10)

    render ::Decor::Pagination.new(
      current_page: 3,
      page_size: 10,
      path: "/products",
      style: :outlined,
      collection: @collection
    )
  end

  # @group Styles
  # @label Ghost Style
  def style_ghost
    @collection = ::ApplicationCollectionBackedQuery.wrap((1..100).to_a).new(page: 3, page_size: 10)

    render ::Decor::Pagination.new(
      current_page: 3,
      page_size: 10,
      path: "/products",
      style: :ghost,
      collection: @collection
    )
  end

  # @group Colors
  # @label Primary Color
  def color_primary
    @collection = ::ApplicationCollectionBackedQuery.wrap((1..100).to_a).new(page: 3, page_size: 10)

    render ::Decor::Pagination.new(
      current_page: 3,
      page_size: 10,
      path: "/products",
      color: :primary,
      style: :filled,
      collection: @collection
    )
  end

  # @group Colors
  # @label Secondary Color
  def color_secondary
    @collection = ::ApplicationCollectionBackedQuery.wrap((1..100).to_a).new(page: 3, page_size: 10)

    render ::Decor::Pagination.new(
      current_page: 3,
      page_size: 10,
      path: "/products",
      color: :secondary,
      style: :outlined,
      collection: @collection
    )
  end

  # @group Sizes
  # @label Extra Small
  def size_xs
    @collection = ::ApplicationCollectionBackedQuery.wrap((1..100).to_a).new(page: 3, page_size: 10)

    render ::Decor::Pagination.new(
      current_page: 3,
      page_size: 10,
      path: "/products",
      size: :xs,
      collection: @collection
    )
  end

  # @group Sizes
  # @label Small
  def size_sm
    @collection = ::ApplicationCollectionBackedQuery.wrap((1..100).to_a).new(page: 3, page_size: 10)

    render ::Decor::Pagination.new(
      current_page: 3,
      page_size: 10,
      path: "/products",
      size: :sm,
      collection: @collection
    )
  end

  # @group Sizes
  # @label Large
  def size_lg
    @collection = ::ApplicationCollectionBackedQuery.wrap((1..100).to_a).new(page: 3, page_size: 10)

    render ::Decor::Pagination.new(
      current_page: 3,
      page_size: 10,
      path: "/products",
      size: :lg,
      collection: @collection
    )
  end

  # @group Sizes
  # @label Extra Large
  def size_xl
    @collection = ::ApplicationCollectionBackedQuery.wrap((1..100).to_a).new(page: 3, page_size: 10)

    render ::Decor::Pagination.new(
      current_page: 3,
      page_size: 10,
      path: "/products",
      size: :xl,
      collection: @collection
    )
  end
end
