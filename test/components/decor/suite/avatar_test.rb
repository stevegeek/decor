# frozen_string_literal: true

require "test_helper"

class Decor::Suite::AvatarTest < ActiveSupport::TestCase
  test "renders <span> root with decor--suite placeholder structure for initials" do
    rendered = render_component(Decor::Suite::Avatar.new(initials: "JG"))
    assert_match(/<span[^>]*decor--suite--avatar/, rendered)
    assert_includes rendered, "JG"
  end

  test "renders <img> child when :url provided" do
    rendered = render_component(Decor::Suite::Avatar.new(url: "https://example.com/x.jpg", alt: "Jane"))
    assert_match(/<img[^>]*src="https:\/\/example\.com\/x\.jpg"[^>]*alt="Jane"/, rendered)
  end

  test "alt falls back to :initials when missing" do
    rendered = render_component(Decor::Suite::Avatar.new(url: "https://x/x.jpg", initials: "JG"))
    assert_match(/alt="JG"/, rendered)
  end

  test "border defaults to true (hairline) — matches historical Confinus look" do
    rendered = render_component(Decor::Suite::Avatar.new(initials: "JG"))
    assert_includes rendered, "decor:border decor:border-suite-hairline"
  end

  test ":border false omits border classes" do
    rendered = render_component(Decor::Suite::Avatar.new(initials: "JG", border: false))
    refute_includes rendered, "decor:border-suite-hairline"
  end

  test "default color :primary falls back to alt5 blue gradient" do
    rendered = render_component(Decor::Suite::Avatar.new(initials: "JG"))
    assert_includes rendered, "decor:from-[#2e74bd] decor:to-[#143f6f]"
  end

  test "initials use subtle tracking, not tracking-tight" do
    rendered = render_component(Decor::Suite::Avatar.new(initials: "JG"))
    assert_includes rendered, "decor:tracking-[-0.01em]"
    refute_includes rendered, "decor:tracking-tight"
  end

  test "size :lg is 48px (w-12 h-12, matches ConfinusUI :medium)" do
    rendered = render_component(Decor::Suite::Avatar.new(initials: "JG", size: :lg))
    assert_includes rendered, "decor:w-12 decor:h-12"
  end

  test "size :xl is 56px (w-14 h-14, matches ConfinusUI :large/:x_large/:xx_large)" do
    rendered = render_component(Decor::Suite::Avatar.new(initials: "JG", size: :xl))
    assert_includes rendered, "decor:w-14 decor:h-14"
  end

  %i[alt1 alt2 alt3 alt4 alt5].each do |color|
    test "renders bespoke gradient for color :#{color}" do
      rendered = render_component(Decor::Suite::Avatar.new(initials: "JG", color: color))
      assert_match(/decor:bg-linear-to-br decor:from-\[#/, rendered)
    end
  end

  test "square shape uses rounded-card" do
    rendered = render_component(Decor::Suite::Avatar.new(initials: "JG", shape: :square))
    assert_includes rendered, "decor:rounded-card"
  end

  test "circle shape uses rounded-full" do
    rendered = render_component(Decor::Suite::Avatar.new(initials: "JG", shape: :circle))
    assert_includes rendered, "decor:rounded-full"
  end

  %i[xs sm md lg xl].each do |size|
    test "size :#{size} renders width class" do
      rendered = render_component(Decor::Suite::Avatar.new(initials: "JG", size: size))
      assert_match(/decor:w-\d+/, rendered)
    end
  end

  test "status dot renders when :status is :online" do
    rendered = render_component(Decor::Suite::Avatar.new(initials: "JG", status: :online))
    assert_includes rendered, "aria-label=\"online\""
    assert_includes rendered, "decor:bg-success-500"
  end

  test "status dot omitted when :status nil" do
    rendered = render_component(Decor::Suite::Avatar.new(initials: "JG"))
    refute_includes rendered, "aria-label=\"online\""
  end
end
