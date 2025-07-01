require "test_helper"

class Decor::TagTest < ActiveSupport::TestCase
  test "renders successfully with label" do
    component = Decor::Tag.new(label: "Test Tag")
    rendered = render_component(component)

    assert_includes rendered, "Test Tag"
    assert_includes rendered, "<span"
    assert_includes rendered, "rounded-full"
  end

  test "renders with label attribute" do
    component = Decor::Tag.new(label: "Test Tag")
    rendered = render_component(component)

    assert_includes rendered, "Test Tag"
    assert_includes rendered, "rounded-full"
  end

  test "renders with label content" do
    component = Decor::Tag.new(label: "Content Tag")
    rendered = render_component(component)

    assert_includes rendered, "Content Tag"
    assert_includes rendered, "whitespace-nowrap"
  end

  # Color tests
  test "applies correct color classes" do
    [:primary, :secondary, :accent, :success, :error, :warning, :info, :neutral].each do |color|
      component = Decor::Tag.new(label: "Test", color: color)
      rendered = render_component(component)

      assert_includes rendered, "bg-#{color}"
      assert_includes rendered, "text-#{color}-content"
    end
  end

  test "defaults to neutral color" do
    component = Decor::Tag.new(label: "Default")
    rendered = render_component(component)

    assert_includes rendered, "bg-neutral"
    assert_includes rendered, "text-neutral-content"
  end

  # Size tests
  test "applies correct size classes" do
    component = Decor::Tag.new(label: "Large Tag", size: :lg)
    rendered = render_component(component)

    assert_includes rendered, "px-3 py-1 text-base"
  end

  test "applies small size classes" do
    component = Decor::Tag.new(label: "Small Tag", size: :sm)
    rendered = render_component(component)

    assert_includes rendered, "px-2.5 py-0.5 text-sm"
  end

  test "applies xs size classes" do
    component = Decor::Tag.new(label: "XS Tag", size: :xs)
    rendered = render_component(component)

    assert_includes rendered, "px-2 py-0.5 text-xs"
  end

  test "medium size is default" do
    component = Decor::Tag.new(label: "Medium Tag", size: :md)
    rendered = render_component(component)

    assert_includes rendered, "px-2.5 py-0.5 text-sm"
  end

  test "applies xl size classes" do
    component = Decor::Tag.new(label: "XL Tag", size: :xl)
    rendered = render_component(component)

    assert_includes rendered, "px-4 py-1.5 text-lg"
  end

  # Variant tests
  test "applies outline variant classes" do
    component = Decor::Tag.new(label: "Outlined", variant: :outlined, color: :primary)
    rendered = render_component(component)

    assert_includes rendered, "border border-primary"
    assert_includes rendered, "text-primary"
  end

  test "filled variant is default" do
    component = Decor::Tag.new(label: "Filled", variant: :filled, color: :primary)
    rendered = render_component(component)

    assert_includes rendered, "bg-primary"
    assert_includes rendered, "text-primary-content"
    refute_includes rendered, "border"
  end

  test "applies ghost variant classes" do
    component = Decor::Tag.new(label: "Ghost", variant: :ghost, color: :primary)
    rendered = render_component(component)

    assert_includes rendered, "text-primary"
    assert_includes rendered, "hover:bg-primary/10"
    refute_includes rendered, "bg-primary text-primary-content"
    refute_includes rendered, "border"
  end

  # Icon tests
  test "renders with icon" do
    component = Decor::Tag.new(label: "With Icon", icon: "star")
    rendered = render_component(component)

    assert_includes rendered, "star"
    assert_includes rendered, "gap-2" # Gap added when icon present
  end

  test "icon has correct size classes" do
    component = Decor::Tag.new(label: "Icon", icon: "star", size: :lg)
    rendered = render_component(component)

    assert_includes rendered, "w-5 h-5"
  end

  test "renders without icon when not specified" do
    component = Decor::Tag.new(label: "No Icon")
    rendered = render_component(component)

    refute_includes rendered, "gap-2"
  end

  # Removable tests
  test "renders remove button when removable" do
    component = Decor::Tag.new(label: "Removable", removable: true)
    rendered = render_component(component)

    assert_includes rendered, "<button"
    assert_includes rendered, "btn"
    assert_includes rendered, "btn-xs"
    assert_includes rendered, "btn-circle"
    assert_includes rendered, "btn-ghost"
    assert_includes rendered, "gap-2" # Gap added when removable
  end

  test "does not render remove button when not removable" do
    component = Decor::Tag.new(label: "Not Removable")
    rendered = render_component(component)

    refute_includes rendered, "<button"
    refute_includes rendered, "gap-2"
  end

  test "remove button includes accessibility label" do
    component = Decor::Tag.new(label: "Removable", removable: true)
    rendered = render_component(component)

    assert_includes rendered, "sr-only"
    assert_includes rendered, "Remove tag"
  end

  test "remove button includes x-mark icon" do
    component = Decor::Tag.new(label: "Removable", removable: true)
    rendered = render_component(component)

    assert_includes rendered, "x-mark"
  end

  test "remove button has correct classes" do
    component = Decor::Tag.new(label: "Removable", color: :error, removable: true)
    rendered = render_component(component)

    assert_includes rendered, "btn-ghost"
    assert_includes rendered, "btn-xs"
    assert_includes rendered, "btn-circle"
  end

  # Combination tests
  test "renders with icon and removable" do
    component = Decor::Tag.new(
      label: "Complex",
      icon: "star",
      removable: true,
      color: :primary
    )
    rendered = render_component(component)

    assert_includes rendered, "star"
    assert_includes rendered, "<button"
    assert_includes rendered, "bg-primary"
    assert_includes rendered, "gap-2"
  end

  test "combines variant and color correctly" do
    component = Decor::Tag.new(
      label: "Combined",
      color: :success,
      variant: :outlined
    )
    rendered = render_component(component)

    assert_includes rendered, "border border-success"
    assert_includes rendered, "text-success"
  end

  # Default values tests
  test "has correct default values" do
    component = Decor::Tag.new(label: "Test")

    assert_equal :md, component.instance_variable_get(:@size)
    assert_equal :neutral, component.instance_variable_get(:@color)
    assert_equal :filled, component.instance_variable_get(:@variant)
    assert_equal false, component.instance_variable_get(:@removable)
  end

  # Nokogiri parsing test
  test "uses nokogiri for parsing" do
    component = Decor::Tag.new(label: "Test", color: :success)
    fragment = render_fragment(component)

    # The outermost element should be a span with DaisyUI success classes
    span = fragment.at_css("span")
    assert_not_nil span
    assert_includes span["class"], "bg-success"
    assert_includes span["class"], "rounded-full"

    # The span should contain the text
    span = fragment.at_css("span")
    assert_not_nil span
    assert_includes span.text, "Test"
  end

  # Edge cases
  test "handles empty label gracefully" do
    component = Decor::Tag.new(label: "")
    rendered = render_component(component)

    assert_includes rendered, "rounded-full"
    assert rendered # Should not raise error
  end

  test "whitespace-nowrap is applied to text content" do
    component = Decor::Tag.new(label: "Long tag name")
    rendered = render_component(component)

    assert_includes rendered, "whitespace-nowrap"
  end

  # Block content test
  test "supports block content" do
    component = Decor::Tag.new(color: :primary)

    # This simulates passing a block to the component
    component.instance_eval do
      def view_template
        render parent_element do
          span(class: "whitespace-nowrap") { "Custom Content" }
        end
      end
    end

    rendered = render_component(component)
    assert_includes rendered, "Custom Content"
  end
end
