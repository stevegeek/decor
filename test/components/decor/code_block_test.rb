# frozen_string_literal: true

require "test_helper"

class Decor::CodeBlockTest < ActiveSupport::TestCase
  def test_renders_basic_code_block
    component = Decor::CodeBlock.new

    rendered = render_fragment(component) do
      "function hello() {\n  console.log('Hello, world!');\n}"
    end

    # Should have wrapper div
    wrapper = rendered.css(".rounded-lg").first
    assert wrapper

    # Should have pre element
    pre = rendered.css("pre").first
    assert pre
    assert_includes pre["class"], "p-4"
    assert_includes pre["class"], "overflow-x-auto"

    # Should have code element
    code = rendered.css("code").first
    assert code
    assert_includes code["class"], "font-mono"
  end

  def test_renders_with_language
    component = Decor::CodeBlock.new(language: "javascript", highlight: true)

    rendered = render_fragment(component) { "const x = 42;" }

    code = rendered.css("code").first
    assert_includes code["class"], "language-javascript"
  end

  def test_renders_with_filename
    component = Decor::CodeBlock.new(filename: "app.js")

    rendered = render_fragment(component) { "// code here" }

    # Should have header
    header = rendered.css(".border-b").first
    assert header

    # Should display filename
    assert_includes rendered.text, "app.js"
  end

  def test_renders_with_copy_button
    component = Decor::CodeBlock.new(copy_button: true)

    rendered = render_fragment(component) { "copy me" }

    # Should have header with ClickToCopy component
    click_to_copy = rendered.css("[data-controller*='click-to-copy']").first
    assert click_to_copy
    assert_equal "copy me", click_to_copy["data-decor--click-to-copy-to-copy-value"]

    # Should have icon inside ClickToCopy
    icon = click_to_copy.css("svg").first
    assert icon
  end

  def test_renders_terminal_variant
    component = Decor::CodeBlock.new(variant: :terminal)

    rendered = render_fragment(component) do
      "$ npm install\n> installing...\n> Done!"
    end

    # Should use mockup-code
    mockup = rendered.css(".mockup-code").first
    assert mockup

    # Should have pre elements with prefixes
    pres = rendered.css("pre")
    assert_equal 3, pres.length
    assert_equal "$", pres[0]["data-prefix"]
    assert_equal ">", pres[1]["data-prefix"]
    assert_equal ">", pres[2]["data-prefix"]
  end

  def test_renders_with_line_numbers
    component = Decor::CodeBlock.new(show_line_numbers: true)

    rendered = render_fragment(component) do
      "line 1\nline 2\nline 3"
    end

    # Should have line numbers column
    line_numbers = rendered.css(".select-none").first
    assert line_numbers
    assert_includes line_numbers.text, "1"
    assert_includes line_numbers.text, "2"
    assert_includes line_numbers.text, "3"

    # Should have flex layout
    flex_container = rendered.css(".flex").first
    assert flex_container
  end

  def test_highlights_specific_lines
    component = Decor::CodeBlock.new(
      show_line_numbers: true,
      highlight_lines: [2]
    )

    rendered = render_fragment(component) do
      "normal line\nhighlighted line\nanother normal line"
    end

    # Should have highlight class on line 2
    lines = rendered.css(".flex-1 > div")
    assert_equal 3, lines.length
    assert_includes lines[1]["class"], "bg-warning/20"
  end

  def test_terminal_variant_with_highlights
    component = Decor::CodeBlock.new(
      variant: :terminal,
      highlight_lines: [2]
    )

    rendered = render_fragment(component) do
      "$ command one\n> output\n> error!"
    end

    pres = rendered.css("pre")
    assert_includes pres[1]["class"], "bg-warning"
    assert_includes pres[1]["class"], "text-warning-content"
  end

  def test_renders_with_both_filename_and_copy_button
    component = Decor::CodeBlock.new(
      filename: "example.rb",
      copy_button: true
    )

    rendered = render_fragment(component) { "puts 'Hello'" }

    # Should have both filename and copy button
    assert_includes rendered.text, "example.rb"
    assert rendered.css("[data-controller*='click-to-copy']").first
  end

  def test_empty_content
    component = Decor::CodeBlock.new

    rendered = render_fragment(component)

    # Should still render structure
    assert rendered.css(".rounded-lg").first
    assert rendered.css("pre").first
  end

  def test_multiline_code_formatting
    component = Decor::CodeBlock.new(language: "ruby")

    rendered = render_fragment(component) do
      <<~RUBY
        class Example
          def initialize(name)
            @name = name
          end
        end
      RUBY
    end

    code = rendered.css("code").first
    assert code
    assert_includes code.text, "class Example"
    assert_includes code.text, "def initialize"
  end

  def test_stimulus_controller_setup
    component = Decor::CodeBlock.new(copy_button: true)

    rendered = render_fragment(component) { "code" }

    # When copy_button is true, the component should have ClickToCopy with stimulus controller
    assert_includes rendered.to_html, "data-controller=\"decor--click-to-copy\""
    assert_includes rendered.to_html, "data-decor--click-to-copy-to-copy-value=\"code\""
  end

  def test_stimulus_controller_values
    component = Decor::CodeBlock.new(language: "javascript", highlight: true)

    rendered = render_fragment(component) { "const x = 42;" }

    # Should have code block controller with values
    assert_includes rendered.to_html, "data-controller=\"decor--code-block\""
    assert_includes rendered.to_html, "data-decor--code-block-language-value=\"javascript\""
    assert_includes rendered.to_html, "data-decor--code-block-highlight-value=\"true\""
    assert_includes rendered.to_html, "data-decor--code-block-target=\"code\""
  end
end
