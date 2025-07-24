# frozen_string_literal: true

# Table header cell component with sorting functionality and column stretching capabilities.
# Extends DataTableCell with additional header-specific features like sorting indicators.
# @label Data Table Header Cell
class ::Decor::Tables::DataTableHeaderCellPreview < ::Lookbook::Preview
  # @!group Examples

  # @label Default
  def default
    render_header_row do |e|
      e.render ::Decor::Tables::DataTableHeaderCell.new(title: "Product Name")
      e.render ::Decor::Tables::DataTableHeaderCell.new(title: "Category")
      e.render ::Decor::Tables::DataTableHeaderCell.new(title: "Price", numeric: true)
    end
  end

  # @label Sortable columns
  def sortable
    render_header_row do |e|
      e.render ::Decor::Tables::DataTableHeaderCell.new(
        title: "Name",
        sort_key: :name,
        sorted_direction: :asc
      )
      e.render ::Decor::Tables::DataTableHeaderCell.new(
        title: "Date",
        sort_key: :date
      )
      e.render ::Decor::Tables::DataTableHeaderCell.new(
        title: "Amount",
        sort_key: :amount,
        sorted_direction: :desc,
        numeric: true
      )
    end
  end

  # @label Stretched columns
  def stretched
    render_header_row do |e|
      e.render ::Decor::Tables::DataTableHeaderCell.new(
        title: "Description",
        stretch_divisor: 3
      )
      e.render ::Decor::Tables::DataTableHeaderCell.new(
        title: "Status",
        stretch_divisor: 1
      )
      e.render ::Decor::Tables::DataTableHeaderCell.new(
        title: "Actions",
        stretch_divisor: 1
      )
    end
  end

  # @label Mixed features
  def mixed_features
    render_header_row do |e|
      e.render ::Decor::Tables::DataTableHeaderCell.new(
        title: "Product",
        sort_key: :product,
        stretch_divisor: 2
      )
      e.render ::Decor::Tables::DataTableHeaderCell.new(
        title: "Sales",
        sort_key: :sales,
        sorted_direction: :desc,
        numeric: true
      )
      e.render ::Decor::Tables::DataTableHeaderCell.new(
        title: "Revenue",
        numeric: true,
        stretch_divisor: 1
      )
    end
  end

  # @!endgroup

  # @!group Playground

  # @label Playground
  # @param title [String] text
  # @param numeric [Boolean] toggle
  # @param sort_key [String] text
  # @param sorted_direction select [~, asc, desc]
  # @param stretch_divisor [Integer] number
  # @param row_height [Symbol] select [comfortable, standard, tight]
  # @param size [Symbol] select [xs, sm, base, lg, xl]
  # @param color [Symbol] select [primary, secondary, success, warning, danger, info, light, dark]
  # @param style [Symbol] select [filled, outlined, ghost]
  def playground(
    title: "Column Header",
    numeric: false,
    sort_key: nil,
    sorted_direction: nil,
    stretch_divisor: nil,
    row_height: :standard,
    size: :medium,
    color: :primary,
    style: :filled
  )
    render ::Decor::Element.new do |e|
      e.table(class: "min-w-full border border-gray-200") do
        e.thead(class: "bg-gray-50") do
          e.tr do
            e.render ::Decor::Tables::DataTableHeaderCell.new(
              title: title,
              numeric: numeric,
              sort_key: sort_key.present? ? sort_key.to_sym : nil,
              sorted_direction: sorted_direction.present? ? sorted_direction.to_sym : nil,
              stretch_divisor: stretch_divisor,
              row_height: row_height,
              size: size,
              color: color,
              style: style
            )
          end
        end
      end
    end
  end

  # @!endgroup

  # @!group Row Heights

  # @label Comfortable
  def row_height_comfortable
    render_header_row(row_height: :comfortable) do |e|
      e.render ::Decor::Tables::DataTableHeaderCell.new(
        title: "Name",
        row_height: :comfortable
      )
      e.render ::Decor::Tables::DataTableHeaderCell.new(
        title: "Value",
        row_height: :comfortable,
        numeric: true
      )
    end
  end

  # @label Standard
  def row_height_standard
    render_header_row(row_height: :standard) do |e|
      e.render ::Decor::Tables::DataTableHeaderCell.new(
        title: "Name",
        row_height: :standard
      )
      e.render ::Decor::Tables::DataTableHeaderCell.new(
        title: "Value",
        row_height: :standard,
        numeric: true
      )
    end
  end

  # @label Tight
  def row_height_tight
    render_header_row(row_height: :tight) do |e|
      e.render ::Decor::Tables::DataTableHeaderCell.new(
        title: "Name",
        row_height: :tight
      )
      e.render ::Decor::Tables::DataTableHeaderCell.new(
        title: "Value",
        row_height: :tight,
        numeric: true
      )
    end
  end

  # @!endgroup

  # @!group Sorting States

  # @label Unsorted
  def unsorted
    render_header_row do |e|
      e.render ::Decor::Tables::DataTableHeaderCell.new(
        title: "Product",
        sort_key: :product
      )
      e.render ::Decor::Tables::DataTableHeaderCell.new(
        title: "Price",
        sort_key: :price,
        numeric: true
      )
    end
  end

  # @label Ascending
  def ascending
    render_header_row do |e|
      e.render ::Decor::Tables::DataTableHeaderCell.new(
        title: "Product",
        sort_key: :product,
        sorted_direction: :asc
      )
      e.render ::Decor::Tables::DataTableHeaderCell.new(
        title: "Price",
        sort_key: :price,
        numeric: true
      )
    end
  end

  # @label Descending
  def descending
    render_header_row do |e|
      e.render ::Decor::Tables::DataTableHeaderCell.new(
        title: "Product",
        sort_key: :product
      )
      e.render ::Decor::Tables::DataTableHeaderCell.new(
        title: "Price",
        sort_key: :price,
        sorted_direction: :desc,
        numeric: true
      )
    end
  end

  # @!endgroup

  # @!group Alignment

  # @label Text columns
  def text_columns
    render_header_row do |e|
      e.render ::Decor::Tables::DataTableHeaderCell.new(title: "First Name")
      e.render ::Decor::Tables::DataTableHeaderCell.new(title: "Last Name")
      e.render ::Decor::Tables::DataTableHeaderCell.new(title: "Email")
    end
  end

  # @label Numeric columns
  def numeric_columns
    render_header_row do |e|
      e.render ::Decor::Tables::DataTableHeaderCell.new(
        title: "Quantity",
        numeric: true
      )
      e.render ::Decor::Tables::DataTableHeaderCell.new(
        title: "Price",
        numeric: true
      )
      e.render ::Decor::Tables::DataTableHeaderCell.new(
        title: "Total",
        numeric: true
      )
    end
  end

  # @label Mixed alignment
  def mixed_alignment
    render_header_row do |e|
      e.render ::Decor::Tables::DataTableHeaderCell.new(title: "Item")
      e.render ::Decor::Tables::DataTableHeaderCell.new(
        title: "Qty",
        numeric: true
      )
      e.render ::Decor::Tables::DataTableHeaderCell.new(title: "Status")
      e.render ::Decor::Tables::DataTableHeaderCell.new(
        title: "Price",
        numeric: true
      )
    end
  end

  # @!endgroup

  private

  def render_header_row(row_height: :standard)
    render ::Decor::Element.new do |e|
      e.table(class: "min-w-full border border-gray-200") do
        e.thead(class: "bg-gray-50") do
          e.tr do
            yield(e)
          end
        end
      end
    end
  end
end
