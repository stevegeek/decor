# @label DataTableBuilder
class ::Decor::Tables::DataTableBuilderPreview < ::Lookbook::Preview
  # @param title text
  # @param rows_selectable_as_name text
  def playground(
    title: "Title of table",
    rows_selectable_as_name: nil
  )
    render_with_template(
      locals: {
        title: title,
        rows_selectable_as_name: rows_selectable_as_name
      }
    )
  end

  class DataTableBuilderSubclass < ::Decor::Tables::DataTableBuilder
    def title
      "The amazing Table"
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

  # @param alternating toggle
  def with_subclass(alternating: false)
    render_with_template(
      locals: {
        alternating: alternating
      }
    )
  end
end
