# frozen_string_literal: true

require "test_helper"

class Decor::CodeSnippetTest < ActiveSupport::TestCase
  def test_renders_with_content
    component = Decor::CodeSnippet.new

    rendered = render_fragment(component) { "const foo = 'bar';" }

    # Should render as code element
    code_element = rendered.css("code").first
    assert code_element
    assert_equal "const foo = 'bar';", code_element.text

    # Should have base classes
    assert_includes code_element["class"], "px-2"
    assert_includes code_element["class"], "py-1"
    assert_includes code_element["class"], "rounded"
    assert_includes code_element["class"], "font-mono"
  end

  def test_default_variant_styling
    component = Decor::CodeSnippet.new

    rendered = render_fragment(component) { "code" }

    code_element = rendered.css("code").first
    assert_includes code_element["class"], "bg-base-200"
    assert_includes code_element["class"], "text-base-content"
  end

  def test_primary_variant
    component = Decor::CodeSnippet.new(variant: :primary)

    rendered = render_fragment(component) { "code" }

    code_element = rendered.css("code").first
    assert_includes code_element["class"], "bg-primary/20"
    assert_includes code_element["class"], "text-primary"
  end

  def test_secondary_variant
    component = Decor::CodeSnippet.new(variant: :secondary)

    rendered = render_fragment(component) { "code" }

    code_element = rendered.css("code").first
    assert_includes code_element["class"], "bg-secondary/20"
    assert_includes code_element["class"], "text-secondary"
  end

  def test_accent_variant
    component = Decor::CodeSnippet.new(variant: :accent)

    rendered = render_fragment(component) { "code" }

    code_element = rendered.css("code").first
    assert_includes code_element["class"], "bg-accent/20"
    assert_includes code_element["class"], "text-accent"
  end

  def test_size_xs
    component = Decor::CodeSnippet.new(size: :xs)

    rendered = render_fragment(component) { "tiny code" }

    code_element = rendered.css("code").first
    assert_includes code_element["class"], "text-xs"
  end

  def test_size_sm
    component = Decor::CodeSnippet.new(size: :sm)

    rendered = render_fragment(component) { "small code" }

    code_element = rendered.css("code").first
    assert_includes code_element["class"], "text-sm"
  end

  def test_size_normal
    component = Decor::CodeSnippet.new(size: :normal)

    rendered = render_fragment(component) { "normal code" }

    code_element = rendered.css("code").first
    assert_includes code_element["class"], "text-base"
  end

  def test_size_lg
    component = Decor::CodeSnippet.new(size: :lg)

    rendered = render_fragment(component) { "large code" }

    code_element = rendered.css("code").first
    assert_includes code_element["class"], "text-lg"
  end

  def test_with_complex_content
    component = Decor::CodeSnippet.new

    rendered = render_fragment(component) do
      "Array.from({ length: 5 }, (_, i) => i * 2)"
    end

    code_element = rendered.css("code").first
    assert_equal "Array.from({ length: 5 }, (_, i) => i * 2)", code_element.text
  end

  def test_combined_props
    component = Decor::CodeSnippet.new(variant: :primary, size: :sm)

    rendered = render_fragment(component) { "npm install" }

    code_element = rendered.css("code").first
    # Should have both variant and size classes
    assert_includes code_element["class"], "bg-primary/20"
    assert_includes code_element["class"], "text-primary"
    assert_includes code_element["class"], "text-sm"
  end
end
