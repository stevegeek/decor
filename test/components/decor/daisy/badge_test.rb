require "test_helper"

class Decor::Daisy::BadgeTest < ActiveSupport::TestCase
  test "renders successfully with label" do
    component = Decor::Daisy::Badge.new(label: "Test Badge")
    rendered = render_component(component)

    assert_includes rendered, "Test Badge"
    assert_includes rendered, "decor:d-badge"
    assert_includes rendered, "decor:d-badge-neutral"
  end

  test "applies correct color classes" do
    component = Decor::Daisy::Badge.new(label: "Success", color: :success)
    rendered = render_component(component)

    assert_includes rendered, "decor:d-badge-success"
  end

  test "applies correct size classes" do
    component = Decor::Daisy::Badge.new(label: "Large", size: :lg)
    rendered = render_component(component)

    assert_includes rendered, "decor:d-badge-lg"
  end

  test "renders with icon" do
    component = Decor::Daisy::Badge.new(label: "With icon", icon: "star")
    rendered = render_component(component)

    assert_includes rendered, "star"
    assert_includes rendered, "decor:h-3.5 decor:w-3.5"
  end

  test "renders medium size by default" do
    component = Decor::Daisy::Badge.new(label: "Medium")
    rendered = render_component(component)

    refute_includes rendered, "decor:d-badge-sm"
    assert_includes rendered, "decor:d-badge"
  end

  test "renders different error colors" do
    component = Decor::Daisy::Badge.new(label: "Error", color: :error)
    rendered = render_component(component)

    assert_includes rendered, "decor:d-badge-error"
  end

  test "renders different warning colors" do
    component = Decor::Daisy::Badge.new(label: "Warning", color: :warning)
    rendered = render_component(component)

    assert_includes rendered, "decor:d-badge-warning"
  end

  test "renders outlined style" do
    component = Decor::Daisy::Badge.new(label: "Outlined", style: :outlined)
    rendered = render_component(component)

    assert_includes rendered, "decor:d-badge-outline"
  end

  test "renders dashed style" do
    component = Decor::Daisy::Badge.new(label: "Dashed", dashed: true)
    rendered = render_component(component)

    assert_includes rendered, "decor:border-dashed"
  end

  test "renders outlined and dashed together" do
    component = Decor::Daisy::Badge.new(label: "Both", style: :outlined, dashed: true)
    rendered = render_component(component)

    assert_includes rendered, "decor:d-badge-outline"
    assert_includes rendered, "decor:border-dashed"
  end

  test "uses nokogiri for parsing" do
    component = Decor::Daisy::Badge.new(label: "Test")
    fragment = render_fragment(component)

    badge_span = fragment.at_css('[class~="decor:d-badge"]')
    assert_not_nil badge_span
    assert_includes badge_span.text, "Test"
    assert_includes badge_span["class"], "decor:d-badge-neutral"
  end
end
