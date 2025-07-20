# @label DataTableSortAndFilter
class ::Decor::SearchAndFilterPreview < ::Lookbook::Preview
  def playground
    render ::Decor::SearchAndFilter.new(
      url: "#",
      search: ::Decor::SearchAndFilter::Search.new(
        name: "search_table",
        label: "Search",
        value: ""
      ),
      filters: [
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
    )
  end
end
