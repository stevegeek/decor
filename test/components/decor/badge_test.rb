require "test_helper"

class Decor::BadgeTest < ActiveSupport::TestCase
  test "renders successfully with label" do
    component = Decor::Badge.new(label: "Test Badge")
    rendered = render_component(component)

    assert_includes rendered, "Test Badge"
    assert_includes rendered, "badge"
    assert_includes rendered, "badge-neutral"
  end

  test "applies correct style classes" do
    component = Decor::Badge.new(label: "Success", style: :success)
    rendered = render_component(component)

    assert_includes rendered, "badge-success"
  end

  test "applies correct size classes" do
    component = Decor::Badge.new(label: "Large", size: :lg)
    rendered = render_component(component)

    assert_includes rendered, "badge-lg"
  end

  test "renders with icon" do
    component = Decor::Badge.new(label: "With icon", icon: "star")
    rendered = render_component(component)

    assert_includes rendered, "star"
    assert_includes rendered, "h-3.5 w-3.5"
  end

  test "renders medium size by default" do
    component = Decor::Badge.new(label: "Medium")
    rendered = render_component(component)

    # Small is default according to the attribute definition
    refute_includes rendered, "badge-sm"
    assert_includes rendered, "badge"
  end

  test "renders different error styles" do
    component = Decor::Badge.new(label: "Error", style: :error)
    rendered = render_component(component)

    assert_includes rendered, "badge-error"
  end

  test "renders different warning styles" do
    component = Decor::Badge.new(label: "Warning", style: :warning)
    rendered = render_component(component)

    assert_includes rendered, "badge-warning"
  end

  test "renders outlined variant" do
    component = Decor::Badge.new(label: "Outlined", variant: :outlined)
    rendered = render_component(component)

    assert_includes rendered, "badge-outline"
  end

  test "renders dashed style" do
    component = Decor::Badge.new(label: "Dashed", dashed: true)
    rendered = render_component(component)

    assert_includes rendered, "border-dashed"
  end

  test "renders outlined and dashed together" do
    component = Decor::Badge.new(label: "Both", variant: :outlined, dashed: true)
    rendered = render_component(component)

    assert_includes rendered, "badge-outline"
    assert_includes rendered, "border-dashed"
  end

  test "uses nokogiri for parsing" do
    component = Decor::Badge.new(label: "Test")
    fragment = render_fragment(component)

    badge_span = fragment.at_css(".badge")
    assert_not_nil badge_span
    assert_includes badge_span.text, "Test"
    assert_includes badge_span["class"], "badge-neutral"
  end
end
