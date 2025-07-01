# @label DataTableSortAndFilter
class ::Decor::SearchAndFilterPreview < ::Lookbook::Preview
  def playground
    render ::Decor::SearchAndFilter.new(
      search: ::Decor::SearchAndFilter::Search.new(
        name: "search_table"
      ),
      filters: [
        ::Decor::SearchAndFilter::Filter.new(
          type: :select,
          name: "select_filter",
          label: "Select Filter",
          options: [["Option 1", "option_1"], ["Option 2", "option_2"]],
          disabled: nil,
          disabled_options: nil
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
          disabled: true
        ),
        ::Decor::SearchAndFilter::Filter.new(
          type: :date_range,
          name: "date_range",
          label: "Date Range",
          value: nil
        )
      ]
    )
  end
end
