# @label CodeSnippet
class ::Decor::CodeSnippetPreview < ::Lookbook::Preview
  # CodeSnippet
  # ----------
  #
  # Inline code snippets with various styling options
  #
  # @label Playground
  # @param variant select [default, primary, secondary, accent]
  # @param size select [xs, sm, normal, lg]
  def playground(variant: :default, size: :normal)
    render ::Decor::CodeSnippet.new(variant: variant, size: size) do
      "const greeting = 'Hello, World!';"
    end
  end

  # @label Default styling
  def default_styling
    render Decor::Element.new(classes: "space-y-4") do |el|
      el.p do
        el.plain "Run "
        el.render ::Decor::CodeSnippet.new { "npm install" }
        el.plain " to install dependencies."
      end

      el.p do
        el.plain "The "
        el.render ::Decor::CodeSnippet.new { "useState" }
        el.plain " hook is commonly used in React."
      end
    end
  end

  # @label Variant examples
  def variant_examples
    render Decor::Element.new(classes: "space-y-4") do |el|
      el.div do
        el.h4(class: "font-semibold mb-2") { "Default:" }
        el.render ::Decor::CodeSnippet.new { "console.log('default')" }
      end

      el.div do
        el.h4(class: "font-semibold mb-2") { "Primary:" }
        el.render ::Decor::CodeSnippet.new(variant: :primary) { "console.log('primary')" }
      end

      el.div do
        el.h4(class: "font-semibold mb-2") { "Secondary:" }
        el.render ::Decor::CodeSnippet.new(variant: :secondary) { "console.log('secondary')" }
      end

      el.div do
        el.h4(class: "font-semibold mb-2") { "Accent:" }
        el.render ::Decor::CodeSnippet.new(variant: :accent) { "console.log('accent')" }
      end
    end
  end

  # @label Size examples
  def size_examples
    render Decor::Element.new(classes: "space-y-4") do |el|
      el.div do
        el.h4(class: "font-semibold mb-2") { "Extra Small (xs):" }
        el.render ::Decor::CodeSnippet.new(size: :xs) { "tiny_code()" }
      end

      el.div do
        el.h4(class: "font-semibold mb-2") { "Small (sm):" }
        el.render ::Decor::CodeSnippet.new(size: :sm) { "small_code()" }
      end

      el.div do
        el.h4(class: "font-semibold mb-2") { "Normal:" }
        el.render ::Decor::CodeSnippet.new(size: :normal) { "normal_code()" }
      end

      el.div do
        el.h4(class: "font-semibold mb-2") { "Large (lg):" }
        el.render ::Decor::CodeSnippet.new(size: :lg) { "large_code()" }
      end
    end
  end

  # @label In context
  def in_context
    render Decor::Element.new(classes: "prose max-w-none") do |el|
      el.p do
        el.plain "To authenticate, include your API key in the "
        el.render ::Decor::CodeSnippet.new { "Authorization" }
        el.plain " header:"
      end

      el.p do
        el.render ::Decor::CodeSnippet.new(variant: :primary) { "Bearer YOUR_API_KEY" }
      end

      el.p do
        el.plain "You can also use the "
        el.render ::Decor::CodeSnippet.new { "X-API-Key" }
        el.plain " header as an alternative."
      end

      el.p do
        el.plain "Send a POST request to "
        el.render ::Decor::CodeSnippet.new(variant: :accent) { "/api/v1/users" }
        el.plain " with the following payload:"
      end
    end
  end

  # @label Special characters
  def special_characters
    render Decor::Element.new(classes: "space-y-4") do |el|
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
