require "test_helper"

class Decor::StatsTest < ActiveSupport::TestCase
  test "renders successfully with default attributes" do
    component = Decor::Stats.new
    rendered = render_component(component)

    assert_includes rendered, "stats"
    assert_includes rendered, "shadow"
    refute_includes rendered, "stats-vertical"
  end

  test "renders with block content" do
    component = Decor::Stats.new

    # Simulate block content
    component.instance_eval do
      def view_template(&block)
        render parent_element do
          div(class: "stat") { "Test Stat Content" }
        end
      end
    end

    rendered = render_component(component)
    assert_includes rendered, "stats"
    assert_includes rendered, "Test Stat Content"
  end

  # Orientation tests
  test "applies horizontal orientation by default" do
    component = Decor::Stats.new
    rendered = render_component(component)

    assert_includes rendered, "stats"
    refute_includes rendered, "stats-vertical"
  end

  test "applies vertical orientation when specified" do
    component = Decor::Stats.new(orientation: :vertical)
    rendered = render_component(component)

    assert_includes rendered, "stats"
    assert_includes rendered, "stats-vertical"
  end

  test "applies horizontal orientation explicitly" do
    component = Decor::Stats.new(orientation: :horizontal)
    rendered = render_component(component)

    assert_includes rendered, "stats"
    refute_includes rendered, "stats-vertical"
  end

  # Shadow tests
  test "applies shadow by default" do
    component = Decor::Stats.new
    rendered = render_component(component)

    assert_includes rendered, "shadow"
  end

  test "does not apply shadow when disabled" do
    component = Decor::Stats.new(shadow: false)
    rendered = render_component(component)

    refute_includes rendered, "shadow"
  end

  test "applies shadow when explicitly enabled" do
    component = Decor::Stats.new(shadow: true)
    rendered = render_component(component)

    assert_includes rendered, "shadow"
  end

  # Background tests
  test "does not apply background by default" do
    component = Decor::Stats.new
    rendered = render_component(component)

    refute_includes rendered, "bg-base-100"
  end

  test "applies background when enabled" do
    component = Decor::Stats.new(background: true)
    rendered = render_component(component)

    assert_includes rendered, "bg-base-100"
  end

  test "does not apply background when disabled" do
    component = Decor::Stats.new(background: false)
    rendered = render_component(component)

    refute_includes rendered, "bg-base-100"
  end

  # Responsive tests
  test "does not apply responsive classes by default" do
    component = Decor::Stats.new
    rendered = render_component(component)

    refute_includes rendered, "stats-vertical lg:stats-horizontal"
  end

  test "applies responsive classes when enabled" do
    component = Decor::Stats.new(responsive: true)
    rendered = render_component(component)

    assert_includes rendered, "stats-vertical lg:stats-horizontal"
  end

  test "responsive overrides explicit orientation" do
    component = Decor::Stats.new(orientation: :horizontal, responsive: true)
    rendered = render_component(component)

    assert_includes rendered, "stats-vertical lg:stats-horizontal"
    refute_includes rendered, "stats-vertical lg:stats-horizontal stats-vertical"
  end

  # Accessibility tests
  test "includes proper ARIA attributes" do
    component = Decor::Stats.new
    fragment = render_fragment(component)

    stats_div = fragment.at_css(".stats")
    assert_not_nil stats_div
    assert_equal "group", stats_div["role"]
    assert_equal "Statistics", stats_div["aria-label"]
  end

  # Combination tests
  test "combines all styling options correctly" do
    component = Decor::Stats.new(
      orientation: :vertical,
      shadow: true,
      background: true,
      responsive: false
    )
    rendered = render_component(component)

    assert_includes rendered, "stats"
    assert_includes rendered, "stats-vertical"
    assert_includes rendered, "shadow"
    assert_includes rendered, "bg-base-100"
    refute_includes rendered, "lg:stats-horizontal"
  end

  test "combines responsive with other options" do
    component = Decor::Stats.new(
      responsive: true,
      shadow: false,
      background: true
    )
    rendered = render_component(component)

    assert_includes rendered, "stats"
    assert_includes rendered, "stats-vertical lg:stats-horizontal"
    assert_includes rendered, "bg-base-100"
    refute_includes rendered, "shadow"
  end

  # Default values tests
  test "has correct default values" do
    component = Decor::Stats.new

    assert_equal :horizontal, component.instance_variable_get(:@orientation)
    assert_equal true, component.instance_variable_get(:@shadow)
    assert_equal false, component.instance_variable_get(:@background)
    assert_equal false, component.instance_variable_get(:@responsive)
  end

  # HTML structure tests
  test "uses div as root element" do
    component = Decor::Stats.new
    fragment = render_fragment(component)

    assert_equal "div", fragment.children.first.name
  end

  test "root element has stats class" do
    component = Decor::Stats.new
    fragment = render_fragment(component)

    stats_div = fragment.at_css("div")
    assert_not_nil stats_div
    assert_includes stats_div["class"], "stats"
  end

  # Nokogiri parsing tests
  test "uses nokogiri for parsing simple case" do
    component = Decor::Stats.new(orientation: :vertical, shadow: false)
    fragment = render_fragment(component)

    stats_div = fragment.at_css(".stats")
    assert_not_nil stats_div
    assert_includes stats_div["class"], "stats"
    assert_includes stats_div["class"], "stats-vertical"
    refute_includes stats_div["class"], "shadow"
  end

  test "uses nokogiri for parsing complex case" do
    component = Decor::Stats.new(
      orientation: :horizontal,
      shadow: true,
      background: true,
      responsive: false
    )
    fragment = render_fragment(component)

    stats_div = fragment.at_css(".stats")
    assert_not_nil stats_div

    classes = stats_div["class"].split(" ")
    assert_includes classes, "stats"
    assert_includes classes, "shadow"
    assert_includes classes, "bg-base-100"
    refute_includes classes, "stats-vertical"
    refute_includes classes, "lg:stats-horizontal"
  end

  # Integration with Stat components
  test "renders with nested Stat components" do
    stats_component = Decor::Stats.new

    # Simulate nested stats
    stats_component.instance_eval do
      def view_template(&block)
        render parent_element do
          div(class: "stat") do
            div(class: "stat-title") { "Test Title" }
            div(class: "stat-value") { "123" }
          end
          div(class: "stat") do
            div(class: "stat-title") { "Another Title" }
            div(class: "stat-value") { "456" }
          end
        end
      end
    end

    rendered = render_component(stats_component)
    assert_includes rendered, "stats"
    assert_includes rendered, "stat-title"
    assert_includes rendered, "Test Title"
    assert_includes rendered, "Another Title"
    assert_includes rendered, "123"
    assert_includes rendered, "456"
  end

  # Edge cases
  test "handles empty block gracefully" do
    component = Decor::Stats.new

    component.instance_eval do
      def view_template(&block)
        render parent_element do
          # Empty block
        end
      end
    end

    rendered = render_component(component)
    assert_includes rendered, "stats"
    assert rendered # Should not raise error
  end

  test "handles nil options gracefully" do
    # This tests that component can handle potential nil values
    component = Decor::Stats.new
    component.instance_variable_set(:@orientation, nil)
    component.instance_variable_set(:@shadow, nil)
    component.instance_variable_set(:@background, nil)
    component.instance_variable_set(:@responsive, nil)

    rendered = render_component(component)
    assert_includes rendered, "stats"
    assert rendered # Should not raise error
  end

  # Class ordering tests
  test "classes are ordered consistently" do
    component = Decor::Stats.new(
      orientation: :vertical,
      shadow: true,
      background: true
    )
    rendered = render_component(component)

    # Basic check that all expected classes are present
    assert_includes rendered, "stats"
    assert_includes rendered, "stats-vertical"
    assert_includes rendered, "shadow"
    assert_includes rendered, "bg-base-100"
  end

  test "responsive classes take precedence over orientation" do
    component = Decor::Stats.new(
      orientation: :vertical,
      responsive: true
    )
    rendered = render_component(component)

    # Should have responsive classes, not just vertical
    assert_includes rendered, "stats-vertical lg:stats-horizontal"

    # Make sure it doesn't duplicate vertical class
    refute_match(/stats-vertical.*stats-vertical/, rendered)
  end

  # Attribute validation would be tested here if we had strict validation
  test "accepts valid orientation values" do
    [:horizontal, :vertical].each do |orientation|
      component = Decor::Stats.new(orientation: orientation)
      rendered = render_component(component)

      assert_includes rendered, "stats"
      if orientation == :vertical
        assert_includes rendered, "stats-vertical"
      else
        refute_includes rendered, "stats-vertical"
      end
    end
  end
end
