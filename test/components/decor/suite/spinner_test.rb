# frozen_string_literal: true

require "test_helper"

class Decor::Suite::SpinnerTest < ActiveSupport::TestCase
  test "renders border-rotate ring with animate-spin" do
    rendered = render_component(Decor::Suite::Spinner.new)
    assert_includes rendered, "decor:inline-block"
    assert_includes rendered, "decor:rounded-full"
    assert_includes rendered, "decor:animate-spin"
    assert_includes rendered, "decor:border-gray-200"
  end

  test "default size :md is 18px with 2.5px border" do
    rendered = render_component(Decor::Suite::Spinner.new)
    assert_includes rendered, "decor:w-[18px] decor:h-[18px] decor:border-[2.5px]"
  end

  test "default color uses suite primary 500" do
    rendered = render_component(Decor::Suite::Spinner.new)
    assert_includes rendered, "decor:border-t-suite-primary-500"
  end

  test "size :xs renders w-3 h-3 border-2" do
    rendered = render_component(Decor::Suite::Spinner.new(size: :xs))
    assert_includes rendered, "decor:w-3 decor:h-3 decor:border-2"
  end

  test "size :sm renders w-4 h-4 border-[2px]" do
    rendered = render_component(Decor::Suite::Spinner.new(size: :sm))
    assert_includes rendered, "decor:w-4 decor:h-4 decor:border-[2px]"
  end

  test "size :lg renders w-6 h-6 border-[3px]" do
    rendered = render_component(Decor::Suite::Spinner.new(size: :lg))
    assert_includes rendered, "decor:w-6 decor:h-6 decor:border-[3px]"
  end

  test "size :xl renders w-8 h-8 border-[3px]" do
    rendered = render_component(Decor::Suite::Spinner.new(size: :xl))
    assert_includes rendered, "decor:w-8 decor:h-8 decor:border-[3px]"
  end

  test "color :success uses suite-success-500 top border" do
    rendered = render_component(Decor::Suite::Spinner.new(color: :success))
    assert_includes rendered, "decor:border-t-suite-success-500"
  end

  test "color :warning uses suite-warning-500 top border" do
    rendered = render_component(Decor::Suite::Spinner.new(color: :warning))
    assert_includes rendered, "decor:border-t-suite-warning-500"
  end

  test "color :error uses suite-danger-500 top border" do
    rendered = render_component(Decor::Suite::Spinner.new(color: :error))
    assert_includes rendered, "decor:border-t-suite-danger-500"
  end

  test "color :neutral falls through to suite-primary-500 default" do
    rendered = render_component(Decor::Suite::Spinner.new(color: :neutral))
    assert_includes rendered, "decor:border-t-suite-primary-500"
  end
end
