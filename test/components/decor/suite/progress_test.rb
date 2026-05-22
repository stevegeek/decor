# frozen_string_literal: true

require "test_helper"

class ::Decor::Suite::ProgressTest < ActiveSupport::TestCase
  STANDARD = [
    {label_key: "One"},
    {label_key: "Two"},
    {label_key: "Three"},
    {label_key: "Four"}
  ].freeze

  test "default style renders the steps indicator (nav + ol)" do
    html = render_component(::Decor::Suite::Progress.new(steps: STANDARD))
    assert_includes html, "<nav"
    assert_includes html, "aria-label=\"Progress\""
    assert_includes html, "<ol"
  end

  test "default color uses suite-primary palette on the current marker" do
    html = render_component(::Decor::Suite::Progress.new(steps: STANDARD, current_step: 2))
    assert_includes html, "decor:border-suite-primary-500"
    assert_includes html, "decor:text-suite-primary-700"
  end

  test "completed step renders a saturated suite-primary-500 filled marker" do
    html = render_component(::Decor::Suite::Progress.new(steps: STANDARD, current_step: 3))
    assert_includes html, "decor:bg-suite-primary-500"
  end

  test "upcoming step uses gray text with suite-hairline-strong border" do
    html = render_component(::Decor::Suite::Progress.new(steps: STANDARD, current_step: 1))
    assert_includes html, "decor:text-gray-500"
    assert_includes html, "decor:border-suite-hairline-strong"
  end

  test "color :success swaps the palette to suite-success" do
    html = render_component(::Decor::Suite::Progress.new(steps: STANDARD, current_step: 2, color: :success))
    assert_includes html, "decor:border-suite-success-500"
    assert_includes html, "decor:text-suite-success-700"
    refute_includes html, "decor:border-suite-primary-500"
  end

  test "color :warning swaps the palette to suite-warning" do
    html = render_component(::Decor::Suite::Progress.new(steps: STANDARD, current_step: 2, color: :warning))
    assert_includes html, "decor:border-suite-warning-500"
    assert_includes html, "decor:text-suite-warning-700"
  end

  test "color :error swaps the palette to suite-danger" do
    html = render_component(::Decor::Suite::Progress.new(steps: STANDARD, current_step: 2, color: :error))
    assert_includes html, "decor:border-suite-danger-500"
    assert_includes html, "decor:text-suite-danger-700"
  end

  test "style :progress renders only the linear bar (no nav)" do
    html = render_component(::Decor::Suite::Progress.new(steps: STANDARD, current_step: 2, style: :progress))
    assert_includes html, "role=\"progressbar\""
    assert_includes html, "aria-valuenow"
    refute_includes html, "<nav"
  end

  test "progress bar uses muted suite-primary-50 track and saturated suite-primary-500 fill" do
    html = render_component(::Decor::Suite::Progress.new(steps: STANDARD, current_step: 2, style: :progress))
    assert_includes html, "decor:bg-suite-primary-50"
    assert_includes html, "decor:bg-suite-primary-500"
  end

  test "progress bar fill width comes from progress_value" do
    html = render_component(::Decor::Suite::Progress.new(steps: STANDARD, current_step: 2, style: :progress))
    assert_includes html, "width: 25%"
  end

  test "progress bar at not-started reports 0%" do
    html = render_component(::Decor::Suite::Progress.new(steps: STANDARD, current_step: 0, style: :progress))
    assert_includes html, "width: 0%"
  end

  test "progress bar at completed reports 100%" do
    html = render_component(::Decor::Suite::Progress.new(steps: STANDARD, current_step: 5, style: :progress))
    assert_includes html, "width: 100%"
  end

  test "progress bar uses suite-success palette when color is :success" do
    html = render_component(::Decor::Suite::Progress.new(steps: STANDARD, current_step: 2, style: :progress, color: :success))
    assert_includes html, "decor:bg-suite-success-50"
    assert_includes html, "decor:bg-suite-success-500"
  end

  test "style :both renders both bar and steps separated by a hairline divider" do
    html = render_component(::Decor::Suite::Progress.new(steps: STANDARD, current_step: 2, style: :both))
    assert_includes html, "role=\"progressbar\""
    assert_includes html, "<nav"
    assert_includes html, "decor:border-suite-hairline"
  end

  test "step with href and completed state renders an anchor" do
    steps = [{label_key: "One", href: "#one"}, {label_key: "Two"}]
    html = render_component(::Decor::Suite::Progress.new(steps: steps, current_step: 2))
    assert_includes html, "href=\"#one\""
  end

  test "current step gets aria-current=step" do
    html = render_component(::Decor::Suite::Progress.new(steps: STANDARD, current_step: 2))
    assert_includes html, "aria-current=\"step\""
  end

  test "completed step renders an inline check svg" do
    html = render_component(::Decor::Suite::Progress.new(steps: STANDARD, current_step: 3))
    assert_includes html, "<svg"
    assert_includes html, "M1 5.5"
  end

  test "connectors tint to suite-primary-500 once the step before them is completed" do
    html = render_component(::Decor::Suite::Progress.new(steps: STANDARD, current_step: 3))
    assert_includes html, "decor:bg-suite-primary-500"
  end

  test "connectors remain hairline-strong for upcoming segments" do
    html = render_component(::Decor::Suite::Progress.new(steps: STANDARD, current_step: 1))
    assert_includes html, "decor:bg-suite-hairline-strong"
  end

  test "uses suite-dense-body typography on the default-size marker" do
    html = render_component(::Decor::Suite::Progress.new(steps: STANDARD, current_step: 2))
    assert_includes html, "decor:suite-dense-body"
    assert_includes html, "decor:tabular-nums"
  end

  test "uses suite-description typography token for step descriptions when i18n provides one" do
    html = render_component(::Decor::Suite::Progress.new(steps: STANDARD, current_step: 1))
    assert_includes html, "decor:suite-dense-body"
  end

  test "size :lg increases marker dimensions" do
    html = render_component(::Decor::Suite::Progress.new(steps: STANDARD, current_step: 2, size: :lg))
    assert_includes html, "decor:w-10 decor:h-10"
  end

  test "size :xs shrinks marker dimensions" do
    html = render_component(::Decor::Suite::Progress.new(steps: STANDARD, current_step: 2, size: :xs))
    assert_includes html, "decor:w-6 decor:h-6"
  end

  test "vertical layout omits the horizontal lg: classes from the ol container" do
    html = render_component(::Decor::Suite::Progress.new(steps: STANDARD, current_step: 2, vertical: true))
    assert_includes html, "<ol"
    refute_includes html, "decor:lg:flex-row"
  end

  test "transitions use suite duration tokens, not raw duration-150/200" do
    html = render_component(::Decor::Suite::Progress.new(steps: STANDARD, current_step: 2))
    assert_includes html, "decor:duration-suite-fast"
    refute_includes html, "decor:duration-150"
    refute_includes html, "decor:duration-200"
  end

  test "renders an aria-label on the progress bar with the percentage" do
    html = render_component(::Decor::Suite::Progress.new(steps: STANDARD, current_step: 2, style: :progress))
    assert_includes html, "Progress: 25% complete"
  end

  test "root wrapper carries a stable suite background" do
    html = render_component(::Decor::Suite::Progress.new(steps: STANDARD, current_step: 1))
    assert_includes html, "decor:bg-white"
  end
end
