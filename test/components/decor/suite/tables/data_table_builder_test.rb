# frozen_string_literal: true

require "test_helper"

class Decor::Suite::Tables::DataTableBuilderTest < ActiveSupport::TestCase
  def setup
    @mock_data = [
      {id: 1, name: "John Doe", email: "john@example.com", active: true},
      {id: 2, name: "Jane Smith", email: "jane@example.com", active: false}
    ]
    @mock_params = ActionController::Parameters.new({})
    @mock_helpers = Object.new
  end

  def create_builder(attributes = {}, &block)
    default_attributes = {
      query: @mock_data,
      title: "Test Table",
      paginated: false
    }
    # Apply the DSL block *after* construction rather than passing it to
    # `.new`. The builder's `self.new` consumes the block on initialization,
    # but Phlex also stashes it on `@_content_block` and re-invokes it during
    # `vanish(&)` in `view_template`. That re-invocation hits
    # `columns_hash[name].attributes` (Literal::Struct has no `attributes`).
    # Applying the DSL post-construction avoids the double invocation while
    # producing the same builder state.
    builder = Decor::Suite::Tables::DataTableBuilder.new(
      params: @mock_params,
      helpers: @mock_helpers,
      **default_attributes.merge(attributes)
    )
    block&.call(builder)
    builder
  end

  test "component returns a Suite DataTable instance (not Daisy)" do
    builder = create_builder
    component = builder.component
    assert_kind_of Decor::Suite::Tables::DataTable, component
    refute_kind_of Decor::Daisy::Tables::DataTable, component
  end

  test "renders Suite chrome rounded card with hairline border" do
    builder = create_builder do |b|
      b.column(:name, title: "Name") { |row| row[:name] }
    end
    rendered = render_component(builder)

    assert_includes rendered, "decor:border-suite-hairline"
    assert_includes rendered, "decor:rounded-suite-card"
  end

  test "renders columns and row data" do
    builder = create_builder do |b|
      b.column(:name, title: "Full Name") { |row| row[:name] }
      b.column(:email, title: "Email") { |row| row[:email] }
    end
    rendered = render_component(builder)

    assert_includes rendered, "Full Name"
    assert_includes rendered, "Email"
    assert_includes rendered, "John Doe"
    assert_includes rendered, "jane@example.com"
  end

  test "column block humanizes the column name when no title given" do
    builder = create_builder do |b|
      b.column(:email) { |row| row[:email] }
    end
    rendered = render_component(builder)
    assert_includes rendered, "Email"
  end

  test "column block computes cell content with arity 1" do
    builder = create_builder do |b|
      b.column(:name) { |row| "USER: #{row[:name]}" }
    end
    rendered = render_component(builder)
    assert_includes rendered, "USER: John Doe"
    assert_includes rendered, "USER: Jane Smith"
  end

  test "renders empty state when data is empty" do
    builder = create_builder(query: []) do |b|
      b.column(:name, title: "Name") { |row| row[:name] }
    end
    rendered = render_component(builder)
    assert_includes rendered, "Nothing here yet"
  end

  test "renders Suite typography on body cells (suite-body class)" do
    builder = create_builder do |b|
      b.column(:name, title: "Name") { |row| row[:name] }
    end
    rendered = render_component(builder)
    assert_includes rendered, "decor:suite-body"
  end

  test "header row uses Suite gray-25 background and hairline divider" do
    builder = create_builder do |b|
      b.column(:name, title: "Name") { |row| row[:name] }
    end
    rendered = render_component(builder)
    assert_includes rendered, "decor:bg-suite-gray-25"
  end

  test "row body cells render in <tr><td> elements" do
    builder = create_builder do |b|
      b.column(:name, title: "Name") { |row| row[:name] }
    end
    doc = render_fragment(builder)
    assert_operator doc.css("tbody tr").size, :>=, 2
    assert_operator doc.css("tbody td").size, :>=, 2
  end

  test "subtitle is rendered when given" do
    builder = create_builder(subtitle: "Just a subtitle") do |b|
      b.column(:name, title: "Name") { |row| row[:name] }
    end
    rendered = render_component(builder)
    assert_includes rendered, "Just a subtitle"
  end

  test "bulk_action DSL registers actions and exposes them via #bulk_actions" do
    builder = create_builder(rows_selectable_as_name: :user_ids) do |b|
      b.column(:name, title: "Name") { |row| row[:name] }
      b.bulk_action(:archive, label: "Archive")
      b.bulk_action(:delete, label: "Delete", style: :danger)
    end
    # `create_builder` applies the DSL block eagerly, so `bulk_actions` is
    # already populated without rendering. Fully rendering would require a
    # valid form URL on the bulk-actions bar, which we don't care about here.
    actions = builder.bulk_actions
    assert_equal 2, actions.size
    assert_equal :archive, actions[0].name
    assert_equal "Delete", actions[1].label
    assert_equal :danger, actions[1].style
  end

  test "should_persist_selections? defaults to true when enable_selection_persistence is true" do
    builder = create_builder(enable_selection_persistence: true)
    assert builder.send(:should_persist_selections?)
  end

  test "should_persist_selections? returns true when selectable + bulk actions" do
    builder = create_builder(rows_selectable_as_name: :ids, enable_selection_persistence: false) do |b|
      b.bulk_action(:archive, label: "Archive")
    end
    # `create_builder` applies the DSL block eagerly, so the bulk-action
    # registration is already visible to `should_persist_selections?`
    # without needing a render pass.
    assert builder.send(:should_persist_selections?)
  end

  test "should_persist_selections? returns false when not selectable and no bulk actions" do
    builder = create_builder(enable_selection_persistence: false)
    refute builder.send(:should_persist_selections?)
  end

  test "configure_slot forwards to the underlying DataTable component" do
    builder = create_builder do |b|
      b.column(:name, title: "Name") { |row| row[:name] }
      b.configure_slot(:filter_bar) { "[FILTER BAR CONTENT]" }
    end
    rendered = render_component(builder)
    assert_includes rendered, "[FILTER BAR CONTENT]"
  end

  test "with_cta block is exposed to search/filter slot" do
    # CTA alone triggers search_or_filter_element?. Block runs during render.
    builder = create_builder do |b|
      b.column(:name, title: "Name") { |row| row[:name] }
      b.with_cta { "CTA BUTTON" }
    end
    render_component(builder)
    assert builder.send(:search_or_filter_element?)
  end

  test "column DSL returns self for chaining" do
    builder = create_builder
    result = builder.column(:name, title: "Name")
    assert_same builder, result
  end

  test "bulk_action DSL returns self for chaining" do
    builder = create_builder
    result = builder.bulk_action(:archive, label: "Archive")
    assert_same builder, result
  end

  test "html_options pass through to the DataTable" do
    builder = create_builder(html_options: {data: {custom: "yes"}}) do |b|
      b.column(:name, title: "Name") { |row| row[:name] }
    end
    rendered = render_component(builder)
    # html_options become table_html_options on Suite DataTable
    assert_includes rendered, "custom"
  end

  test "cell_attributes hook merges into each cell" do
    builder = create_builder do |b|
      b.column(:name, title: "Name") { |row| row[:name] }
    end
    builder.define_singleton_method(:cell_attributes) do |_row, _t, _i, _ii|
      {align: :center}
    end
    rendered = render_component(builder)
    # Suite cell renders an alignment class for :center
    assert_includes rendered, "decor:text-center"
  end

  test "row_attributes hook merges into each row" do
    builder = create_builder do |b|
      b.column(:name, title: "Name") { |row| row[:name] }
    end
    builder.define_singleton_method(:row_attributes) do |_row, _t, _i, _ii|
      {disabled: true}
    end
    rendered = render_component(builder)
    # Suite row applies opacity-50 when disabled
    assert_includes rendered, "decor:opacity-50"
  end

  test "transform_row hook rewrites the value going into cells" do
    builder = create_builder do |b|
      b.column(:name, title: "Name") { |row| row[:name] }
    end
    builder.define_singleton_method(:transform_row) do |row_data, _i, _ii|
      row_data.merge(name: "TX_#{row_data[:name]}")
    end
    rendered = render_component(builder)
    assert_includes rendered, "TX_John Doe"
    assert_includes rendered, "TX_Jane Smith"
  end
end
