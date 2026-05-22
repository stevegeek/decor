# frozen_string_literal: true

require "test_helper"

class Decor::Daisy::CodeBlockTest < ActiveSupport::TestCase
  def test_renders_basic_code_block
    component = Decor::Daisy::CodeBlock.new

    rendered = render_fragment(component) do
      "function hello() {\n  console.log('Hello, world!');\n}"
    end

    wrapper = rendered.css(".rounded-lg").first
    assert wrapper

    pre = rendered.css("pre").first
    assert pre
    assert_includes pre["class"], "p-4"
    assert_includes pre["class"], "overflow-x-auto"

    code = rendered.css("code").first
    assert code
    assert_includes code["class"], "font-mono"
  end

  def test_renders_with_language
    component = Decor::Daisy::CodeBlock.new(language: "javascript", highlight: true)

    rendered = render_fragment(component) { "const x = 42;" }

    code = rendered.css("code").first
    assert_includes code["class"], "language-javascript"
  end

  def test_renders_with_filename
    component = Decor::Daisy::CodeBlock.new(filename: "app.js")

    rendered = render_fragment(component) { "// code here" }

    header = rendered.css(".border-b").first
    assert header

    assert_includes rendered.text, "app.js"
  end

  def test_renders_with_copy_button
    component = Decor::Daisy::CodeBlock.new(copy_button: true)

    rendered = render_fragment(component) { "copy me" }

    click_to_copy = rendered.css("[data-controller*='click-to-copy']").first
    assert click_to_copy
    assert_equal "copy me", click_to_copy["data-decor--daisy--click-to-copy-to-copy-value"]

    icon = click_to_copy.css("svg").first
    assert icon
  end

  def test_renders_terminal_variant
    component = Decor::Daisy::CodeBlock.new(style: :terminal)

    rendered = render_fragment(component) do
      "$ npm install\n> installing...\n> Done!"
    end

    mockup = rendered.css(".mockup-code").first
    assert mockup

    pres = rendered.css("pre")
    assert_equal 3, pres.length
    assert_equal "$", pres[0]["data-prefix"]
    assert_equal ">", pres[1]["data-prefix"]
    assert_equal ">", pres[2]["data-prefix"]
  end

  def test_renders_with_line_numbers
    component = Decor::Daisy::CodeBlock.new(show_line_numbers: true)

    rendered = render_fragment(component) do
      "line 1\nline 2\nline 3"
    end

    line_numbers = rendered.css(".select-none").first
    assert line_numbers
    assert_includes line_numbers.text, "1"
    assert_includes line_numbers.text, "2"
    assert_includes line_numbers.text, "3"

    flex_container = rendered.css(".flex").first
    assert flex_container
  end

  def test_highlights_specific_lines
    component = Decor::Daisy::CodeBlock.new(
      show_line_numbers: true,
      highlight_lines: [2]
    )

    rendered = render_fragment(component) do
      "normal line\nhighlighted line\nanother normal line"
    end

    lines = rendered.css(".flex-1 > div")
    assert_equal 3, lines.length
    assert_includes lines[1]["class"], "bg-warning/20"
  end

  def test_terminal_variant_with_highlights
    component = Decor::Daisy::CodeBlock.new(
      style: :terminal,
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
    component = Decor::Daisy::CodeBlock.new(
      filename: "example.rb",
      copy_button: true
    )

    rendered = render_fragment(component) { "puts 'Hello'" }

    assert_includes rendered.text, "example.rb"
    assert rendered.css("[data-controller*='click-to-copy']").first
  end

  def test_empty_content
    component = Decor::Daisy::CodeBlock.new

    rendered = render_fragment(component)

    assert rendered.css(".rounded-lg").first
    assert rendered.css("pre").first
  end

  def test_multiline_code_formatting
    component = Decor::Daisy::CodeBlock.new(language: "ruby")

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
    component = Decor::Daisy::CodeBlock.new(copy_button: true)

    rendered = render_fragment(component) { "code" }

    assert_includes rendered.to_html, "data-controller=\"decor--daisy--click-to-copy\""
    assert_includes rendered.to_html, "data-decor--daisy--click-to-copy-to-copy-value=\"code\""
  end

  def test_stimulus_controller_values
    component = Decor::Daisy::CodeBlock.new(language: "javascript", highlight: true)

    rendered = render_fragment(component) { "const x = 42;" }

    assert_includes rendered.to_html, "data-controller=\"decor--daisy--code-block\""
    assert_includes rendered.to_html, "data-decor--daisy--code-block-language-value=\"javascript\""
    assert_includes rendered.to_html, "data-decor--daisy--code-block-highlight-value=\"true\""
    assert_includes rendered.to_html, "data-decor--daisy--code-block-target=\"code\""
  end
end
