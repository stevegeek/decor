# @label CodeSnippet
class ::Decor::CodeSnippetPreview < ::Lookbook::Preview
  # CodeSnippet
  # ----------
  #
  # Inline code snippets with various styling options.
  # Used to highlight code fragments within text content.
  # Supports different styles and sizes for visual emphasis.
  #
  # @group Examples
  # @label Basic Inline Code
  def basic_inline_code
    render ::Decor::Element.new do |el|
      el.p do
        el.plain "Run "
        el.render ::Decor::CodeSnippet.new { "npm install" }
        el.plain " to install dependencies."
      end
    end
  end

  # @group Examples
  # @label Colored Code Snippet
  def colored_code_snippet
    render ::Decor::Element.new do |el|
      el.p do
        el.plain "The function "
        el.render ::Decor::CodeSnippet.new(color: :primary) { "calculateTotal()" }
        el.plain " returns the sum of all items."
      end
    end
  end

  # @group Examples
  # @label API Endpoint
  def api_endpoint
    render ::Decor::Element.new do |el|
      el.p do
        el.plain "Send a POST request to "
        el.render ::Decor::CodeSnippet.new(color: :accent) { "/api/v1/users" }
        el.plain " to create a new user."
      end
    end
  end

  # @group Playground
  # @label Playground
  # @param size [Symbol] select [~, xs, sm, md, lg, xl]
  # @param color [Symbol] select [~, base, primary, secondary, accent, neutral, success, error, warning, info]
  # @param style [Symbol] select [~, filled, outlined, ghost]
  def playground(color: nil, style: nil, size: nil)
    render ::Decor::CodeSnippet.new(style: style, size: size) do
      "const greeting = 'Hello, World!';"
    end
  end

  # @group Colors
  # @label Default
  def color_default
    render ::Decor::CodeSnippet.new { "console.log('default')" }
  end

  # @group Colors
  # @label Primary style
  def color_primary
    render ::Decor::CodeSnippet.new(color: :primary) { "console.log('primary')" }
  end

  # @group Colors
  # @label Secondary style
  def color_secondary
    render ::Decor::CodeSnippet.new(color: :secondary) { "console.log('secondary')" }
  end

  # @group Colors
  # @label Accent style
  def color_accent
    render ::Decor::CodeSnippet.new(color: :accent) { "console.log('accent')" }
  end

  # @group Sizes
  # @label Extra Small Size
  def size_xs
    render ::Decor::CodeSnippet.new(size: :xs) { "tiny_code()" }
  end

  # @group Sizes
  # @label Small Size
  def size_sm
    render ::Decor::CodeSnippet.new(size: :sm) { "small_code()" }
  end

  # @group Sizes
  # @label Normal Size
  def size_normal
    render ::Decor::CodeSnippet.new(size: :normal) { "normal_code()" }
  end

  # @group Sizes
  # @label Large Size
  def size_lg
    render ::Decor::CodeSnippet.new(size: :lg) { "large_code()" }
  end

  # @group Examples
  # @label Authentication Header
  def authentication_header
    render ::Decor::Element.new(classes: "prose max-w-none") do |el|
      el.p do
        el.plain "To authenticate, include your API key in the "
        el.render ::Decor::CodeSnippet.new { "Authorization" }
        el.plain " header:"
      end
      el.p do
        el.render ::Decor::CodeSnippet.new(color: :primary) { "Bearer YOUR_API_KEY" }
      end
    end
  end

  # @group Examples
  # @label React Hook Usage
  def react_hook_usage
    render ::Decor::Element.new do |el|
      el.p do
        el.plain "The "
        el.render ::Decor::CodeSnippet.new { "useState" }
        el.plain " hook is commonly used in React for managing component state."
      end
    end
  end

  # @group Examples
  # @label Special Characters
  def special_characters
    render ::Decor::Element.new(classes: "space-y-4") do |el|
      el.p do
        el.plain "HTML entities: "
        el.render ::Decor::CodeSnippet.new { "<div class=\"container\">" }
      end
      el.p do
        el.plain "Regular expression: "
        el.render ::Decor::CodeSnippet.new { "/^[a-zA-Z0-9]+$/" }
      end
      el.p do
        el.plain "Template literal: "
        el.render ::Decor::CodeSnippet.new { "`Hello, ${name}!`" }
      end
    end
  end
end
