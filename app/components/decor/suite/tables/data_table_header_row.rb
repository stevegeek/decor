# frozen_string_literal: true

module Decor
  module Suite
    module Tables
      class DataTableHeaderRow < ::Decor::Components::Tables::DataTableHeaderRow
        def with_data_table_header_cell(component = nil, **attributes, &block)
          cell = component || ::Decor::Suite::Tables::DataTableHeaderCell.new(**attributes)
          @data_table_header_cells << cell
          cell
        end

        def view_template(&)
          @content = capture(&) if block_given?
          root_element do
            if selectable_as?
              render ::Decor::Suite::Tables::DataTableCell.new(
                content_clickable: false,
                stop_propagation: true,
                row_height: :standard,
                compact: true,
                align: :center
              ) {
                render ::Decor::Suite::Forms::Checkbox.new(
                  control_targets: [stimulus_target("decor/suite/tables/data_table", :select_all_checkbox)],
                  control_actions: [stimulus_action(:change, "decor/suite/tables/data_table", :toggle_all)],
                  name: @selectable_as,
                  checked: @selected,
                  disabled: @disabled,
                  silent_helper_and_error_text: true,
                  stimulus_outlet_host: self
                )
              }
            end
            @data_table_header_cells.each { |cell| render cell }
          end
        end

        private

        def selectable_as?
          @selectable_as.present?
        end

        def root_element_attributes
          {element_tag: :tr}
        end
      end
    end
  end
end
