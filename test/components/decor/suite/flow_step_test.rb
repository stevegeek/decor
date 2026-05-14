# frozen_string_literal: true

require "test_helper"

class ::Decor::Suite::FlowStepTest < ActiveSupport::TestCase
  test "renders step indicator and title without a block" do
    html = render_component(::Decor::Suite::FlowStep.new(step: 1, title: "Step one"))
    assert_includes html, "01"
    assert_includes html, "Step one"
  end

  test "wraps a child block in card-chrome div" do
    html = render_component(::Decor::Suite::FlowStep.new(step: 1, title: "Step")) { "child-content".html_safe }
    assert_includes html, "child-content"
    assert_includes html, "decor:bg-base-200/40"
    assert_includes html, "decor:rounded-md"
  end

  test "default color renders muted info palette on the step indicator" do
    html = render_component(::Decor::Suite::FlowStep.new(step: 1, title: "T"))
    assert_includes html, "decor:bg-info/10"
    assert_includes html, "decor:border-info/40"
    assert_includes html, "decor:text-info"
  end

  test "color :success swaps the palette" do
    html = render_component(::Decor::Suite::FlowStep.new(step: 1, title: "T", color: :success))
    assert_includes html, "decor:bg-success/10"
    assert_includes html, "decor:border-success/40"
    refute_includes html, "decor:bg-info/10"
  end

  test "color :neutral uses base-200 + black/15 border" do
    html = render_component(::Decor::Suite::FlowStep.new(step: 1, title: "T", color: :neutral))
    assert_includes html, "decor:bg-base-200"
    assert_includes html, "decor:border-black/15"
  end

  test "icon variant renders an icon inside the step indicator" do
    html = render_component(::Decor::Suite::FlowStep.new(icon: "upload", title: "T"))
    # Tabler sprite reference for upload
    assert_includes html, "tabler-upload"
    refute_includes html, "01"
  end

  test "style :outlined uses the muted-outline palette" do
    html = render_component(::Decor::Suite::FlowStep.new(step: 1, title: "T", style: :outlined, color: :success))
    assert_includes html, "decor:border-success/60"
    assert_includes html, "decor:bg-transparent"
  end
end
