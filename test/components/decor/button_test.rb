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

  test "applies correct color classes" do
    component = Decor::Button.new(label: "Danger", color: :danger)
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

  test "applies daisyUI primary color by default" do
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

  test "applies xs size correctly (alias for micro)" do
    component = Decor::Button.new(label: "XS", size: :xs)
    rendered = render_component(component)

    assert_includes rendered, "btn-xs"
  end

  test "applies lg size alias correctly" do
    component = Decor::Button.new(label: "Large Alias", size: :lg)
    rendered = render_component(component)

    assert_includes rendered, "btn-lg"
  end

  test "applies md size alias correctly (default size)" do
    component = Decor::Button.new(label: "Medium Alias", size: :md)
    rendered = render_component(component)

    # Medium/md size should not add any btn-* size class (it's the default)
    refute_includes rendered, "btn-lg"
    refute_includes rendered, "btn-sm"
    refute_includes rendered, "btn-xs"
    assert_includes rendered, "btn" # but should have base btn class
  end

  test "applies sm size alias correctly" do
    component = Decor::Button.new(label: "Small Alias", size: :sm)
    rendered = render_component(component)

    assert_includes rendered, "btn-sm"
  end

  test "size aliases work same as original sizes" do
    # Test that :lg works same as :large
    lg_component = Decor::Button.new(label: "LG", size: :lg)
    large_component = Decor::Button.new(label: "Large", size: :large)
    lg_rendered = render_component(lg_component)
    large_rendered = render_component(large_component)

    # Both should have btn-lg class
    assert_includes lg_rendered, "btn-lg"
    assert_includes large_rendered, "btn-lg"

    # Test that :sm works same as :small
    sm_component = Decor::Button.new(label: "SM", size: :sm)
    small_component = Decor::Button.new(label: "Small", size: :small)
    sm_rendered = render_component(sm_component)
    small_rendered = render_component(small_component)

    # Both should have btn-sm class
    assert_includes sm_rendered, "btn-sm"
    assert_includes small_rendered, "btn-sm"

    # Test that :xs works same as :micro
    xs_component = Decor::Button.new(label: "XS", size: :xs)
    micro_component = Decor::Button.new(label: "Micro", size: :micro)
    xs_rendered = render_component(xs_component)
    micro_rendered = render_component(micro_component)

    # Both should have btn-xs class
    assert_includes xs_rendered, "btn-xs"
    assert_includes micro_rendered, "btn-xs"
  end

  test "attribute validation accepts all size values" do
    # Test existing sizes
    assert_nothing_raised { Decor::Button.new(label: "Test", size: :large) }
    assert_nothing_raised { Decor::Button.new(label: "Test", size: :medium) }
    assert_nothing_raised { Decor::Button.new(label: "Test", size: :small) }
    assert_nothing_raised { Decor::Button.new(label: "Test", size: :micro) }
    assert_nothing_raised { Decor::Button.new(label: "Test", size: :wide) }

    # Test new aliases
    assert_nothing_raised { Decor::Button.new(label: "Test", size: :lg) }
    assert_nothing_raised { Decor::Button.new(label: "Test", size: :md) }
    assert_nothing_raised { Decor::Button.new(label: "Test", size: :sm) }
    assert_nothing_raised { Decor::Button.new(label: "Test", size: :xs) }

    # Should raise for invalid values
    assert_raises(Dry::Struct::Error) { Decor::Button.new(label: "Test", size: :invalid) }
  end

  # Icon size tests
  test "large size button icons get size-8 pr-2 classes" do
    component = Decor::Button.new(label: "Large", size: :large, icon: "home")
    rendered = render_component(component)

    assert_includes rendered, "size-8"
    assert_includes rendered, "pr-2"
  end

  test "lg size alias button icons get size-8 pr-2 classes" do
    component = Decor::Button.new(label: "LG", size: :lg, icon: "home")
    rendered = render_component(component)

    assert_includes rendered, "size-8"
    assert_includes rendered, "pr-2"
  end

  test "medium size button icons get size-6 pr-1 classes" do
    component = Decor::Button.new(label: "Medium", size: :medium, icon: "home")
    rendered = render_component(component)

    assert_includes rendered, "size-6"
    assert_includes rendered, "pr-1"
  end

  test "md size alias button icons get size-6 pr-1 classes" do
    component = Decor::Button.new(label: "MD", size: :md, icon: "home")
    rendered = render_component(component)

    assert_includes rendered, "size-6"
    assert_includes rendered, "pr-1"
  end

  test "wide size button icons get size-6 pr-1 classes" do
    component = Decor::Button.new(label: "Wide", size: :wide, icon: "home")
    rendered = render_component(component)

    assert_includes rendered, "size-6"
    assert_includes rendered, "pr-1"
  end

  test "small size button icons get size-5.5 pr-1 classes" do
    component = Decor::Button.new(label: "Small", size: :small, icon: "home")
    rendered = render_component(component)

    assert_includes rendered, "size-5.5"
    assert_includes rendered, "pr-1"
  end

  test "sm size alias button icons get size-5.5 pr-1 classes" do
    component = Decor::Button.new(label: "SM", size: :sm, icon: "home")
    rendered = render_component(component)

    assert_includes rendered, "size-5.5"
    assert_includes rendered, "pr-1"
  end

  test "micro size button icons get size-4.5 pr-1 classes" do
    component = Decor::Button.new(label: "Micro", size: :micro, icon: "home")
    rendered = render_component(component)

    assert_includes rendered, "size-4.5"
    assert_includes rendered, "pr-1"
  end

  test "xs size alias button icons get size-4.5 pr-1 classes" do
    component = Decor::Button.new(label: "XS", size: :xs, icon: "home")
    rendered = render_component(component)

    assert_includes rendered, "size-4.5"
    assert_includes rendered, "pr-1"
  end

  test "icon size classes match between original and alias sizes" do
    # Test that :lg and :large produce same icon classes
    lg_component = Decor::Button.new(label: "LG", size: :lg, icon: "home")
    large_component = Decor::Button.new(label: "Large", size: :large, icon: "home")
    lg_rendered = render_component(lg_component)
    large_rendered = render_component(large_component)

    assert_includes lg_rendered, "size-8"
    assert_includes large_rendered, "size-8"
    assert_includes lg_rendered, "pr-2"
    assert_includes large_rendered, "pr-2"

    # Test that :md and :medium produce same icon classes
    md_component = Decor::Button.new(label: "MD", size: :md, icon: "home")
    medium_component = Decor::Button.new(label: "Medium", size: :medium, icon: "home")
    md_rendered = render_component(md_component)
    medium_rendered = render_component(medium_component)

    assert_includes md_rendered, "size-6"
    assert_includes medium_rendered, "size-6"

    # Test that :sm and :small produce same icon classes
    sm_component = Decor::Button.new(label: "SM", size: :sm, icon: "home")
    small_component = Decor::Button.new(label: "Small", size: :small, icon: "home")
    sm_rendered = render_component(sm_component)
    small_rendered = render_component(small_component)

    assert_includes sm_rendered, "size-5.5"
    assert_includes small_rendered, "size-5.5"

    # Test that :xs and :micro produce same icon classes
    xs_component = Decor::Button.new(label: "XS", size: :xs, icon: "home")
    micro_component = Decor::Button.new(label: "Micro", size: :micro, icon: "home")
    xs_rendered = render_component(xs_component)
    micro_rendered = render_component(micro_component)

    assert_includes xs_rendered, "size-4.5"
    assert_includes micro_rendered, "size-4.5"
  end

  test "icons always include inline and mr-1 classes" do
    component = Decor::Button.new(label: "Test", icon: "home")
    rendered = render_component(component)

    assert_includes rendered, "inline"
    assert_includes rendered, "mr-1"
  end

  test "icon_only_on_mobile changes margin classes" do
    component = Decor::Button.new(label: "Test", icon: "home", icon_only_on_mobile: true)
    rendered = render_component(component)

    assert_includes rendered, "mr-0"
    assert_includes rendered, "md:mr-1"
  end
end
