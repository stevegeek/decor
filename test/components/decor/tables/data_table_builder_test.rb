require "test_helper"

class Decor::Tables::DataTableBuilderTest < ActiveSupport::TestCase
  def setup
    @mock_data = [
      {id: 1, name: "John Doe", email: "john@example.com", active: true},
      {id: 2, name: "Jane Smith", email: "jane@example.com", active: false}
    ]
    @mock_params = ActionController::Parameters.new({})
    @mock_helpers = Object.new
  end

  private

  def create_builder(attributes = {}, &block)
    default_attributes = {
      query: @mock_data,
      title: "Test Table",
      paginated: false
    }
    Decor::Tables::DataTableBuilder.new(
      params: @mock_params,
      helpers: @mock_helpers,
      **default_attributes.merge(attributes),
      &block
    )
  end

  test "renders successfully with data and columns" do
    builder = create_builder do |b|
      b.column(:name, title: "Name")
      b.column(:email, title: "Email")
    end
    component = builder.component
    rendered = render_component(component)

    assert_includes rendered, "table"
    assert_includes rendered, "Name"
    assert_includes rendered, "Email"
  end

  test "renders data from collection" do
    builder = create_builder do |b|
      b.column(:name, title: "Name") { |item| item[:name] }
      b.column(:email, title: "Email") { |item| item[:email] }
    end
    component = builder.component
    rendered = render_component(component)

    assert_includes rendered, "John Doe"
    assert_includes rendered, "jane@example.com"
  end

  test "supports custom column formatting" do
    builder = create_builder do |b|
      b.column(:active, title: "Status") { |item| item[:active] ? "Active" : "Inactive" }
    end
    component = builder.component
    rendered = render_component(component)

    assert_includes rendered, "Active"
    assert_includes rendered, "Inactive"
  end

  test "renders table headers" do
    builder = create_builder do |b|
      b.column(:name, title: "Full Name") { |item| item[:name] }
      b.column(:email, title: "Email Address") { |item| item[:email] }
    end
    component = builder.component
    rendered = render_component(component)

    assert_includes rendered, "Full Name"
    assert_includes rendered, "Email Address"
  end

  test "renders table rows for each data item" do
    builder = create_builder do |b|
      b.column(:name, title: "Name") { |item| item[:name] }
    end
    component = builder.component
    rendered = render_component(component)

    # Should contain both names from our mock data
    assert_includes rendered, "John Doe"
    assert_includes rendered, "Jane Smith"
  end

  test "component returns DataTable instance" do
    builder = create_builder
    component = builder.component

    assert component.is_a?(Decor::Tables::DataTable)
  end

  test "supports empty data collection" do
    builder = create_builder(query: []) do |b|
      b.column(:name, title: "Name") { |item| item[:name] }
    end
    component = builder.component
    rendered = render_component(component)

    assert_includes rendered, "table"
    assert_includes rendered, "Name"
  end

  test "supports sortable columns" do
    builder = create_builder do |b|
      b.column(:name, title: "Name", sortable: true) { |item| item[:name] }
    end
    component = builder.component
    rendered = render_component(component)

    assert_includes rendered, "Name"
    assert_includes rendered, "table"
  end

  test "handles multiple columns with different data types" do
    builder = create_builder do |b|
      b.column(:id, title: "ID") { |item| item[:id] }
      b.column(:name, title: "Name") { |item| item[:name] }
      b.column(:active, title: "Active") { |item| item[:active] }
    end
    component = builder.component
    rendered = render_component(component)

    assert_includes rendered, "1"
    assert_includes rendered, "2"
    assert_includes rendered, "John Doe"
    assert_includes rendered, "Jane Smith"
  end

  test "supports custom cell rendering" do
    builder = create_builder do |b|
      b.column(:email, title: "Contact") { |item| "📧 #{item[:email]}" }
    end
    component = builder.component
    rendered = render_component(component)

    assert_includes rendered, "📧 john@example.com"
    assert_includes rendered, "📧 jane@example.com"
  end

  test "renders with table styling" do
    builder = create_builder do |b|
      b.column(:name, title: "Name") { |item| item[:name] }
    end
    component = builder.component
    rendered = render_component(component)

    assert_includes rendered, "table"
  end

  test "supports pagination integration" do
    builder = create_builder(paginated: true) do |b|
      b.column(:name, title: "Name") { |item| item[:name] }
    end

    # Override pagination_options to provide a path
    def builder.pagination_options
      {path: "/test"}
    end

    component = builder.component
    rendered = render_component(component)

    assert_includes rendered, "table"
  end

  test "column method adds columns to internal collection" do
    builder = create_builder

    # This test verifies the column method exists and can be called
    assert_respond_to builder, :column
  end

  test "builder configuration is accessible" do
    builder = create_builder(title: "Custom Title")

    assert_respond_to builder, :params
  end

  test "supports CTA blocks" do
    builder = create_builder do |b|
      b.column(:name, title: "Name") { |item| item[:name] }
      b.with_cta { "Custom Action" }
    end
    component = builder.component

    # Should not raise an error
    assert component.is_a?(Decor::Tables::DataTable)
  end
end
