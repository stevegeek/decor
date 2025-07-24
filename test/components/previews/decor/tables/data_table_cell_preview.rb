# Table cell component for displaying data with formatting options and optional interactivity
# @label Data Table Cell
class ::Decor::Tables::DataTableCellPreview < ::Lookbook::Preview
  # @!group Examples

  # @label Default
  def default
    render_example(value: "Sample Cell Content")
  end

  # @label Numeric with alignment
  def numeric_aligned
    render_example(
      value: "$1,234.56",
      numeric: true
    )
  end

  # @label Clickable cell
  def clickable_with_path
    render_example(
      value: "View Details",
      content_clickable: true,
      path: "/details/123"
    )
  end

  # @label Constrained width
  def with_constraints
    render_example(
      value: "This is a very long cell content that should be constrained",
      max_width: 200,
      min_width_rem: 10
    )
  end

  # @!endgroup

  # @!group Playground

  # @label Playground
  # @param value text Cell content
  # @param numeric toggle Right-align for numeric values
  # @param emphasis [Symbol] select [regular, low] Visual emphasis level
  # @param weight [Symbol] select [light, regular, medium] Font weight
  # @param row_height [Symbol] select [comfortable, standard, tight] Cell padding
  # @param content_clickable toggle Make content clickable
  # @param path text Link destination when clickable
  # @param max_width number Maximum width in pixels
  # @param min_width_rem number Minimum width in rem units
  def playground(
    value: "Sample Cell Content",
    numeric: false,
    emphasis: :regular,
    weight: :regular,
    row_height: :standard,
    content_clickable: false,
    path: nil,
    max_width: nil,
    min_width_rem: nil
  )
    render_example(
      value: value,
      numeric: numeric,
      emphasis: emphasis,
      weight: weight,
      row_height: row_height,
      content_clickable: content_clickable,
      path: path,
      max_width: max_width,
      min_width_rem: min_width_rem
    )
  end

  # @!endgroup

  # @!group Typography

  # @label Emphasis levels
  def emphasis_levels
    render ::Decor::Element.new do |e|
      e.table(class: "min-w-full border border-gray-200") do
        e.tbody do
          [:regular, :low].each do |emphasis|
            e.tr(class: "bg-white border-b border-gray-200") do
              e.render ::Decor::Tables::DataTableCell.new(
                value: "#{emphasis.to_s.capitalize} emphasis",
                emphasis: emphasis
              )
            end
          end
        end
      end
    end
  end

  # @label Font weights
  def font_weights
    render ::Decor::Element.new do |e|
      e.table(class: "min-w-full border border-gray-200") do
        e.tbody do
          [:light, :regular, :medium].each do |weight|
            e.tr(class: "bg-white border-b border-gray-200") do
              e.render ::Decor::Tables::DataTableCell.new(
                value: "#{weight.to_s.capitalize} weight",
                weight: weight
              )
            end
          end
        end
      end
    end
  end

  # @!endgroup

  # @!group Row Heights

  # @label All row heights
  def row_heights
    render ::Decor::Element.new do |e|
      e.table(class: "min-w-full border border-gray-200") do
        e.tbody do
          [:comfortable, :standard, :tight].each do |height|
            e.tr(class: "bg-white border-b border-gray-200") do
              e.render ::Decor::Tables::DataTableCell.new(
                value: "#{height.to_s.capitalize} row height",
                row_height: height
              )
            end
          end
        end
      end
    end
  end

  # @!endgroup

  private

  def render_example(**options)
    render ::Decor::Element.new do |e|
      e.table(class: "min-w-full border border-gray-200") do
        e.tbody do
          e.tr(class: "bg-white") do
            e.render ::Decor::Tables::DataTableCell.new(**options)
          end
        end
      end
    end
  end
end
