# frozen_string_literal: true

module Decor
  module Tables
    class DataTableHeaderRow < PhlexComponent
      attr_reader :data_table_header_cells

      def initialize(**attributes)
        super
        @data_table_header_cells = []
      end

      def with_data_table_header_cell(component = nil, **attributes, &block)
        cell = component || ::Decor::Tables::DataTableHeaderCell.new(**attributes)
        @data_table_header_cells << cell
        cell
      end

      # Whether the row should get lower opacity or not
      attribute :disabled, :boolean, default: false

      # If row has a select box next to it
      attribute :selectable_as, String, convert: true
      # Whether the row should get an indicator on the left side
      attribute :selected, :boolean, default: false

      def view_template(&)
        vanish(&)
        render parent_element do |el|
          if @selectable_as.present?
            td(class: "px-4") do
              render ::Decor::Forms::Checkbox.new(
                actions: [el.action(:change, :handle_checkbox_change)],
                show_label: false,
                name: @selectable_as,
                checked: @selected,
                disabled: @disabled,
                collapsing_helper_text: true,
                outlet_host: el
              )
            end
          end
          @data_table_header_cells.each do |cell|
            render cell
          end
        end
      end

      private

      def root_element_attributes
        {
          element_tag: :tr
        }
      end
    end
  end
end
