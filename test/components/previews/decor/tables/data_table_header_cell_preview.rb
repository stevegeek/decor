# @label Data Table Header Cell
class ::Decor::Tables::DataTableHeaderCellPreview < ::Lookbook::Preview
  # Data Table Header Cell
  # -------
  #
  # A table header cell component that extends DataTableCell with sorting functionality,
  # title support, and column stretching capabilities.
  #
  # @label Playground
  # @param title [String] text
  # @param numeric [Boolean] toggle
  # @param sort_key [String] text
  # @param sorted_direction select [~, asc, desc]
  # @param stretch_divisor [Integer] number
  # @param row_height select [comfortable, standard, tight]
  def playground(
    title: "Column Header",
    numeric: false,
    sort_key: nil,
    sorted_direction: nil,
    stretch_divisor: nil,
    row_height: :standard
  )
    render ::Decor::Element.new do |e|
      e.table(class: "min-w-full border border-gray-200") do
        e.thead(class: "bg-gray-50") do
          e.tr do
            e.render ::Decor::Tables::DataTableHeaderCell.new(
              title: title,
              numeric: numeric,
              sort_key: sort_key.present? ? sort_key.to_sym : nil,
              sorted_direction: sorted_direction.present? ? sorted_direction.to_sym : nil,
              stretch_divisor: stretch_divisor,
              row_height: row_height
            )
          end
        end
      end
    end
  end
end
