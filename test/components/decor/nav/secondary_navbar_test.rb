require "test_helper"

class Decor::Nav::SecondaryNavbarTest < ActiveSupport::TestCase
  test "renders successfully with default attributes" do
    component = Decor::Nav::SecondaryNavbar.new
    rendered = render_component(component)

    assert_includes rendered, "decor--nav--secondary-navbar"
    assert_includes rendered, "navbar"
    assert_includes rendered, "bg-base-100"
  end

  test "renders with DaisyUI navbar classes" do
    component = Decor::Nav::SecondaryNavbar.new
    rendered = render_component(component)

    assert_includes rendered, "navbar"
    assert_includes rendered, "bg-base-100"
    assert_includes rendered, "min-h-12"
  end

  test "supports wide style" do
    component = Decor::Nav::SecondaryNavbar.new(style: :wide)
    rendered = render_component(component)

    assert_includes rendered, "min-h-[68px]"
    assert_not_includes rendered, "min-h-12"
  end

  test "supports narrow style" do
    component = Decor::Nav::SecondaryNavbar.new(style: :narrow)
    rendered = render_component(component)

    assert_includes rendered, "min-h-12"
    assert_not_includes rendered, "min-h-[68px]"
  end

  test "supports bottom border" do
    component = Decor::Nav::SecondaryNavbar.new(bottom_border: true)
    rendered = render_component(component)

    assert_includes rendered, "border-b"
    assert_includes rendered, "border-base-300"
  end

  test "does not include border by default" do
    component = Decor::Nav::SecondaryNavbar.new(bottom_border: false)
    rendered = render_component(component)

    assert_not_includes rendered, "border-b"
  end

  test "supports left content" do
    component = Decor::Nav::SecondaryNavbar.new
    component.with_left do
      plain "Left Content"
    end
    rendered = render_component(component)

    assert_includes rendered, "Left Content"
  end

  test "supports center content" do
    component = Decor::Nav::SecondaryNavbar.new
    component.with_center do
      plain "Center Content"
    end
    rendered = render_component(component)

    assert_includes rendered, "Center Content"
  end

  test "supports right content" do
    component = Decor::Nav::SecondaryNavbar.new
    component.with_right do
      plain "Right Content"
    end
    rendered = render_component(component)

    assert_includes rendered, "Right Content"
  end

  test "supports all three content areas" do
    component = Decor::Nav::SecondaryNavbar.new
    component.with_left do
      plain "Left"
    end
    component.with_center do
      plain "Center"
    end
    component.with_right do
      plain "Right"
    end
    rendered = render_component(component)

    assert_includes rendered, "Left"
    assert_includes rendered, "Center"
    assert_includes rendered, "Right"
  end

  test "renders proper flex layout structure" do
    component = Decor::Nav::SecondaryNavbar.new
    component.with_left do
      plain "Left"
    end
    component.with_right do
      plain "Right"
    end
    rendered = render_component(component)

    assert_includes rendered, "flex-1 flex items-center"
    assert_includes rendered, "ml-auto flex items-center"
  end

  test "component inherits from PhlexComponent" do
    component = Decor::Nav::SecondaryNavbar.new

    assert component.is_a?(Decor::PhlexComponent)
  end

  test "renders with correct HTML structure" do
    component = Decor::Nav::SecondaryNavbar.new
    fragment = render_fragment(component)

    navbar = fragment.at_css(".navbar")
    assert_not_nil navbar
    assert_includes navbar["class"], "decor--nav--secondary-navbar"
  end

  test "has proper aria-label for accessibility" do
    component = Decor::Nav::SecondaryNavbar.new
    rendered = render_component(component)

    assert_includes rendered, 'aria-label="Secondary Navigation"'
  end

  test "renders as header element" do
    component = Decor::Nav::SecondaryNavbar.new
    fragment = render_fragment(component)

    header = fragment.at_css("header")
    assert_not_nil header
    assert_includes header["class"], "navbar"
  end

  test "renders without content when no blocks provided" do
    component = Decor::Nav::SecondaryNavbar.new
    rendered = render_component(component)

    assert_includes rendered, "navbar"
    assert_includes rendered, "decor--nav--secondary-navbar"
    # Should have empty content areas
    assert_includes rendered, "flex-1 flex items-center"
  end

  test "supports method chaining" do
    component = Decor::Nav::SecondaryNavbar.new
      .with_left { plain "Left" }
      .with_center { plain "Center" }
      .with_right { plain "Right" }

    rendered = render_component(component)

    assert_includes rendered, "Left"
    assert_includes rendered, "Center"
    assert_includes rendered, "Right"
  end
end
