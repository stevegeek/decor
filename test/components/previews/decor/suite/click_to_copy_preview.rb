# @label ClickToCopy
class ::Decor::Suite::ClickToCopyPreview < ::Lookbook::Preview
  # @label Playground
  # @param variant select [chip, inline]
  # @param content text
  def playground(variant: :chip, content: "ENT-2024-001")
    render ::Decor::Suite::ClickToCopy.new(variant: variant) do
      content
    end
  end

  # @label Chip variant
  def chip_variant
    render ::Decor::Suite::ClickToCopy.new(variant: :chip) { "abc-123-xyz" }
  end

  # @label Inline variant
  def inline_variant
    render ::Decor::Suite::ClickToCopy.new(variant: :inline) { "abc-123" }
  end

  # @label With to_copy prop override
  def with_to_copy_override
    render ::Decor::Suite::ClickToCopy.new(variant: :chip, to_copy: "different-secret-value") do
      "displayed-text"
    end
  end
end
