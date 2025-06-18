# @label Pagination
class ::Decor::PaginationPreview < ::Lookbook::Preview
  # Pagination
  # ----------
  #
  # A DaisyUI-styled pagination component for navigating through pages of data.
  # Supports responsive design, page size selection, result counts, and accessibility features.
  #
  # @label Playground
  # @param current_page number
  # @param number_of_items number
  # @param per_page number
  # @param page_size_selector toggle
  # @param total_count number
  def playground(
    current_page: 3,
    number_of_items: 250,
    per_page: 20,
    page_size_selector: true,
    total_count: nil
  )
    fake_items = (1..[[number_of_items, 0].max, 10_000].min).to_a
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
      collection: @collection
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

  # @group Features
  # @label With Page Size Selector
  def with_page_size_selector
    @collection = ::ApplicationCollectionBackedQuery.wrap((1..500).to_a).new(page: 3, page_size: 25)

    render ::Decor::Pagination.new(
      current_page: 3,
      page_size: 25,
      path: "/",
      page_size_selector: true,
      custom_page_sizes: [10, 25, 50, 100],
      collection: @collection
    )
  end

  # @group Features
  # @label High Page Numbers (Ellipsis)
  def high_page_numbers
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

  # @group Responsive
  # @label Mobile Layout
  def mobile_layout
    @collection = ::ApplicationCollectionBackedQuery.wrap((1..100).to_a).new(page: 3, page_size: 10)

    div(class: "max-w-sm mx-auto") do
      render ::Decor::Pagination.new(
        current_page: 3,
        page_size: 10,
        path: "/",
        page_size_selector: true,
        collection: @collection
      )
    end
  end

  # @group Integration
  # @label With Data Table
  def with_data_table
    @collection = ::ApplicationCollectionBackedQuery.wrap((1..200).to_a).new(page: 4, page_size: 15)

    div(class: "bg-base-100 border border-base-300 rounded-lg") do
      div(class: "px-4 py-3 border-b border-base-300") do
        h3(class: "text-lg font-medium text-base-content") { "Product Inventory" }
        p(class: "text-sm text-base-content/70") { "Manage your product catalog" }
      end

      div(class: "p-4") do
        div(class: "text-center text-base-content/70 py-8") do
          "Table content would go here..."
        end
      end

      render ::Decor::Pagination.new(
        current_page: 4,
        page_size: 15,
        path: "/admin/products",
        page_size_selector: true,
        collection: @collection
      )
    end
  end
end
