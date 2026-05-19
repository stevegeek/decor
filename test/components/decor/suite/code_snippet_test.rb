# frozen_string_literal: true

require "test_helper"

class ::Decor::Suite::CodeSnippetTest < ActiveSupport::TestCase
  test "renders a single <code> element wrapping the block content" do
    rendered = render_fragment(::Decor::Suite::CodeSnippet.new) { "puts :ok" }
    code = rendered.css("code").first
    assert code
    assert_equal "puts :ok", code.text
  end

  test "default filled style uses suite-gray-25 surface with hairline border" do
    html = render_component(::Decor::Suite::CodeSnippet.new) { "x" }
    assert_includes html, "decor:bg-suite-gray-25"
    assert_includes html, "decor:border-suite-hairline"
    assert_includes html, "decor:border"
  end

  test "always applies font-mono + rounded-suite-control + inline padding" do
    rendered = render_fragment(::Decor::Suite::CodeSnippet.new) { "x" }
    code = rendered.css("code").first
    assert_includes code["class"], "decor:font-mono"
    assert_includes code["class"], "decor:rounded-suite-control"
    assert_includes code["class"], "decor:px-1.5"
    assert_includes code["class"], "decor:py-0.5"
    assert_includes code["class"], "decor:inline"
  end

  test "does NOT pick up CodeBlock card chrome (smaller cousin invariant)" do
    html = render_component(::Decor::Suite::CodeSnippet.new) { "x" }
    refute_includes html, "decor:rounded-suite-card"
    refute_includes html, "decor:overflow-hidden"
  end

  test "outlined style drops the surface but keeps the hairline border" do
    html = render_component(::Decor::Suite::CodeSnippet.new(style: :outlined)) { "x" }
    assert_includes html, "decor:bg-transparent"
    assert_includes html, "decor:border-suite-hairline"
    refute_includes html, "decor:bg-suite-gray-25"
  end

  test "ghost style drops both surface and border" do
    html = render_component(::Decor::Suite::CodeSnippet.new(style: :ghost)) { "x" }
    assert_includes html, "decor:bg-transparent"
    refute_includes html, "decor:bg-suite-gray-25"
    refute_includes html, "decor:border-suite-hairline"
  end

  test "primary color tints background, text and border with suite-primary palette" do
    html = render_component(::Decor::Suite::CodeSnippet.new(color: :primary)) { "x" }
    assert_includes html, "decor:bg-suite-primary-50"
    assert_includes html, "decor:text-suite-primary-700"
    assert_includes html, "decor:border-suite-primary-200"
  end

  test "error color uses suite-danger palette (semantic alias)" do
    html = render_component(::Decor::Suite::CodeSnippet.new(color: :error)) { "x" }
    assert_includes html, "decor:bg-suite-danger-50"
    assert_includes html, "decor:text-suite-danger-700"
  end

  test "color other than :base suppresses style classes" do
    html = render_component(::Decor::Suite::CodeSnippet.new(color: :success)) { "x" }
    assert_includes html, "decor:bg-suite-success-50"
    refute_includes html, "decor:bg-suite-gray-25"
  end

  test "md size defaults to text-xs (Suite snippets read smaller than Daisy)" do
    rendered = render_fragment(::Decor::Suite::CodeSnippet.new(size: :md)) { "x" }
    assert_includes rendered.css("code").first["class"], "decor:text-xs"
  end

  test "sm size uses suite-description typography" do
    rendered = render_fragment(::Decor::Suite::CodeSnippet.new(size: :sm)) { "x" }
    assert_includes rendered.css("code").first["class"], "decor:suite-description"
  end

  test "lg size bumps to text-sm" do
    rendered = render_fragment(::Decor::Suite::CodeSnippet.new(size: :lg)) { "x" }
    assert_includes rendered.css("code").first["class"], "decor:text-sm"
  end

  test "renders complex inline content verbatim" do
    rendered = render_fragment(::Decor::Suite::CodeSnippet.new) { "Hash[*a.zip(b).flatten]" }
    assert_equal "Hash[*a.zip(b).flatten]", rendered.css("code").first.text
  end

  test "combines color and size classes simultaneously" do
    rendered = render_fragment(::Decor::Suite::CodeSnippet.new(color: :warning, size: :lg)) { "TODO" }
    classes = rendered.css("code").first["class"]
    assert_includes classes, "decor:bg-suite-warning-50"
    assert_includes classes, "decor:text-suite-warning-700"
    assert_includes classes, "decor:text-sm"
  end
end
