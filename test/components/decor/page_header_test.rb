require "test_helper"

class Decor::PageHeaderTest < ActiveSupport::TestCase
  test "renders successfully with basic title" do
    component = Decor::PageHeader.new(title: "Test Page")
    rendered = render_component(component)

    assert_includes rendered, "page-header"
    assert_includes rendered, "Test Page"
  end

  test "renders with all content attributes" do
    component = Decor::PageHeader.new(
      title: "Main Title",
      subtitle: "Subtitle Text",
      description: "This is a description of the page content."
    )
    rendered = render_component(component)

    assert_includes rendered, "Main Title"
    assert_includes rendered, "Subtitle Text"
    assert_includes rendered, "This is a description of the page content."
  end

  test "supports default layout" do
    component = Decor::PageHeader.new(title: "Test", layout: :default)
    rendered = render_component(component)

    assert_includes rendered, "flex flex-col lg:flex-row"
    assert_includes rendered, "lg:items-center lg:justify-between"
  end

  test "supports centered layout" do
    component = Decor::PageHeader.new(title: "Test", layout: :centered)
    rendered = render_component(component)

    assert_includes rendered, "text-center"
    assert_includes rendered, "max-w-4xl mx-auto"
  end

  test "supports minimal layout" do
    component = Decor::PageHeader.new(title: "Test", layout: :minimal)
    rendered = render_component(component)

    assert_includes rendered, "flex items-center justify-between"
  end

  test "supports hero layout" do
    component = Decor::PageHeader.new(title: "Test", layout: :hero)
    rendered = render_component(component)

    assert_includes rendered, "hero"
    assert_includes rendered, "hero-content"
  end

  test "supports compact layout" do
    component = Decor::PageHeader.new(title: "Test", layout: :compact)
    rendered = render_component(component)

    assert_includes rendered, "flex items-center justify-between py-2"
  end

  test "supports different sizes" do
    small_component = Decor::PageHeader.new(title: "Test", size: :sm)
    large_component = Decor::PageHeader.new(title: "Test", size: :xl)

    small_rendered = render_component(small_component)
    large_rendered = render_component(large_component)

    assert_includes small_rendered, "text-xl"
    assert_includes large_rendered, "text-2xl"
  end

  test "supports different backgrounds" do
    hero_component = Decor::PageHeader.new(title: "Test", background: :hero)
    gradient_component = Decor::PageHeader.new(title: "Test", background: :gradient)
    transparent_component = Decor::PageHeader.new(title: "Test", background: :transparent)

    hero_rendered = render_component(hero_component)
    gradient_rendered = render_component(gradient_component)
    transparent_rendered = render_component(transparent_component)

    assert_includes hero_rendered, "bg-base-200"
    assert_includes gradient_rendered, "bg-gradient-to-r from-primary to-secondary"
    refute_includes transparent_rendered, "bg-"
  end

  test "supports border configuration" do
    with_border = Decor::PageHeader.new(title: "Test", border: true)
    without_border = Decor::PageHeader.new(title: "Test", border: false)

    with_rendered = render_component(with_border)
    without_rendered = render_component(without_border)

    assert_includes with_rendered, "border-b border-base-300"
    refute_includes without_rendered, "border-b"
  end

  test "supports different padding levels" do
    small_padding = Decor::PageHeader.new(title: "Test", padding: :sm)
    large_padding = Decor::PageHeader.new(title: "Test", padding: :lg)

    small_rendered = render_component(small_padding)
    large_rendered = render_component(large_padding)

    assert_includes small_rendered, "p-4"
    assert_includes large_rendered, "p-8 lg:p-12"
  end

  test "supports avatar content area" do
    component = Decor::PageHeader.new(title: "Test")
    component.with_avatar do
      "Avatar Content"
    end
    rendered = render_component(component)

    assert_includes rendered, "Avatar Content"
    assert_includes rendered, "flex-shrink-0"
  end

  test "supports title content area override" do
    component = Decor::PageHeader.new(title: "Original Title")
    component.with_title_content do
      "Custom Title Content"
    end
    rendered = render_component(component)

    assert_includes rendered, "Custom Title Content"
  end

  test "supports meta content area" do
    component = Decor::PageHeader.new(title: "Test")
    component.with_meta_content do
      "Badge Tag"
    end
    rendered = render_component(component)

    assert_includes rendered, "Badge Tag"
  end

  test "supports actions content area" do
    component = Decor::PageHeader.new(title: "Test")
    component.with_actions do
      "Edit Delete"
    end
    rendered = render_component(component)

    assert_includes rendered, "Edit Delete"
  end

  test "supports secondary actions content area" do
    component = Decor::PageHeader.new(title: "Test")
    component.with_secondary_actions do
      "More"
    end
    rendered = render_component(component)

    assert_includes rendered, "More"
  end

  test "supports breadcrumbs content area" do
    component = Decor::PageHeader.new(title: "Test")
    component.with_breadcrumbs do
      "Home > Current"
    end
    rendered = render_component(component)

    assert_includes rendered, "Home &gt; Current"
  end

  test "supports status content area" do
    component = Decor::PageHeader.new(title: "Test", layout: :centered)
    component.with_status do
      "Success status"
    end
    rendered = render_component(component)

    assert_includes rendered, "Success status"
  end

  test "supports multiple content areas together" do
    component = Decor::PageHeader.new(title: "Test Page")
    component.with_avatar { "Avatar" }
    component.with_meta_content { "Meta" }
    component.with_actions { "Action" }
    component.with_breadcrumbs { "Breadcrumbs" }
    rendered = render_component(component)

    assert_includes rendered, "Avatar"
    assert_includes rendered, "Meta"
    assert_includes rendered, "Action"
    assert_includes rendered, "Breadcrumbs"
  end

  test "handles empty content gracefully" do
    component = Decor::PageHeader.new
    rendered = render_component(component)

    assert_includes rendered, "page-header"
    # Should not crash with no content
  end

  test "renders compact layout with minimal content" do
    component = Decor::PageHeader.new(
      title: "Compact Title",
      layout: :compact,
      description: "This should not show in compact mode"
    )
    rendered = render_component(component)

    assert_includes rendered, "Compact Title"
    assert_includes rendered, "font-semibold"
    assert_includes rendered, "text-lg"
    # Description should not appear in compact layout
    refute_includes rendered, "This should not show in compact mode"
  end

  test "component inherits from PhlexComponent" do
    component = Decor::PageHeader.new(title: "Test")

    assert component.is_a?(Decor::PhlexComponent)
  end

  test "uses daisyUI classes" do
    component = Decor::PageHeader.new(title: "Test")
    rendered = render_component(component)

    assert_includes rendered, "page-header"
    assert_includes rendered, "bg-base-100"
    assert_includes rendered, "text-base-content"
  end

  test "responsive behavior in default layout" do
    component = Decor::PageHeader.new(title: "Test", layout: :default)
    rendered = render_component(component)

    assert_includes rendered, "flex-col lg:flex-row"
    assert_includes rendered, "sm:flex-row"
  end

  test "validates layout choices" do
    valid_layouts = [:default, :centered, :minimal, :hero, :compact]

    valid_layouts.each do |layout|
      component = Decor::PageHeader.new(title: "Test", layout: layout)
      assert_nothing_raised { render_component(component) }
    end
  end

  test "validates size choices" do
    valid_sizes = [:sm, :md, :lg, :xl]

    valid_sizes.each do |size|
      component = Decor::PageHeader.new(title: "Test", size: size)
      assert_nothing_raised { render_component(component) }
    end
  end

  test "validates background choices" do
    valid_backgrounds = [:default, :hero, :gradient, :transparent]

    valid_backgrounds.each do |background|
      component = Decor::PageHeader.new(title: "Test", background: background)
      assert_nothing_raised { render_component(component) }
    end
  end
end
