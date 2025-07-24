# @label DataTableBuilder
class ::Decor::Tables::DataTableBuilderPreview < ::Lookbook::Preview
  # A powerful table builder that provides automatic data fetching, sorting, filtering,
  # and pagination. Use DataTableBuilder for complex tables that need server-side
  # features and state management, or when working with ActiveRecord/Query objects.

  # @group Examples

  # Basic Table Builder
  # -------------------
  # A simple table using an inline builder class with basic columns.
  def default
    render_with_template(
      locals: {
        title: "Product Inventory"
      }
    )
  end

  # Table Builder with Subclass
  # ---------------------------
  # Using a custom DataTableBuilder subclass with row transformations,
  # sorting, and custom attributes.
  # @param alternating toggle
  def with_subclass(alternating: false)
    render_with_template(
      locals: {
        alternating: alternating
      }
    )
  end

  # Selectable Rows
  # ---------------
  # Table with row selection checkboxes for bulk operations.
  def selectable
    render_with_template(
      locals: {
        title: "User Management",
        rows_selectable_as_name: "user_ids[]"
      }
    )
  end

  # @group Playground

  # @param title text
  # @param size [Symbol] select [~, xs, sm, md, lg, xl]
  # @param color [Symbol] select [~, base, primary, secondary, accent, neutral, success, error, warning, info]
  # @param style [Symbol] select [~, filled, outlined, ghost]
  # @param alternating toggle
  # @param hover_highlight toggle
  # @param header_height select [comfortable, standard, tight]
  # @param row_height select [comfortable, standard, tight]
  # @param rows_selectable_as_name text
  # @param paginated toggle
  def playground(
    title: "Title of table",
    size: nil,
    color: nil,
    style: nil,
    alternating: false,
    hover_highlight: false,
    header_height: :standard,
    row_height: :standard,
    rows_selectable_as_name: nil,
    paginated: false
  )
    render_with_template(
      locals: {
        title: title,
        size: size,
        color: color,
        style: style,
        alternating: alternating,
        hover_highlight: hover_highlight,
        header_height: header_height,
        row_height: row_height,
        rows_selectable_as_name: rows_selectable_as_name,
        paginated: paginated
      }
    )
  end

  # @group Column Configuration

  # Column Types
  # ------------
  # Demonstrates different column configurations including numeric,
  # sortable, and stretched columns.
  def column_types
    render_with_template
  end

  # @group Sorting & Filtering

  # Sortable Columns
  # ----------------
  # Table with sortable columns and default sort configuration.
  def sortable
    render_with_template
  end

  # @group Row Customization

  # Row Highlighting
  # ----------------
  # Shows different row highlight states and patterns.
  def row_highlights
    render_with_template
  end

  # Row Attributes
  # --------------
  # Custom row attributes including paths and click handlers.
  def row_attributes
    render_with_template
  end

  # Example DataTableBuilder subclass used in previews
  class DataTableBuilderSubclass < ::Decor::Tables::DataTableBuilder
    def title
      "The Amazing Table"
    end

    def pagination_options
      {
        path: "#" # Just so we can render in preview
      }
    end

    def default_sort_by
      :id
    end

    def default_sort_direction
      :desc
    end

    def default_page_size
      50
    end

    def query
      ::ApplicationCollectionBackedQuery.wrap(
        ("a".."z").map { |c| {id: c} }
      ).new
    end

    def transform_row(row_data, index, _item_index)
      row_data[:id] = row_data[:id].upcase
      row_data
    end

    def path_for_row(_row_data, _transformed_value, index, item_index)
      return if item_index == 0
      "#row_#{index}_item_#{item_index}"
    end

    def row_attributes(_row_data, _transformed_value, index, _item_index)
      (index == 1) ? {highlight: :high} : {}
    end
  end
end
