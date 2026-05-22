# @label PropertyCard
class ::Decor::Suite::PropertyCardPreview < ::Lookbook::Preview
  # PropertyCard (Suite)
  # --------------------
  #
  # Card-shaped grouping of label/value pairs with a left accent edge,
  # title row, optional CTA slot, and a grid-or-rows body. Use for
  # dashboard tiles, settings summaries, or any compact record-detail
  # block that benefits from a stronger surface than a PropertyStrip.
  #
  # @group Examples
  # @label Default (3-col grid, primary accent)
  def default
    render ::Decor::Suite::PropertyCard.new(title: "Order summary") do |card|
      card.with_property(label: "Reference", value: "PO-10042")
      card.with_property(label: "Status", value: "Open")
      card.with_property(label: "Total", value: "$1,248.50")
    end
  end

  # @group Examples
  # @label Rows layout
  def rows_layout
    render ::Decor::Suite::PropertyCard.new(title: "Customer details", layout: :rows) do |card|
      card.with_property(label: "Name", value: "Acme Co.")
      card.with_property(label: "Account #", value: "ACC-9981")
      card.with_property(label: "Owner", value: "Procurement", meta: "primary contact")
    end
  end

  # @group Examples
  # @label With CTA slot
  def with_cta
    render ::Decor::Suite::PropertyCard.new(title: "Billing address") do |card|
      card.with_cta { '<a href="#" class="decor:text-suite-primary-700 decor:suite-label decor:underline">Edit</a>'.html_safe }
      card.with_property(label: "Street", value: "123 Main St")
      card.with_property(label: "City", value: "Brooklyn")
      card.with_property(label: "Zip", value: "11201")
    end
  end

  # @group Examples
  # @label Accent variants
  def accents
    render ::Decor::Suite::PropertyCard.new(title: "Success accent", accent: :success) do |card|
      card.with_property(label: "Outcome", value: "Approved")
      card.with_property(label: "Reviewed", value: "today")
    end
  end

  # @group Examples
  # @label 4-column grid
  def four_columns
    render ::Decor::Suite::PropertyCard.new(title: "Quarter metrics", columns: 4) do |card|
      card.with_property(label: "Q1", value: "$120k")
      card.with_property(label: "Q2", value: "$145k")
      card.with_property(label: "Q3", value: "$162k")
      card.with_property(label: "Q4", value: "$188k")
    end
  end

  # @group Playground
  # @param title text
  # @param accent [Symbol] select [primary, success, warning, danger, neutral]
  # @param layout [Symbol] select [grid, rows]
  # @param columns [Integer] select [2, 3, 4]
  def playground(title: "Card title", accent: :primary, layout: :grid, columns: 3)
    render ::Decor::Suite::PropertyCard.new(title: title, accent: accent, layout: layout, columns: columns) do |card|
      card.with_property(label: "Alpha", value: "AAA")
      card.with_property(label: "Beta", value: "BBB")
      card.with_property(label: "Gamma", value: "CCC")
    end
  end
end
