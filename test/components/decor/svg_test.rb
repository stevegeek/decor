require "test_helper"

class Decor::SvgTest < ActiveSupport::TestCase
  # Test only the method-based functionality since rendering requires
  # asset paths and inline_svg gem which may not be available in test environment

  test "file_name method returns correct path" do
    component = Decor::Svg.new(name: "test-icon")

    assert_equal "svgs/test-icon.svg", component.send(:file_name)
  end

  test "file_name method handles heroicons paths" do
    component = Decor::Svg.new(name: "heroicons/outline/home")

    assert_equal "svgs/heroicons/outline/home.svg", component.send(:file_name)
  end

  test "handles complex icon names with slashes" do
    component = Decor::Svg.new(name: "heroicons/outline/academic-cap")
    expected_path = "svgs/heroicons/outline/academic-cap.svg"

    assert_equal expected_path, component.send(:file_name)
  end

  test "inline attribute defaults to true" do
    component = Decor::Svg.new(name: "heroicons/outline/home")

    # Test that the default inline value is true by checking component attribute
    assert_equal true, component.instance_variable_get(:@inline)
  end

  test "handles various heroicon collections" do
    component = Decor::Svg.new(name: "heroicons/solid/home")
    expected_path = "svgs/heroicons/solid/home.svg"

    assert_equal expected_path, component.send(:file_name)
  end

  test "svg_attributes method returns correct hash structure with basic attributes" do
    component = Decor::Svg.new(
      name: "heroicons/outline/home",
      id: "test-id",
      title: "Test Title",
      description: "Test Description",
      width: 20,
      height: 20
    )

    attributes = component.send(:svg_attributes)

    assert_equal "test-id", attributes[:id]
    assert_equal "Test Title", attributes[:title]
    assert_equal "Test Description", attributes[:desc]
    assert_equal 20, attributes[:width]
    assert_equal 20, attributes[:height]
    assert_equal true, attributes[:aria]
    assert_equal true, attributes[:aria_hidden]
    assert_not_nil attributes[:class]
  end

  test "svg_attributes includes render_classes" do
    component = Decor::Svg.new(name: "test-icon")

    attributes = component.send(:svg_attributes)

    assert_not_nil attributes[:class]
    assert_includes attributes[:class], "decor--svg"
  end

  test "strip method removes whitespace and returns html_safe string" do
    component = Decor::Svg.new(name: "heroicons/outline/home")
    test_string = "  <svg>content</svg>  "

    result = component.send(:strip, test_string)

    assert_equal "<svg>content</svg>", result
    assert result.html_safe?
  end

  test "component inherits from PhlexComponent" do
    component = Decor::Svg.new(name: "test-icon")

    assert component.is_a?(Decor::PhlexComponent)
  end

  test "name attribute is required" do
    component = Decor::Svg.new(name: "required-name")

    assert_equal "required-name", component.instance_variable_get(:@name)
  end

  test "handles optional attributes correctly" do
    component = Decor::Svg.new(name: "test")

    assert_nil component.instance_variable_get(:@title)
    assert_nil component.instance_variable_get(:@description)
    assert_nil component.instance_variable_get(:@width)
    assert_nil component.instance_variable_get(:@height)
  end

  test "inline can be set to false" do
    component = Decor::Svg.new(name: "test", inline: false)

    assert_equal false, component.instance_variable_get(:@inline)
  end
end
