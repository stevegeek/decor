# @label ClickToCopy
class ::Decor::ClickToCopyPreview < ::Lookbook::Preview
  # ClickToCopy
  # -------
  #
  # A simple tag component which can be used to copy-on-click whatever text it is wrapped around
  #
  # @label Playground
  def playground
    render ::Decor::ClickToCopy.new do
      "Click to copy me!"
    end
  end

  # @label With custom content
  def with_custom_content
    render ::Decor::ClickToCopy.new do
      "Copy this custom text"
    end
  end

  # @label With different display and copy text
  def with_different_display_and_copy_text
    render ::Decor::ClickToCopy.new(to_copy: "secret@email.com") do
      "Click to copy email"
    end
  end

  # @label Default icon (no block)
  def default_icon
    render ::Decor::ClickToCopy.new(to_copy: "Text to copy")
  end

  # @label Multiple instances
  def multiple_instances
    render ::Decor::Element.new do |el|
      el.div(class: "space-y-4") do
        div do
          h4(class: "font-semibold mb-2") { "API Key:" }
          render ::Decor::ClickToCopy.new(to_copy: "sk-1234567890abcdef") do
            code(class: "bg-gray-100 px-2 py-1 rounded") { "sk-****cdef" }
          end
        end

        div do
          h4(class: "font-semibold mb-2") { "Share Link:" }
          render ::Decor::ClickToCopy.new do
            span(class: "text-blue-600 underline") { "https://example.com/share/xyz" }
          end
        end

        div do
          h4(class: "font-semibold mb-2") { "Quick Copy Icon:" }
          render ::Decor::ClickToCopy.new(to_copy: "Quick copy text")
        end
      end
    end
  end
end
