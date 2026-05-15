# @label PropertyStrip
class ::Decor::Suite::PropertyStripPreview < ::Lookbook::Preview
  # PropertyStrip (Suite)
  # ---------------------
  #
  # Inline horizontal strip of label/value pairs in an auto-fit grid.
  # Use for record-summary headers, dense admin metadata blocks, and
  # contextual property rollups above page content.
  #
  # @group Examples
  # @label Plain values
  def plain_values
    render ::Decor::Suite::PropertyStrip.new do |strip|
      strip.with_property(label: "Order #", value: "PO-10042")
      strip.with_property(label: "Status", value: "Open")
      strip.with_property(label: "Total", value: "$1,248.50")
      strip.with_property(label: "Created", value: "2026-05-12")
    end
  end

  # @group Examples
  # @label With title and subtitle
  def with_title_and_subtitle
    render ::Decor::Suite::PropertyStrip.new(title: "Summary", subtitle: "Key facts about this record") do |strip|
      strip.with_property(label: "Reference", value: "REF-9981")
      strip.with_property(label: "Owner", value: "Procurement")
      strip.with_property(label: "Updated", value: "2 hours ago")
    end
  end

  # @group Examples
  # @label With meta captions
  def with_meta
    render ::Decor::Suite::PropertyStrip.new do |strip|
      strip.with_property(label: "Subtotal", value: "$1,100.00", meta: "before tax")
      strip.with_property(label: "Tax", value: "$96.25", meta: "8.75%")
      strip.with_property(label: "Shipping", value: "$52.25", meta: "ground, 3-day")
      strip.with_property(label: "Total", value: "$1,248.50", meta: "USD")
    end
  end

  # @group Examples
  # @label With icons
  def with_icons
    render ::Decor::Suite::PropertyStrip.new do |strip|
      strip.with_property(label: "Customer", value: "Acme Co.", icon: "user")
      strip.with_property(label: "Location", value: "Brooklyn, NY", icon: "map-pin")
      strip.with_property(label: "Email", value: "ops@example.com", icon: "envelope")
    end
  end

  # @group Examples
  # @label Block-rendered values (rich content)
  def block_values
    render ::Decor::Suite::PropertyStrip.new do |strip|
      strip.with_property(label: "Customer") do
        '<a href="#" class="decor:text-suite-primary-700 decor:underline">Acme Co.</a>'.html_safe
      end
      strip.with_property(label: "Status") do
        '<span class="decor:bg-suite-success-50 decor:text-suite-success-700 decor:px-2 decor:py-0.5 decor:rounded-suite-control">Active</span>'.html_safe
      end
      strip.with_property(label: "Plain", value: "Regular text")
    end
  end

  # @group Playground
  # @param title text
  # @param subtitle text
  # @param min_column_width number
  def playground(title: "Order summary", subtitle: "Snapshot of the key fields", min_column_width: 140)
    render ::Decor::Suite::PropertyStrip.new(title: title, subtitle: subtitle, min_column_width: min_column_width) do |strip|
      strip.with_property(label: "Reference", value: "REF-0042")
      strip.with_property(label: "Owner", value: "Procurement")
      strip.with_property(label: "Total", value: "$1,248.50", meta: "USD")
      strip.with_property(label: "Updated", value: "today")
    end
  end
end
