# @label SearchAndFilter
class ::Decor::SearchAndFilterPreview < ::Lookbook::Preview
  # SearchAndFilter
  # -------
  #
  # A comprehensive search and filter component for data tables and lists.
  # Combines search input with multiple filter types including select dropdowns,
  # checkboxes, and date ranges. Perfect for filtering large datasets.
  #
  # @group Examples
  # @label Basic Search
  def basic_search
    render ::Decor::SearchAndFilter.new(
      url: "/search",
      search: ::Decor::SearchAndFilter::Search.new(
        name: "q",
        label: "Search",
        value: ""
      )
    )
  end

  # @group Examples
  # @label Search with Select Filter
  def search_with_select
    render ::Decor::SearchAndFilter.new(
      url: "/products",
      search: ::Decor::SearchAndFilter::Search.new(
        name: "search",
        label: "Search Products",
        value: ""
      ),
      filters: [
        ::Decor::SearchAndFilter::Filter.new(
          type: :select,
          name: "category",
          label: "Category",
          value: "",
          options: [
            ["", "All Categories"],
            ["electronics", "Electronics"],
            ["clothing", "Clothing"],
            ["books", "Books"],
            ["home", "Home & Garden"]
          ]
        )
      ]
    )
  end

  # @group Examples
  # @label Full Featured Filters
  def full_featured_filters
    render ::Decor::SearchAndFilter.new(
      url: "/users",
      search: ::Decor::SearchAndFilter::Search.new(
        name: "search",
        label: "Search Users",
        value: "",
        placeholder: "Name, email, or ID..."
      ),
      filters: [
        ::Decor::SearchAndFilter::Filter.new(
          type: :select,
          name: "status",
          label: "Status",
          value: "active",
          options: [
            ["all", "All Statuses"],
            ["active", "Active"],
            ["inactive", "Inactive"],
            ["pending", "Pending"]
          ]
        ),
        ::Decor::SearchAndFilter::Filter.new(
          type: :checkbox,
          name: "verified",
          label: "Verified Only",
          value: "true"
        ),
        ::Decor::SearchAndFilter::Filter.new(
          type: :date_range,
          name: "created_at",
          label: "Registration Date",
          value: ""
        )
      ]
    )
  end

  # @group Playground
  # @param url text
  # @param show_search toggle
  # @param show_filters toggle
  # @param show_export toggle
  # @param size [Symbol] select [~, xs, sm, md, lg, xl]
  # @param color [Symbol] select [~, base, primary, secondary, accent, neutral, success, error, warning, info]
  # @param style [Symbol] select [~, filled, outlined, ghost]
  def playground(url: "#", show_search: true, show_filters: true, show_export: false, size: nil, color: nil, style: nil)
    filters = []
    search = nil

    if show_search
      search = ::Decor::SearchAndFilter::Search.new(
        name: "search_table",
        label: "Search",
        value: ""
      )
    end

    if show_filters
      filters = [
        ::Decor::SearchAndFilter::Filter.new(
          type: :select,
          name: "select_filter",
          label: "Select Filter",
          value: "",
          options: [["Option 1", "option_1"], ["Option 2", "option_2"]]
        ),
        ::Decor::SearchAndFilter::Filter.new(
          type: :checkbox,
          name: "checkbox",
          label: "Checkbox",
          value: ""
        ),
        ::Decor::SearchAndFilter::Filter.new(
          type: :checkbox,
          name: "checkbox_disabled",
          label: "Checkbox Disabled",
          value: "",
          disabled: true
        ),
        ::Decor::SearchAndFilter::Filter.new(
          type: :date_range,
          name: "date_range",
          label: "Date Range",
          value: ""
        )
      ]
    end

    render ::Decor::SearchAndFilter.new(
      url: url,
      search: search,
      filters: filters,
      download_path: show_export ? "/export" : nil,
      size: size,
      color: color,
      style: style
    )
  end

  # @group Filter Types
  # @label Select Filter
  def filter_select
    render ::Decor::SearchAndFilter.new(
      url: "/filter",
      search: ::Decor::SearchAndFilter::Search.new(
        name: "q",
        label: "Search",
        value: ""
      ),
      filters: [
        ::Decor::SearchAndFilter::Filter.new(
          type: :select,
          name: "sort_by",
          label: "Sort By",
          value: "name",
          options: [
            ["name", "Name"],
            ["date", "Date Created"],
            ["price", "Price"],
            ["popularity", "Popularity"]
          ]
        )
      ]
    )
  end

  # @group Filter Types
  # @label Checkbox Filter
  def filter_checkbox
    render ::Decor::SearchAndFilter.new(
      url: "/filter",
      search: ::Decor::SearchAndFilter::Search.new(
        name: "q",
        label: "Search",
        value: ""
      ),
      filters: [
        ::Decor::SearchAndFilter::Filter.new(
          type: :checkbox,
          name: "in_stock",
          label: "In Stock Only",
          value: ""
        ),
        ::Decor::SearchAndFilter::Filter.new(
          type: :checkbox,
          name: "on_sale",
          label: "On Sale",
          value: ""
        ),
        ::Decor::SearchAndFilter::Filter.new(
          type: :checkbox,
          name: "free_shipping",
          label: "Free Shipping",
          value: ""
        )
      ]
    )
  end

  # @group Filter Types
  # @label Date Range Filter
  def filter_date_range
    render ::Decor::SearchAndFilter.new(
      url: "/filter",
      filters: [
        ::Decor::SearchAndFilter::Filter.new(
          type: :date_range,
          name: "date_range",
          label: "Date Range",
          value: "",
          placeholder: "Select date range..."
        )
      ]
    )
  end

  # @group Filter States
  # @label Disabled Filters
  def disabled_filters
    render ::Decor::SearchAndFilter.new(
      url: "/filter",
      search: ::Decor::SearchAndFilter::Search.new(
        name: "search",
        label: "Search",
        value: ""
      ),
      filters: [
        ::Decor::SearchAndFilter::Filter.new(
          type: :select,
          name: "category",
          label: "Category (Disabled)",
          value: "",
          disabled: true,
          options: [["option1", "Option 1"]]
        ),
        ::Decor::SearchAndFilter::Filter.new(
          type: :checkbox,
          name: "filter",
          label: "Filter (Disabled)",
          value: "",
          disabled: true
        )
      ]
    )
  end

  # @group Filter States
  # @label Pre-filled Values
  def prefilled_values
    render ::Decor::SearchAndFilter.new(
      url: "/search",
      search: ::Decor::SearchAndFilter::Search.new(
        name: "q",
        label: "Search",
        value: "example search"
      ),
      filters: [
        ::Decor::SearchAndFilter::Filter.new(
          type: :select,
          name: "category",
          label: "Category",
          value: "electronics",
          options: [
            ["", "All"],
            ["electronics", "Electronics"],
            ["books", "Books"]
          ]
        ),
        ::Decor::SearchAndFilter::Filter.new(
          type: :checkbox,
          name: "in_stock",
          label: "In Stock",
          value: "true"
        )
      ]
    )
  end

  # @group Examples
  # @label E-commerce Product Filter
  def ecommerce_filter
    render ::Decor::SearchAndFilter.new(
      url: "/products",
      search: ::Decor::SearchAndFilter::Search.new(
        name: "search",
        label: "Search Products",
        value: "",
        placeholder: "Search products..."
      ),
      filters: [
        ::Decor::SearchAndFilter::Filter.new(
          type: :select,
          name: "category",
          label: "Category",
          value: "",
          options: [
            ["", "All Categories"],
            ["electronics", "Electronics"],
            ["clothing", "Clothing"],
            ["books", "Books"]
          ]
        ),
        ::Decor::SearchAndFilter::Filter.new(
          type: :select,
          name: "price_range",
          label: "Price Range",
          value: "",
          options: [
            ["", "Any Price"],
            ["0-50", "Under $50"],
            ["50-100", "$50 - $100"],
            ["100-200", "$100 - $200"],
            ["200+", "Over $200"]
          ]
        ),
        ::Decor::SearchAndFilter::Filter.new(
          type: :checkbox,
          name: "in_stock",
          label: "In Stock Only",
          value: ""
        ),
        ::Decor::SearchAndFilter::Filter.new(
          type: :checkbox,
          name: "free_shipping",
          label: "Free Shipping",
          value: ""
        )
      ]
    )
  end

  # @group Examples
  # @label Admin User Management
  def admin_user_filter
    render ::Decor::SearchAndFilter.new(
      url: "/admin/users",
      search: ::Decor::SearchAndFilter::Search.new(
        name: "search",
        label: "Search Users",
        value: "",
        placeholder: "Name, email, or user ID..."
      ),
      filters: [
        ::Decor::SearchAndFilter::Filter.new(
          type: :select,
          name: "role",
          label: "User Role",
          value: "",
          options: [
            ["", "All Roles"],
            ["admin", "Admin"],
            ["moderator", "Moderator"],
            ["user", "User"],
            ["guest", "Guest"]
          ]
        ),
        ::Decor::SearchAndFilter::Filter.new(
          type: :select,
          name: "status",
          label: "Account Status",
          value: "",
          options: [
            ["", "All Statuses"],
            ["active", "Active"],
            ["suspended", "Suspended"],
            ["pending", "Pending Verification"]
          ]
        ),
        ::Decor::SearchAndFilter::Filter.new(
          type: :date_range,
          name: "last_login",
          label: "Last Login",
          value: ""
        ),
        ::Decor::SearchAndFilter::Filter.new(
          type: :checkbox,
          name: "verified",
          label: "Email Verified",
          value: ""
        )
      ]
    )
  end
end
