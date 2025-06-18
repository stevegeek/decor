# frozen_string_literal: true

module Decor
  module Tables
    class DataTableRow < PhlexComponent
      attr_reader :expanded_content, :data_table_cells

      def initialize(**attributes)
        super
        @data_table_cells = []
      end

      def with_expanded_content(&block)
        @expanded_content = block
        self
      end

      def with_data_table_cell(component = nil, **attributes, &block)
        cell = component || ::Decor::Tables::DataTableCell.new(**attributes)
        @data_table_cells << cell
        cell
      end

      # Background changes on hover
      attribute :hover_highlight, :boolean

      # Background is highlighted
      attribute :highlight, Symbol, in: [:gray_low, :gray_medium, :gray_high, :low, :medium, :high, :primary, :secondary, :accent, :info, :success, :warning, :error]

      # Whether the row should get lower opacity or not
      attribute :disabled, :boolean, default: false

      # Whether the row should be hidden or not
      attribute :hidden, :boolean, default: false

      # If row has a select box next to it
      attribute :selectable_as, String, convert: true
      # Whether the row should get an indicator on the left side
      attribute :selected, :boolean, default: false

      # A row can optionally link to another page.
      attribute :path, String

      # A row can optionally have a form builder which can then be used to created nested forms per row. The form builder
      # is normally prepared by the data table builder when preparing the table row data.
      attribute :form_builder, ::ActionView::Helpers::FormBuilder

      def view_template(&)
        vanish(&)
        render parent_element do |el|
          if @selectable_as.present?
            td(class: "px-4") do
              render ::Decor::Forms::Checkbox.new(
                targets: [el.target(:checkbox)],
                actions: [el.action(:change, :row_selected)],
                show_label: false,
                name: @selectable_as,
                checked: @selected,
                disabled: @disabled,
                collapsing_helper_text: true,
                outlet_host: el
              )
            end
          end
          @data_table_cells.each do |cell|
            el.connect_outlet(cell)
            render cell
          end
        end
        if @expanded_content.present?
          tr do
            @expanded_content.call
          end
        end
      end

      private

      def root_element_attributes
        {
          element_tag: :tr,
          actions: [[:click, :handle_row_click]],
          named_classes: {
            selected: "bg-base-200"
          },
          values: [{id: id}.merge(@path ? {href: @path} : {})]
        }
      end

      def element_classes
        [
          @expanded_content.present? ? "border-b border-white" : nil,
          @hover_highlight && "hover:bg-base-200 transition-colors duration-150",
          @highlight && highlight_bg,
          @disabled && "opacity-50",
          @hidden && "hidden"
        ].compact_blank
      end

      def highlight_bg
        case @highlight
        when :gray_low
          "bg-gray-50"
        when :gray_medium
          "bg-gray-100"
        when :gray_high
          "bg-gray-200"
        when :low
          "bg-primary-50"
        when :high
          "bg-primary-200"
        when :primary
          "bg-primary/20"
        when :secondary
          "bg-secondary/20"
        when :accent
          "bg-accent/20"
        when :info
          "bg-info/20"
        when :success
          "bg-success/20"
        when :warning
          "bg-warning/20"
        when :error
          "bg-error/20"
        else
          "bg-primary-100"
        end
      end
    end
  end
end
