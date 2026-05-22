# frozen_string_literal: true

require "test_helper"

class ::Decor::Suite::StatTest < ActiveSupport::TestCase
  test "renders title with suite-caption typography" do
    html = render_component(::Decor::Suite::Stat.new(title: "Revenue", value: "$12,480"))
    assert_includes html, "Revenue"
    assert_includes html, "decor:suite-caption"
    assert_includes html, "decor:text-gray-500"
  end

  test "renders value with suite-section-title and tabular-nums" do
    html = render_component(::Decor::Suite::Stat.new(title: "Revenue", value: "$12,480"))
    assert_includes html, "$12,480"
    assert_includes html, "decor:suite-section-title"
    assert_includes html, "decor:text-gray-900"
    assert_includes html, "decor:tabular-nums"
  end

  test "renders suite surface chrome — white bg, hairline border, rounded-suite-card" do
    html = render_component(::Decor::Suite::Stat.new(title: "T", value: "1"))
    assert_includes html, "decor:bg-white"
    assert_includes html, "decor:border-suite-hairline"
    assert_includes html, "decor:rounded-suite-card"
  end

  test "delta :up paints description in suite-primary-700" do
    html = render_component(::Decor::Suite::Stat.new(title: "T", value: "1", description: "+12.4%", delta: :up))
    assert_includes html, "+12.4%"
    assert_includes html, "decor:text-suite-primary-700"
    refute_includes html, "decor:text-suite-danger-700"
  end

  test "delta :down paints description in suite-danger-700" do
    html = render_component(::Decor::Suite::Stat.new(title: "T", value: "1", description: "-3.1%", delta: :down))
    assert_includes html, "-3.1%"
    assert_includes html, "decor:text-suite-danger-700"
    refute_includes html, "decor:text-suite-primary-700"
  end

  test "default delta :none leaves description gray" do
    html = render_component(::Decor::Suite::Stat.new(title: "T", value: "1", description: "vs last week"))
    assert_includes html, "vs last week"
    assert_includes html, "decor:suite-description"
    refute_includes html, "decor:text-suite-primary-700"
    refute_includes html, "decor:text-suite-danger-700"
  end

  test "description uses suite-description typography" do
    html = render_component(::Decor::Suite::Stat.new(title: "T", value: "1", description: "x"))
    assert_includes html, "decor:suite-description"
  end

  test "renders icon in the figure slot when icon: provided" do
    html = render_component(::Decor::Suite::Stat.new(title: "Orders", value: "42", icon: "shopping-cart"))
    assert_includes html, "<svg"
  end

  test "block value overrides value: prop" do
    html = render_component(::Decor::Suite::Stat.new(title: "T")) do
      '<span data-testid="rich">$1,000</span>'.html_safe
    end
    assert_includes html, 'data-testid="rich"'
    assert_includes html, "$1,000"
  end

  test "figure block renders custom figure content in place of icon" do
    html = render_component(::Decor::Suite::Stat.new(title: "T", value: "1", icon: "star")) do |stat|
      stat.figure { '<svg data-testid="sparkline"></svg>'.html_safe }
    end
    assert_includes html, 'data-testid="sparkline"'
  end

  test "actions block renders a footer row" do
    html = render_component(::Decor::Suite::Stat.new(title: "T", value: "1")) do |stat|
      stat.actions { '<button data-testid="cta">View</button>'.html_safe }
    end
    assert_includes html, 'data-testid="cta"'
    assert_includes html, "View"
  end

  test "no figure wrapper rendered when no icon, no figure block, no with_figure" do
    html = render_component(::Decor::Suite::Stat.new(title: "T", value: "1"))
    refute_includes html, "<svg"
  end

  test "centered: true adds text-center" do
    html = render_component(::Decor::Suite::Stat.new(title: "T", value: "1", centered: true))
    assert_includes html, "decor:text-center"
  end
end
