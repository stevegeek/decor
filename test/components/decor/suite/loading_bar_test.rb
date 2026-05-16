# frozen_string_literal: true

require "test_helper"

class Decor::Suite::LoadingBarTest < ActiveSupport::TestCase
  test "default renders indeterminate bar with sliding animation keyframes" do
    rendered = render_component(Decor::Suite::LoadingBar.new)
    assert_includes rendered, "decor:w-full"
    assert_includes rendered, "decor:bg-gray-200"
    assert_includes rendered, "decor:rounded-full"
    assert_includes rendered, "decor:bg-suite-primary-500"
    assert_includes rendered, "decor-suite-loading-bar"
  end

  test "default size :md uses h-2 track" do
    rendered = render_component(Decor::Suite::LoadingBar.new)
    assert_includes rendered, "decor:h-2"
  end

  test "size :xs uses h-1 track" do
    rendered = render_component(Decor::Suite::LoadingBar.new(size: :xs))
    assert_includes rendered, "decor:h-1"
  end

  test "size :sm uses h-1.5 track" do
    rendered = render_component(Decor::Suite::LoadingBar.new(size: :sm))
    assert_includes rendered, "decor:h-1.5"
  end

  test "size :lg uses h-3 track" do
    rendered = render_component(Decor::Suite::LoadingBar.new(size: :lg))
    assert_includes rendered, "decor:h-3"
  end

  test "size :xl uses h-4 track" do
    rendered = render_component(Decor::Suite::LoadingBar.new(size: :xl))
    assert_includes rendered, "decor:h-4"
  end

  test "determinate style sets fill width inline" do
    rendered = render_component(Decor::Suite::LoadingBar.new(style: :determinate, progress: 40))
    assert_includes rendered, "width: 40%"
    assert_includes rendered, "transition: width"
    refute_includes rendered, "decor-suite-loading-bar"
  end

  test "determinate clamps progress to 0..100" do
    over = render_component(Decor::Suite::LoadingBar.new(style: :determinate, progress: 150))
    assert_includes over, "width: 100%"

    under = render_component(Decor::Suite::LoadingBar.new(style: :determinate, progress: -10))
    assert_includes under, "width: 0%"
  end

  test "determinate animated renders hatch overlay keyframes" do
    rendered = render_component(Decor::Suite::LoadingBar.new(style: :determinate, progress: 50, animated: true))
    assert_includes rendered, "decor-suite-bar-hatch"
    assert_includes rendered, "repeating-linear-gradient"
  end

  test "determinate animated false omits hatch overlay" do
    rendered = render_component(Decor::Suite::LoadingBar.new(style: :determinate, progress: 50, animated: false))
    refute_includes rendered, "decor-suite-bar-hatch"
    refute_includes rendered, "repeating-linear-gradient"
  end

  test "label renders above bar with suite label typography" do
    rendered = render_component(Decor::Suite::LoadingBar.new(label: "Uploading"))
    assert_includes rendered, "Uploading"
    assert_includes rendered, "decor:suite-label"
  end

  test "show_percentage on determinate large bar renders percent text" do
    rendered = render_component(Decor::Suite::LoadingBar.new(style: :determinate, progress: 73, show_percentage: true, size: :lg))
    assert_includes rendered, "73%"
    assert_includes rendered, "decor:text-white"
  end

  test "show_percentage indeterminate does not render percent text" do
    rendered = render_component(Decor::Suite::LoadingBar.new(show_percentage: true, progress: 73))
    refute_includes rendered, "73%"
  end

  test "color success uses suite-success-500 fill" do
    rendered = render_component(Decor::Suite::LoadingBar.new(color: :success))
    assert_includes rendered, "decor:bg-suite-success-500"
  end

  test "color warning uses suite-warning-500 fill" do
    rendered = render_component(Decor::Suite::LoadingBar.new(color: :warning))
    assert_includes rendered, "decor:bg-suite-warning-500"
  end

  test "color error uses suite-danger-500 fill" do
    rendered = render_component(Decor::Suite::LoadingBar.new(color: :error))
    assert_includes rendered, "decor:bg-suite-danger-500"
  end

  test "color neutral uses gray-600 fill" do
    rendered = render_component(Decor::Suite::LoadingBar.new(color: :neutral))
    assert_includes rendered, "decor:bg-gray-600"
  end

  test "label color follows color prop" do
    rendered = render_component(Decor::Suite::LoadingBar.new(label: "Saving", color: :success))
    assert_includes rendered, "decor:text-suite-success-700"
  end
end
