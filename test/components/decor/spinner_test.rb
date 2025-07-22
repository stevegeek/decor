require "test_helper"

class Decor::SpinnerTest < ActiveSupport::TestCase
  test "renders successfully with default attributes" do
    component = Decor::Spinner.new
    rendered = render_component(component)

    assert_includes rendered, "loading"
    assert_includes rendered, "loading-spinner"
    assert_includes rendered, "loading-md"
    assert_includes rendered, "text-neutral"
  end

  test "applies default spinner style" do
    component = Decor::Spinner.new
    rendered = render_component(component)

    assert_includes rendered, "loading-spinner"
  end

  test "applies dots style" do
    component = Decor::Spinner.new(style: :dots)
    rendered = render_component(component)

    assert_includes rendered, "loading-dots"
    refute_includes rendered, "loading-spinner"
  end

  test "applies ring style" do
    component = Decor::Spinner.new(style: :ring)
    rendered = render_component(component)

    assert_includes rendered, "loading-ring"
    refute_includes rendered, "loading-spinner"
  end

  test "applies ball style" do
    component = Decor::Spinner.new(style: :ball)
    rendered = render_component(component)

    assert_includes rendered, "loading-ball"
    refute_includes rendered, "loading-spinner"
  end

  test "applies bars style" do
    component = Decor::Spinner.new(style: :bars)
    rendered = render_component(component)

    assert_includes rendered, "loading-bars"
    refute_includes rendered, "loading-spinner"
  end

  test "applies infinity style" do
    component = Decor::Spinner.new(style: :infinity)
    rendered = render_component(component)

    assert_includes rendered, "loading-infinity"
    refute_includes rendered, "loading-spinner"
  end

  test "applies correct size classes" do
    component = Decor::Spinner.new(size: :lg)
    rendered = render_component(component)

    assert_includes rendered, "loading-lg"
  end

  test "applies extra small size" do
    component = Decor::Spinner.new(size: :xs)
    rendered = render_component(component)

    assert_includes rendered, "loading-xs"
  end

  test "applies small size" do
    component = Decor::Spinner.new(size: :sm)
    rendered = render_component(component)

    assert_includes rendered, "loading-sm"
  end

  test "applies medium size by default" do
    component = Decor::Spinner.new
    rendered = render_component(component)

    assert_includes rendered, "loading-md"
  end

  test "applies correct color classes" do
    component = Decor::Spinner.new(color: :primary)
    rendered = render_component(component)

    assert_includes rendered, "text-primary"
  end

  test "applies base color" do
    component = Decor::Spinner.new(color: :base)
    rendered = render_component(component)

    assert_includes rendered, "text-base-content"
  end

  test "applies success color" do
    component = Decor::Spinner.new(color: :success)
    rendered = render_component(component)

    assert_includes rendered, "text-success"
  end

  test "applies error color" do
    component = Decor::Spinner.new(color: :error)
    rendered = render_component(component)

    assert_includes rendered, "text-error"
  end

  test "renders with default color class" do
    component = Decor::Spinner.new
    rendered = render_component(component)

    assert_includes rendered, "text-neutral"
    refute_includes rendered, "text-primary"
    refute_includes rendered, "text-base-content"
    refute_includes rendered, "text-success"
  end

  test "combines size and color classes" do
    component = Decor::Spinner.new(size: :lg, color: :primary)
    rendered = render_component(component)

    assert_includes rendered, "loading-lg"
    assert_includes rendered, "text-primary"
  end

  test "uses nokogiri for parsing" do
    component = Decor::Spinner.new(size: :sm, color: :success)
    fragment = render_fragment(component)

    spinner = fragment.at_css(".loading")
    assert_not_nil spinner
    assert_includes spinner["class"], "loading-spinner"
    assert_includes spinner["class"], "loading-sm"
    assert_includes spinner["class"], "text-success"
  end

  test "combines style, size and color classes" do
    component = Decor::Spinner.new(style: :dots, size: :lg, color: :primary)
    rendered = render_component(component)

    assert_includes rendered, "loading-dots"
    assert_includes rendered, "loading-lg"
    assert_includes rendered, "text-primary"
  end

  test "supports xl size" do
    component = Decor::Spinner.new(size: :xl)
    rendered = render_component(component)

    assert_includes rendered, "loading-xl"
  end
end
