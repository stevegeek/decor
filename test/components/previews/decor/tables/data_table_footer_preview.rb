# @label DataTableFooter
class ::Decor::Tables::DataTableFooterPreview < ::Lookbook::Preview
  # @param show_example_summary_lines toggle
  # @param message text
  # @param show_left_slot toggle
  # @param show_right_slot toggle
  def playground(show_example_summary_lines: false, message: nil, show_left_slot: false, show_right_slot: false)
    render ::Decor::Tables::DataTableFooter.new(
      summary_lines: show_example_summary_lines ? [
        ::Decor::Tables::DataTableFooter::FooterSummaryLine.new(
          title: "Subtotal",
          value: "$1,000.00"
        ),
        ::Decor::Tables::DataTableFooter::FooterSummaryLine.new(
          title: "VAT",
          value: "$200.00"
        ),
        ::Decor::Tables::DataTableFooter::FooterSummaryLine.new(
          title: "Credit",
          value: "$-100.00",
          separator: :section
        ),
        ::Decor::Tables::DataTableFooter::FooterSummaryLine.new(
          title: "Promo",
          value: "$-100.00"
        ),
        ::Decor::Tables::DataTableFooter::FooterSummaryLine.new(
          title: "Total",
          value: "$1,000.00",
          separator: :final
        )
      ] : nil,
      message: message
    ) do |footer|
      if show_left_slot
        footer.with_left do
          "Left slot"
        end
      end
      if show_right_slot
        footer.with_right do
          "Right slot"
        end
      end
    end
  end
end
