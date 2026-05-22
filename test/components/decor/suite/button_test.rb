# frozen_string_literal: true

require "test_helper"

class ::Decor::Suite::ButtonTest < ActiveSupport::TestCase
  test "renders a button with the label" do
    html = render_component(::Decor::Suite::Button.new(label: "Save"))
    assert_includes html, "<button"
    assert_includes html, "Save"
  end

  test "default is filled + primary + md" do
    html = render_component(::Decor::Suite::Button.new(label: "Save"))
    assert_includes html, "decor:bg-suite-primary-600"
    assert_includes html, "decor:text-white"
    assert_includes html, "decor:px-3.5"
    assert_includes html, "decor:text-[13px]"
    assert_includes html, "decor:rounded-suite-control"
  end

  test "color :error filled uses the danger palette" do
    html = render_component(::Decor::Suite::Button.new(label: "Delete", color: :error))
    assert_includes html, "decor:bg-suite-danger-600"
    assert_includes html, "decor:hover:bg-suite-danger-700"
    refute_includes html, "decor:bg-suite-primary-600"
  end

  test "color :warning filled uses the muted warning pale-50 surface" do
    html = render_component(::Decor::Suite::Button.new(label: "Proceed", color: :warning))
    assert_includes html, "decor:bg-suite-warning-50"
    assert_includes html, "decor:text-suite-warning-700"
  end

  test "color :base filled is the neutral white button" do
    html = render_component(::Decor::Suite::Button.new(label: "Cancel", color: :base))
    assert_includes html, "decor:bg-white"
    assert_includes html, "decor:border-suite-hairline-strong"
    assert_includes html, "decor:text-gray-700"
  end

  test "style :outlined for primary uses white bg + primary-200 border + primary-700 text" do
    html = render_component(::Decor::Suite::Button.new(label: "Save", color: :primary, style: :outlined))
    assert_includes html, "decor:bg-white"
    assert_includes html, "decor:border-suite-primary-200"
    assert_includes html, "decor:text-suite-primary-700"
    refute_includes html, "decor:bg-suite-primary-600"
  end

  test "style :outlined for error uses the danger-100 border + hover-danger-500" do
    html = render_component(::Decor::Suite::Button.new(label: "Delete", color: :error, style: :outlined))
    assert_includes html, "decor:border-suite-danger-100"
    assert_includes html, "decor:hover:border-suite-danger-500"
    assert_includes html, "decor:text-suite-danger-700"
  end

  test "style :ghost (text) drops bg/border until hover" do
    html = render_component(::Decor::Suite::Button.new(label: "Edit", color: :primary, style: :ghost))
    assert_includes html, "decor:bg-transparent"
    assert_includes html, "decor:border-transparent"
    assert_includes html, "decor:text-suite-primary-600"
    assert_includes html, "decor:hover:bg-gray-100"
  end

  test "size :sm uses small padding + text-xs" do
    html = render_component(::Decor::Suite::Button.new(label: "Small", size: :sm))
    assert_includes html, "decor:px-[11px]"
    assert_includes html, "decor:text-xs"
  end

  test "size :lg uses 38px height + text-sm" do
    html = render_component(::Decor::Suite::Button.new(label: "Large", size: :lg))
    assert_includes html, "decor:h-[38px]"
    assert_includes html, "decor:text-sm"
  end

  test "size :wide uses wide horizontal padding" do
    html = render_component(::Decor::Suite::Button.new(label: "CTA", size: :wide))
    assert_includes html, "decor:px-16"
  end

  test "size :link strips padding + adds underline + drops radius" do
    html = render_component(::Decor::Suite::Button.new(label: "Inline", size: :link))
    assert_includes html, "decor:px-0"
    assert_includes html, "decor:py-0"
    assert_includes html, "decor:underline"
    assert_includes html, "decor:rounded-none"
  end

  test "size alias :large normalizes to :lg" do
    html = render_component(::Decor::Suite::Button.new(label: "Large", size: :large))
    assert_includes html, "decor:h-[38px]"
  end

  test "size alias :small normalizes to :sm" do
    html = render_component(::Decor::Suite::Button.new(label: "Small", size: :small))
    assert_includes html, "decor:px-[11px]"
  end

  test "size alias :medium normalizes to :md" do
    html = render_component(::Decor::Suite::Button.new(label: "Medium", size: :medium))
    assert_includes html, "decor:px-3.5"
  end

  test "size alias :micro normalizes to :xs" do
    html = render_component(::Decor::Suite::Button.new(label: "Micro", size: :micro))
    assert_includes html, "decor:px-[9px]"
    assert_includes html, "decor:text-[11px]"
  end

  test "disabled emits the HTML disabled attribute" do
    html = render_component(::Decor::Suite::Button.new(label: "Off", disabled: true))
    assert_includes html, 'disabled="disabled"'
    assert_includes html, "decor:disabled:opacity-50"
  end

  test "loading hides the label via text-transparent + invisible inner span" do
    html = render_component(::Decor::Suite::Button.new(label: "Saving", loading: true))
    assert_includes html, 'disabled="disabled"'
    assert_includes html, "decor:text-transparent"
    assert_includes html, "decor:invisible"
    assert_includes html, "decor:animate-spin"
  end

  test "loading spinner is white text on filled primary" do
    html = render_component(::Decor::Suite::Button.new(label: "x", loading: true, color: :primary))
    assert_includes html, "decor:text-white"
  end

  test "loading spinner is gray text on outlined/ghost variants" do
    html = render_component(::Decor::Suite::Button.new(label: "x", loading: true, style: :outlined))
    assert_includes html, "decor:text-gray-600"
  end

  test "full_width adds w-full justify-center" do
    html = render_component(::Decor::Suite::Button.new(label: "Continue", full_width: true))
    assert_includes html, "decor:w-full"
    assert_includes html, "decor:justify-center"
  end

  test "icon renders a Decor::Icon with the suite-sized class for the size" do
    html = render_component(::Decor::Suite::Button.new(label: "Add", icon: "plus", size: :md))
    assert_includes html, "decor:h-[13px]"
    assert_includes html, "decor:w-[13px]"
  end

  test "icon_only_on_mobile hides the label span at sub-md viewports" do
    html = render_component(::Decor::Suite::Button.new(label: "Filters", icon: "filter", icon_only_on_mobile: true))
    assert_includes html, "decor:hidden"
    assert_includes html, "decor:md:inline"
  end

  test "uses suite tokens, not daisy semantic colors" do
    html = render_component(::Decor::Suite::Button.new(label: "Save"))
    refute_includes html, "decor:bg-primary"
    refute_includes html, "decor:d-btn"
    refute_includes html, "decor:rounded-md"
  end

  test "uses duration-suite-fast motion token" do
    html = render_component(::Decor::Suite::Button.new(label: "Save"))
    assert_includes html, "decor:duration-suite-fast"
    refute_includes html, "decor:duration-150"
  end

  test "block content overrides label" do
    html = render_component(::Decor::Suite::Button.new(label: "ignored")) { "Block body" }
    assert_includes html, "Block body"
  end

  test "rejects color values outside the suite scheme" do
    assert_raises(Literal::TypeError) { ::Decor::Suite::Button.new(label: "x", color: :neutral) }
    assert_raises(Literal::TypeError) { ::Decor::Suite::Button.new(label: "x", color: :accent) }
  end
end
