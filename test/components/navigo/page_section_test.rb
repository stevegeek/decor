require "test_helper"

class Navigo::PageSectionTest < ActiveSupport::TestCase
  # Basic rendering tests
  test "renders successfully without any attributes" do
    component = Navigo::PageSection.new
    rendered = render_component(component)

    assert_includes rendered, "pb-6"
    assert_includes rendered, "space-y-4"
  end

  test "renders with title" do
    component = Navigo::PageSection.new(title: "Test Title")
    rendered = render_component(component)

    assert_includes rendered, "Test Title"
    assert_includes rendered, "<h3"
    assert_includes rendered, "text-base-content"
  end

  test "renders with description" do
    component = Navigo::PageSection.new(description: "Test description")
    rendered = render_component(component)

    assert_includes rendered, "Test description"
    assert_includes rendered, "text-base-content/70"
  end

  test "renders with both title and description" do
    component = Navigo::PageSection.new(
      title: "Section Title",
      description: "Section description"
    )
    rendered = render_component(component)

    assert_includes rendered, "Section Title"
    assert_includes rendered, "Section description"
    assert_includes rendered, "mt-2" # Margin top when title is present
  end

  # Separator tests
  test "renders separator when enabled" do
    component = Navigo::PageSection.new(
      title: "With Separator",
      separator: true
    )
    rendered = render_component(component)

    assert_includes rendered, "border-b"
    assert_includes rendered, "border-base-300"
  end

  test "does not render separator by default" do
    component = Navigo::PageSection.new(title: "No Separator")
    rendered = render_component(component)

    refute_includes rendered, "border-b"
  end

  # Size tests
  test "applies correct size classes for title" do
    [:xs, :sm, :md, :lg, :xl].each do |size|
      component = Navigo::PageSection.new(title: "Test", size: size)
      rendered = render_component(component)

      case size
      when :xs
        assert_includes rendered, "text-sm leading-5"
      when :sm
        assert_includes rendered, "text-base leading-5"
      when :md
        assert_includes rendered, "text-lg leading-6"
      when :lg
        assert_includes rendered, "text-xl leading-7"
      when :xl
        assert_includes rendered, "text-2xl leading-8"
      end
    end
  end

  test "applies correct size classes for description" do
    [:xs, :sm, :md, :lg, :xl].each do |size|
      component = Navigo::PageSection.new(description: "Test", size: size)
      rendered = render_component(component)

      case size
      when :xs
        assert_includes rendered, "text-xs"
      when :sm
        assert_includes rendered, "text-sm"
      when :md
        assert_includes rendered, "text-sm"
      when :lg
        assert_includes rendered, "text-base"
      when :xl
        assert_includes rendered, "text-lg"
      end
    end
  end

  test "applies correct size classes for content area spacing" do
    component = Navigo::PageSection.new(size: :lg)
    rendered = render_component(component) { "Content" }

    assert_includes rendered, "space-y-8"
  end

  test "medium size is default" do
    component = Navigo::PageSection.new(title: "Default Size")
    rendered = render_component(component)

    assert_includes rendered, "text-lg leading-6"
  end

  # Background tests
  test "applies correct background classes" do
    [:primary, :secondary, :neutral].each do |background|
      component = Navigo::PageSection.new(background: background)
      rendered = render_component(component)

      assert_includes rendered, "bg-#{background}/10"
      assert_includes rendered, "p-6"
      assert_includes rendered, "rounded-lg"
    end
  end

  test "default background applies no background classes" do
    component = Navigo::PageSection.new(background: :default)
    rendered = render_component(component)

    refute_includes rendered, "bg-primary/10"
    refute_includes rendered, "bg-secondary/10"
    refute_includes rendered, "bg-neutral/10"
  end

  test "background defaults to default" do
    component = Navigo::PageSection.new
    rendered = render_component(component)

    refute_includes rendered, "bg-primary/10"
  end

  # Padding tests
  test "applies correct padding classes" do
    {
      none: nil,
      sm: "pb-4",
      md: "pb-6",
      lg: "pb-8",
      xl: "pb-10"
    }.each do |padding, expected_class|
      component = Navigo::PageSection.new(padding: padding)
      rendered = render_component(component)

      if expected_class
        assert_includes rendered, expected_class
      else
        # For :none padding, check that no pb- classes are present
        refute_includes rendered, "pb-4"
        refute_includes rendered, "pb-6"
        refute_includes rendered, "pb-8"
        refute_includes rendered, "pb-10"
      end
    end
  end

  test "medium padding is default" do
    component = Navigo::PageSection.new
    rendered = render_component(component)

    assert_includes rendered, "pb-6"
  end

  # Slot tests
  test "renders hero slot when provided" do
    component = Navigo::PageSection.new
    component.with_hero { "Hero content" }
    rendered = render_component(component)

    assert_includes rendered, "Hero content"
  end

  test "renders cta slot when provided" do
    component = Navigo::PageSection.new
    component.with_cta { "CTA content" }
    rendered = render_component(component)

    assert_includes rendered, "CTA content"
  end

  test "adjusts content wrapper classes when cta slot is present" do
    component = Navigo::PageSection.new(title: "Test")
    component.with_cta { "CTA" }
    rendered = render_component(component)

    assert_includes rendered, "pr-4"
    assert_includes rendered, "pb-4"
    assert_includes rendered, "sm:pb-0"
  end

  test "renders without hero slot by default" do
    component = Navigo::PageSection.new
    rendered = render_component(component)

    # Should render successfully without hero content
    assert rendered
  end

  # Tags tests
  test "renders tags when provided" do
    component = Navigo::PageSection.new
    component.with_tag(label: "Test Tag", color: :success)
    rendered = render_component(component)

    assert_includes rendered, "Test Tag"
    assert_includes rendered, "bg-success"
  end

  test "renders multiple tags" do
    component = Navigo::PageSection.new
    component.with_tag(label: "Tag 1", color: :primary)
    component.with_tag(label: "Tag 2", color: :secondary)
    rendered = render_component(component)

    assert_includes rendered, "Tag 1"
    assert_includes rendered, "Tag 2"
    assert_includes rendered, "bg-primary"
    assert_includes rendered, "bg-secondary"
  end

  # Block content tests
  test "renders block content" do
    component = Navigo::PageSection.new
    rendered = render_component(component) { "Block content here" }

    assert_includes rendered, "Block content here"
  end

  test "renders without block content" do
    component = Navigo::PageSection.new(title: "Just title")
    rendered = render_component(component)

    assert_includes rendered, "Just title"
    assert rendered # Should not error
  end

  # Combination tests
  test "renders with all features combined" do
    component = Navigo::PageSection.new(
      title: "Full Feature Test",
      description: "With all options",
      separator: true,
      size: :lg,
      background: :primary,
      padding: :xl
    )
    component.with_hero { "Hero section" }
    component.with_tag(label: "Tag", color: :success)
    component.with_cta { "Action button" }

    rendered = render_component(component) { "Main content" }

    # Check all elements are present
    assert_includes rendered, "Full Feature Test"
    assert_includes rendered, "With all options"
    assert_includes rendered, "Hero section"
    assert_includes rendered, "Tag"
    assert_includes rendered, "Action button"
    assert_includes rendered, "Main content"

    # Check styling classes
    assert_includes rendered, "border-b"
    assert_includes rendered, "border-base-300"
    assert_includes rendered, "text-xl" # lg size title
    assert_includes rendered, "bg-primary/10"
    assert_includes rendered, "p-6" # Background applies p-6 instead of padding attribute
    assert_includes rendered, "space-y-8" # lg content spacing
  end

  # Default values tests
  test "has correct default values" do
    component = Navigo::PageSection.new

    assert_equal false, component.instance_variable_get(:@separator)
    assert_equal :md, component.instance_variable_get(:@size)
    assert_equal :default, component.instance_variable_get(:@background)
    assert_equal :md, component.instance_variable_get(:@padding)
  end

  # DaisyUI semantic classes validation
  test "uses daisyUI semantic classes instead of legacy Tailwind" do
    component = Navigo::PageSection.new(
      title: "Modern Classes",
      description: "Testing semantic classes",
      separator: true
    )
    rendered = render_component(component)

    # Check for modern daisyUI classes
    assert_includes rendered, "text-base-content"
    assert_includes rendered, "text-base-content/70"
    assert_includes rendered, "border-base-300"

    # Ensure legacy Tailwind classes are not present
    refute_includes rendered, "text-gray-900"
    refute_includes rendered, "text-gray-500"
    refute_includes rendered, "border-gray-200"
  end

  # Edge cases
  test "handles empty attributes gracefully" do
    component = Navigo::PageSection.new(
      title: "",
      description: ""
    )
    rendered = render_component(component)

    assert rendered # Should not raise error
    assert_includes rendered, "pb-6" # Basic structure maintained
  end

  test "handles only title without description" do
    component = Navigo::PageSection.new(title: "Only Title")
    rendered = render_component(component)

    assert_includes rendered, "Only Title"
    assert_includes rendered, "<h3"
    refute_includes rendered, "mt-2" # No margin top without title
  end

  test "handles only description without title" do
    component = Navigo::PageSection.new(description: "Only description")
    rendered = render_component(component)

    assert_includes rendered, "Only description"
    refute_includes rendered, "<h3"
    refute_includes rendered, "mt-2" # No margin top without title
  end

  # Header padding behavior
  test "applies header padding when separator and content present" do
    component = Navigo::PageSection.new(
      title: "Test",
      separator: true,
      size: :lg
    )
    rendered = render_component(component)

    assert_includes rendered, "pb-6" # lg header padding
  end

  test "does not apply header padding without separator" do
    component = Navigo::PageSection.new(
      title: "Test",
      separator: false
    )
    rendered = render_component(component)

    # Should not have the conditional padding class for headers
    refute_includes rendered, "pb-5"
  end

  # Nokogiri parsing test
  test "uses nokogiri for complex DOM assertions" do
    component = Navigo::PageSection.new(
      title: "Parse Test",
      description: "DOM structure test",
      separator: true,
      background: :primary
    )
    fragment = render_fragment(component)

    # Find the main container
    main_div = fragment.at_css("div")
    assert_not_nil main_div
    # When background is applied, uses p-6 instead of pb-6
    assert_includes main_div["class"], "p-6"
    assert_includes main_div["class"], "bg-primary/10"

    # Find the title
    title_h3 = fragment.at_css("h3")
    assert_not_nil title_h3
    assert_equal "Parse Test", title_h3.text.strip
    assert_includes title_h3["class"], "text-base-content"

    # Find the description paragraph
    desc_p = fragment.at_css("p")
    assert_not_nil desc_p
    assert_includes desc_p.text, "DOM structure test"
    assert_includes desc_p["class"], "text-base-content/70"
  end

  # Backward compatibility tests
  test "maintains backward compatibility with existing usage" do
    # This simulates existing usage patterns that should continue to work
    component = Navigo::PageSection.new(
      title: "Legacy Usage",
      description: "Should still work",
      separator: true
    )
    rendered = render_component(component)

    assert_includes rendered, "Legacy Usage"
    assert_includes rendered, "Should still work"
    assert_includes rendered, "border-b"
    assert rendered # Should render successfully
  end
end
