require "test_helper"

class Decor::Daisy::Tables::DataTableBuilderSortTest < ActiveSupport::TestCase
  def setup
    @mock_data = [{id: 1, name: "John"}, {id: 2, name: "Jane"}]
  end

  test "merge_sort_and_filter_params reads the class-prefixed sort_by key" do
    builder = create_builder(
      params: ActionController::Parameters.new(
        data_table_builder_sort_by: "name",
        data_table_builder_sorted_direction: "desc"
      )
    )

    assert_equal :name, builder.send(:sanitised_sort_by)
    assert_equal :desc, builder.send(:sanitised_sorted_direction)
  end

  test "regression: unprefixed sort_by param is ignored" do
    builder = create_builder(
      params: ActionController::Parameters.new(sort_by: "name", sorted_direction: "desc")
    )

    assert_nil builder.send(:sanitised_sort_by)
  end

  test "sort_href_for defaults to asc when column is not currently sorted" do
    builder = create_builder(helpers: make_helpers)

    href = builder.send(:sort_href_for, builder.send(:columns_hash)[:name])

    assert_equal "/items?data_table_builder_sort_by=name&data_table_builder_sorted_direction=asc", href
  end

  test "sort_href_for toggles asc → desc on the active column" do
    builder = create_builder(
      params: ActionController::Parameters.new(
        data_table_builder_sort_by: "name",
        data_table_builder_sorted_direction: "asc"
      ),
      helpers: make_helpers
    )

    href = builder.send(:sort_href_for, builder.send(:columns_hash)[:name])

    assert_includes href, "data_table_builder_sorted_direction=desc"
  end

  test "sort_href_for toggles desc → asc on the active column" do
    builder = create_builder(
      params: ActionController::Parameters.new(
        data_table_builder_sort_by: "name",
        data_table_builder_sorted_direction: "desc"
      ),
      helpers: make_helpers
    )

    href = builder.send(:sort_href_for, builder.send(:columns_hash)[:name])

    assert_includes href, "data_table_builder_sorted_direction=asc"
  end

  test "sort_href_for preserves unrelated query params (page, filters)" do
    builder = create_builder(
      helpers: make_helpers(query_parameters: {"page" => "3", "category" => "books"})
    )

    href = builder.send(:sort_href_for, builder.send(:columns_hash)[:name])

    assert_includes href, "page=3"
    assert_includes href, "category=books"
    assert_includes href, "data_table_builder_sort_by=name"
  end

  test "sort_href_for overwrites any existing sort params in the query string" do
    builder = create_builder(
      helpers: make_helpers(query_parameters: {
        "data_table_builder_sort_by" => "stale",
        "data_table_builder_sorted_direction" => "desc"
      })
    )

    href = builder.send(:sort_href_for, builder.send(:columns_hash)[:name])

    refute_includes href, "stale"
    assert_includes href, "data_table_builder_sort_by=name"
    assert_includes href, "data_table_builder_sorted_direction=asc"
  end

  private

  def create_builder(params: ActionController::Parameters.new({}), helpers: Object.new, sortable_columns: [:name], **attributes)
    builder = Decor::Daisy::Tables::DataTableBuilder.new(
      params: params,
      helpers: helpers,
      query: @mock_data,
      title: "Test Table",
      paginated: false,
      **attributes
    )
    sortable_columns.each do |col_name|
      builder.column(col_name, sortable: true) { |i| i[col_name] }
    end
    builder
  end

  def make_helpers(path: "/items", query_parameters: {})
    request = Struct.new(:path, :query_parameters).new(path, query_parameters)
    helpers = Object.new
    helpers.define_singleton_method(:request) { request }
    helpers
  end
end
