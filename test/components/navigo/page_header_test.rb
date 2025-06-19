require "test_helper"

class Navigo::PageHeaderTest < ActiveSupport::TestCase
  test "renders successfully with basic title" do
    component = Navigo::PageHeader.new(title: "Test Page")
    rendered = render_component(component)

    assert_includes rendered, "page-header"
    assert_includes rendered, "Test Page"
  end

  test "renders with all content attributes" do
    component = Navigo::PageHeader.new(
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
    component = Navigo::PageHeader.new(title: "Test", layout: :default)
    rendered = render_component(component)

    assert_includes rendered, "flex flex-col lg:flex-row"
    assert_includes rendered, "lg:items-center lg:justify-between"
  end

  test "supports centered layout" do
    component = Navigo::PageHeader.new(title: "Test", layout: :centered)
    rendered = render_component(component)

    assert_includes rendered, "text-center"
    assert_includes rendered, "max-w-4xl mx-auto"
  end

  test "supports minimal layout" do
    component = Navigo::PageHeader.new(title: "Test", layout: :minimal)
    rendered = render_component(component)

    assert_includes rendered, "flex items-center justify-between"
  end

  test "supports hero layout" do
    component = Navigo::PageHeader.new(title: "Test", layout: :hero)
    rendered = render_component(component)

    assert_includes rendered, "hero"
    assert_includes rendered, "hero-content"
  end

  test "supports compact layout" do
    component = Navigo::PageHeader.new(title: "Test", layout: :compact)
    rendered = render_component(component)

    assert_includes rendered, "flex items-center justify-between py-2"
  end

  test "supports different sizes" do
    small_component = Navigo::PageHeader.new(title: "Test", size: :sm)
    large_component = Navigo::PageHeader.new(title: "Test", size: :xl)

    small_rendered = render_component(small_component)
    large_rendered = render_component(large_component)

    assert_includes small_rendered, "text-xl"
    assert_includes large_rendered, "text-4xl"
  end

  test "supports different backgrounds" do
    hero_component = Navigo::PageHeader.new(title: "Test", background: :hero)
    gradient_component = Navigo::PageHeader.new(title: "Test", background: :gradient)
    transparent_component = Navigo::PageHeader.new(title: "Test", background: :transparent)

    hero_rendered = render_component(hero_component)
    gradient_rendered = render_component(gradient_component)
    transparent_rendered = render_component(transparent_component)

    assert_includes hero_rendered, "bg-base-200"
    assert_includes gradient_rendered, "bg-gradient-to-r from-primary to-secondary"
    refute_includes transparent_rendered, "bg-"
  end

  test "supports border configuration" do
    with_border = Navigo::PageHeader.new(title: "Test", border: true)
    without_border = Navigo::PageHeader.new(title: "Test", border: false)

    with_rendered = render_component(with_border)
    without_rendered = render_component(without_border)

    assert_includes with_rendered, "border-b border-base-300"
    refute_includes without_rendered, "border-b"
  end

  test "supports different padding levels" do
    small_padding = Navigo::PageHeader.new(title: "Test", padding: :sm)
    large_padding = Navigo::PageHeader.new(title: "Test", padding: :lg)

    small_rendered = render_component(small_padding)
    large_rendered = render_component(large_padding)

    assert_includes small_rendered, "p-4"
    assert_includes large_rendered, "p-8 lg:p-12"
  end

  test "supports avatar content area" do
    component = Navigo::PageHeader.new(title: "Test")
    component.with_avatar do
      span { "Avatar Content" }
    end
    rendered = render_component(component)

    assert_includes rendered, "Avatar Content"
    assert_includes rendered, "flex-shrink-0"
  end

  test "supports title content area override" do
    component = Navigo::PageHeader.new(title: "Original Title")
    component.with_title_content do
      h1 { "Custom Title Content" }
    end
    rendered = render_component(component)

    assert_includes rendered, "Custom Title Content"
  end

  test "supports meta content area" do
    component = Navigo::PageHeader.new(title: "Test")
    component.with_meta_content do
      div(class: "flex gap-2") do
        span(class: "badge badge-primary") { "Badge" }
        span(class: "badge badge-secondary") { "Tag" }
      end
    end
    rendered = render_component(component)

    assert_includes rendered, "badge badge-primary"
    assert_includes rendered, "Badge"
    assert_includes rendered, "Tag"
  end

  test "supports actions content area" do
    component = Navigo::PageHeader.new(title: "Test")
    component.with_actions do
      button(class: "btn btn-primary") { "Edit" }
      button(class: "btn btn-secondary") { "Delete" }
    end
    rendered = render_component(component)

    assert_includes rendered, "btn btn-primary"
    assert_includes rendered, "Edit"
    assert_includes rendered, "Delete"
  end

  test "supports secondary actions content area" do
    component = Navigo::PageHeader.new(title: "Test")
    component.with_secondary_actions do
      button(class: "btn btn-ghost") { "More" }
    end
    rendered = render_component(component)

    assert_includes rendered, "btn btn-ghost"
    assert_includes rendered, "More"
  end

  test "supports breadcrumbs content area" do
    component = Navigo::PageHeader.new(title: "Test")
    component.with_breadcrumbs do
      nav(class: "breadcrumbs") do
        ul do
          li { a(href: "/") { "Home" } }
          li { "Current" }
        end
      end
    end
    rendered = render_component(component)

    assert_includes rendered, "breadcrumbs"
    assert_includes rendered, "Home"
    assert_includes rendered, "Current"
  end

  test "supports status content area" do
    component = Navigo::PageHeader.new(title: "Test", layout: :centered)
    component.with_status do
      div(class: "alert alert-success") do
        span { "Success status" }
      end
    end
    rendered = render_component(component)

    assert_includes rendered, "alert alert-success"
    assert_includes rendered, "Success status"
  end

  test "supports multiple content areas together" do
    component = Navigo::PageHeader.new(title: "Test Page")
    component.with_avatar { span { "Avatar" } }
    component.with_meta_content { span { "Meta" } }
    component.with_actions { button { "Action" } }
    component.with_breadcrumbs { nav { "Breadcrumbs" } }
    rendered = render_component(component)

    assert_includes rendered, "Avatar"
    assert_includes rendered, "Meta"
    assert_includes rendered, "Action"
    assert_includes rendered, "Breadcrumbs"
  end

  test "handles empty content gracefully" do
    component = Navigo::PageHeader.new
    rendered = render_component(component)

    assert_includes rendered, "page-header"
    # Should not crash with no content
  end

  test "renders compact layout with minimal content" do
    component = Navigo::PageHeader.new(
      title: "Compact Title",
      layout: :compact,
      description: "This should not show in compact mode"
    )
    rendered = render_component(component)

    assert_includes rendered, "Compact Title"
    assert_includes rendered, "text-lg font-semibold"
    # Description should not appear in compact layout
    refute_includes rendered, "This should not show in compact mode"
  end

  test "component inherits from PhlexComponent" do
    component = Navigo::PageHeader.new(title: "Test")

    assert component.is_a?(Navigo::PhlexComponent)
  end

  test "uses daisyUI classes" do
    component = Navigo::PageHeader.new(title: "Test")
    rendered = render_component(component)

    assert_includes rendered, "page-header"
    assert_includes rendered, "bg-base-100"
    assert_includes rendered, "text-base-content"
  end

  test "responsive behavior in default layout" do
    component = Navigo::PageHeader.new(title: "Test", layout: :default)
    rendered = render_component(component)

    assert_includes rendered, "flex-col lg:flex-row"
    assert_includes rendered, "sm:flex-row"
  end

  test "validates layout choices" do
    valid_layouts = [:default, :centered, :minimal, :hero, :compact]

    valid_layouts.each do |layout|
      component = Navigo::PageHeader.new(title: "Test", layout: layout)
      assert_nothing_raised { render_component(component) }
    end
  end

  test "validates size choices" do
    valid_sizes = [:sm, :md, :lg, :xl]

    valid_sizes.each do |size|
      component = Navigo::PageHeader.new(title: "Test", size: size)
      assert_nothing_raised { render_component(component) }
    end
  end

  test "validates background choices" do
    valid_backgrounds = [:default, :hero, :gradient, :transparent]

    valid_backgrounds.each do |background|
      component = Navigo::PageHeader.new(title: "Test", background: background)
      assert_nothing_raised { render_component(component) }
    end
  end
end
