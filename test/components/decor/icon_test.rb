require "test_helper"

class Decor::IconTest < ActiveSupport::TestCase
  test "renders successfully with name" do
    component = Decor::Icon.new(name: "home")
    rendered = render_component(component)

    assert_includes rendered, "<svg"
    assert_includes rendered, "data-src="
    assert_includes rendered, "heroicons/outline/home"
  end

  test "applies correct variant classes" do
    component = Decor::Icon.new(name: "user", variant: :solid)
    rendered = render_component(component)

    assert_includes rendered, "heroicons/solid/user"
  end

  test "applies correct collection" do
    component = Decor::Icon.new(name: "star", collection: :heroicons)
    rendered = render_component(component)

    assert_includes rendered, "heroicons/outline/star"
  end

  test "applies custom width and height" do
    component = Decor::Icon.new(name: "cog", width: 32, height: 32)
    rendered = render_component(component)

    assert_includes rendered, 'width="32"'
    assert_includes rendered, 'height="32"'
  end

  test "renders small solid variant" do
    component = Decor::Icon.new(name: "check", variant: :small_solid)
    rendered = render_component(component)

    assert_includes rendered, "heroicons/small_solid/check"
  end

  test "renders inline icon" do
    component = Decor::Icon.new(name: "info", inline: true)
    rendered = render_component(component)

    # When inline=true and SVG not found, it should render an SVG with error comment
    assert_includes rendered, "<svg"
    refute_includes rendered, "data-src"
  end

  test "generates correct file name" do
    component = Decor::Icon.new(name: "arrow-left", collection: :heroicons, variant: :outline)
    expected_filename = "heroicons/outline/arrow-left.svg"

    assert_equal expected_filename, component.file_name
  end

  test "uses nokogiri for parsing" do
    component = Decor::Icon.new(name: "home")
    fragment = render_fragment(component)

    svg = fragment.at_css("svg")
    assert_not_nil svg
    assert_equal "24", svg["width"]
    assert_equal "24", svg["height"]
  end
end
