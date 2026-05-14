# @label ClickToCopy
class ::Decor::Daisy::ClickToCopyPreview < ::Lookbook::Preview
  # ClickToCopy
  # -------
  #
  # A simple tag component which can be used to copy-on-click whatever text it is wrapped around.
  # It provides visual feedback when text is copied and supports custom display text.
  #
  # @group Examples
  # @label Basic Copy
  def basic_copy
    render ::Decor::Daisy::ClickToCopy.new do
      "Click to copy me!"
    end
  end

  # @group Examples
  # @label Copy with Different Display
  def copy_with_different_display
    render ::Decor::Daisy::ClickToCopy.new(to_copy: "secret@email.com") do
      "Click to copy email"
    end
  end

  # @group Examples
  # @label Default Icon Copy
  def default_icon_copy
    render ::Decor::Daisy::ClickToCopy.new(to_copy: "Text to copy")
  end

  # @group Playground
  # @param text text
  # @param to_copy text
  # @param size [Symbol] select [~, xs, sm, md, lg, xl]
  # @param color [Symbol] select [~, base, primary, secondary, accent, neutral, success, error, warning, info]
  # @param style [Symbol] select [~, filled, outlined, ghost]
  def playground(text: "Click to copy me!", to_copy: nil, size: nil, color: nil, style: nil)
    render ::Decor::Daisy::ClickToCopy.new(to_copy: to_copy, size: size, color: color, style: style) do
      text
    end
  end

  # @group Examples
  # @label API Key Copy
  def api_key_copy
    render ::Decor::Daisy::Element.new do |el|
      el.div do
        el.h4(class: "decor:font-semibold decor:mb-2") { "API Key:" }
        el.render ::Decor::Daisy::ClickToCopy.new(to_copy: "sk-1234567890abcdef") do
          el.code(class: "decor:bg-gray-100 decor:px-2 decor:py-1 decor:rounded") { "sk-****cdef" }
        end
      end
    end
  end

  # @group Examples
  # @label Share Link Copy
  def share_link_copy
    render ::Decor::Daisy::Element.new do |el|
      el.div do
        el.h4(class: "decor:font-semibold decor:mb-2") { "Share Link:" }
        el.render ::Decor::Daisy::ClickToCopy.new do
          el.span(class: "decor:text-blue-600 decor:underline") { "https://example.com/share/xyz" }
        end
      end
    end
  end

  # @group Examples
  # @label Quick Copy Icon
  def quick_copy_icon
    render ::Decor::Daisy::Element.new do |el|
      el.div do
        el.h4(class: "decor:font-semibold decor:mb-2") { "Quick Copy Icon:" }
        el.render ::Decor::Daisy::ClickToCopy.new(to_copy: "Quick copy text")
      end
    end
  end
end
