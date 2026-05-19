# frozen_string_literal: true

require "test_helper"

class ::Decor::Suite::CodeBlockTest < ActiveSupport::TestCase
  test "root has suite surface chrome with hairline + suite-card corners" do
    html = render_component(::Decor::Suite::CodeBlock.new) { "puts 'hi'" }
    assert_includes html, "decor:bg-suite-gray-25"
    assert_includes html, "decor:border-suite-hairline"
    assert_includes html, "decor:rounded-suite-card"
    assert_includes html, "decor:overflow-hidden"
  end

  test "renders pre + code body with font-mono" do
    rendered = render_fragment(::Decor::Suite::CodeBlock.new) { "function hi(){}" }
    pre = rendered.css("pre").first
    assert pre
    assert_includes pre["class"], "decor:overflow-x-auto"
    code = rendered.css("code").first
    assert code
    assert_includes code["class"], "decor:font-mono"
  end

  test "applies decor:language-<lang> class when highlight is on" do
    rendered = render_fragment(::Decor::Suite::CodeBlock.new(language: "ruby", highlight: true)) { "x = 1" }
    code = rendered.css("code").first
    assert_includes code["class"], "decor:language-ruby"
  end

  test "omits language class when highlight is off" do
    rendered = render_fragment(::Decor::Suite::CodeBlock.new(language: "ruby")) { "x = 1" }
    code = rendered.css("code").first
    refute_includes code["class"], "language-ruby"
  end

  test "header is omitted when neither filename nor copy_button set" do
    rendered = render_fragment(::Decor::Suite::CodeBlock.new) { "x" }
    assert_nil rendered.css(".decor\\:border-b").first
  end

  test "renders filename in header with suite-description typography" do
    html = render_component(::Decor::Suite::CodeBlock.new(filename: "app.rb")) { "puts 1" }
    assert_includes html, "app.rb"
    assert_includes html, "decor:suite-description"
    assert_includes html, "decor:border-b"
  end

  test "renders Suite ClickToCopy in header when copy_button is true" do
    html = render_component(::Decor::Suite::CodeBlock.new(copy_button: true)) { "copy me" }
    assert_includes html, "decor--suite--click-to-copy"
    assert_includes html, "to-copy-value=\"copy me\""
  end

  test "terminal style swaps surface to dark and renders one pre per line with prompts" do
    rendered = render_fragment(::Decor::Suite::CodeBlock.new(style: :terminal)) do
      "$ bin/rails s\n> Listening on http://localhost:3000\n> Ready."
    end
    pres = rendered.css("pre")
    assert_equal 3, pres.length
    prompts = pres.map { |p| p.css("span").first.text }
    assert_equal ["$", ">", ">"], prompts
    assert_includes rendered.to_html, "decor:bg-gray-900"
  end

  test "line numbers render in a select-none column" do
    rendered = render_fragment(::Decor::Suite::CodeBlock.new(show_line_numbers: true)) do
      "a\nb\nc"
    end
    column = rendered.css(".decor\\:select-none").first
    assert column
    assert_includes column.text, "1"
    assert_includes column.text, "2"
    assert_includes column.text, "3"
  end

  test "highlight_lines marks the matching line wrapper" do
    rendered = render_fragment(::Decor::Suite::CodeBlock.new(show_line_numbers: true, highlight_lines: [2])) do
      "one\ntwo\nthree"
    end
    rows = rendered.css(".decor\\:flex-1 > div")
    assert_equal 3, rows.length
    refute_includes rows[0]["class"], "decor:bg-amber-500"
    assert_includes rows[1]["class"], "decor:bg-amber-500"
    refute_includes rows[2]["class"], "decor:bg-amber-500"
  end

  test "stimulus identifier binds to the daisy code_block controller" do
    html = render_component(::Decor::Suite::CodeBlock.new(language: "javascript", highlight: true)) { "const x = 1;" }
    assert_includes html, "data-controller=\"decor--daisy--code-block\""
    assert_includes html, "data-decor--daisy--code-block-language-value=\"javascript\""
    assert_includes html, "data-decor--daisy--code-block-highlight-value=\"true\""
    assert_includes html, "data-decor--daisy--code-block-target=\"code\""
  end

  test "renders both filename and copy button together" do
    html = render_component(::Decor::Suite::CodeBlock.new(filename: "main.rb", copy_button: true)) { "puts :ok" }
    assert_includes html, "main.rb"
    assert_includes html, "decor--suite--click-to-copy"
  end

  test "empty content still renders structural wrapper + pre" do
    rendered = render_fragment(::Decor::Suite::CodeBlock.new)
    assert rendered.css("pre").first
    assert_includes rendered.to_html, "decor:rounded-suite-card"
  end
end
