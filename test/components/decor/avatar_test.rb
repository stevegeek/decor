require "test_helper"

class Decor::AvatarTest < ActiveSupport::TestCase
  test "renders successfully with initials" do
    component = Decor::Avatar.new(initials: "AB")
    rendered = render_component(component)

    assert_includes rendered, "AB"
    assert_includes rendered, "avatar"
    assert_includes rendered, "avatar-placeholder"
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

  test "applies ring classes when border is specified" do
    component = Decor::Avatar.new(initials: "AB", border: true)
    rendered = render_component(component)

    assert_includes rendered, "ring-primary"
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

    assert_includes rendered, "w-10"
    assert_includes rendered, "text-base"
  end

  test "applies correct modern size classes" do
    # Test xs size
    component = Decor::Avatar.new(initials: "XS", size: :xs)
    rendered = render_component(component)
    assert_includes rendered, "w-6"
    assert_includes rendered, "text-xs"

    # Test sm size
    component = Decor::Avatar.new(initials: "SM", size: :sm)
    rendered = render_component(component)
    assert_includes rendered, "w-8"
    assert_includes rendered, "text-sm"

    # Test md size (default)
    component = Decor::Avatar.new(initials: "MD", size: :md)
    rendered = render_component(component)
    assert_includes rendered, "w-10"
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
    component = Decor::Avatar.new(initials: "PC", color: :primary)
    rendered = render_component(component)
    assert_includes rendered, "bg-primary"
    assert_includes rendered, "text-primary-content"

    component = Decor::Avatar.new(initials: "SC", color: :secondary)
    rendered = render_component(component)
    assert_includes rendered, "bg-secondary"
    assert_includes rendered, "text-secondary-content"
  end

  test "applies variant styles" do
    # Outlined variant
    component = Decor::Avatar.new(initials: "OV", color: :primary, variant: :outlined)
    rendered = render_component(component)
    assert_includes rendered, "border-2"
    assert_includes rendered, "border-primary"
    assert_includes rendered, "text-primary"
    refute_includes rendered, "bg-primary"

    # Ghost variant
    component = Decor::Avatar.new(initials: "GV", color: :primary, variant: :ghost)
    rendered = render_component(component)
    assert_includes rendered, "hover:bg-primary"
    assert_includes rendered, "text-primary"
  end

  test "color does not affect image avatars" do
    component = Decor::Avatar.new(url: "https://example.com/avatar.jpg", color: :primary)
    rendered = render_component(component)

    # Should not include color classes for image avatars
    refute_includes rendered, "bg-primary"
    refute_includes rendered, "text-primary"
    refute_includes rendered, "bg-neutral"
    refute_includes rendered, "text-neutral-content"
  end

  test "maintains default behavior" do
    # Default color and variant
    component = Decor::Avatar.new(initials: "DB")
    rendered = render_component(component)
    assert_includes rendered, "bg-neutral"
    assert_includes rendered, "text-neutral-content"

    # No unexpected classes from new features
    refute_includes rendered, "border-2"
    refute_includes rendered, "hover:"
  end

  # COMPREHENSIVE COLOR_CLASSES VALIDATION TESTS

  test "validates all color options with filled variant" do
    Decor::Avatar::COLOR_OPTIONS.each do |color|
      component = Decor::Avatar.new(initials: "TC", color: color, variant: :filled)
      rendered = render_component(component)

      case color
      when :base
        assert_includes rendered, "bg-base"
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

  test "validates all color options with outlined variant" do
    Decor::Avatar::COLOR_OPTIONS.each do |color|
      component = Decor::Avatar.new(initials: "TC", color: color, variant: :outlined)
      rendered = render_component(component)

      assert_includes rendered, "border-2"

      case color
      when :base
        assert_includes rendered, "text-base"
        assert_includes rendered, "border-base"
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

  test "validates all color options with ghost variant" do
    Decor::Avatar::COLOR_OPTIONS.each do |color|
      component = Decor::Avatar.new(initials: "TC", color: color, variant: :ghost)
      rendered = render_component(component)

      case color
      when :base
        assert_includes rendered, "text-base"
        assert_includes rendered, "hover:bg-base"
      when :primary
        assert_includes rendered, "text-primary"
        assert_includes rendered, "hover:bg-primary"
      when :secondary
        assert_includes rendered, "text-secondary"
        assert_includes rendered, "hover:bg-secondary"
      when :accent
        assert_includes rendered, "text-accent"
        assert_includes rendered, "hover:bg-accent"
      when :success
        assert_includes rendered, "text-success"
        assert_includes rendered, "hover:bg-success"
      when :error
        assert_includes rendered, "text-error"
        assert_includes rendered, "hover:bg-error"
      when :warning
        assert_includes rendered, "text-warning"
        assert_includes rendered, "hover:bg-warning"
      when :info
        assert_includes rendered, "text-info"
        assert_includes rendered, "hover:bg-info"
      when :neutral
        assert_includes rendered, "text-neutral"
        assert_includes rendered, "hover:bg-neutral"
      end
    end
  end

  test "validates specific key combinations from requirements" do
    # Primary + filled: should output "bg-primary text-primary-content"
    component = Decor::Avatar.new(initials: "PF", color: :primary, variant: :filled)
    rendered = render_component(component)
    assert_includes rendered, "bg-primary"
    assert_includes rendered, "text-primary-content"

    # Secondary + outlined: should output "text-secondary border-2 border-secondary"
    component = Decor::Avatar.new(initials: "SO", color: :secondary, variant: :outlined)
    rendered = render_component(component)
    assert_includes rendered, "text-secondary"
    assert_includes rendered, "border-2"
    assert_includes rendered, "border-secondary"

    # Accent + ghost: should output "text-accent hover:bg-accent"
    component = Decor::Avatar.new(initials: "AG", color: :accent, variant: :ghost)
    rendered = render_component(component)
    assert_includes rendered, "text-accent"
    assert_includes rendered, "hover:bg-accent"

    # Neutral + filled: should output "bg-neutral text-neutral-content" (default behavior)
    component = Decor::Avatar.new(initials: "NF", color: :neutral, variant: :filled)
    rendered = render_component(component)
    assert_includes rendered, "bg-neutral"
    assert_includes rendered, "text-neutral-content"
  end

  test "ensures no dynamic string building or nil values in output" do
    # Test that all combinations produce valid class strings with no interpolation artifacts
    Decor::Avatar::COLOR_OPTIONS.each do |color|
      Decor::Avatar::VARIANT_OPTIONS.each do |variant|
        component = Decor::Avatar.new(initials: "TC", color: color, variant: variant)
        rendered = render_component(component)

        # Should not contain dynamic interpolation artifacts
        refute_includes rendered, "nil"
        refute_includes rendered, "#{"
        refute_includes rendered, "}"

        # Should contain valid HTML classes
        assert_match(/class="[^"]*"/, rendered)
      end
    end
  end

  test "validates default behavior still works" do
    # Default color :neutral + default variant :filled
    component = Decor::Avatar.new(initials: "DB")
    rendered = render_component(component)

    assert_includes rendered, "bg-neutral"
    assert_includes rendered, "text-neutral-content"
    assert_includes rendered, "w-10" # default size
    assert_includes rendered, "rounded-full" # default shape
  end
end
