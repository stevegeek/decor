require "test_helper"

class Decor::Daisy::TagTest < ActiveSupport::TestCase
  test "renders successfully with label" do
    component = Decor::Daisy::Tag.new(label: "Test Tag")
    rendered = render_component(component)

    assert_includes rendered, "Test Tag"
    assert_includes rendered, "<span"
    assert_includes rendered, "decor:rounded-full"
  end

  test "renders with label attribute" do
    component = Decor::Daisy::Tag.new(label: "Test Tag")
    rendered = render_component(component)

    assert_includes rendered, "Test Tag"
    assert_includes rendered, "decor:rounded-full"
  end

  test "renders with label content" do
    component = Decor::Daisy::Tag.new(label: "Content Tag")
    rendered = render_component(component)

    assert_includes rendered, "Content Tag"
    assert_includes rendered, "decor:whitespace-nowrap"
  end

  test "applies correct color classes" do
    [:primary, :secondary, :accent, :success, :error, :warning, :info, :neutral].each do |color|
      component = Decor::Daisy::Tag.new(label: "Test", color: color)
      rendered = render_component(component)

      assert_includes rendered, "decor:bg-#{color}"
      assert_includes rendered, "decor:text-#{color}-content"
    end
  end

  test "defaults to neutral color" do
    component = Decor::Daisy::Tag.new(label: "Default")
    rendered = render_component(component)

    assert_includes rendered, "decor:bg-neutral"
    assert_includes rendered, "decor:text-neutral-content"
  end

  test "applies correct size classes" do
    component = Decor::Daisy::Tag.new(label: "Large Tag", size: :lg)
    rendered = render_component(component)

    assert_includes rendered, "decor:px-4 decor:py-1.5 decor:text-base"
  end

  test "applies small size classes" do
    component = Decor::Daisy::Tag.new(label: "Small Tag", size: :sm)
    rendered = render_component(component)

    assert_includes rendered, "decor:px-2.5 decor:py-0.5 decor:text-sm"
  end

  test "applies xs size classes" do
    component = Decor::Daisy::Tag.new(label: "XS Tag", size: :xs)
    rendered = render_component(component)

    assert_includes rendered, "decor:px-2 decor:py-0.5 decor:text-xs"
  end

  test "medium size is default" do
    component = Decor::Daisy::Tag.new(label: "Medium Tag", size: :md)
    rendered = render_component(component)

    assert_includes rendered, "decor:px-3 decor:py-1 decor:text-sm"
  end

  test "applies xl size classes" do
    component = Decor::Daisy::Tag.new(label: "XL Tag", size: :xl)
    rendered = render_component(component)

    assert_includes rendered, "decor:px-5 decor:py-2 decor:text-lg"
  end

  test "applies outline style classes" do
    component = Decor::Daisy::Tag.new(label: "Outlined", style: :outlined, color: :primary)
    rendered = render_component(component)

    assert_includes rendered, "decor:border-2"
    assert_includes rendered, "decor:border-primary"
    assert_includes rendered, "decor:text-primary"
  end

  test "filled style is default" do
    component = Decor::Daisy::Tag.new(label: "Filled", style: :filled, color: :primary)
    rendered = render_component(component)

    assert_includes rendered, "decor:bg-primary"
    assert_includes rendered, "decor:text-primary-content"
    refute_includes rendered, "decor:border-2"
  end

  test "applies ghost style classes" do
    component = Decor::Daisy::Tag.new(label: "Ghost", style: :ghost, color: :primary)
    rendered = render_component(component)

    assert_includes rendered, "decor:text-primary"
    assert_includes rendered, "decor:hover:bg-primary/10"
    refute_includes rendered, "decor:bg-primary decor:text-primary-content"
    refute_includes rendered, "decor:border-2"
  end

  test "renders with icon" do
    component = Decor::Daisy::Tag.new(label: "With Icon", icon: "star")
    rendered = render_component(component)

    assert_includes rendered, "star"
    assert_includes rendered, "decor:gap-2" # Gap added when icon present
  end

  test "icon has correct size classes" do
    component = Decor::Daisy::Tag.new(label: "Icon", icon: "star", size: :lg)
    rendered = render_component(component)

    assert_includes rendered, "decor:w-5 decor:h-5"
  end

  test "renders without icon when not specified" do
    component = Decor::Daisy::Tag.new(label: "No Icon")
    rendered = render_component(component)

    refute_includes rendered, "decor:gap-2"
  end

  test "renders remove button when removable" do
    component = Decor::Daisy::Tag.new(label: "Removable", removable: true)
    rendered = render_component(component)

    assert_includes rendered, "<button"
    assert_includes rendered, "decor:d-btn"
    assert_includes rendered, "decor:d-btn-xs"
    assert_includes rendered, "decor:d-btn-circle"
    assert_includes rendered, "decor:d-btn-ghost"
    assert_includes rendered, "decor:gap-2" # Gap added when removable
  end

  test "does not render remove button when not removable" do
    component = Decor::Daisy::Tag.new(label: "Not Removable")
    rendered = render_component(component)

    refute_includes rendered, "<button"
    refute_includes rendered, "decor:gap-2"
  end

  test "remove button includes accessibility label" do
    component = Decor::Daisy::Tag.new(label: "Removable", removable: true)
    rendered = render_component(component)

    assert_includes rendered, "decor:sr-only"
    assert_includes rendered, "Remove tag"
  end

  test "remove button includes x-mark icon" do
    component = Decor::Daisy::Tag.new(label: "Removable", removable: true)
    rendered = render_component(component)

    assert_includes rendered, "x-mark"
  end

  test "remove button has correct classes" do
    component = Decor::Daisy::Tag.new(label: "Removable", color: :error, removable: true)
    rendered = render_component(component)

    assert_includes rendered, "decor:d-btn-ghost"
    assert_includes rendered, "decor:d-btn-xs"
    assert_includes rendered, "decor:d-btn-circle"
  end

  test "renders with icon and removable" do
    component = Decor::Daisy::Tag.new(
      label: "Complex",
      icon: "star",
      removable: true,
      color: :primary
    )
    rendered = render_component(component)

    assert_includes rendered, "star"
    assert_includes rendered, "<button"
    assert_includes rendered, "decor:bg-primary"
    assert_includes rendered, "decor:gap-2"
  end

  test "combines style and color correctly" do
    component = Decor::Daisy::Tag.new(
      label: "Combined",
      color: :success,
      style: :outlined
    )
    rendered = render_component(component)

    assert_includes rendered, "decor:border-2"
    assert_includes rendered, "decor:border-success"
    assert_includes rendered, "decor:text-success"
  end

  test "has correct default values" do
    component = Decor::Daisy::Tag.new(label: "Test")

    assert_equal :md, component.instance_variable_get(:@size)
    assert_equal :neutral, component.instance_variable_get(:@color)
    assert_equal :filled, component.instance_variable_get(:@style)
    assert_equal false, component.instance_variable_get(:@removable)
  end

  test "uses nokogiri for parsing" do
    component = Decor::Daisy::Tag.new(label: "Test", color: :success)
    fragment = render_fragment(component)

    span = fragment.at_css("span")
    assert_not_nil span
    assert_includes span["class"], "decor:bg-success"
    assert_includes span["class"], "decor:rounded-full"

    span = fragment.at_css("span")
    assert_not_nil span
    assert_includes span.text, "Test"
  end

  test "handles empty label gracefully" do
    component = Decor::Daisy::Tag.new(label: "")
    rendered = render_component(component)

    assert_includes rendered, "decor:rounded-full"
    assert rendered # Should not raise error
  end

  test "whitespace-nowrap is applied to text content" do
    component = Decor::Daisy::Tag.new(label: "Long tag name")
    rendered = render_component(component)

    assert_includes rendered, "decor:whitespace-nowrap"
  end

  test "supports block content" do
    component = Decor::Daisy::Tag.new(color: :primary)

    component.instance_eval do
      def view_template
        root_element do
          span(class: "whitespace-nowrap") { "Custom Content" }
        end
      end
    end

    rendered = render_component(component)
    assert_includes rendered, "Custom Content"
  end
end
