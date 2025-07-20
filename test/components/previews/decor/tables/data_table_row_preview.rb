# @label Data Table Row
class ::Decor::Tables::DataTableRowPreview < ::Lookbook::Preview
  # Data Table Row
  # -------
  #
  # A table row component that can contain multiple data cells, handle selection,
  # provide hover effects, and include expandable content.
  #
  # @label Playground
  # @param hover_highlight [Boolean] toggle
  # @param highlight select [~, gray_low, gray_medium, gray_high, low, medium, high]
  # @param disabled [Boolean] toggle
  # @param hidden [Boolean] toggle
  # @param selected [Boolean] toggle
  # @param selectable_as [String] text
  # @param path [String] text
  def playground(
    hover_highlight: true,
    highlight: nil,
    disabled: false,
    hidden: false,
    selected: false,
    selectable_as: nil,
    path: nil
  )
    render ::Decor::Element.new do |e|
      e.table(class: "min-w-full border border-gray-200") do
        e.tbody(class: "bg-white divide-y divide-gray-200") do
          e.render ::Decor::Tables::DataTableRow.new(
            hover_highlight: hover_highlight,
            highlight: highlight.present? ? highlight.to_sym : nil,
            disabled: disabled,
            hidden: hidden,
            selected: selected,
            selectable_as: selectable_as.present? ? selectable_as : nil,
            path: path.present? ? path : nil
          ) do |row|
            row.with_data_table_cell(value: "John Doe")
            row.with_data_table_cell(value: "john@example.com")
            row.with_data_table_cell(value: "$1,234.56", numeric: true)
            row.with_data_table_cell(value: "Active")
          end
        end
      end
    end
  end
end
