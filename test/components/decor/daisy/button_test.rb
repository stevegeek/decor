require "test_helper"

class Decor::Daisy::ButtonTest < ActiveSupport::TestCase
  test "renders successfully with label" do
    component = Decor::Daisy::Button.new(label: "Click me")
    rendered = render_component(component)

    assert_includes rendered, "Click me"
    assert_includes rendered, "<button"
    assert_includes rendered, 'class="'
  end

  test "renders with disabled state" do
    component = Decor::Daisy::Button.new(label: "Disabled", disabled: true)
    rendered = render_component(component)

    assert_includes rendered, 'disabled="disabled"'
    assert_includes rendered, "btn"
  end

  test "applies correct style classes" do
    component = Decor::Daisy::Button.new(label: "Outlined", style: :outlined)
    rendered = render_component(component)

    assert_includes rendered, "btn-outline"
  end

  test "applies correct color classes" do
    component = Decor::Daisy::Button.new(label: "Error", color: :error)
    rendered = render_component(component)

    assert_includes rendered, "btn-error"
  end

  test "applies correct size classes" do
    component = Decor::Daisy::Button.new(label: "Large", size: :lg)
    rendered = render_component(component)

    assert_includes rendered, "btn-lg"
  end

  test "applies full width when specified" do
    component = Decor::Daisy::Button.new(label: "Full width", full_width: true)
    rendered = render_component(component)

    assert_includes rendered, "btn-block"
  end

  test "uses nokogiri for parsing button element" do
    component = Decor::Daisy::Button.new(label: "Test button")
    fragment = render_fragment(component)

    button = fragment.at_css("button")
    assert_not_nil button
    assert_includes button.text, "Test button"
    assert_includes button["class"], "btn"
  end

  test "renders text center span" do
    component = Decor::Daisy::Button.new(label: "Centered")
    fragment = render_fragment(component)

    span = fragment.at_css("span.text-center")
    assert_not_nil span
    assert_includes span.text, "Centered"
  end

  test "applies no color class when color is not specified" do
    component = Decor::Daisy::Button.new(label: "No Color")
    rendered = render_component(component)

    assert_includes rendered, "btn"
    refute_includes rendered, "btn-primary"
    refute_includes rendered, "btn-secondary"
    refute_includes rendered, "btn-error"
    refute_includes rendered, "btn-warning"
    refute_includes rendered, "btn-neutral"
  end

  test "applies ghost style as ghost button" do
    component = Decor::Daisy::Button.new(label: "Ghost", style: :ghost)
    rendered = render_component(component)

    assert_includes rendered, "btn-ghost"
  end

  test "applies small size correctly" do
    component = Decor::Daisy::Button.new(label: "Small", size: :sm)
    rendered = render_component(component)

    assert_includes rendered, "btn-sm"
  end

  test "applies xs size correctly" do
    component = Decor::Daisy::Button.new(label: "XS", size: :xs)
    rendered = render_component(component)

    assert_includes rendered, "btn-xs"
  end

  test "applies xs size correctly (alias for micro)" do
    component = Decor::Daisy::Button.new(label: "XS", size: :xs)
    rendered = render_component(component)

    assert_includes rendered, "btn-xs"
  end

  test "applies xl size correctly" do
    component = Decor::Daisy::Button.new(label: "XL", size: :xl)
    rendered = render_component(component)

    assert_includes rendered, "btn-xl"
  end

  test "applies lg size alias correctly" do
    component = Decor::Daisy::Button.new(label: "Large Alias", size: :lg)
    rendered = render_component(component)

    assert_includes rendered, "btn-lg"
  end

  test "applies md size alias correctly (default size)" do
    component = Decor::Daisy::Button.new(label: "Medium Alias", size: :md)
    rendered = render_component(component)

    refute_includes rendered, "btn-lg"
    refute_includes rendered, "btn-sm"
    refute_includes rendered, "btn-xs"
    assert_includes rendered, "btn" # but should have base btn class
  end

  test "applies sm size alias correctly" do
    component = Decor::Daisy::Button.new(label: "Small Alias", size: :sm)
    rendered = render_component(component)

    assert_includes rendered, "btn-sm"
  end

  test "size aliases work same as original sizes" do
    lg_component = Decor::Daisy::Button.new(label: "LG", size: :lg)
    large_component = Decor::Daisy::Button.new(label: "Large", size: :large)
    lg_rendered = render_component(lg_component)
    large_rendered = render_component(large_component)

    assert_includes lg_rendered, "btn-lg"
    assert_includes large_rendered, "btn-lg"

    sm_component = Decor::Daisy::Button.new(label: "SM", size: :sm)
    small_component = Decor::Daisy::Button.new(label: "Small", size: :small)
    sm_rendered = render_component(sm_component)
    small_rendered = render_component(small_component)

    assert_includes sm_rendered, "btn-sm"
    assert_includes small_rendered, "btn-sm"

    xs_component = Decor::Daisy::Button.new(label: "XS", size: :xs)
    micro_component = Decor::Daisy::Button.new(label: "Micro", size: :micro)
    xs_rendered = render_component(xs_component)
    micro_rendered = render_component(micro_component)

    assert_includes xs_rendered, "btn-xs"
    assert_includes micro_rendered, "btn-xs"
  end

  test "attribute validation accepts all size values" do
    assert_nothing_raised { Decor::Daisy::Button.new(label: "Test", size: :xs) }
    assert_nothing_raised { Decor::Daisy::Button.new(label: "Test", size: :sm) }
    assert_nothing_raised { Decor::Daisy::Button.new(label: "Test", size: :md) }
    assert_nothing_raised { Decor::Daisy::Button.new(label: "Test", size: :lg) }
    assert_nothing_raised { Decor::Daisy::Button.new(label: "Test", size: :xl) }

    assert_nothing_raised { Decor::Daisy::Button.new(label: "Test", size: :small) }
    assert_nothing_raised { Decor::Daisy::Button.new(label: "Test", size: :medium) }
    assert_nothing_raised { Decor::Daisy::Button.new(label: "Test", size: :large) }
    assert_nothing_raised { Decor::Daisy::Button.new(label: "Test", size: :micro) }
    assert_nothing_raised { Decor::Daisy::Button.new(label: "Test", size: :extra_small) }
    assert_nothing_raised { Decor::Daisy::Button.new(label: "Test", size: :extra_large) }

    assert_raises(Literal::TypeError) { Decor::Daisy::Button.new(label: "Test", size: :invalid) }
    assert_raises(Literal::TypeError) { Decor::Daisy::Button.new(label: "Test", size: :wide) }
  end

  test "large size button icons get size-8 pr-2 classes" do
    component = Decor::Daisy::Button.new(label: "Large", size: :large, icon: "home")
    rendered = render_component(component)

    assert_includes rendered, "size-8"
    assert_includes rendered, "pr-2"
  end

  test "lg size alias button icons get size-8 pr-2 classes" do
    component = Decor::Daisy::Button.new(label: "LG", size: :lg, icon: "home")
    rendered = render_component(component)

    assert_includes rendered, "size-8"
    assert_includes rendered, "pr-2"
  end

  test "medium size button icons get size-6 pr-1 classes" do
    component = Decor::Daisy::Button.new(label: "Medium", size: :medium, icon: "home")
    rendered = render_component(component)

    assert_includes rendered, "size-6"
    assert_includes rendered, "pr-1"
  end

  test "md size alias button icons get size-6 pr-1 classes" do
    component = Decor::Daisy::Button.new(label: "MD", size: :md, icon: "home")
    rendered = render_component(component)

    assert_includes rendered, "size-6"
    assert_includes rendered, "pr-1"
  end

  test "small size button icons get size-5.5 pr-1 classes" do
    component = Decor::Daisy::Button.new(label: "Small", size: :small, icon: "home")
    rendered = render_component(component)

    assert_includes rendered, "size-5.5"
    assert_includes rendered, "pr-1"
  end

  test "sm size alias button icons get size-5.5 pr-1 classes" do
    component = Decor::Daisy::Button.new(label: "SM", size: :sm, icon: "home")
    rendered = render_component(component)

    assert_includes rendered, "size-5.5"
    assert_includes rendered, "pr-1"
  end

  test "micro size button icons get size-4.5 pr-1 classes" do
    component = Decor::Daisy::Button.new(label: "Micro", size: :micro, icon: "home")
    rendered = render_component(component)

    assert_includes rendered, "size-4.5"
    assert_includes rendered, "pr-1"
  end

  test "xs size alias button icons get size-4.5 pr-1 classes" do
    component = Decor::Daisy::Button.new(label: "XS", size: :xs, icon: "home")
    rendered = render_component(component)

    assert_includes rendered, "size-4.5"
    assert_includes rendered, "pr-1"
  end

  test "icon size classes match between original and alias sizes" do
    lg_component = Decor::Daisy::Button.new(label: "LG", size: :lg, icon: "home")
    large_component = Decor::Daisy::Button.new(label: "Large", size: :large, icon: "home")
    lg_rendered = render_component(lg_component)
    large_rendered = render_component(large_component)

    assert_includes lg_rendered, "size-8"
    assert_includes large_rendered, "size-8"
    assert_includes lg_rendered, "pr-2"
    assert_includes large_rendered, "pr-2"

    md_component = Decor::Daisy::Button.new(label: "MD", size: :md, icon: "home")
    medium_component = Decor::Daisy::Button.new(label: "Medium", size: :medium, icon: "home")
    md_rendered = render_component(md_component)
    medium_rendered = render_component(medium_component)

    assert_includes md_rendered, "size-6"
    assert_includes medium_rendered, "size-6"

    sm_component = Decor::Daisy::Button.new(label: "SM", size: :sm, icon: "home")
    small_component = Decor::Daisy::Button.new(label: "Small", size: :small, icon: "home")
    sm_rendered = render_component(sm_component)
    small_rendered = render_component(small_component)

    assert_includes sm_rendered, "size-5.5"
    assert_includes small_rendered, "size-5.5"

    xs_component = Decor::Daisy::Button.new(label: "XS", size: :xs, icon: "home")
    micro_component = Decor::Daisy::Button.new(label: "Micro", size: :micro, icon: "home")
    xs_rendered = render_component(xs_component)
    micro_rendered = render_component(micro_component)

    assert_includes xs_rendered, "size-4.5"
    assert_includes micro_rendered, "size-4.5"
  end

  test "icons always include inline and mr-1 classes" do
    component = Decor::Daisy::Button.new(label: "Test", icon: "home")
    rendered = render_component(component)

    assert_includes rendered, "inline"
    assert_includes rendered, "mr-1"
  end

  test "icon_only_on_mobile changes margin classes" do
    component = Decor::Daisy::Button.new(label: "Test", icon: "home", icon_only_on_mobile: true)
    rendered = render_component(component)

    assert_includes rendered, "mr-0"
    assert_includes rendered, "md:mr-1"
  end
end
