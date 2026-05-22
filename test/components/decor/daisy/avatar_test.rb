require "test_helper"

class Decor::Daisy::AvatarTest < ActiveSupport::TestCase
  test "renders successfully with initials" do
    component = Decor::Daisy::Avatar.new(initials: "AB")
    rendered = render_component(component)

    assert_includes rendered, "AB"
    assert_includes rendered, "avatar"
    assert_includes rendered, "avatar-placeholder"
    assert_includes rendered, "bg-neutral"
    assert_includes rendered, "text-neutral-content"
  end

  test "renders successfully with url" do
    component = Decor::Daisy::Avatar.new(url: "https://example.com/avatar.jpg", initials: "AB")
    rendered = render_component(component)

    assert_includes rendered, "<img"
    assert_includes rendered, 'src="https://example.com/avatar.jpg"'
    assert_includes rendered, 'alt="AB"'
  end

  test "applies correct size classes" do
    component = Decor::Daisy::Avatar.new(initials: "AB", size: :lg)
    rendered = render_component(component)

    assert_includes rendered, "w-16"
    assert_includes rendered, "text-xl"
  end

  test "applies correct shape classes" do
    component = Decor::Daisy::Avatar.new(initials: "AB", shape: :square)
    rendered = render_component(component)

    assert_includes rendered, "rounded"
    refute_includes rendered, "rounded-full"
  end

  test "applies ring classes when ring is specified" do
    component = Decor::Daisy::Avatar.new(initials: "AB", border: true)
    rendered = render_component(component)

    assert_includes rendered, "ring-neutral"
    assert_includes rendered, "ring-offset-base-100"
    assert_includes rendered, "ring-2"
    assert_includes rendered, "ring-offset-2"
  end

  test "renders with nil initials when url is provided" do
    component = Decor::Daisy::Avatar.new(url: "https://example.com/avatar.jpg", initials: nil)
    rendered = render_component(component)

    assert_includes rendered, "<img"
    assert_includes rendered, 'src="https://example.com/avatar.jpg"'
    assert_includes rendered, 'alt="Avatar image"'
    refute_includes rendered, "avatar-placeholder"
  end

  test "uses nokogiri for parsing" do
    component = Decor::Daisy::Avatar.new(initials: "AB")
    fragment = render_fragment(component)

    avatar_div = fragment.at_css('[class*="d-avatar"]')
    assert_not_nil avatar_div

    span = fragment.at_css("span")
    assert_not_nil span
    assert_includes span.text, "AB"
    assert_includes span["class"], "text-base"
  end

  test "uses md as default size" do
    component = Decor::Daisy::Avatar.new(initials: "AB")
    rendered = render_component(component)

    assert_includes rendered, "w-8"
    assert_includes rendered, "text-base"
  end

  test "applies correct modern size classes" do
    component = Decor::Daisy::Avatar.new(initials: "XS", size: :xs)
    rendered = render_component(component)
    assert_includes rendered, "w-4"
    assert_includes rendered, "text-2xs"

    component = Decor::Daisy::Avatar.new(initials: "SM", size: :sm)
    rendered = render_component(component)
    assert_includes rendered, "w-6"
    assert_includes rendered, "text-sm"

    component = Decor::Daisy::Avatar.new(initials: "MD", size: :md)
    rendered = render_component(component)
    assert_includes rendered, "w-8"
    assert_includes rendered, "text-base"

    component = Decor::Daisy::Avatar.new(initials: "LG", size: :lg)
    rendered = render_component(component)
    assert_includes rendered, "w-16"
    assert_includes rendered, "text-xl"

    component = Decor::Daisy::Avatar.new(initials: "XL", size: :xl)
    rendered = render_component(component)
    assert_includes rendered, "w-24"
    assert_includes rendered, "text-2xl"
  end

  test "applies color classes to placeholder avatars" do
    component = Decor::Daisy::Avatar.new(initials: "PC", color: :primary, style: :filled)
    rendered = render_component(component)
    assert_includes rendered, "bg-primary"
    assert_includes rendered, "text-primary-content"

    component = Decor::Daisy::Avatar.new(initials: "SC", color: :secondary, style: :filled)
    rendered = render_component(component)
    assert_includes rendered, "bg-secondary"
    assert_includes rendered, "text-secondary-content"
  end

  test "applies color classes with default filled style" do
    component = Decor::Daisy::Avatar.new(initials: "NV", color: :primary)
    rendered = render_component(component)
    assert_includes rendered, "bg-primary"
    assert_includes rendered, "text-primary-content"
  end

  test "applies style styles" do
    component = Decor::Daisy::Avatar.new(initials: "OV", color: :primary, style: :outlined)
    rendered = render_component(component)
    assert_includes rendered, "border-2"
    assert_includes rendered, "border-primary"
    assert_includes rendered, "text-primary"
    refute_includes rendered, "bg-primary"

    component = Decor::Daisy::Avatar.new(initials: "GV", color: :primary, style: :ghost)
    rendered = render_component(component)
    assert_includes rendered, "hover:bg-primary"
    assert_includes rendered, "text-primary"
  end

  test "color affects image avatars" do
    component = Decor::Daisy::Avatar.new(url: "https://example.com/avatar.jpg", color: :primary)
    rendered = render_component(component)

    assert_includes rendered, "bg-primary"
    assert_includes rendered, "text-primary-content"
  end

  test "maintains default behavior" do
    component = Decor::Daisy::Avatar.new(initials: "DB")
    rendered = render_component(component)
    assert_includes rendered, "bg-neutral"
    assert_includes rendered, "text-neutral-content"

    refute_includes rendered, "border-2"
    refute_includes rendered, "hover:"
  end

  test "validates all color options with filled style" do
    Decor::Concerns::ColorClasses::SEMANTIC_COLORS.each do |color|
      component = Decor::Daisy::Avatar.new(initials: "TC", color: color, style: :filled)
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
      component = Decor::Daisy::Avatar.new(initials: "TC", color: color, style: :outlined)
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
      component = Decor::Daisy::Avatar.new(initials: "TC", color: color, style: :ghost)
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
    component = Decor::Daisy::Avatar.new(initials: "PF", color: :primary, style: :filled)
    rendered = render_component(component)
    assert_includes rendered, "bg-primary"
    assert_includes rendered, "text-primary-content"

    component = Decor::Daisy::Avatar.new(initials: "SO", color: :secondary, style: :outlined)
    rendered = render_component(component)
    assert_includes rendered, "text-secondary"
    assert_includes rendered, "border-2"
    assert_includes rendered, "border-secondary"

    component = Decor::Daisy::Avatar.new(initials: "AG", color: :accent, style: :ghost)
    rendered = render_component(component)
    assert_includes rendered, "text-accent"
    assert_includes rendered, "hover:bg-accent"

    component = Decor::Daisy::Avatar.new(initials: "NF", color: :neutral, style: :filled)
    rendered = render_component(component)
    assert_includes rendered, "bg-neutral"
    assert_includes rendered, "text-neutral-content"
  end

  test "ensures no dynamic string building or nil values in output" do
    Decor::Concerns::ColorClasses::SEMANTIC_COLORS.each do |color|
      [:filled, :outlined, :ghost].each do |style|
        component = Decor::Daisy::Avatar.new(initials: "TC", color: color, style: style)
        rendered = render_component(component)

        refute_includes rendered, "nil"
        refute_includes rendered, '#{'
        refute_includes rendered, "}"

        assert_match(/class="[^"]*"/, rendered)
      end
    end
  end

  test "validates default behavior still works" do
    component = Decor::Daisy::Avatar.new(initials: "DB")
    rendered = render_component(component)

    assert_includes rendered, "bg-neutral"
    assert_includes rendered, "text-neutral-content"
    assert_includes rendered, "w-8" # default size
    assert_includes rendered, "rounded-full" # default shape
  end

  test "ring color matches avatar color" do
    Decor::Concerns::ColorClasses::SEMANTIC_COLORS.each do |color|
      component = Decor::Daisy::Avatar.new(initials: "BC", color: color, border: true)
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
    component = Decor::Daisy::Avatar.new(initials: "NB", color: :primary, border: false)
    rendered = render_component(component)

    refute_includes rendered, "ring-primary"
    refute_includes rendered, "ring-offset-base-100"
    refute_includes rendered, "ring-2"
    refute_includes rendered, "ring-offset-2"
  end

  test "avatar component is cacheable" do
    component = Decor::Daisy::Avatar.new(initials: "AB")
    assert component.cacheable?
    assert_respond_to component, :cache_key
  end

  test "cache key includes avatar properties" do
    component1 = Decor::Daisy::Avatar.new(initials: "AB", color: :primary, style: :filled, size: :lg, shape: :circle, border: true)
    component2 = Decor::Daisy::Avatar.new(initials: "AB", color: :primary, style: :filled, size: :lg, shape: :circle, border: true)

    assert_equal component1.cache_key, component2.cache_key
  end

  test "cache key differs for different initials" do
    component1 = Decor::Daisy::Avatar.new(initials: "AB")
    component2 = Decor::Daisy::Avatar.new(initials: "CD")

    refute_equal component1.cache_key, component2.cache_key
  end

  test "cache key differs for different urls" do
    component1 = Decor::Daisy::Avatar.new(url: "https://example.com/avatar1.jpg")
    component2 = Decor::Daisy::Avatar.new(url: "https://example.com/avatar2.jpg")

    refute_equal component1.cache_key, component2.cache_key
  end

  test "cache key differs for different colors" do
    component1 = Decor::Daisy::Avatar.new(initials: "AB", color: :primary)
    component2 = Decor::Daisy::Avatar.new(initials: "AB", color: :secondary)

    refute_equal component1.cache_key, component2.cache_key
  end

  test "cache key differs for different styles" do
    component1 = Decor::Daisy::Avatar.new(initials: "AB", style: :filled)
    component2 = Decor::Daisy::Avatar.new(initials: "AB", style: :outlined)

    refute_equal component1.cache_key, component2.cache_key
  end

  test "cache key differs for different sizes" do
    component1 = Decor::Daisy::Avatar.new(initials: "AB", size: :sm)
    component2 = Decor::Daisy::Avatar.new(initials: "AB", size: :lg)

    refute_equal component1.cache_key, component2.cache_key
  end

  test "cache key differs for different shapes" do
    component1 = Decor::Daisy::Avatar.new(initials: "AB", shape: :circle)
    component2 = Decor::Daisy::Avatar.new(initials: "AB", shape: :square)

    refute_equal component1.cache_key, component2.cache_key
  end

  test "cache key differs for different ring values" do
    component1 = Decor::Daisy::Avatar.new(initials: "AB", border: true)
    component2 = Decor::Daisy::Avatar.new(initials: "AB", border: false)

    refute_equal component1.cache_key, component2.cache_key
  end

  test "cache key includes component modified time" do
    component = Decor::Daisy::Avatar.new(initials: "AB")
    cache_key = component.cache_key

    assert_includes cache_key, "Decor::Daisy::Avatar"

    assert_respond_to component, :component_modified_time
  end

  test "cache key respects cache key modifier from environment" do
    original_modifier = ENV["RAILS_CACHE_ID"]

    ENV["RAILS_CACHE_ID"] = nil
    component1 = Decor::Daisy::Avatar.new(initials: "AB")
    key1 = component1.cache_key

    ENV["RAILS_CACHE_ID"] = "v2"
    component2 = Decor::Daisy::Avatar.new(initials: "AB")
    key2 = component2.cache_key

    refute_equal key1, key2
    assert_includes key2, "v2"
  ensure
    ENV["RAILS_CACHE_ID"] = original_modifier
  end

  test "cache key is stable for same properties" do
    component1 = Decor::Daisy::Avatar.new(initials: "AB", color: :primary, style: :filled, size: :lg)
    key1 = component1.cache_key

    component2 = Decor::Daisy::Avatar.new(initials: "AB", color: :primary, style: :filled, size: :lg)
    key2 = component2.cache_key

    assert_equal key1, key2
  end

  test "cache key includes all avatar properties in hash" do
    component = Decor::Daisy::Avatar.new(
      initials: "TK",
      url: "https://example.com/test.jpg",
      color: :primary,
      style: :filled,
      size: :lg,
      shape: :square,
      border: true
    )

    cache_key = component.cache_key

    assert_not_nil cache_key
    assert_kind_of String, cache_key
  end

  test "nil properties are handled correctly in cache key" do
    component1 = Decor::Daisy::Avatar.new(initials: "AB", url: nil)
    component2 = Decor::Daisy::Avatar.new(initials: "AB")

    assert_not_nil component1.cache_key
    assert_not_nil component2.cache_key

    assert_equal component1.cache_key, component2.cache_key
  end

  test "renders status dot when :status is :online" do
    rendered = render_component(Decor::Daisy::Avatar.new(initials: "JG", status: :online))
    assert_includes rendered, 'aria-label="online"'
    assert_includes rendered, "decor:bg-success"
  end

  test "renders status dot when :status is :away" do
    rendered = render_component(Decor::Daisy::Avatar.new(initials: "JG", status: :away))
    assert_includes rendered, "decor:bg-warning"
  end

  test "renders status dot when :status is :offline" do
    rendered = render_component(Decor::Daisy::Avatar.new(initials: "JG", status: :offline))
    assert_includes rendered, "decor:bg-base-300"
  end

  test "omits status dot when :status is nil" do
    rendered = render_component(Decor::Daisy::Avatar.new(initials: "JG"))
    refute_includes rendered, 'aria-label="online"'
  end

  test "uses :alt for image alt text when provided" do
    rendered = render_component(Decor::Daisy::Avatar.new(url: "https://example.com/x.jpg", alt: "Jane Goodall"))
    assert_includes rendered, 'alt="Jane Goodall"'
  end

  test "falls back to :initials when :alt is missing" do
    rendered = render_component(Decor::Daisy::Avatar.new(url: "https://example.com/x.jpg", initials: "JG"))
    assert_includes rendered, 'alt="JG"'
  end
end
