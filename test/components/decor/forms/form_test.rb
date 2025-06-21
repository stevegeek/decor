require "test_helper"

class Decor::Forms::FormTest < ActiveSupport::TestCase
  def setup
    @model = OpenStruct.new(name: "Test", email: "test@example.com")
  end

  test "renders successfully with model" do
    component = Decor::Forms::Form.new(model: @model, url: "/test")
    rendered = render_component(component)

    assert_includes rendered, "<form"
    assert_includes rendered, 'role="form"'
    assert_includes rendered, 'action="/test"'
  end

  test "renders with custom URL" do
    component = Decor::Forms::Form.new(model: @model, url: "/custom-path")
    rendered = render_component(component)

    assert_includes rendered, 'action="/custom-path"'
  end

  test "renders with HTTP method" do
    component = Decor::Forms::Form.new(model: @model, url: "/test", http_method: :patch)
    rendered = render_component(component)

    assert_includes rendered, 'method="patch"'
  end

  test "renders as local form by default" do
    component = Decor::Forms::Form.new(model: @model, url: "/test")
    rendered = render_component(component)

    assert_includes rendered, 'data-turbo="false"'
  end

  test "renders as remote form when local is false" do
    component = Decor::Forms::Form.new(model: @model, url: "/test", local: false)
    rendered = render_component(component)

    assert_includes rendered, 'data-type="json"'
  end

  test "includes lock version when model responds to it" do
    model_with_lock = OpenStruct.new(name: "Test", lock_version: 5)
    def model_with_lock.respond_to?(method)
      method == :lock_version || super
    end

    component = Decor::Forms::Form.new(model: model_with_lock, url: "/test")
    rendered = render_component(component)

    assert_includes rendered, 'name="lock_version"'
    assert_includes rendered, 'value="5"'
  end

  test "handles model as hash with lock_version" do
    hash_model = {name: "Test", lock_version: 3}
    component = Decor::Forms::Form.new(model: hash_model, url: "/test")
    rendered = render_component(component)

    assert_includes rendered, 'name="lock_version"'
    assert_includes rendered, 'value="3"'
  end

  test "renders with custom namespace" do
    component = Decor::Forms::Form.new(
      model: @model,
      url: "/test",
      namespace: :admin
    )

    # The namespace affects form field names, but we can't easily test this
    # without rendering actual form fields within the form
    rendered = render_component(component)
    assert_includes rendered, "<form"
  end

  test "sets up stimulus actions for local forms" do
    component = Decor::Forms::Form.new(model: @model, url: "/test", local: true)
    rendered = render_component(component)

    # Local forms should have submit event handler
    assert_includes rendered, "data-action="
    assert_includes rendered, "submit"
  end

  test "sets up stimulus actions for remote forms" do
    component = Decor::Forms::Form.new(model: @model, url: "/test", local: false)
    rendered = render_component(component)

    # Remote forms should have ajax event handlers
    assert_includes rendered, "data-action="
    assert_includes rendered, "ajax:beforeSend"
  end

  test "renders with custom form builder" do
    custom_builder = Class.new(ActionView::Helpers::FormBuilder)
    component = Decor::Forms::Form.new(
      model: @model,
      url: "/test",
      form_builder_class: custom_builder
    )

    rendered = render_component(component)
    assert_includes rendered, "<form"
  end

  test "uses nokogiri for parsing" do
    component = Decor::Forms::Form.new(model: @model, url: "/test")
    fragment = render_fragment(component)

    form = fragment.at_css("form")
    assert_not_nil form
    assert_equal "form", form["role"]
    assert_equal "/test", form["action"]
    assert_includes form["data-turbo"], "false"
  end
end
