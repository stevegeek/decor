# @label SearchAndFilter
class ::Decor::Suite::SearchAndFilterPreview < ::Lookbook::Preview
  # @group Examples
  # @label Search only
  def search_only
    render ::Decor::Suite::SearchAndFilter.new(
      url: "/search",
      search: ::Decor::Suite::SearchAndFilter::Search.new(
        name: "q",
        label: "Search",
        value: ""
      )
    )
  end

  # @group Examples
  # @label Search + filter
  def search_with_filters
    render ::Decor::Suite::SearchAndFilter.new(
      url: "/products",
      search: ::Decor::Suite::SearchAndFilter::Search.new(
        name: "q",
        label: "Search products",
        value: ""
      ),
      filters: [
        ::Decor::Suite::SearchAndFilter::Filter.new(
          type: :select,
          name: "category",
          label: "Category",
          value: "",
          options: [
            ["", "All categories"],
            ["electronics", "Electronics"],
            ["clothing", "Clothing"],
            ["books", "Books"]
          ]
        ),
        ::Decor::Suite::SearchAndFilter::Filter.new(
          type: :checkbox,
          name: "in_stock",
          label: "In stock only",
          value: ""
        ),
        ::Decor::Suite::SearchAndFilter::Filter.new(
          type: :date_range,
          name: "created_at",
          label: "Created at",
          value: ""
        )
      ]
    )
  end

  # @group Examples
  # @label With active filters + download
  def active_filters_with_download
    render ::Decor::Suite::SearchAndFilter.new(
      url: "/orders",
      download_path: "/orders/export",
      search: ::Decor::Suite::SearchAndFilter::Search.new(
        name: "q",
        label: "Search orders",
        value: "INV-12"
      ),
      filters: [
        ::Decor::Suite::SearchAndFilter::Filter.new(
          type: :select,
          name: "status",
          label: "Status",
          value: "open",
          options: [
            ["", "All statuses"],
            ["open", "Open"],
            ["closed", "Closed"],
            ["cancelled", "Cancelled"]
          ]
        ),
        ::Decor::Suite::SearchAndFilter::Filter.new(
          type: :checkbox,
          name: "flagged",
          label: "Flagged only",
          value: "true"
        )
      ]
    )
  end

  # @group Playground
  # @param show_search toggle
  # @param show_filters toggle
  # @param show_download toggle
  # @param active toggle
  def playground(show_search: true, show_filters: true, show_download: false, active: false)
    search = nil
    filters = []

    if show_search
      search = ::Decor::Suite::SearchAndFilter::Search.new(
        name: "q",
        label: "Search",
        value: active ? "example" : ""
      )
    end

    if show_filters
      filters = [
        ::Decor::Suite::SearchAndFilter::Filter.new(
          type: :select,
          name: "category",
          label: "Category",
          value: active ? "electronics" : "",
          options: [["", "All"], ["electronics", "Electronics"], ["clothing", "Clothing"]]
        ),
        ::Decor::Suite::SearchAndFilter::Filter.new(
          type: :checkbox,
          name: "in_stock",
          label: "In stock only",
          value: active ? "true" : ""
        ),
        ::Decor::Suite::SearchAndFilter::Filter.new(
          type: :date_range,
          name: "created_at",
          label: "Created at",
          value: ""
        )
      ]
    end

    render ::Decor::Suite::SearchAndFilter.new(
      url: "/playground",
      search: search,
      filters: filters,
      download_path: show_download ? "/playground/export" : nil
    )
  end
end
