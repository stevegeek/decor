require "test_helper"

class Decor::ToggleTest < ActiveSupport::TestCase
  def setup
    @mock_model = TestModel.new(id: 1, active: true)
    @mock_url = "/test/1"
  end

  test "renders successfully with default settings" do
    component = Decor::Toggle.new(
      model: @mock_model,
      url: @mock_url,
      property_name: :active
    )
    rendered = render_component(component)

    assert_includes rendered, "<form"
    assert_includes rendered, 'method="post"'
    assert_includes rendered, "test_model[active]"
  end

  test "renders with custom checked and unchecked values" do
    component = Decor::Toggle.new(
      model: @mock_model,
      url: @mock_url,
      property_name: :active,
      checked_value: "1",
      unchecked_value: "0"
    )
    rendered = render_component(component)

    assert_includes rendered, "<form"
    assert_includes rendered, "test_model[active]"
  end

  test "renders with custom http method" do
    component = Decor::Toggle.new(
      model: @mock_model,
      url: @mock_url,
      property_name: :active,
      http_method: :put
    )
    rendered = render_component(component)

    assert_includes rendered, "<form"
    assert_includes rendered, "_method"
    assert_includes rendered, "put"
  end

  test "renders with various property names" do
    %i[active enabled visible published].each do |property|
      @mock_model.define_singleton_method(property) { true }
      @mock_model.define_singleton_method("#{property}=") { |val| }
      
      component = Decor::Toggle.new(
        model: @mock_model,
        url: @mock_url,
        property_name: property
      )
      rendered = render_component(component)

      assert_includes rendered, "<form"
      assert_includes rendered, "test_model[#{property}]"
    end
  end

  test "renders with block content instead of default switch" do
    component = Decor::Toggle.new(
      model: @mock_model,
      url: @mock_url,
      property_name: :active
    ) do
      "Custom toggle content"
    end
    rendered = render_component(component)

    assert_includes rendered, "<form"
    assert_includes rendered, "Custom toggle content"
  end

  test "component inherits from PhlexComponent base class" do
    component = Decor::Toggle.new(
      model: @mock_model,
      url: @mock_url,
      property_name: :active
    )

    assert component.is_a?(Decor::PhlexComponent)
  end

  test "renders form with correct action URL" do
    component = Decor::Toggle.new(
      model: @mock_model,
      url: "/custom/path",
      property_name: :active
    )
    rendered = render_component(component)

    assert_includes rendered, "<form"
    assert_includes rendered, 'action="/custom/path"'
  end

  test "can be initialized without errors" do
    component = Decor::Toggle.new(
      model: @mock_model,
      url: @mock_url,
      property_name: :active,
      http_method: :put,
      checked_value: "yes",
      unchecked_value: "no",
      switch_options: {theme: :primary}
    )

    assert_not_nil component
    assert component.is_a?(Decor::Toggle)
  end
end
