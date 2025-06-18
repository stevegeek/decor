# @label Data Table Cell
class ::Decor::Tables::DataTableCellPreview < ::Lookbook::Preview
  # Data Table Cell
  # -------
  #
  # A table cell component that provides rich functionality including clickable content,
  # numeric alignment, typography control, and path navigation.
  #
  # @label Playground
  # @param value [String] text
  # @param numeric [Boolean] toggle
  # @param emphasis select [regular, low]
  # @param weight select [light, regular, medium]
  # @param row_height select [comfortable, standard, tight]
  # @param content_clickable [Boolean] toggle
  # @param path [String] text
  # @param max_width [Integer] number
  # @param min_width_rem [Integer] number
  def playground(
    value: "Sample Cell Content",
    numeric: false,
    emphasis: :regular,
    weight: :regular,
    row_height: :standard,
    content_clickable: false,
    path: nil,
    max_width: nil,
    min_width_rem: nil
  )
    render ::Decor::Element.new do |e|
      e.table(class: "min-w-full border border-gray-200") do
        e.tbody do
          e.tr(class: "bg-white") do
            e.render ::Decor::Tables::DataTableCell.new(
              value: value,
              numeric: numeric,
              emphasis: emphasis,
              weight: weight,
              row_height: row_height,
              content_clickable: content_clickable,
              path: path.present? ? path : nil,
              max_width: max_width,
              min_width_rem: min_width_rem
            )
          end
        end
      end
    end
  end
end
