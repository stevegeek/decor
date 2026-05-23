# frozen_string_literal: true

require "test_helper"

class Decor::Daisy::LoadingBarTest < ActiveSupport::TestCase
  test "renders root with daisy loading-bar identifier and full width" do
    html = render_component(::Decor::Daisy::LoadingBar.new)
    assert_includes html, "decor--daisy--loading-bar"
    assert_includes html, "decor:w-full"
  end

  test "default indeterminate renders sliding animation div with keyframes" do
    html = render_component(::Decor::Daisy::LoadingBar.new)
    refute_includes html, "<progress"
    assert_includes html, "decor-daisy-loading-bar"
    assert_includes html, "@keyframes"
  end

  test "default size :md uses h-2 track" do
    html = render_component(::Decor::Daisy::LoadingBar.new)
    assert_includes html, "decor:h-2"
  end

  test "size :xs uses h-1 track" do
    html = render_component(::Decor::Daisy::LoadingBar.new(size: :xs))
    assert_includes html, "decor:h-1"
  end

  test "size :sm uses h-1.5 track" do
    html = render_component(::Decor::Daisy::LoadingBar.new(size: :sm))
    assert_includes html, "decor:h-1.5"
  end

  test "size :lg uses h-3 track" do
    html = render_component(::Decor::Daisy::LoadingBar.new(size: :lg))
    assert_includes html, "decor:h-3"
  end

  test "size :xl uses h-4 track" do
    html = render_component(::Decor::Daisy::LoadingBar.new(size: :xl))
    assert_includes html, "decor:h-4"
  end

  test "determinate style renders a native progress element with value and max" do
    html = render_component(::Decor::Daisy::LoadingBar.new(style: :determinate, progress: 40))
    assert_includes html, "<progress"
    assert_includes html, 'value="40"'
    assert_includes html, 'max="100"'
    assert_includes html, "decor:d-progress"
  end

  test "determinate clamps progress to 0..100" do
    over = render_component(::Decor::Daisy::LoadingBar.new(style: :determinate, progress: 150))
    assert_includes over, 'value="100"'
    under = render_component(::Decor::Daisy::LoadingBar.new(style: :determinate, progress: -10))
    assert_includes under, 'value="0"'
  end

  test "determinate sets aria-label with progress percentage" do
    html = render_component(::Decor::Daisy::LoadingBar.new(style: :determinate, progress: 73))
    assert_includes html, "Progress: 73% complete"
  end

  test "label renders above bar in label color" do
    html = render_component(::Decor::Daisy::LoadingBar.new(label: "Uploading"))
    assert_includes html, "Uploading"
    assert_includes html, "decor:text-primary"
  end

  test "color success uses bg-success fill (indeterminate)" do
    html = render_component(::Decor::Daisy::LoadingBar.new(color: :success))
    assert_includes html, "decor:bg-success"
  end

  test "color error uses bg-error fill (indeterminate)" do
    html = render_component(::Decor::Daisy::LoadingBar.new(color: :error))
    assert_includes html, "decor:bg-error"
  end

  test "color secondary uses d-progress-secondary on determinate progress" do
    html = render_component(::Decor::Daisy::LoadingBar.new(style: :determinate, progress: 50, color: :secondary))
    assert_includes html, "decor:d-progress-secondary"
  end

  test "color base uses bg-base-content for indeterminate fill" do
    html = render_component(::Decor::Daisy::LoadingBar.new(color: :base))
    assert_includes html, "decor:bg-base-content"
  end

  test "label color tracks the color prop" do
    html = render_component(::Decor::Daisy::LoadingBar.new(label: "Saving", color: :success))
    assert_includes html, "decor:text-success"
  end
end
