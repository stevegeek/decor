# frozen_string_literal: true

require "test_helper"

class Decor::Daisy::TooltipTest < ActiveSupport::TestCase
  def test_renders_simple_tooltip_with_text
    component = Decor::Daisy::Tooltip.new(tip_text: "Help text", position: :top)
    rendered = render_fragment(component) { "Hover me" }

    assert rendered.css('[class~="decor:d-tooltip"][class~="decor:d-tooltip-top"]').any?
    assert_equal "Help text", rendered.at_css('[class~="decor:d-tooltip"]')["data-tip"]
    assert_includes rendered.text, "Hover me"
  end

  def test_renders_tooltip_with_different_positions
    positions = [:top, :bottom, :left, :right]

    positions.each do |position|
      component = Decor::Daisy::Tooltip.new(tip_text: "Help text", position: position)
      rendered = render_fragment(component) { "Content" }
      assert rendered.css(%([class~="decor:d-tooltip"][class~="decor:d-tooltip-#{position}"])).any?
    end
  end

  def test_renders_custom_tooltip_content_with_slot
    component = Decor::Daisy::Tooltip.new(position: :top)
    rendered = render_fragment(component) do |c|
      c.with_tip_content { "Custom tip content" }
      "Main content"
    end
    assert_includes rendered.text, "Main content"
    assert_equal "Custom tip content", rendered.at_css('[class~="decor:d-tooltip"]')["data-tip"]
  end

  def test_default_position_is_top
    component = Decor::Daisy::Tooltip.new(tip_text: "Help text")
    rendered = render_fragment(component) { "Content" }

    assert rendered.css('[class~="decor:d-tooltip"][class~="decor:d-tooltip-top"]').any?
  end

  def test_custom_offset_calculations
    component = Decor::Daisy::Tooltip.new(position: :right, offset_percent_x: 200, offset_percent_y: 100)

    assert_equal "200%", component.translate_x
    assert_equal "-90%", component.translate_y
  end

  def test_renders_with_base_component_classes
    component = Decor::Daisy::Tooltip.new(tip_text: "Help", classes: "custom-class")
    rendered = render_fragment(component) { "Content" }
    assert rendered.css('[class~="decor:d-tooltip"][class~="custom-class"]').any?
  end

  def test_size_attribute
    component = Decor::Daisy::Tooltip.new(tip_text: "Large tooltip", size: :lg)
    rendered = render_fragment(component) { "Content" }

    assert rendered.css('[class~="decor:d-tooltip-lg"]').any?
  end

  def test_color_attribute
    component = Decor::Daisy::Tooltip.new(tip_text: "Primary tooltip", color: :primary)
    rendered = render_fragment(component) { "Content" }

    assert rendered.css('[class~="decor:d-tooltip-primary"]').any?
  end

  def test_style_attribute
    component = Decor::Daisy::Tooltip.new(tip_text: "Outlined tooltip", style: :outlined)
    rendered = render_fragment(component) { "Content" }

    assert rendered.css('[class~="decor:d-tooltip-outline"]').any?
  end

  def test_default_attributes
    component = Decor::Daisy::Tooltip.new(tip_text: "Default tooltip")
    rendered = render_fragment(component) { "Content" }

    assert rendered.css('[class~="decor:d-tooltip"]').any?
    refute rendered.css('[class~="decor:d-tooltip-md"]').any? # md is default, no class needed
    refute rendered.css('[class~="decor:d-tooltip-base"]').any? # base is default, no class needed
    refute rendered.css('[class~="decor:d-tooltip-filled"]').any? # filled is default, no class needed
  end

  def test_attribute_validation
    assert_nothing_raised { Decor::Daisy::Tooltip.new(tip_text: "Test", size: :xs) }
    assert_nothing_raised { Decor::Daisy::Tooltip.new(tip_text: "Test", size: :xl) }

    assert_nothing_raised { Decor::Daisy::Tooltip.new(tip_text: "Test", color: :primary) }
    assert_nothing_raised { Decor::Daisy::Tooltip.new(tip_text: "Test", color: :success) }

    assert_nothing_raised { Decor::Daisy::Tooltip.new(tip_text: "Test", style: :outlined) }
    assert_nothing_raised { Decor::Daisy::Tooltip.new(tip_text: "Test", style: :ghost) }

    assert_raises(Literal::TypeError) { Decor::Daisy::Tooltip.new(tip_text: "Test", size: :invalid) }
    assert_raises(Literal::TypeError) { Decor::Daisy::Tooltip.new(tip_text: "Test", color: :invalid) }
    assert_raises(Literal::TypeError) { Decor::Daisy::Tooltip.new(tip_text: "Test", style: :invalid) }
  end

  def test_inherits_from_phlex_component
    component = Decor::Daisy::Tooltip.new(tip_text: "Test")
    assert_kind_of Decor::PhlexComponent, component
  end
end
