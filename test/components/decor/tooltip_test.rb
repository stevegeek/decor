# frozen_string_literal: true

require "test_helper"

class Decor::TooltipTest < ActiveSupport::TestCase
  def test_renders_simple_tooltip_with_text
    component = Decor::Tooltip.new(tip_text: "Help text", position: :top)
    rendered = render_fragment(component) { "Hover me" }

    assert rendered.css(".tooltip.tooltip-top").any?
    assert_equal "Help text", rendered.at_css(".tooltip")["data-tip"]
    assert_includes rendered.text, "Hover me"
  end

  def test_renders_tooltip_with_different_positions
    positions = [:top, :bottom, :left, :right]

    positions.each do |position|
      component = Decor::Tooltip.new(tip_text: "Help text", position: position)
      rendered = render_fragment(component) { "Content" }
      assert rendered.css(".tooltip.tooltip-#{position}").any?
    end
  end

  def test_renders_custom_tooltip_content_with_slot
    component = Decor::Tooltip.new(position: :top)
    component.with_tip_content { "Custom tip content" }

    rendered = render_fragment(component) { "Main content" }

    assert_includes rendered.text, "Main content"
    # For backward compatibility, it should still work but use fallback data-tip
    assert_equal "Custom content", rendered.at_css(".tooltip")["data-tip"]
  end

  def test_default_position_is_top
    component = Decor::Tooltip.new(tip_text: "Help text")
    rendered = render_fragment(component) { "Content" }

    assert rendered.css(".tooltip.tooltip-top").any?
  end

  def test_custom_offset_calculations
    component = Decor::Tooltip.new(position: :right, offset_percent_x: 200, offset_percent_y: 100)

    assert_equal "200%", component.translate_x
    assert_equal "-90%", component.translate_y
  end

  def test_renders_with_base_component_classes
    component = Decor::Tooltip.new(tip_text: "Help", html_options: {class: "custom-class"})
    rendered = render_fragment(component) { "Content" }

    assert rendered.css(".tooltip.custom-class").any?
  end

  def test_size_attribute
    component = Decor::Tooltip.new(tip_text: "Large tooltip", size: :lg)
    rendered = render_fragment(component) { "Content" }

    assert rendered.css(".tooltip-lg").any?
  end

  def test_color_attribute
    component = Decor::Tooltip.new(tip_text: "Primary tooltip", color: :primary)
    rendered = render_fragment(component) { "Content" }

    assert rendered.css(".tooltip-primary").any?
  end

  def test_variant_attribute
    component = Decor::Tooltip.new(tip_text: "Outlined tooltip", variant: :outlined)
    rendered = render_fragment(component) { "Content" }

    assert rendered.css(".tooltip-outline").any?
  end

  def test_default_attributes
    component = Decor::Tooltip.new(tip_text: "Default tooltip")
    rendered = render_fragment(component) { "Content" }

    # Should use default values: size: :md, color: :base, variant: :filled
    assert rendered.css(".tooltip").any?
    refute rendered.css(".tooltip-md").any? # md is default, no class needed
    refute rendered.css(".tooltip-base").any? # base is default, no class needed
    refute rendered.css(".tooltip-filled").any? # filled is default, no class needed
  end

  def test_attribute_validation
    # Valid sizes
    assert_nothing_raised { Decor::Tooltip.new(tip_text: "Test", size: :xs) }
    assert_nothing_raised { Decor::Tooltip.new(tip_text: "Test", size: :xl) }

    # Valid colors
    assert_nothing_raised { Decor::Tooltip.new(tip_text: "Test", color: :primary) }
    assert_nothing_raised { Decor::Tooltip.new(tip_text: "Test", color: :success) }

    # Valid variants
    assert_nothing_raised { Decor::Tooltip.new(tip_text: "Test", variant: :outlined) }
    assert_nothing_raised { Decor::Tooltip.new(tip_text: "Test", variant: :ghost) }

    # Should raise for invalid values - using Dry::Struct::Error which is what the attribute system raises
    assert_raises(Dry::Struct::Error) { Decor::Tooltip.new(tip_text: "Test", size: :invalid) }
    assert_raises(Dry::Struct::Error) { Decor::Tooltip.new(tip_text: "Test", color: :invalid) }
    assert_raises(Dry::Struct::Error) { Decor::Tooltip.new(tip_text: "Test", variant: :invalid) }
  end

  def test_inherits_from_phlex_component
    component = Decor::Tooltip.new(tip_text: "Test")
    assert_kind_of Decor::PhlexComponent, component
  end
end
