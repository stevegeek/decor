# @label Data Table Row
class ::Decor::Tables::DataTableRowPreview < ::Lookbook::Preview
  # A table row component that can contain multiple data cells, handle selection,
  # provide hover effects, and include expandable content.

  # @!group Examples

  # @label Default Row
  # Basic table row with standard cells
  def default
    render_table do |tbody|
      tbody.render ::Decor::Tables::DataTableRow.new do |row|
        row.with_data_table_cell(value: "John Doe")
        row.with_data_table_cell(value: "john@example.com")
        row.with_data_table_cell(value: "$1,234.56", numeric: true)
        row.with_data_table_cell(value: "Active")
      end
    end
  end

  # @label Selectable Row
  # Row with checkbox selection
  def selectable
    render_table do |tbody|
      tbody.render ::Decor::Tables::DataTableRow.new(selectable_as: "user_1", selected: true) do |row|
        row.with_data_table_cell(value: "Jane Smith")
        row.with_data_table_cell(value: "jane@example.com")
        row.with_data_table_cell(value: "$2,345.67", numeric: true)
        row.with_data_table_cell(value: "Premium")
      end
    end
  end

  # @label Clickable Row
  # Row with link behavior
  def clickable
    render_table do |tbody|
      tbody.render ::Decor::Tables::DataTableRow.new(path: "/users/123") do |row|
        row.with_data_table_cell(value: "Bob Johnson")
        row.with_data_table_cell(value: "bob@example.com")
        row.with_data_table_cell(value: "$3,456.78", numeric: true)
        row.with_data_table_cell(value: "Standard")
      end
    end
  end

  # @label Expandable Row
  # Row with expandable content
  def expandable
    render_table do |tbody|
      tbody.render ::Decor::Tables::DataTableRow.new do |row|
        row.with_data_table_cell(value: "Alice Williams")
        row.with_data_table_cell(value: "alice@example.com")
        row.with_data_table_cell(value: "$4,567.89", numeric: true)
        row.with_data_table_cell(value: "Enterprise")
        row.with_expandable_content do |content|
          content.div(class: "p-4 bg-gray-50") do
            content.h4(class: "font-medium mb-2") { "Additional Information" }
            content.p { "Last login: 2 hours ago" }
            content.p { "Account created: January 1, 2024" }
            content.p { "Total orders: 42" }
          end
        end
      end
    end
  end

  # @!endgroup

  # @!group Playground

  # @label Playground
  # @param hover_highlight [Boolean] toggle
  # @param highlight [Symbol] select [~, gray_low, gray_medium, gray_high, low, medium, high]
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
    render_table do |tbody|
      tbody.render ::Decor::Tables::DataTableRow.new(
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

  # @!endgroup

  # @!group States

  # @label Highlighted Rows
  # Rows with different highlight levels
  def highlighted_rows
    render_table do |tbody|
      # Gray highlights
      tbody.render ::Decor::Tables::DataTableRow.new(highlight: :gray_low) do |row|
        row.with_data_table_cell(value: "Low Gray Highlight")
        row.with_data_table_cell(value: "Subtle background")
      end

      tbody.render ::Decor::Tables::DataTableRow.new(highlight: :gray_medium) do |row|
        row.with_data_table_cell(value: "Medium Gray Highlight")
        row.with_data_table_cell(value: "Moderate background")
      end

      tbody.render ::Decor::Tables::DataTableRow.new(highlight: :gray_high) do |row|
        row.with_data_table_cell(value: "High Gray Highlight")
        row.with_data_table_cell(value: "Strong background")
      end

      # Colored highlights
      tbody.render ::Decor::Tables::DataTableRow.new(highlight: :low) do |row|
        row.with_data_table_cell(value: "Low Color Highlight")
        row.with_data_table_cell(value: "Subtle colored background")
      end

      tbody.render ::Decor::Tables::DataTableRow.new(highlight: :medium) do |row|
        row.with_data_table_cell(value: "Medium Color Highlight")
        row.with_data_table_cell(value: "Moderate colored background")
      end

      tbody.render ::Decor::Tables::DataTableRow.new(highlight: :high) do |row|
        row.with_data_table_cell(value: "High Color Highlight")
        row.with_data_table_cell(value: "Strong colored background")
      end
    end
  end

  # @label Disabled Row
  # Row in disabled state
  def disabled
    render_table do |tbody|
      tbody.render ::Decor::Tables::DataTableRow.new(disabled: true) do |row|
        row.with_data_table_cell(value: "Disabled User")
        row.with_data_table_cell(value: "disabled@example.com")
        row.with_data_table_cell(value: "$0.00", numeric: true)
        row.with_data_table_cell(value: "Inactive")
      end
    end
  end

  # @label Hidden Row
  # Row that is hidden (for demonstration)
  def hidden
    render_table do |tbody|
      tbody.render ::Decor::Tables::DataTableRow.new do |row|
        row.with_data_table_cell(value: "Visible Row")
        row.with_data_table_cell(value: "visible@example.com")
      end

      tbody.render ::Decor::Tables::DataTableRow.new(hidden: true) do |row|
        row.with_data_table_cell(value: "Hidden Row")
        row.with_data_table_cell(value: "hidden@example.com")
      end

      tbody.render ::Decor::Tables::DataTableRow.new do |row|
        row.with_data_table_cell(value: "Another Visible Row")
        row.with_data_table_cell(value: "visible2@example.com")
      end
    end
  end

  # @!endgroup

  # @!group Interactions

  # @label Hover Effects
  # Comparison of hover behavior
  def hover_effects
    render_table do |tbody|
      tbody.render ::Decor::Tables::DataTableRow.new(hover_highlight: true) do |row|
        row.with_data_table_cell(value: "Hover Enabled")
        row.with_data_table_cell(value: "Highlights on hover")
      end

      tbody.render ::Decor::Tables::DataTableRow.new(hover_highlight: false) do |row|
        row.with_data_table_cell(value: "Hover Disabled")
        row.with_data_table_cell(value: "No hover effect")
      end
    end
  end

  # @label Multiple Selections
  # Multiple selectable rows
  def multiple_selections
    render_table do |tbody|
      tbody.render ::Decor::Tables::DataTableRow.new(selectable_as: "user_1", selected: true) do |row|
        row.with_data_table_cell(value: "Selected User 1")
        row.with_data_table_cell(value: "user1@example.com")
      end

      tbody.render ::Decor::Tables::DataTableRow.new(selectable_as: "user_2") do |row|
        row.with_data_table_cell(value: "Unselected User 2")
        row.with_data_table_cell(value: "user2@example.com")
      end

      tbody.render ::Decor::Tables::DataTableRow.new(selectable_as: "user_3", selected: true) do |row|
        row.with_data_table_cell(value: "Selected User 3")
        row.with_data_table_cell(value: "user3@example.com")
      end
    end
  end

  # @!endgroup

  private

  def render_table(&block)
    render ::Decor::Element.new do |e|
      e.table(class: "min-w-full border border-gray-200") do
        e.tbody(class: "bg-white divide-y divide-gray-200", &block)
      end
    end
  end
end
