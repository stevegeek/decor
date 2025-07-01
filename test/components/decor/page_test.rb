require "test_helper"

class Decor::PageTest < ActiveSupport::TestCase
  test "renders successfully with default attributes" do
    component = Decor::Page.new
    rendered = render_component(component)

    assert_includes rendered, "decor--page"
    refute_includes rendered, "min-h-screen" # Should not include by default
  end

  test "supports body slot" do
    component = Decor::Page.new
    component.with_body { "<div>Page content here</div>" }
    rendered = render_component(component)

    assert_includes rendered, "Page content here"
  end

  test "renders with full height layout when enabled" do
    component = Decor::Page.new(full_height: true)
    rendered = render_component(component)

    assert_includes rendered, "min-h-screen"
  end

  test "does not render full height layout by default" do
    component = Decor::Page.new
    rendered = render_component(component)

    refute_includes rendered, "min-h-screen"
  end

  test "supports header slot" do
    component = Decor::Page.new
    component.with_header { "<header>Page Header</header>" }
    rendered = render_component(component)

    assert_includes rendered, "Page Header"
  end

  test "supports hero slot" do
    component = Decor::Page.new
    component.with_hero { "<div>Hero Content</div>" }
    rendered = render_component(component)

    assert_includes rendered, "Hero Content"
  end

  test "renders all slots together" do
    component = Decor::Page.new
    component.with_hero { "Hero" }
    component.with_header { "Header" }
    component.with_body { "Content" }
    component.with_cta { "CTA" }
    rendered = render_component(component)

    assert_includes rendered, "Hero"
    assert_includes rendered, "Header"
    assert_includes rendered, "Content"
    assert_includes rendered, "CTA"
  end

  test "component inherits from PhlexComponent" do
    component = Decor::Page.new

    assert component.is_a?(Decor::PhlexComponent)
  end

  test "renders with correct HTML structure" do
    component = Decor::Page.new
    fragment = render_fragment(component)

    page_div = fragment.at_css(".decor--page")
    assert_not_nil page_div
    refute_includes page_div["class"], "min-h-screen"
  end

  test "renders without slots when none provided" do
    component = Decor::Page.new
    rendered = render_component(component)

    assert_includes rendered, "decor--page"
    refute_includes rendered, "min-h-screen"
  end

  test "supports responsive layout" do
    component = Decor::Page.new(full_height: true)
    rendered = render_component(component)

    assert_includes rendered, "min-h-screen"
  end

  test "maintains proper slot order" do
    component = Decor::Page.new
    component.with_hero { "First" }
    component.with_header { "Second" }
    component.with_body { "Third" }
    fragment = render_fragment(component)

    content = fragment.to_html
    first_pos = content.index("First")
    second_pos = content.index("Second")
    third_pos = content.index("Third")

    assert first_pos < second_pos
    assert second_pos < third_pos
  end

  test "uses daisyUI semantic classes" do
    component = Decor::Page.new(title: "Test Title", description: "Test description")
    rendered = render_component(component)

    assert_includes rendered, "bg-base-100"
    assert_includes rendered, "text-base-content"
    assert_includes rendered, "border-base-300"

    # Ensure legacy classes are not present
    refute_includes rendered, "bg-white"
    refute_includes rendered, "text-gray-900"
    refute_includes rendered, "border-gray-200"
  end

  # Modern attribute tests
  test "applies correct size classes" do
    component = Decor::Page.new(title: "Test", size: :lg)
    rendered = render_component(component)

    assert_includes rendered, "text-xl" # lg title size
  end

  test "applies background classes" do
    [:primary, :secondary, :hero, :neutral].each do |background|
      component = Decor::Page.new(background: background)
      rendered = render_component(component)

      case background
      when :primary
        assert_includes rendered, "bg-primary/10"
      when :secondary
        assert_includes rendered, "bg-secondary/10"
      when :hero
        assert_includes rendered, "bg-base-200"
      when :neutral
        assert_includes rendered, "bg-neutral/10"
      end
    end
  end

  test "applies padding classes" do
    component = Decor::Page.new(padding: :lg)
    rendered = render_component(component)

    assert_includes rendered, "py-12"
  end

  test "applies spacing classes" do
    component = Decor::Page.new(spacing: :xl)
    rendered = render_component(component)

    assert_includes rendered, "space-y-12"
  end

  # Tag and badge tests
  test "supports tags" do
    component = Decor::Page.new(title: "Test")
    component.with_tag(label: "Test Tag", color: :success)
    rendered = render_component(component)

    assert_includes rendered, "Test Tag"
    assert_includes rendered, "bg-success"
  end

  test "supports badges" do
    component = Decor::Page.new(title: "Test")
    component.with_badge(label: "Test Badge", color: :primary)
    rendered = render_component(component)

    assert_includes rendered, "Test Badge"
  end

  # Backward compatibility tests
  test "maintains backward compatibility" do
    component = Decor::Page.new(
      title: "Legacy Title",
      subtitle: "Legacy Subtitle",
      description: "Legacy description",
      cta_snap_large: true,
      include_flash: false
    )
    rendered = render_component(component)

    assert_includes rendered, "Legacy Title"
    assert_includes rendered, "Legacy Subtitle"
    assert_includes rendered, "Legacy description"
    assert_includes rendered, "xl:flex" # cta_snap_large behavior
    refute_includes rendered, "decor--flash" # flash disabled
  end

  test "supports tabs slot" do
    component = Decor::Page.new
    component.with_tabs { "<div>Tab content</div>" }
    rendered = render_component(component)

    assert_includes rendered, "Tab content"
  end

  test "default values are correct" do
    component = Decor::Page.new

    assert_equal :md, component.instance_variable_get(:@size)
    assert_equal :default, component.instance_variable_get(:@background)
    assert_equal :md, component.instance_variable_get(:@padding)
    assert_equal :md, component.instance_variable_get(:@spacing)
    assert_equal true, component.instance_variable_get(:@include_flash)
    assert_equal false, component.instance_variable_get(:@cta_snap_large)
    assert_equal false, component.instance_variable_get(:@full_height)
  end
end
