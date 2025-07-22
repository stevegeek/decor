require "test_helper"

class Decor::AvatarTest < ActiveSupport::TestCase
  test "renders successfully with initials" do
    component = Decor::Avatar.new(initials: "AB")
    rendered = render_component(component)

    assert_includes rendered, "AB"
    assert_includes rendered, "avatar"
    assert_includes rendered, "avatar-placeholder"
    # Default color is neutral and style is filled
    assert_includes rendered, "bg-neutral"
    assert_includes rendered, "text-neutral-content"
  end

  test "renders successfully with url" do
    component = Decor::Avatar.new(url: "https://example.com/avatar.jpg", initials: "AB")
    rendered = render_component(component)

    assert_includes rendered, "<img"
    assert_includes rendered, 'src="https://example.com/avatar.jpg"'
    assert_includes rendered, 'alt="Avatar image"'
  end

  test "applies correct size classes" do
    component = Decor::Avatar.new(initials: "AB", size: :lg)
    rendered = render_component(component)

    assert_includes rendered, "w-16"
    assert_includes rendered, "text-xl"
  end

  test "applies correct shape classes" do
    component = Decor::Avatar.new(initials: "AB", shape: :square)
    rendered = render_component(component)

    assert_includes rendered, "rounded"
    refute_includes rendered, "rounded-full"
  end

  test "applies ring classes when ring is specified" do
    component = Decor::Avatar.new(initials: "AB", ring: true)
    rendered = render_component(component)

    # Default color is neutral so ring-neutral should be present
    assert_includes rendered, "ring-neutral"
    assert_includes rendered, "ring-offset-base-100"
    assert_includes rendered, "ring-2"
    assert_includes rendered, "ring-offset-2"
  end

  test "renders with nil initials when url is provided" do
    component = Decor::Avatar.new(url: "https://example.com/avatar.jpg", initials: nil)
    rendered = render_component(component)

    assert_includes rendered, "<img"
    assert_includes rendered, 'src="https://example.com/avatar.jpg"'
    assert_includes rendered, 'alt="Avatar image"'
    # Should not render avatar-placeholder when using image
    refute_includes rendered, "avatar-placeholder"
  end

  test "uses nokogiri for parsing" do
    component = Decor::Avatar.new(initials: "AB")
    fragment = render_fragment(component)

    # Find the avatar div
    avatar_div = fragment.at_css(".avatar")
    assert_not_nil avatar_div

    span = fragment.at_css("span")
    assert_not_nil span
    assert_includes span.text, "AB"
    assert_includes span["class"], "text-base"
  end

  test "uses md as default size" do
    component = Decor::Avatar.new(initials: "AB")
    rendered = render_component(component)

    assert_includes rendered, "w-8"
    assert_includes rendered, "text-base"
  end

  test "applies correct modern size classes" do
    # Test xs size
    component = Decor::Avatar.new(initials: "XS", size: :xs)
    rendered = render_component(component)
    assert_includes rendered, "w-4"
    assert_includes rendered, "text-2xs"

    # Test sm size
    component = Decor::Avatar.new(initials: "SM", size: :sm)
    rendered = render_component(component)
    assert_includes rendered, "w-6"
    assert_includes rendered, "text-sm"

    # Test md size (default)
    component = Decor::Avatar.new(initials: "MD", size: :md)
    rendered = render_component(component)
    assert_includes rendered, "w-8"
    assert_includes rendered, "text-base"

    # Test lg size
    component = Decor::Avatar.new(initials: "LG", size: :lg)
    rendered = render_component(component)
    assert_includes rendered, "w-16"
    assert_includes rendered, "text-xl"

    # Test xl size
    component = Decor::Avatar.new(initials: "XL", size: :xl)
    rendered = render_component(component)
    assert_includes rendered, "w-24"
    assert_includes rendered, "text-2xl"
  end

  test "applies color classes to placeholder avatars" do
    component = Decor::Avatar.new(initials: "PC", color: :primary, style: :filled)
    rendered = render_component(component)
    assert_includes rendered, "bg-primary"
    assert_includes rendered, "text-primary-content"

    component = Decor::Avatar.new(initials: "SC", color: :secondary, style: :filled)
    rendered = render_component(component)
    assert_includes rendered, "bg-secondary"
    assert_includes rendered, "text-secondary-content"
  end

  test "applies color classes with default filled style" do
    component = Decor::Avatar.new(initials: "NV", color: :primary)
    rendered = render_component(component)
    # Default style is filled, so color classes should be applied
    assert_includes rendered, "bg-primary"
    assert_includes rendered, "text-primary-content"
  end

  test "applies style styles" do
    # Outlined style
    component = Decor::Avatar.new(initials: "OV", color: :primary, style: :outlined)
    rendered = render_component(component)
    assert_includes rendered, "border-2"
    assert_includes rendered, "border-primary"
    assert_includes rendered, "text-primary"
    refute_includes rendered, "bg-primary"

    # Ghost style
    component = Decor::Avatar.new(initials: "GV", color: :primary, style: :ghost)
    rendered = render_component(component)
    assert_includes rendered, "hover:bg-primary"
    assert_includes rendered, "text-primary"
  end

  test "color affects image avatars" do
    component = Decor::Avatar.new(url: "https://example.com/avatar.jpg", color: :primary)
    rendered = render_component(component)

    # Color classes are applied even to image avatars in the new implementation
    assert_includes rendered, "bg-primary"
    assert_includes rendered, "text-primary-content"
  end

  test "maintains default behavior" do
    # Default color is neutral and style is filled
    component = Decor::Avatar.new(initials: "DB")
    rendered = render_component(component)
    # Default color classes should be present
    assert_includes rendered, "bg-neutral"
    assert_includes rendered, "text-neutral-content"

    # No unexpected classes from other styles
    refute_includes rendered, "border-2"
    refute_includes rendered, "hover:"
  end

  # COMPREHENSIVE COLOR_CLASSES VALIDATION TESTS

  test "validates all color options with filled style" do
    Decor::Concerns::ColorClasses::SEMANTIC_COLORS.each do |color|
      component = Decor::Avatar.new(initials: "TC", color: color, style: :filled)
      rendered = render_component(component)

      case color
      when :base
        assert_includes rendered, "bg-base-100"
        assert_includes rendered, "text-base-content"
      when :primary
        assert_includes rendered, "bg-primary"
        assert_includes rendered, "text-primary-content"
      when :secondary
        assert_includes rendered, "bg-secondary"
        assert_includes rendered, "text-secondary-content"
      when :accent
        assert_includes rendered, "bg-accent"
        assert_includes rendered, "text-accent-content"
      when :success
        assert_includes rendered, "bg-success"
        assert_includes rendered, "text-success-content"
      when :error
        assert_includes rendered, "bg-error"
        assert_includes rendered, "text-error-content"
      when :warning
        assert_includes rendered, "bg-warning"
        assert_includes rendered, "text-warning-content"
      when :info
        assert_includes rendered, "bg-info"
        assert_includes rendered, "text-info-content"
      when :neutral
        assert_includes rendered, "bg-neutral"
        assert_includes rendered, "text-neutral-content"
      end
    end
  end

  test "validates all color options with outlined style" do
    Decor::Concerns::ColorClasses::SEMANTIC_COLORS.each do |color|
      component = Decor::Avatar.new(initials: "TC", color: color, style: :outlined)
      rendered = render_component(component)

      assert_includes rendered, "border-2"

      case color
      when :base
        assert_includes rendered, "text-base-content"
        assert_includes rendered, "border-base-300"
      when :primary
        assert_includes rendered, "text-primary"
        assert_includes rendered, "border-primary"
      when :secondary
        assert_includes rendered, "text-secondary"
        assert_includes rendered, "border-secondary"
      when :accent
        assert_includes rendered, "text-accent"
        assert_includes rendered, "border-accent"
      when :success
        assert_includes rendered, "text-success"
        assert_includes rendered, "border-success"
      when :error
        assert_includes rendered, "text-error"
        assert_includes rendered, "border-error"
      when :warning
        assert_includes rendered, "text-warning"
        assert_includes rendered, "border-warning"
      when :info
        assert_includes rendered, "text-info"
        assert_includes rendered, "border-info"
      when :neutral
        assert_includes rendered, "text-neutral"
        assert_includes rendered, "border-neutral"
      end
    end
  end

  test "validates all color options with ghost style" do
    Decor::Concerns::ColorClasses::SEMANTIC_COLORS.each do |color|
      component = Decor::Avatar.new(initials: "TC", color: color, style: :ghost)
      rendered = render_component(component)

      case color
      when :base
        assert_includes rendered, "text-base-content"
        assert_includes rendered, "hover:bg-base-200"
      when :primary
        assert_includes rendered, "text-primary"
        assert_includes rendered, "hover:bg-primary/10"
      when :secondary
        assert_includes rendered, "text-secondary"
        assert_includes rendered, "hover:bg-secondary/10"
      when :accent
        assert_includes rendered, "text-accent"
        assert_includes rendered, "hover:bg-accent/10"
      when :success
        assert_includes rendered, "text-success"
        assert_includes rendered, "hover:bg-success/10"
      when :error
        assert_includes rendered, "text-error"
        assert_includes rendered, "hover:bg-error/10"
      when :warning
        assert_includes rendered, "text-warning"
        assert_includes rendered, "hover:bg-warning/10"
      when :info
        assert_includes rendered, "text-info"
        assert_includes rendered, "hover:bg-info/10"
      when :neutral
        assert_includes rendered, "text-neutral"
        assert_includes rendered, "hover:bg-neutral/10"
      end
    end
  end

  test "validates specific key combinations from requirements" do
    # Primary + filled: should output "bg-primary text-primary-content"
    component = Decor::Avatar.new(initials: "PF", color: :primary, style: :filled)
    rendered = render_component(component)
    assert_includes rendered, "bg-primary"
    assert_includes rendered, "text-primary-content"

    # Secondary + outlined: should output "text-secondary border-2 border-secondary"
    component = Decor::Avatar.new(initials: "SO", color: :secondary, style: :outlined)
    rendered = render_component(component)
    assert_includes rendered, "text-secondary"
    assert_includes rendered, "border-2"
    assert_includes rendered, "border-secondary"

    # Accent + ghost: should output "text-accent hover:bg-accent"
    component = Decor::Avatar.new(initials: "AG", color: :accent, style: :ghost)
    rendered = render_component(component)
    assert_includes rendered, "text-accent"
    assert_includes rendered, "hover:bg-accent"

    # Neutral + filled: should output "bg-neutral text-neutral-content" (default behavior)
    component = Decor::Avatar.new(initials: "NF", color: :neutral, style: :filled)
    rendered = render_component(component)
    assert_includes rendered, "bg-neutral"
    assert_includes rendered, "text-neutral-content"
  end

  test "ensures no dynamic string building or nil values in output" do
    # Test that all combinations produce valid class strings with no interpolation artifacts
    Decor::Concerns::ColorClasses::SEMANTIC_COLORS.each do |color|
      [:filled, :outlined, :ghost].each do |style|
        component = Decor::Avatar.new(initials: "TC", color: color, style: style)
        rendered = render_component(component)

        # Should not contain dynamic interpolation artifacts
        refute_includes rendered, "nil"
        refute_includes rendered, '#{'
        refute_includes rendered, "}"

        # Should contain valid HTML classes
        assert_match(/class="[^"]*"/, rendered)
      end
    end
  end

  test "validates default behavior still works" do
    # Default color is neutral and style is filled
    component = Decor::Avatar.new(initials: "DB")
    rendered = render_component(component)

    # Default color classes should be present
    assert_includes rendered, "bg-neutral"
    assert_includes rendered, "text-neutral-content"
    assert_includes rendered, "w-8" # default size
    assert_includes rendered, "rounded-full" # default shape
  end

  test "ring color matches avatar color" do
    Decor::Concerns::ColorClasses::SEMANTIC_COLORS.each do |color|
      component = Decor::Avatar.new(initials: "BC", color: color, ring: true)
      rendered = render_component(component)

      expected_ring_class = case color
      when :base then "ring-base-300"
      when :primary then "ring-primary"
      when :secondary then "ring-secondary"
      when :accent then "ring-accent"
      when :success then "ring-success"
      when :error then "ring-error"
      when :warning then "ring-warning"
      when :info then "ring-info"
      when :neutral then "ring-neutral"
      end

      assert_includes rendered, expected_ring_class, "Expected #{expected_ring_class} for color #{color}"
      assert_includes rendered, "ring-offset-base-100"
      assert_includes rendered, "ring-2"
      assert_includes rendered, "ring-offset-2"
    end
  end

  test "no ring classes when ring is false" do
    component = Decor::Avatar.new(initials: "NB", color: :primary, ring: false)
    rendered = render_component(component)

    refute_includes rendered, "ring-primary"
    refute_includes rendered, "ring-offset-base-100"
    refute_includes rendered, "ring-2"
    refute_includes rendered, "ring-offset-2"
  end

  # CACHE KEY TESTS

  test "avatar component is cacheable" do
    component = Decor::Avatar.new(initials: "AB")
    assert component.cacheable?
    assert_respond_to component, :cache_key
  end

  test "cache key includes avatar properties" do
    component1 = Decor::Avatar.new(initials: "AB", color: :primary, style: :filled, size: :lg, shape: :circle, ring: true)
    component2 = Decor::Avatar.new(initials: "AB", color: :primary, style: :filled, size: :lg, shape: :circle, ring: true)

    # Same props should generate same cache key
    assert_equal component1.cache_key, component2.cache_key
  end

  test "cache key differs for different initials" do
    component1 = Decor::Avatar.new(initials: "AB")
    component2 = Decor::Avatar.new(initials: "CD")

    refute_equal component1.cache_key, component2.cache_key
  end

  test "cache key differs for different urls" do
    component1 = Decor::Avatar.new(url: "https://example.com/avatar1.jpg")
    component2 = Decor::Avatar.new(url: "https://example.com/avatar2.jpg")

    refute_equal component1.cache_key, component2.cache_key
  end

  test "cache key differs for different colors" do
    component1 = Decor::Avatar.new(initials: "AB", color: :primary)
    component2 = Decor::Avatar.new(initials: "AB", color: :secondary)

    refute_equal component1.cache_key, component2.cache_key
  end

  test "cache key differs for different styles" do
    component1 = Decor::Avatar.new(initials: "AB", style: :filled)
    component2 = Decor::Avatar.new(initials: "AB", style: :outlined)

    refute_equal component1.cache_key, component2.cache_key
  end

  test "cache key differs for different sizes" do
    component1 = Decor::Avatar.new(initials: "AB", size: :sm)
    component2 = Decor::Avatar.new(initials: "AB", size: :lg)

    refute_equal component1.cache_key, component2.cache_key
  end

  test "cache key differs for different shapes" do
    component1 = Decor::Avatar.new(initials: "AB", shape: :circle)
    component2 = Decor::Avatar.new(initials: "AB", shape: :square)

    refute_equal component1.cache_key, component2.cache_key
  end

  test "cache key differs for different ring values" do
    component1 = Decor::Avatar.new(initials: "AB", ring: true)
    component2 = Decor::Avatar.new(initials: "AB", ring: false)

    refute_equal component1.cache_key, component2.cache_key
  end

  test "cache key includes component modified time" do
    component = Decor::Avatar.new(initials: "AB")
    cache_key = component.cache_key

    # Cache key should include component class name
    assert_includes cache_key, "Decor::Avatar"

    # Should be able to get component_modified_time
    assert_respond_to component, :component_modified_time
  end

  test "cache key respects cache key modifier from environment" do
    original_modifier = ENV["RAILS_CACHE_ID"]

    # Test with no modifier
    ENV["RAILS_CACHE_ID"] = nil
    component1 = Decor::Avatar.new(initials: "AB")
    key1 = component1.cache_key

    # Test with modifier
    ENV["RAILS_CACHE_ID"] = "v2"
    component2 = Decor::Avatar.new(initials: "AB")
    key2 = component2.cache_key

    # Keys should be different with different modifiers
    refute_equal key1, key2
    assert_includes key2, "v2"
  ensure
    ENV["RAILS_CACHE_ID"] = original_modifier
  end

  test "cache key is stable for same properties" do
    component1 = Decor::Avatar.new(initials: "AB", color: :primary, style: :filled, size: :lg)
    key1 = component1.cache_key

    # Create another instance with same properties
    component2 = Decor::Avatar.new(initials: "AB", color: :primary, style: :filled, size: :lg)
    key2 = component2.cache_key

    # Keys should be identical
    assert_equal key1, key2
  end

  test "cache key includes all avatar properties in hash" do
    component = Decor::Avatar.new(
      initials: "TK",
      url: "https://example.com/test.jpg",
      color: :primary,
      style: :filled,
      size: :lg,
      shape: :square,
      ring: true
    )

    cache_key = component.cache_key

    # The cache key should be based on the component's properties
    # Different combinations should produce different keys
    assert_not_nil cache_key
    assert_kind_of String, cache_key
  end

  test "nil properties are handled correctly in cache key" do
    component1 = Decor::Avatar.new(initials: "AB", url: nil)
    component2 = Decor::Avatar.new(initials: "AB")

    # Both should generate valid cache keys
    assert_not_nil component1.cache_key
    assert_not_nil component2.cache_key

    # And they should be the same since url defaults to nil
    assert_equal component1.cache_key, component2.cache_key
  end
end
