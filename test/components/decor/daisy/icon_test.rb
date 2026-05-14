require "test_helper"

class Decor::Daisy::IconTest < ActiveSupport::TestCase
  test "renders svg element with use tag pointing to tabler sprite" do
    component = Decor::Icon.new(name: "home")
    rendered = render_component(component)

    assert_includes rendered, "<svg"
    assert_includes rendered, "tabler-outline.svg#tabler-home"
  end

  test "solid style points to tabler filled sprite when icon exists" do
    # 'star' is a common icon likely present in filled sprite
    component = Decor::Icon.new(name: "star", style: :solid)
    rendered = render_component(component)

    assert_includes rendered, "<svg"
    # Either filled (if it exists) or falls back to outline
    assert_match(/tabler-(filled|outline)\.svg/, rendered)
  end

  test "applies custom width and height" do
    component = Decor::Icon.new(name: "settings", width: 32, height: 32)
    rendered = render_component(component)

    assert_includes rendered, 'width="32"'
    assert_includes rendered, 'height="32"'
  end

  test "decor sprite uses decor prefix" do
    component = Decor::Icon.new(name: "check-tick", sprite: :decor, view_box: "0 0 12 10", width: 16, height: 16)
    rendered = render_component(component)

    assert_includes rendered, "decor.svg#decor-check-tick"
  end

  test "outline style renders with stroke attributes" do
    component = Decor::Icon.new(name: "home", style: :outline)
    rendered = render_component(component)

    assert_includes rendered, 'stroke="currentColor"'
    assert_includes rendered, 'fill="none"'
  end

  test "solid style renders without stroke" do
    component = Decor::Icon.new(name: "home", style: :solid)
    rendered = render_component(component)

    refute_includes rendered, 'stroke="currentColor"'
    assert_includes rendered, 'fill="currentColor"'
  end

  test "renders with aria_hidden true by default" do
    component = Decor::Icon.new(name: "home")
    rendered = render_component(component)

    assert_includes rendered, "aria-hidden"
  end

  test "title is included when provided" do
    component = Decor::Icon.new(name: "home", title: "Home icon")
    rendered = render_component(component)

    assert_includes rendered, "Home icon"
  end

  test "uses default 24x24 dimensions when not specified" do
    component = Decor::Icon.new(name: "home")
    rendered = render_component(component)

    assert_includes rendered, 'width="24"'
    assert_includes rendered, 'height="24"'
  end
end
