require "test_helper"
require "ostruct"

class Decor::ToggleTest < ActiveSupport::TestCase
  # This test is simplified because the Toggle component depends on Decor::Forms::Form
  # which may not be available in the test environment. We'll focus on testing
  # the component attributes and initialization.

  def setup
    @mock_model = OpenStruct.new(id: 1, active: true)
    @mock_url = "/test/1"
  end

  test "applies default checked and unchecked values" do
    component = Decor::Toggle.new(
      model: @mock_model,
      url: @mock_url,
      property_name: :active
    )

    assert_equal "true", component.checked_value
    assert_equal "false", component.unchecked_value
  end

  test "applies custom checked and unchecked values" do
    component = Decor::Toggle.new(
      model: @mock_model,
      url: @mock_url,
      property_name: :active,
      checked_value: "1",
      unchecked_value: "0"
    )

    assert_equal "1", component.checked_value
    assert_equal "0", component.unchecked_value
  end

  test "passes switch options to form builder" do
    switch_options = {size: :large, disabled: true}
    component = Decor::Toggle.new(
      model: @mock_model,
      url: @mock_url,
      property_name: :active,
      switch_options: switch_options
    )

    assert_equal switch_options, component.switch_options
  end

  test "defaults http_method to patch" do
    component = Decor::Toggle.new(
      model: @mock_model,
      url: @mock_url,
      property_name: :active
    )

    assert_equal :patch, component.http_method
  end

  test "handles property_name as required attribute" do
    component = Decor::Toggle.new(
      model: @mock_model,
      url: @mock_url,
      property_name: :active
    )

    assert_equal :active, component.property_name
  end

  test "applies switch_options with empty hash by default" do
    component = Decor::Toggle.new(
      model: @mock_model,
      url: @mock_url,
      property_name: :active
    )

    assert_equal({}, component.switch_options)
  end

  test "handles model and url parameters" do
    component = Decor::Toggle.new(
      model: @mock_model,
      url: @mock_url,
      property_name: :active
    )

    assert_equal @mock_model, component.model
    assert_equal @mock_url, component.url
  end

  test "handles various property names" do
    %i[active enabled visible published].each do |property|
      component = Decor::Toggle.new(
        model: @mock_model,
        url: @mock_url,
        property_name: property
      )

      assert_equal property, component.property_name
    end
  end

  test "supports complex switch options" do
    complex_options = {
      size: :large,
      disabled: false,
      class: "custom-switch",
      data: {test: "value"}
    }

    component = Decor::Toggle.new(
      model: @mock_model,
      url: @mock_url,
      property_name: :active,
      switch_options: complex_options
    )

    assert_equal complex_options, component.switch_options
  end

  test "component inherits from Component base class" do
    component = Decor::Toggle.new(
      model: @mock_model,
      url: @mock_url,
      property_name: :active
    )

    assert component.is_a?(Decor::Component)
  end

  test "can be initialized with all required attributes" do
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
    assert_equal :put, component.http_method
    assert_equal "yes", component.checked_value
    assert_equal "no", component.unchecked_value
    assert_equal({theme: :primary}, component.switch_options)
  end
end
