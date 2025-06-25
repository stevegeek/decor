require "test_helper"

class Decor::StatTest < ActiveSupport::TestCase
  test "renders successfully with basic attributes" do
    component = Decor::Stat.new(
      title: "Test Title",
      value: "123",
      description: "Test description"
    )
    rendered = render_component(component)

    assert_includes rendered, "stat"
    assert_includes rendered, "Test Title"
    assert_includes rendered, "123"
    assert_includes rendered, "Test description"
  end

  test "renders with minimal attributes" do
    component = Decor::Stat.new(value: "42")
    rendered = render_component(component)

    assert_includes rendered, "stat"
    assert_includes rendered, "42"
  end

  test "renders without any attributes" do
    component = Decor::Stat.new
    rendered = render_component(component)

    assert_includes rendered, "stat"
    assert rendered # Should not raise error
  end

  # Color tests
  test "applies correct color classes" do
    [:primary, :secondary, :accent, :success, :error, :warning, :info, :neutral].each do |color|
      component = Decor::Stat.new(value: "Test", color: color)
      rendered = render_component(component)

      if color == :neutral
        refute_includes rendered, "text-neutral"
      else
        assert_includes rendered, "text-#{color}"
      end
    end
  end

  test "defaults to neutral color" do
    component = Decor::Stat.new(value: "Test")
    rendered = render_component(component)

    refute_includes rendered, "text-neutral"
    assert_includes rendered, "stat-value"
  end

  # Centered layout tests
  test "applies centered class when centered is true" do
    component = Decor::Stat.new(value: "Test", centered: true)
    rendered = render_component(component)

    assert_includes rendered, "place-items-center"
  end

  test "does not apply centered class by default" do
    component = Decor::Stat.new(value: "Test")
    rendered = render_component(component)

    refute_includes rendered, "place-items-center"
  end

  # Title tests
  test "renders title in stat-title div" do
    component = Decor::Stat.new(title: "My Stat Title")
    rendered = render_component(component)

    assert_includes rendered, "stat-title"
    assert_includes rendered, "My Stat Title"
  end

  test "does not render title div when no title provided" do
    component = Decor::Stat.new(value: "123")
    rendered = render_component(component)

    refute_includes rendered, "stat-title"
  end

  # Value tests
  test "renders value in stat-value div" do
    component = Decor::Stat.new(value: "42,000")
    rendered = render_component(component)

    assert_includes rendered, "stat-value"
    assert_includes rendered, "42,000"
  end

  test "applies color class to value" do
    component = Decor::Stat.new(value: "123", color: :primary)
    rendered = render_component(component)

    assert_includes rendered, "stat-value"
    assert_includes rendered, "text-primary"
  end

  # Description tests
  test "renders description in stat-desc div" do
    component = Decor::Stat.new(description: "Up 20% from last month")
    rendered = render_component(component)

    assert_includes rendered, "stat-desc"
    assert_includes rendered, "Up 20% from last month"
  end

  test "does not render description div when no description provided" do
    component = Decor::Stat.new(value: "123")
    rendered = render_component(component)

    refute_includes rendered, "stat-desc"
  end

  # Icon tests
  test "renders icon in figure when icon provided" do
    component = Decor::Stat.new(icon: "star", value: "123")
    rendered = render_component(component)

    assert_includes rendered, "stat-figure"
    assert_includes rendered, "star"
    assert_includes rendered, "h-8 w-8"
  end

  test "does not render figure when no icon provided" do
    component = Decor::Stat.new(value: "123")
    rendered = render_component(component)

    refute_includes rendered, "stat-figure"
  end

  test "applies icon color class to figure" do
    component = Decor::Stat.new(icon: "star", icon_color: :primary, value: "123")
    rendered = render_component(component)

    assert_includes rendered, "stat-figure"
    assert_includes rendered, "text-primary"
  end

  test "applies stat color to figure when no icon_color specified" do
    component = Decor::Stat.new(icon: "star", color: :success, value: "123")
    rendered = render_component(component)

    assert_includes rendered, "stat-figure"
    assert_includes rendered, "text-success"
  end

  test "does not apply color class to figure when stat color is neutral" do
    component = Decor::Stat.new(icon: "star", color: :neutral, value: "123")
    rendered = render_component(component)

    assert_includes rendered, "stat-figure"
    refute_includes rendered, "text-neutral"
  end

  # Block content tests
  test "renders block content in value area" do
    component = Decor::Stat.new(title: "Custom")

    # Simulate block content
    component.instance_eval do
      def view_template(&block)
        render parent_element do
          render_title if @title
          div(class: "stat-value") { "Custom Block Content" }
        end
      end
    end

    rendered = render_component(component)
    assert_includes rendered, "Custom Block Content"
    assert_includes rendered, "stat-value"
  end

  # Figure block tests
  test "renders figure block content" do
    component = Decor::Stat.new(value: "123")
    component.figure do
      div(class: "custom-figure") { "Figure Content" }
    end

    rendered = render_component(component)
    assert_includes rendered, "stat-figure"
    assert_includes rendered, "custom-figure"
    assert_includes rendered, "Figure Content"
  end

  test "sets with_figure to true when figure block provided" do
    component = Decor::Stat.new(value: "123")
    component.figure do
      span { "test" }
    end

    assert component.instance_variable_get(:@with_figure)
  end

  # Actions block tests
  test "renders actions block content" do
    component = Decor::Stat.new(value: "123")
    component.actions do
      button(class: "btn") { "Action Button" }
    end

    rendered = render_component(component)
    assert_includes rendered, "stat-actions"
    assert_includes rendered, "btn"
    assert_includes rendered, "Action Button"
  end

  test "sets with_actions to true when actions block provided" do
    component = Decor::Stat.new(value: "123")
    component.actions do
      button { "test" }
    end

    assert component.instance_variable_get(:@with_actions)
  end

  # Complete stat tests
  test "renders complete stat with all elements" do
    component = Decor::Stat.new(
      title: "Total Sales",
      value: "$45,231",
      description: "+20% from last month",
      color: :success,
      icon: "currency-dollar",
      icon_color: :primary,
      centered: true
    )

    rendered = render_component(component)

    assert_includes rendered, "stat"
    assert_includes rendered, "place-items-center"
    assert_includes rendered, "stat-title"
    assert_includes rendered, "Total Sales"
    assert_includes rendered, "stat-value"
    assert_includes rendered, "text-success"
    assert_includes rendered, "$45,231"
    assert_includes rendered, "stat-desc"
    assert_includes rendered, "+20% from last month"
    assert_includes rendered, "stat-figure"
    assert_includes rendered, "text-primary"
    assert_includes rendered, "currency-dollar"
  end

  # Nokogiri parsing tests
  test "uses nokogiri for parsing" do
    component = Decor::Stat.new(value: "Test", color: :primary)
    fragment = render_fragment(component)

    stat_div = fragment.at_css(".stat")
    assert_not_nil stat_div
    assert_includes stat_div["class"], "stat"

    value_div = fragment.at_css(".stat-value")
    assert_not_nil value_div
    assert_includes value_div.text, "Test"
    assert_includes value_div["class"], "text-primary"
  end

  test "handles complex nested structure with nokogiri" do
    component = Decor::Stat.new(
      title: "Complex Stat",
      value: "123",
      description: "Test desc",
      icon: "star"
    )
    fragment = render_fragment(component)

    # Check main stat container
    stat_div = fragment.at_css(".stat")
    assert_not_nil stat_div

    # Check figure
    figure_div = fragment.at_css(".stat-figure")
    assert_not_nil figure_div

    # Check title
    title_div = fragment.at_css(".stat-title")
    assert_not_nil title_div
    assert_includes title_div.text, "Complex Stat"

    # Check value
    value_div = fragment.at_css(".stat-value")
    assert_not_nil value_div
    assert_includes value_div.text, "123"

    # Check description
    desc_div = fragment.at_css(".stat-desc")
    assert_not_nil desc_div
    assert_includes desc_div.text, "Test desc"
  end

  # Edge cases
  test "handles nil values gracefully" do
    component = Decor::Stat.new(
      title: nil,
      value: nil,
      description: nil
    )
    rendered = render_component(component)

    assert_includes rendered, "stat"
    assert rendered # Should not raise error
  end

  test "handles empty strings gracefully" do
    component = Decor::Stat.new(
      title: "",
      value: "",
      description: ""
    )
    rendered = render_component(component)

    assert_includes rendered, "stat"
    assert rendered # Should not raise error
  end

  # Default values tests
  test "has correct default values" do
    component = Decor::Stat.new

    assert_equal :neutral, component.instance_variable_get(:@color)
    assert_equal false, component.instance_variable_get(:@centered)
    assert_equal false, component.instance_variable_get(:@with_figure)
    assert_equal false, component.instance_variable_get(:@with_actions)
  end

  # HTML structure tests
  test "uses div as root element" do
    component = Decor::Stat.new(value: "Test")
    fragment = render_fragment(component)

    assert_equal "div", fragment.children.first.name
  end

  test "renders elements in correct order" do
    component = Decor::Stat.new(
      title: "Title",
      value: "Value",
      description: "Description",
      icon: "star"
    )
    rendered = render_component(component)

    # Check that elements appear in expected order
    title_pos = rendered.index("stat-title")
    value_pos = rendered.index("stat-value")
    desc_pos = rendered.index("stat-desc")
    figure_pos = rendered.index("stat-figure")

    assert figure_pos < title_pos
    assert title_pos < value_pos
    assert value_pos < desc_pos
  end
end
