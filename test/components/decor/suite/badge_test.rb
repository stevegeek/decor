# frozen_string_literal: true

require "test_helper"

class ::Decor::Suite::BadgeTest < ActiveSupport::TestCase
  test "renders label" do
    html = render_component(::Decor::Suite::Badge.new(label: "Active"))
    assert_includes html, "Active"
    assert_includes html, "decor:rounded-full"
    assert_includes html, "decor:whitespace-nowrap"
  end

  test "default neutral palette uses muted base-200 / base-content" do
    html = render_component(::Decor::Suite::Badge.new(label: "x"))
    assert_includes html, "decor:bg-base-200"
    assert_includes html, "decor:text-base-content"
  end

  test "color :success switches to muted success palette" do
    html = render_component(::Decor::Suite::Badge.new(label: "ok", color: :success))
    assert_includes html, "decor:bg-success/10"
    assert_includes html, "decor:text-success"
    refute_includes html, "decor:bg-base-200"
  end

  test "style :outlined uses border + base-100 background on chosen color" do
    html = render_component(::Decor::Suite::Badge.new(label: "ok", color: :success, style: :outlined))
    assert_includes html, "decor:bg-base-100"
    assert_includes html, "decor:border-success/30"
    refute_includes html, "decor:bg-success/10"
  end

  test "icon: 'star' renders icon and not a dot" do
    html = render_component(::Decor::Suite::Badge.new(label: "Featured", icon: "star", color: :success))
    assert_includes html, "tabler-filled-star"
    refute_includes html, "decor:shadow-success/20"
  end

  test "dot: true renders the halo dot span and not an icon" do
    html = render_component(::Decor::Suite::Badge.new(label: "Active", dot: true, color: :primary, icon: "star"))
    # Saturated dot bg + halo shadow utility pair, but no icon emit.
    assert_includes html, "decor:bg-info"
    assert_includes html, "decor:shadow-info/20"
    refute_includes html, "tabler-filled-star"
  end

  test "size :lg upgrades to larger padding + gap-1.5 (matches ConfinusUI :large)" do
    html = render_component(::Decor::Suite::Badge.new(label: "Large", size: :lg))
    assert_includes html, "decor:px-2.5"
    assert_includes html, "decor:gap-1.5"
  end

  test "default :md uses small padding + gap-[5px] (matches ConfinusUI default :small)" do
    html = render_component(::Decor::Suite::Badge.new(label: "Default"))
    assert_includes html, "decor:px-2"
    assert_includes html, "decor:gap-[5px]"
    refute_includes html, "decor:gap-1.5"
  end

  test "outlined + success uses border-success/30" do
    html = render_component(::Decor::Suite::Badge.new(label: "ok", color: :success, style: :outlined))
    assert_includes html, "decor:border-success/30"
  end
end
