# @label PropertyList
class ::Decor::Suite::PropertyListPreview < ::Lookbook::Preview
  # PropertyList (Suite)
  # --------------------
  #
  # Vertical sibling to PropertyStrip — one or more sections of
  # label/value rows inside a muted card surface, with optional title,
  # CTA slot, and section kickers. Section bodies typically contain
  # `Decor::Suite::Property` rows; use `:grid` layout for multi-column
  # records, `:rows` (default) for stacked detail blocks.
  #
  # @group Examples
  # @label Single section, rows layout
  def single_section_rows
    render ::Decor::Suite::PropertyList.new(title: "User details") do |list|
      list.with_section do
        render ::Decor::Suite::Property.new(label: "Name", value: "Martha Archer", layout: :row)
        render ::Decor::Suite::Property.new(label: "Email", value: "martha@example.com", layout: :row)
        render ::Decor::Suite::Property.new(label: "Phone", value: "+1 555-0142", layout: :row)
      end
    end
  end

  # @group Examples
  # @label Multiple sections with kickers
  def multi_section_with_kickers
    render ::Decor::Suite::PropertyList.new(title: "Order PO-10042") do |list|
      list.with_section(kicker: "Buyer") do
        render ::Decor::Suite::Property.new(label: "Company", value: "Acme Co.", layout: :row)
        render ::Decor::Suite::Property.new(label: "Contact", value: "Jane Doe", layout: :row)
      end
      list.with_section(kicker: "Shipping") do
        render ::Decor::Suite::Property.new(label: "Address", value: "100 Main St, Brooklyn NY", layout: :row)
        render ::Decor::Suite::Property.new(label: "Method", value: "Ground, 3-day", layout: :row)
      end
      list.with_section(kicker: "Totals") do
        render ::Decor::Suite::Property.new(label: "Subtotal", value: "$1,100.00", layout: :row)
        render ::Decor::Suite::Property.new(label: "Tax", value: "$96.25", layout: :row)
        render ::Decor::Suite::Property.new(label: "Total", value: "$1,196.25", layout: :row)
      end
    end
  end

  # @group Examples
  # @label Grid layout (3 columns)
  def grid_layout
    render ::Decor::Suite::PropertyList.new(title: "Import summary", layout: :grid, columns: 3) do |list|
      list.with_section do
        render ::Decor::Suite::Property.new(label: "Rows processed", value: "1,248")
        render ::Decor::Suite::Property.new(label: "Successes", value: "1,210")
        render ::Decor::Suite::Property.new(label: "Failures", value: "38")
        render ::Decor::Suite::Property.new(label: "Started", value: "2026-05-12 09:14")
        render ::Decor::Suite::Property.new(label: "Finished", value: "2026-05-12 09:18")
        render ::Decor::Suite::Property.new(label: "Duration", value: "4m 12s")
      end
    end
  end

  # @group Examples
  # @label With CTA
  def with_cta
    render ::Decor::Suite::PropertyList.new(title: "Customer details") do |list|
      list.with_cta { '<a href="#" class="decor:text-suite-primary-700 decor:underline">Edit</a>'.html_safe }
      list.with_section do
        render ::Decor::Suite::Property.new(label: "Name", value: "Acme Co.", layout: :row)
        render ::Decor::Suite::Property.new(label: "Contact", value: "Jane Doe", layout: :row)
        render ::Decor::Suite::Property.new(label: "Email", value: "jane@acme.com", layout: :row)
      end
    end
  end

  # @group Playground
  # @param title text
  # @param layout [Symbol] select [rows, grid]
  # @param columns [Integer] select [2, 3, 4]
  # @param with_cta toggle
  def playground(title: "Details", layout: :rows, columns: 3, with_cta: false)
    render ::Decor::Suite::PropertyList.new(title: title, layout: layout.to_sym, columns: columns.to_i) do |list|
      list.with_cta { '<a href="#" class="decor:text-suite-primary-700 decor:underline">Edit</a>'.html_safe } if with_cta
      list.with_section(kicker: "Identity") do
        render ::Decor::Suite::Property.new(label: "Name", value: "Acme Co.", layout: (layout.to_sym == :grid) ? :stack : :row)
        render ::Decor::Suite::Property.new(label: "Reference", value: "ACM-001", layout: (layout.to_sym == :grid) ? :stack : :row)
        render ::Decor::Suite::Property.new(label: "Owner", value: "Procurement", layout: (layout.to_sym == :grid) ? :stack : :row)
      end
      list.with_section(kicker: "Activity") do
        render ::Decor::Suite::Property.new(label: "Created", value: "2026-04-01", layout: (layout.to_sym == :grid) ? :stack : :row)
        render ::Decor::Suite::Property.new(label: "Updated", value: "today", layout: (layout.to_sym == :grid) ? :stack : :row)
      end
    end
  end
end
