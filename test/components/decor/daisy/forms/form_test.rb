require "test_helper"

class Decor::Daisy::Forms::FormTest < ActiveSupport::TestCase
  class TestModel
    include ActiveModel::Model
    include ActiveModel::Attributes

    attribute :name, :string
    attribute :email, :string
    attribute :lock_version, :integer

    def self.model_name
      ActiveModel::Name.new(self, nil, "TestModel")
    end

    def persisted?
      false
    end

    def to_key
      nil
    end

    def to_param
      nil
    end
  end

  def setup
    @model = TestModel.new(name: "Test", email: "test@example.com")
  end

  test "renders successfully with model" do
    component = Decor::Daisy::Forms::Form.new(model: @model, url: "/test")
    rendered = render_component(component)

    assert_includes rendered, "<form"
    assert_includes rendered, 'role="form"'
    assert_includes rendered, 'action="/test"'
  end

  test "renders with custom URL" do
    component = Decor::Daisy::Forms::Form.new(model: @model, url: "/custom-path")
    rendered = render_component(component)

    assert_includes rendered, 'action="/custom-path"'
  end

  test "renders with HTTP method" do
    component = Decor::Daisy::Forms::Form.new(model: @model, url: "/test", http_method: :patch)
    rendered = render_component(component)

    assert_includes rendered, 'name="_method"'
    assert_includes rendered, 'value="patch"'
  end

  test "renders as local form by default" do
    component = Decor::Daisy::Forms::Form.new(model: @model, url: "/test")
    rendered = render_component(component)

    assert_includes rendered, 'data-turbo="false"'
  end

  test "renders as remote form when local is false" do
    component = Decor::Daisy::Forms::Form.new(model: @model, url: "/test", local: false)
    rendered = render_component(component)

    assert_includes rendered, 'data-type="json"'
  end

  test "includes lock version when model responds to it" do
    model_with_lock = TestModel.new(name: "Test", lock_version: 5)

    component = Decor::Daisy::Forms::Form.new(model: model_with_lock, url: "/test")
    rendered = render_component(component)

    assert_includes rendered, "test_model[lock_version]"
    assert_includes rendered, "value=\"5\""
  end

  test "handles hash model with lock_version" do
    component = Decor::Daisy::Forms::Form.new(url: "/test") do |form|
      form.raw '<input name="lock_version" value="3" type="hidden">'.html_safe
    end
    rendered = render_component(component)

    assert_includes rendered, 'name="lock_version"'
    assert_includes rendered, 'value="3"'
  end

  test "renders with custom namespace" do
    component = Decor::Daisy::Forms::Form.new(
      model: @model,
      url: "/test",
      namespace: :admin
    )

    rendered = render_component(component)
    assert_includes rendered, "<form"
  end

  test "sets up stimulus actions for local forms" do
    component = Decor::Daisy::Forms::Form.new(model: @model, url: "/test", local: true)
    rendered = render_component(component)

    assert_includes rendered, "data-controller="
    assert_includes rendered, "decor--daisy--forms--form"
  end

  test "sets up stimulus actions for remote forms" do
    component = Decor::Daisy::Forms::Form.new(model: @model, url: "/test", local: false)
    rendered = render_component(component)

    assert_includes rendered, "data-remote="
    assert_includes rendered, "data-type="
    assert_includes rendered, "json"
  end

  test "uses nokogiri for parsing" do
    component = Decor::Daisy::Forms::Form.new(model: @model, url: "/test")
    fragment = render_fragment(component)

    form = fragment.at_css("form")
    assert_not_nil form
    assert_equal "form", form["role"]
    assert_equal "/test", form["action"]
    assert_includes form["data-turbo"], "false"
  end
end
