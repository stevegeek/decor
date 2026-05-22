# frozen_string_literal: true

require "test_helper"

class ::Decor::Suite::StatsTest < ActiveSupport::TestCase
  test "renders the root container with suite card chrome" do
    html = render_component(::Decor::Suite::Stats.new)
    assert_includes html, "decor:bg-white"
    assert_includes html, "decor:border-suite-hairline"
    assert_includes html, "decor:rounded-suite-card"
  end

  test "default horizontal orientation lays children in a row with vertical hairline dividers" do
    html = render_component(::Decor::Suite::Stats.new)
    assert_includes html, "decor:flex"
    assert_includes html, "decor:flex-row"
    assert_includes html, "decor:divide-x"
    assert_includes html, "decor:divide-suite-hairline"
    refute_includes html, "decor:flex-col"
  end

  test "vertical orientation lays children in a column with horizontal hairline dividers" do
    html = render_component(::Decor::Suite::Stats.new(orientation: :vertical))
    assert_includes html, "decor:flex-col"
    assert_includes html, "decor:divide-y"
    assert_includes html, "decor:divide-suite-hairline"
    refute_includes html, "decor:flex-row"
    refute_includes html, "decor:divide-x"
  end

  test "responsive stacks vertically by default and switches to row at lg breakpoint" do
    html = render_component(::Decor::Suite::Stats.new(responsive: true))
    assert_includes html, "decor:flex-col"
    assert_includes html, "decor:divide-y"
    assert_includes html, "decor:lg:flex-row"
    assert_includes html, "decor:lg:divide-x"
    assert_includes html, "decor:lg:divide-y-0"
  end

  test "renders role=group with aria-label Statistics for assistive tech" do
    html = render_component(::Decor::Suite::Stats.new)
    assert_includes html, 'role="group"'
    assert_includes html, 'aria-label="Statistics"'
  end

  test "yields its block so children render inside the container" do
    html = render_component(::Decor::Suite::Stats.new) do |el|
      el.render ::Decor::Daisy::Stat.new(title: "CHILD_TITLE", value: "FIRST_VAL")
    end
    assert_includes html, "CHILD_TITLE"
    assert_includes html, "FIRST_VAL"
  end

  test "renders multiple child tiles in insertion order" do
    html = render_component(::Decor::Suite::Stats.new) do |el|
      el.render ::Decor::Daisy::Stat.new(title: "ALPHA_TILE", value: "1")
      el.render ::Decor::Daisy::Stat.new(title: "BETA_TILE", value: "2")
      el.render ::Decor::Daisy::Stat.new(title: "GAMMA_TILE", value: "3")
    end
    alpha_at = html.index("ALPHA_TILE")
    beta_at = html.index("BETA_TILE")
    gamma_at = html.index("GAMMA_TILE")
    assert alpha_at && beta_at && gamma_at, "all tiles rendered"
    assert alpha_at < beta_at, "alpha precedes beta"
    assert beta_at < gamma_at, "beta precedes gamma"
  end

  test "renders a Daisy::Stat child without raising" do
    html = render_component(::Decor::Suite::Stats.new) do |el|
      el.render ::Decor::Daisy::Stat.new(title: "Revenue", value: "$45,231")
    end
    assert_includes html, "Revenue"
    assert_includes html, "$45,231"
  end

  test "overflow-hidden clips child corners so divider lines meet the rounded edge" do
    html = render_component(::Decor::Suite::Stats.new)
    assert_includes html, "decor:overflow-hidden"
  end
end
