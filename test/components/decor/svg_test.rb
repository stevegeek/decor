require "test_helper"

class Decor::SvgTest < ActiveSupport::TestCase
  test "file_name method returns correct path" do
    component = Decor::Svg.new(file_name: "svgs/test-icon.svg")

    assert_equal "svgs/test-icon.svg", component.file_name
  end

  test "file_name method handles heroicons paths" do
    component = Decor::Svg.new(file_name: "svgs/heroicons/outline/home.svg")

    assert_equal "svgs/heroicons/outline/home.svg", component.file_name
  end

  test "handles complex icon file paths with slashes" do
    component = Decor::Svg.new(file_name: "svgs/heroicons/outline/academic-cap.svg")
    expected_path = "svgs/heroicons/outline/academic-cap.svg"

    assert_equal expected_path, component.file_name
  end

  test "inline attribute defaults to true" do
    component = Decor::Svg.new(file_name: "svgs/heroicons/outline/home.svg")

    # Test that the default inline value is true by checking component attribute
    assert_equal true, component.instance_variable_get(:@inline)
  end

  test "handles various heroicon collections" do
    component = Decor::Svg.new(file_name: "svgs/heroicons/solid/home.svg")
    expected_path = "svgs/heroicons/solid/home.svg"

    assert_equal expected_path, component.file_name
  end

  test "svg_attributes method returns correct hash structure with basic attributes" do
    component = Decor::Svg.new(
      file_name: "svgs/heroicons/outline/home.svg",
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
    component = Decor::Svg.new(file_name: "svgs/test-icon.svg")

    attributes = component.send(:svg_attributes)

    assert_not_nil attributes[:class]
    assert_includes attributes[:class], "decor--svg"
  end

  test "strip method removes whitespace and returns html_safe string" do
    component = Decor::Svg.new(file_name: "svgs/heroicons/outline/home.svg")
    test_string = "  <svg>content</svg>  "

    result = component.send(:strip, test_string)

    assert_equal "<svg>content</svg>", result
    assert result.html_safe?
  end

  test "component inherits from PhlexComponent" do
    component = Decor::Svg.new(file_name: "svgs/test-icon.svg")

    assert component.is_a?(Decor::PhlexComponent)
  end

  test "file_name attribute is required" do
    component = Decor::Svg.new(file_name: "svgs/required-file.svg")

    assert_equal "svgs/required-file.svg", component.instance_variable_get(:@file_name)
  end

  test "handles optional attributes correctly" do
    component = Decor::Svg.new(file_name: "svgs/test.svg")

    assert_nil component.instance_variable_get(:@title)
    assert_nil component.instance_variable_get(:@description)
    assert_nil component.instance_variable_get(:@width)
    assert_nil component.instance_variable_get(:@height)
  end

  test "inline can be set to false" do
    component = Decor::Svg.new(file_name: "svgs/test.svg", inline: false)

    assert_equal false, component.instance_variable_get(:@inline)
  end

  test "renders successfully when inline is false" do
    component = Decor::Svg.new(file_name: "heroicons/outline/home.svg", inline: false)
    rendered = render_component(component)

    assert_includes rendered, "<svg"
    assert_includes rendered, "data-src="
    assert_includes rendered, "heroicons/outline/home"  # Don't check for .svg extension due to asset digests
  end
end
