# @label DataTableCell
class ::Decor::Suite::Tables::DataTableCellPreview < ::Lookbook::Preview
  # DataTableCell (Suite)
  # ---------------------
  #
  # `<td>` with Suite typography + hairline divider. Supports optional
  # cell-to-row link overlay (absolutely-positioned anchor that fills the
  # cell, keeping ctrl-click + middle-click navigation alive on rows that
  # otherwise navigate via a row-level click handler).

  # @group Examples
  # @label Default
  def default
    render_example(value: "Sample cell content")
  end

  # @group Examples
  # @label Numeric (right-aligned, tabular nums)
  def numeric
    render_example(value: "$1,234.56", numeric: true)
  end

  # @group Examples
  # @label Compact density
  def compact
    render_example(value: "compact row", compact: true)
  end

  # @group Examples
  # @label Tight row height
  def tight
    render_example(value: "tight", row_height: :tight)
  end

  # @group Examples
  # @label Comfortable row height
  def comfortable
    render_example(value: "comfortable", row_height: :comfortable)
  end

  # @group Examples
  # @label Link overlay (cell-to-row nav)
  def link_overlay
    render_example(value: "Open record", path: "/example/123")
  end

  # @group Examples
  # @label Centered content
  def centered
    render_example(value: "centered", align: :center)
  end

  # @group Examples
  # @label Width constraints
  def width_constraints
    render_example(
      value: "This is a very long cell content that should be truncated when constrained",
      max_width: 200,
      min_width_rem: 10
    )
  end

  # @group Typography
  # @label Emphasis levels
  def emphasis_levels
    render_table do |t|
      [:regular, :low].each do |emphasis|
        t.row do
          t.render ::Decor::Suite::Tables::DataTableCell.new(
            value: "#{emphasis.to_s.capitalize} emphasis",
            emphasis: emphasis
          )
        end
      end
    end
  end

  # @group Typography
  # @label Font weights
  def font_weights
    render_table do |t|
      [:light, :regular, :medium].each do |weight|
        t.row do
          t.render ::Decor::Suite::Tables::DataTableCell.new(
            value: "#{weight.to_s.capitalize} weight",
            weight: weight
          )
        end
      end
    end
  end

  # @group Playground
  # @param value text
  # @param numeric toggle
  # @param compact toggle
  # @param emphasis [Symbol] select [regular, low]
  # @param weight [Symbol] select [light, regular, medium]
  # @param row_height [Symbol] select [comfortable, standard, tight]
  # @param align [Symbol] select [~, left, center, right]
  # @param content_clickable toggle
  # @param path text
  # @param max_width number
  # @param min_width_rem number
  def playground(
    value: "Sample cell content",
    numeric: false,
    compact: false,
    emphasis: :regular,
    weight: :regular,
    row_height: :standard,
    align: nil,
    content_clickable: false,
    path: nil,
    max_width: nil,
    min_width_rem: nil
  )
    render_example(
      value: value,
      numeric: numeric,
      compact: compact,
      emphasis: emphasis,
      weight: weight,
      row_height: row_height,
      align: align,
      content_clickable: content_clickable,
      path: path,
      max_width: max_width,
      min_width_rem: min_width_rem
    )
  end

  private

  def render_example(**options)
    render_table do |t|
      t.row { t.render ::Decor::Suite::Tables::DataTableCell.new(**options) }
    end
  end

  def render_table(&)
    render ::Decor::Daisy::Element.new do |e|
      e.table(class: "decor:min-w-full decor:border decor:border-suite-hairline") do
        e.tbody do
          wrapper = TableWrapper.new(e)
          yield wrapper
        end
      end
    end
  end

  class TableWrapper
    def initialize(element)
      @e = element
    end

    def row(&block)
      @e.tr(class: "decor:bg-white") { block.call }
    end

    def render(component)
      @e.render(component)
    end
  end
end
