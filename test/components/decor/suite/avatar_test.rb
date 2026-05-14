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

  test ":border true renders hairline border classes" do
    rendered = render_component(Decor::Suite::Avatar.new(initials: "JG", border: true))
    assert_includes rendered, "decor:border decor:border-black/10"
  end

  test ":border false omits border classes" do
    rendered = render_component(Decor::Suite::Avatar.new(initials: "JG", border: false))
    refute_includes rendered, "decor:border-black/10"
  end

  test "default color is :primary (gradient from primary-300 to primary-700)" do
    rendered = render_component(Decor::Suite::Avatar.new(initials: "JG"))
    assert_includes rendered, "decor:from-primary-300 decor:to-primary-700"
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
