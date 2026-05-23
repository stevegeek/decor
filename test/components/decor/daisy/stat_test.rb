require "test_helper"

class Decor::Daisy::StatTest < ActiveSupport::TestCase
  test "renders successfully with basic attributes" do
    component = Decor::Daisy::Stat.new(
      title: "Test Title",
      value: "123",
      description: "Test description"
    )
    rendered = render_component(component)

    assert_includes rendered, "decor:d-stat"
    assert_includes rendered, "Test Title"
    assert_includes rendered, "123"
    assert_includes rendered, "Test description"
  end

  test "renders with minimal attributes" do
    component = Decor::Daisy::Stat.new(value: "42")
    rendered = render_component(component)

    assert_includes rendered, "decor:d-stat"
    assert_includes rendered, "42"
  end

  test "renders without any attributes" do
    component = Decor::Daisy::Stat.new
    rendered = render_component(component)

    assert_includes rendered, "decor:d-stat"
    assert rendered # Should not raise error
  end

  test "applies correct color classes" do
    [:primary, :secondary, :accent, :success, :error, :warning, :info, :neutral].each do |color|
      component = Decor::Daisy::Stat.new(value: "Test", color: color)
      rendered = render_component(component)

      if color == :neutral
        refute_includes rendered, "decor:text-neutral"
      else
        assert_includes rendered, "decor:text-#{color}"
      end
    end
  end

  test "defaults to neutral color" do
    component = Decor::Daisy::Stat.new(value: "Test")
    rendered = render_component(component)

    refute_includes rendered, "decor:text-neutral"
    assert_includes rendered, "decor:d-stat-value"
  end

  test "applies centered class when centered is true" do
    component = Decor::Daisy::Stat.new(value: "Test", centered: true)
    rendered = render_component(component)

    assert_includes rendered, "decor:place-items-center"
  end

  test "does not apply centered class by default" do
    component = Decor::Daisy::Stat.new(value: "Test")
    rendered = render_component(component)

    refute_includes rendered, "decor:place-items-center"
  end

  test "renders title in stat-title div" do
    component = Decor::Daisy::Stat.new(title: "My Stat Title")
    rendered = render_component(component)

    assert_includes rendered, "decor:d-stat-title"
    assert_includes rendered, "My Stat Title"
  end

  test "does not render title div when no title provided" do
    component = Decor::Daisy::Stat.new(value: "123")
    rendered = render_component(component)

    refute_includes rendered, "decor:d-stat-title"
  end

  test "renders value in stat-value div" do
    component = Decor::Daisy::Stat.new(value: "42,000")
    rendered = render_component(component)

    assert_includes rendered, "decor:d-stat-value"
    assert_includes rendered, "42,000"
  end

  test "applies color class to value" do
    component = Decor::Daisy::Stat.new(value: "123", color: :primary)
    rendered = render_component(component)

    assert_includes rendered, "decor:d-stat-value"
    assert_includes rendered, "decor:text-primary"
  end

  test "renders description in stat-desc div" do
    component = Decor::Daisy::Stat.new(description: "Up 20% from last month")
    rendered = render_component(component)

    assert_includes rendered, "decor:d-stat-desc"
    assert_includes rendered, "Up 20% from last month"
  end

  test "does not render description div when no description provided" do
    component = Decor::Daisy::Stat.new(value: "123")
    rendered = render_component(component)

    refute_includes rendered, "decor:d-stat-desc"
  end

  test "renders icon in figure when icon provided" do
    component = Decor::Daisy::Stat.new(icon: "star", value: "123")
    rendered = render_component(component)

    assert_includes rendered, "decor:d-stat-figure"
    assert_includes rendered, "star"
    assert_includes rendered, "decor:h-8 decor:w-8"
  end

  test "does not render figure when no icon provided" do
    component = Decor::Daisy::Stat.new(value: "123")
    rendered = render_component(component)

    refute_includes rendered, "decor:d-stat-figure"
  end

  test "applies icon color class to figure" do
    component = Decor::Daisy::Stat.new(icon: "star", icon_color: :primary, value: "123")
    rendered = render_component(component)

    assert_includes rendered, "decor:d-stat-figure"
    assert_includes rendered, "decor:text-primary"
  end

  test "applies stat color to figure when no icon_color specified" do
    component = Decor::Daisy::Stat.new(icon: "star", color: :success, value: "123")
    rendered = render_component(component)

    assert_includes rendered, "decor:d-stat-figure"
    assert_includes rendered, "decor:text-success"
  end

  test "does not apply color class to figure when stat color is neutral" do
    component = Decor::Daisy::Stat.new(icon: "star", color: :neutral, value: "123")
    rendered = render_component(component)

    assert_includes rendered, "decor:d-stat-figure"
    refute_includes rendered, "decor:text-neutral"
  end

  test "renders block content in value area" do
    component = Decor::Daisy::Stat.new(title: "Custom")

    component.instance_eval do
      def view_template(&block)
        root_element do
          render_title if @title
          div(class: "stat-value") { "Custom Block Content" }
        end
      end
    end

    rendered = render_component(component)
    assert_includes rendered, "Custom Block Content"
    assert_includes rendered, "stat-value"
  end

  test "renders figure block content" do
    component = Decor::Daisy::Stat.new(value: "123")
    component.figure do
      div(class: "custom-figure") { "Figure Content" }
    end

    rendered = render_component(component)
    assert_includes rendered, "decor:d-stat-figure"
    assert_includes rendered, "custom-figure"
    assert_includes rendered, "Figure Content"
  end

  test "sets with_figure to true when figure block provided" do
    component = Decor::Daisy::Stat.new(value: "123")
    component.figure do
      span { "test" }
    end

    assert component.instance_variable_get(:@with_figure)
  end

  test "renders actions block content" do
    component = Decor::Daisy::Stat.new(value: "123")
    component.actions do
      button(class: "btn") { "Action Button" }
    end

    rendered = render_component(component)
    assert_includes rendered, "decor:d-stat-actions"
    assert_includes rendered, "btn"
    assert_includes rendered, "Action Button"
  end

  test "sets with_actions to true when actions block provided" do
    component = Decor::Daisy::Stat.new(value: "123")
    component.actions do
      button { "test" }
    end

    assert component.instance_variable_get(:@with_actions)
  end

  test "renders complete stat with all elements" do
    component = Decor::Daisy::Stat.new(
      title: "Total Sales",
      value: "$45,231",
      description: "+20% from last month",
      color: :success,
      icon: "currency-dollar",
      icon_color: :primary,
      centered: true
    )

    rendered = render_component(component)

    assert_includes rendered, "decor:d-stat"
    assert_includes rendered, "decor:place-items-center"
    assert_includes rendered, "decor:d-stat-title"
    assert_includes rendered, "Total Sales"
    assert_includes rendered, "decor:d-stat-value"
    assert_includes rendered, "decor:text-success"
    assert_includes rendered, "$45,231"
    assert_includes rendered, "decor:d-stat-desc"
    assert_includes rendered, "+20% from last month"
    assert_includes rendered, "decor:d-stat-figure"
    assert_includes rendered, "decor:text-primary"
    assert_includes rendered, "currency-dollar"
  end

  test "uses nokogiri for parsing" do
    component = Decor::Daisy::Stat.new(value: "Test", color: :primary)
    fragment = render_fragment(component)

    stat_div = fragment.at_css('[class~="decor:d-stat"]')
    assert_not_nil stat_div
    assert_includes stat_div["class"], "decor:d-stat"

    value_div = fragment.at_css('[class~="decor:d-stat-value"]')
    assert_not_nil value_div
    assert_includes value_div.text, "Test"
    assert_includes value_div["class"], "decor:text-primary"
  end

  test "handles complex nested structure with nokogiri" do
    component = Decor::Daisy::Stat.new(
      title: "Complex Stat",
      value: "123",
      description: "Test desc",
      icon: "star"
    )
    fragment = render_fragment(component)

    stat_div = fragment.at_css('[class~="decor:d-stat"]')
    assert_not_nil stat_div

    figure_div = fragment.at_css('[class~="decor:d-stat-figure"]')
    assert_not_nil figure_div

    title_div = fragment.at_css('[class~="decor:d-stat-title"]')
    assert_not_nil title_div
    assert_includes title_div.text, "Complex Stat"

    value_div = fragment.at_css('[class~="decor:d-stat-value"]')
    assert_not_nil value_div
    assert_includes value_div.text, "123"

    desc_div = fragment.at_css('[class~="decor:d-stat-desc"]')
    assert_not_nil desc_div
    assert_includes desc_div.text, "Test desc"
  end

  test "handles nil values gracefully" do
    component = Decor::Daisy::Stat.new(
      title: nil,
      value: nil,
      description: nil
    )
    rendered = render_component(component)

    assert_includes rendered, "decor:d-stat"
    assert rendered # Should not raise error
  end

  test "handles empty strings gracefully" do
    component = Decor::Daisy::Stat.new(
      title: "",
      value: "",
      description: ""
    )
    rendered = render_component(component)

    assert_includes rendered, "decor:d-stat"
    assert rendered # Should not raise error
  end

  test "has correct default values" do
    component = Decor::Daisy::Stat.new

    assert_equal :neutral, component.instance_variable_get(:@color)
    assert_equal false, component.instance_variable_get(:@centered)
    assert_equal false, component.instance_variable_get(:@with_figure)
    assert_equal false, component.instance_variable_get(:@with_actions)
  end

  test "uses div as root element" do
    component = Decor::Daisy::Stat.new(value: "Test")
    fragment = render_fragment(component)

    assert_equal "div", fragment.children.first.name
  end

  test "renders elements in correct order" do
    component = Decor::Daisy::Stat.new(
      title: "Title",
      value: "Value",
      description: "Description",
      icon: "star"
    )
    rendered = render_component(component)

    title_pos = rendered.index("decor:d-stat-title")
    value_pos = rendered.index("decor:d-stat-value")
    desc_pos = rendered.index("decor:d-stat-desc")
    figure_pos = rendered.index("decor:d-stat-figure")

    assert figure_pos < title_pos
    assert title_pos < value_pos
    assert value_pos < desc_pos
  end
end
