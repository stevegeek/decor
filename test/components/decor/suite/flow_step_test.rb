# frozen_string_literal: true

require "test_helper"

class ::Decor::Suite::FlowStepTest < ActiveSupport::TestCase
  test "renders step indicator and title without a block" do
    html = render_component(::Decor::Suite::FlowStep.new(step: 1, title: "Step one"))
    assert_includes html, "01"
    assert_includes html, "Step one"
  end

  test "wraps a child block in card-chrome div with suite tokens" do
    html = render_component(::Decor::Suite::FlowStep.new(step: 1, title: "Step")) { "child-content".html_safe }
    assert_includes html, "child-content"
    assert_includes html, "decor:bg-suite-gray-25"
    assert_includes html, "decor:border-suite-hairline"
    assert_includes html, "decor:rounded-suite-card"
  end

  test "default color renders suite-primary palette on the step indicator" do
    html = render_component(::Decor::Suite::FlowStep.new(step: 1, title: "T"))
    assert_includes html, "decor:bg-suite-primary-50"
    assert_includes html, "decor:border-suite-primary-300"
    assert_includes html, "decor:text-suite-primary-700"
  end

  test "color :success swaps the palette to suite-success" do
    html = render_component(::Decor::Suite::FlowStep.new(step: 1, title: "T", color: :success))
    assert_includes html, "decor:bg-suite-success-50"
    assert_includes html, "decor:border-suite-success-500"
    assert_includes html, "decor:text-suite-success-700"
    refute_includes html, "decor:bg-suite-primary-50"
  end

  test "color :neutral uses gray-100 + hairline-strong border" do
    html = render_component(::Decor::Suite::FlowStep.new(step: 1, title: "T", color: :neutral))
    assert_includes html, "decor:bg-gray-100"
    assert_includes html, "decor:border-suite-hairline-strong"
  end

  test "icon variant renders an icon inside the step indicator" do
    html = render_component(::Decor::Suite::FlowStep.new(icon: "upload", title: "T"))
    assert_includes html, "tabler-upload"
  end

  test "style :outlined uses the suite-outline palette" do
    html = render_component(::Decor::Suite::FlowStep.new(step: 1, title: "T", style: :outlined, color: :success))
    assert_includes html, "decor:border-suite-success-500"
    assert_includes html, "decor:bg-transparent"
  end

  test "title renders as plain h4 not via Daisy::Title delegation" do
    html = render_component(::Decor::Suite::FlowStep.new(step: 1, title: "Inline title"))
    assert_includes html, "<h4"
    assert_includes html, "decor:suite-section-title"
    assert_includes html, "Inline title"
    refute_includes html, "decor:justify-between"
  end

  test "description renders below title with suite-description token" do
    html = render_component(::Decor::Suite::FlowStep.new(step: 1, title: "T", description: "Some helper text"))
    assert_includes html, "Some helper text"
    assert_includes html, "decor:suite-description"
  end

  test "root element uses suite-hairline divider" do
    html = render_component(::Decor::Suite::FlowStep.new(step: 1, title: "T"))
    assert_includes html, "decor:border-suite-hairline"
    assert_includes html, "decor:last:border-b-0"
  end

  test "step indicator is the chunky 38px suite circle" do
    html = render_component(::Decor::Suite::FlowStep.new(step: 1, title: "T"))
    assert_includes html, "decor:w-[38px]"
    assert_includes html, "decor:h-[38px]"
    assert_includes html, "decor:suite-dense-body"
    assert_includes html, "decor:tabular-nums"
  end
end
