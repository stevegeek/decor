require "test_helper"

class Decor::AvatarTest < ActiveSupport::TestCase
  test "renders successfully with initials" do
    component = Decor::Avatar.new(initials: "AB")
    rendered = render_component(component)
    
    assert_includes rendered, "AB"
    assert_includes rendered, "avatar"
    assert_includes rendered, "avatar-placeholder"
    assert_includes rendered, "bg-neutral text-neutral-content"
  end

  test "renders successfully with url" do
    component = Decor::Avatar.new(url: "https://example.com/avatar.jpg", initials: "AB")
    rendered = render_component(component)
    
    assert_includes rendered, '<img'
    assert_includes rendered, 'src="https://example.com/avatar.jpg"'
    assert_includes rendered, 'alt="Avatar image"'
  end

  test "applies correct size classes" do
    component = Decor::Avatar.new(initials: "AB", size: :large)
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
    
    assert_includes rendered, '<img'
    assert_includes rendered, 'src="https://example.com/avatar.jpg"'
    assert_includes rendered, 'alt="Avatar image"'
    # Should not render avatar-placeholder when using image
    refute_includes rendered, "avatar-placeholder"
  end

  test "uses nokogiri for parsing" do
    component = Decor::Avatar.new(initials: "AB")
    fragment = render_fragment(component)
    
    avatar_div = fragment.at_css('.avatar')
    assert_not_nil avatar_div
    
    span = fragment.at_css('span')
    assert_not_nil span
    assert_includes span.text, "AB"
    assert_includes span['class'], "text-base"
  end
end