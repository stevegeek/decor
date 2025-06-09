require "test_helper"

class Decor::ButtonTest < ActiveSupport::TestCase
  test "renders successfully with label" do
    component = Decor::Button.new(label: "Click me")
    rendered = render_component(component)

    assert_includes rendered, "Click me"
    assert_includes rendered, "<button"
    assert_includes rendered, 'class="'
  end

  test "renders with disabled state" do
    component = Decor::Button.new(label: "Disabled", disabled: true)
    rendered = render_component(component)

    assert_includes rendered, 'disabled="disabled"'
    assert_includes rendered, "btn"
  end

  test "applies correct variant classes" do
    component = Decor::Button.new(label: "Outlined", variant: :outlined)
    rendered = render_component(component)

    assert_includes rendered, "btn-outline"
  end

  test "applies correct theme classes" do
    component = Decor::Button.new(label: "Danger", theme: :danger)
    rendered = render_component(component)

    assert_includes rendered, "btn-error"
  end

  test "applies correct size classes" do
    component = Decor::Button.new(label: "Large", size: :large)
    rendered = render_component(component)

    assert_includes rendered, "btn-lg"
  end

  test "applies full width when specified" do
    component = Decor::Button.new(label: "Full width", full_width: true)
    rendered = render_component(component)

    assert_includes rendered, "btn-block"
  end

  test "uses nokogiri for parsing button element" do
    component = Decor::Button.new(label: "Test button")
    fragment = render_fragment(component)

    button = fragment.at_css("button")
    assert_not_nil button
    assert_includes button.text, "Test button"
    assert_includes button["class"], "btn"
  end

  test "renders text center span" do
    component = Decor::Button.new(label: "Centered")
    fragment = render_fragment(component)

    span = fragment.at_css("span.text-center")
    assert_not_nil span
    assert_includes span.text, "Centered"
  end

  test "applies daisyUI primary theme by default" do
    component = Decor::Button.new(label: "Primary")
    rendered = render_component(component)

    assert_includes rendered, "btn-primary"
  end

  test "applies text variant as ghost button" do
    component = Decor::Button.new(label: "Ghost", variant: :text)
    rendered = render_component(component)

    assert_includes rendered, "btn-ghost"
  end

  test "applies small size correctly" do
    component = Decor::Button.new(label: "Small", size: :small)
    rendered = render_component(component)

    assert_includes rendered, "btn-sm"
  end

  test "applies micro size correctly" do
    component = Decor::Button.new(label: "Micro", size: :micro)
    rendered = render_component(component)

    assert_includes rendered, "btn-xs"
  end

  test "applies wide size correctly" do
    component = Decor::Button.new(label: "Wide", size: :wide)
    rendered = render_component(component)

    assert_includes rendered, "btn-wide"
  end
end
