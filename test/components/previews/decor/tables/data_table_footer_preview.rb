# @label DataTableFooter
# Renders a footer for data tables with optional summary lines, messages, and customizable left/right slots.
# Commonly used for displaying totals, subtotals, and summary information at the bottom of tables.
class ::Decor::Tables::DataTableFooterPreview < ::Lookbook::Preview
  # @!group Examples

  # @label Default
  # Basic footer with a simple message
  def default
    render ::Decor::Tables::DataTableFooter.new(
      message: "Showing 10 of 100 records"
    )
  end

  # @label With Summary Lines
  # Footer displaying financial summary with subtotals and total
  def with_summary_lines
    render ::Decor::Tables::DataTableFooter.new(
      summary_lines: [
        ::Decor::Tables::DataTableFooter::FooterSummaryLine.new(
          title: "Subtotal",
          value: "$1,000.00"
        ),
        ::Decor::Tables::DataTableFooter::FooterSummaryLine.new(
          title: "VAT (20%)",
          value: "$200.00"
        ),
        ::Decor::Tables::DataTableFooter::FooterSummaryLine.new(
          title: "Total",
          value: "$1,200.00",
          separator: :final
        )
      ]
    )
  end

  # @label With Slots
  # Footer with custom left and right content slots
  def with_slots
    render ::Decor::Tables::DataTableFooter.new do |footer|
      footer.with_left do
        tag.div class: "flex items-center gap-2" do
          concat tag.span("Page 1 of 10", class: "text-gray-600")
        end
      end
      footer.with_right do
        tag.div class: "flex items-center gap-2" do
          concat link_to "Previous", "#", class: "text-blue-600 hover:underline"
          concat tag.span " | ", class: "text-gray-400"
          concat link_to "Next", "#", class: "text-blue-600 hover:underline"
        end
      end
    end
  end

  # @label Complex Example
  # Complete footer with summary lines, sections, and custom slots
  def complex_example
    render ::Decor::Tables::DataTableFooter.new(
      summary_lines: [
        ::Decor::Tables::DataTableFooter::FooterSummaryLine.new(
          title: "Subtotal",
          value: "$1,000.00"
        ),
        ::Decor::Tables::DataTableFooter::FooterSummaryLine.new(
          title: "Shipping",
          value: "$50.00"
        ),
        ::Decor::Tables::DataTableFooter::FooterSummaryLine.new(
          title: "Discount",
          value: "-$100.00",
          separator: :section
        ),
        ::Decor::Tables::DataTableFooter::FooterSummaryLine.new(
          title: "Total",
          value: "$950.00",
          separator: :final
        )
      ],
      message: "Prices include VAT"
    ) do |footer|
      footer.with_left do
        tag.button "Export", class: "px-3 py-1 text-sm bg-gray-100 rounded hover:bg-gray-200"
      end
      footer.with_right do
        tag.button "Print Invoice", class: "px-3 py-1 text-sm bg-blue-600 text-white rounded hover:bg-blue-700"
      end
    end
  end

  # @!endgroup

  # @!group Playground

  # @label Playground
  # @param show_example_summary_lines toggle "Show example summary lines"
  # @param message text "Footer message"
  # @param show_left_slot toggle "Show left slot content"
  # @param show_right_slot toggle "Show right slot content"
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
          value: "-$100.00",
          separator: :section
        ),
        ::Decor::Tables::DataTableFooter::FooterSummaryLine.new(
          title: "Promo",
          value: "-$100.00"
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
          tag.div class: "flex items-center gap-2" do
            concat tag.button "Action 1", class: "px-2 py-1 text-sm bg-gray-100 rounded"
            concat tag.button "Action 2", class: "px-2 py-1 text-sm bg-gray-100 rounded"
          end
        end
      end
      if show_right_slot
        footer.with_right do
          tag.div class: "flex items-center gap-2" do
            concat tag.span "Items per page: ", class: "text-sm text-gray-600"
            concat tag.select do
              options_for_select([["10", 10], ["25", 25], ["50", 50]], 10)
            end
          end
        end
      end
    end
  end

  # @!endgroup

  # @!group Summary Line Variations

  # @label Basic Summary
  # Simple summary with just totals
  def basic_summary
    render ::Decor::Tables::DataTableFooter.new(
      summary_lines: [
        ::Decor::Tables::DataTableFooter::FooterSummaryLine.new(
          title: "Total Items",
          value: "42"
        ),
        ::Decor::Tables::DataTableFooter::FooterSummaryLine.new(
          title: "Total Amount",
          value: "$1,234.56"
        )
      ]
    )
  end

  # @label With Separators
  # Summary lines with section and final separators
  def with_separators
    render ::Decor::Tables::DataTableFooter.new(
      summary_lines: [
        ::Decor::Tables::DataTableFooter::FooterSummaryLine.new(
          title: "Items Total",
          value: "$1,000.00"
        ),
        ::Decor::Tables::DataTableFooter::FooterSummaryLine.new(
          title: "Shipping",
          value: "$50.00"
        ),
        ::Decor::Tables::DataTableFooter::FooterSummaryLine.new(
          title: "Discounts",
          value: "-$100.00",
          separator: :section
        ),
        ::Decor::Tables::DataTableFooter::FooterSummaryLine.new(
          title: "Store Credit",
          value: "-$50.00"
        ),
        ::Decor::Tables::DataTableFooter::FooterSummaryLine.new(
          title: "Amount Due",
          value: "$900.00",
          separator: :final
        )
      ]
    )
  end

  # @!endgroup

  # @!group Content Variations

  # @label Message Only
  # Footer with just a message
  def message_only
    render ::Decor::Tables::DataTableFooter.new(
      message: "Last updated: 5 minutes ago"
    )
  end

  # @label Left Slot Only
  # Footer with only left slot content
  def left_slot_only
    render ::Decor::Tables::DataTableFooter.new do |footer|
      footer.with_left do
        tag.div class: "flex items-center gap-3" do
          concat tag.button "Refresh", class: "px-3 py-1 text-sm bg-gray-100 rounded"
          concat tag.span "Auto-refresh in 30s", class: "text-sm text-gray-500"
        end
      end
    end
  end

  # @label Right Slot Only
  # Footer with only right slot content
  def right_slot_only
    render ::Decor::Tables::DataTableFooter.new do |footer|
      footer.with_right do
        tag.div class: "flex items-center gap-4" do
          concat link_to "Download CSV", "#", class: "text-sm text-blue-600 hover:underline"
          concat link_to "Download PDF", "#", class: "text-sm text-blue-600 hover:underline"
        end
      end
    end
  end

  # @!endgroup
end
