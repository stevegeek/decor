# @label Card
class ::Decor::Suite::CardPreview < ::Lookbook::Preview
  # Card (Suite)
  # ------------
  #
  # Muted-chrome container with optional header / title / footer slots and a
  # body block. Use for grouping admin form-step content or settings panels.
  #
  # @group Examples
  # @label Body only
  def body_only
    render ::Decor::Suite::Card.new do
      "Just some body content rendered inside the card.".html_safe
    end
  end

  # @group Examples
  # @label Header + body
  def header_and_body
    render ::Decor::Suite::Card.new do |card|
      card.with_header { "<strong>Header content</strong>".html_safe }
      "Body text appears beneath the header row.".html_safe
    end
  end

  # @group Examples
  # @label Title + body
  def title_and_body
    render ::Decor::Suite::Card.new do |card|
      card.with_title { "Section title" }
      "Body text appears beneath the title row.".html_safe
    end
  end

  # @group Examples
  # @label Header + title + body + footer
  def header_title_body_footer
    render ::Decor::Suite::Card.new do |card|
      card.with_header { "<em>Toolbar / breadcrumb area</em>".html_safe }
      card.with_title { "Card title" }
      card.with_footer { "<button class=\"decor:px-3 decor:py-1\">Save</button>".html_safe }
      "Multi-slot card with all four regions rendered in order.".html_safe
    end
  end

  # @group Playground
  # @param header text
  # @param title text
  # @param body text
  # @param footer text
  def playground(header: "Optional header", title: "Card title", body: "Card body content.", footer: "Footer actions")
    render ::Decor::Suite::Card.new do |card|
      card.with_header { header } if header.present?
      card.with_title { title } if title.present?
      card.with_footer { footer } if footer.present?
      body.to_s.html_safe
    end
  end
end
