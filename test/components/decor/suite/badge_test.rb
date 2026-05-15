# frozen_string_literal: true

require "test_helper"

class ::Decor::Suite::BadgeTest < ActiveSupport::TestCase
  test "renders label" do
    html = render_component(::Decor::Suite::Badge.new(label: "Active"))
    assert_includes html, "Active"
    assert_includes html, "decor:rounded-full"
    assert_includes html, "decor:whitespace-nowrap"
  end

  test "default neutral palette uses muted gray-100 / gray-700" do
    html = render_component(::Decor::Suite::Badge.new(label: "x"))
    assert_includes html, "decor:bg-gray-100"
    assert_includes html, "decor:text-gray-700"
  end

  test "color :success switches to suite success-50 / success-700 palette" do
    html = render_component(::Decor::Suite::Badge.new(label: "ok", color: :success))
    assert_includes html, "decor:bg-suite-success-50"
    assert_includes html, "decor:text-suite-success-700"
    refute_includes html, "decor:bg-gray-100"
  end

  test "style :outlined uses white bg + suite-100 border + dark text" do
    html = render_component(::Decor::Suite::Badge.new(label: "ok", color: :success, style: :outlined))
    assert_includes html, "decor:bg-white"
    assert_includes html, "decor:border-suite-success-100"
    assert_includes html, "decor:text-suite-success-700"
    refute_includes html, "decor:bg-suite-success-50"
  end

  test "outlined primary uses suite-primary-200 border" do
    html = render_component(::Decor::Suite::Badge.new(label: "x", color: :primary, style: :outlined))
    assert_includes html, "decor:border-suite-primary-200"
  end

  test "icon: 'star' renders icon and not a dot" do
    html = render_component(::Decor::Suite::Badge.new(label: "Featured", icon: "star", color: :success))
    assert_includes html, "tabler-filled-star"
    refute_includes html, "decor:shadow-suite-success-500/20"
  end

  test "dot: true renders the halo dot span and not an icon" do
    html = render_component(::Decor::Suite::Badge.new(label: "Active", dot: true, color: :primary, icon: "star"))
    assert_includes html, "decor:bg-suite-primary-500"
    assert_includes html, "decor:shadow-suite-primary-500/20"
    refute_includes html, "tabler-filled-star"
  end

  test "size :lg upgrades to larger padding + gap-1.5 (matches ConfinusUI :large)" do
    html = render_component(::Decor::Suite::Badge.new(label: "Large", size: :lg))
    assert_includes html, "decor:px-2.5"
    assert_includes html, "decor:gap-1.5"
  end

  test "default :sm uses small padding + gap-[5px] (matches ConfinusUI default :small)" do
    html = render_component(::Decor::Suite::Badge.new(label: "Default"))
    assert_includes html, "decor:px-2"
    assert_includes html, "decor:gap-[5px]"
    refute_includes html, "decor:gap-1.5"
  end

  test "default typography is suite-description (no daisy text-xs)" do
    html = render_component(::Decor::Suite::Badge.new(label: "x"))
    assert_includes html, "decor:suite-description"
  end

  test "neutral outlined uses hairline-strong border + gray-700" do
    html = render_component(::Decor::Suite::Badge.new(label: "x", style: :outlined))
    assert_includes html, "decor:border-suite-hairline-strong"
    assert_includes html, "decor:text-gray-700"
  end

  test "icon color is one shade lighter than body text (suite-600)" do
    html = render_component(::Decor::Suite::Badge.new(label: "x", icon: "star", color: :success))
    assert_includes html, "decor:text-suite-success-600"
  end
end
