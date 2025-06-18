# @label Data Table Header Row
class ::Decor::Tables::DataTableHeaderRowPreview < ::Lookbook::Preview
  # Data Table Header Row
  # -------
  #
  # A table header row component that can contain multiple header cells
  # and optionally include a selectable checkbox.
  #
  # @label Playground
  # @param selectable_as [String] text
  # @param selected [Boolean] toggle
  # @param disabled [Boolean] toggle
  def playground(selectable_as: nil, selected: false, disabled: false)
    render ::Decor::Element.new do |e|
      e.table(class: "min-w-full border border-gray-200") do
        e.thead(class: "bg-gray-50") do
          e.render ::Decor::Tables::DataTableHeaderRow.new(
            selectable_as: selectable_as.present? ? selectable_as : nil,
            selected: selected,
            disabled: disabled
          ) do |row|
            row.with_data_table_header_cell(title: "Name", sort_key: :name)
            row.with_data_table_header_cell(title: "Email", sort_key: :email)
            row.with_data_table_header_cell(title: "Amount", sort_key: :amount, numeric: true)
            row.with_data_table_header_cell(title: "Status")
            row.with_data_table_header_cell(title: "Actions")
          end
        end
      end
    end
  end
end
