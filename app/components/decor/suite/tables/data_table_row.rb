# frozen_string_literal: true

module Decor
  module Suite
    module Tables
      # Suite skin of DataTableRow. Renders a `<tr>` with the Suite cell
      # default + hairline bottom divider so rows separate visually without
      # requiring a tbody-level `divide-y` (which double-borders when each
      # cell already carries its own `border-b`).
      class DataTableRow < ::Decor::Components::Tables::DataTableRow
        # Override the abstract base's default cell constructor so block
        # callers get Suite cells, not Daisy cells.
        def with_data_table_cell(component = nil, **attributes, &block)
          cell = component || ::Decor::Suite::Tables::DataTableCell.new(**attributes)
          @data_table_cells << [cell, block]
          cell
        end

        def with_expanded_content(&block)
          @expanded_content_block = block
          self
        end

        def view_template(&)
          @block_content = capture(&) if block_given?
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
                  stimulus_targets: [stimulus_target(:checkbox)],
                  stimulus_actions: [stimulus_action(:change, :row_selected)],
                  show_label: false,
                  name: @selectable_as,
                  checked: @selected,
                  disabled: @disabled,
                  silent_helper_and_error_text: true,
                  stimulus_outlet_host: self
                )
              }
            end
            @data_table_cells.each do |cell, block|
              if block
                render(cell, &block)
              else
                render(cell)
              end
            end
          end
          if @expanded_content_block
            tr { @expanded_content_block.call }
          end
        end

        private

        def selectable_as?
          @selectable_as.present?
        end

        def root_element_attributes
          {element_tag: :tr}
        end

        def root_element_classes
          [
            @expanded_content_block ? "decor:border-b decor:border-white" : nil,
            @hover_highlight ? "decor:hover:bg-suite-gray-25 decor:transition-colors decor:duration-suite-fast decor:ease-out" : nil,
            @highlight ? highlight_bg : nil,
            @disabled ? "decor:opacity-50" : nil,
            @hidden ? "decor:hidden" : nil
          ].compact_blank
        end

        def highlight_bg
          case @highlight
          when :gray_low    then "decor:bg-gray-50"
          when :gray_medium then "decor:bg-gray-100"
          when :gray_high   then "decor:bg-gray-200"
          when :low         then "decor:bg-suite-primary-50"
          when :high        then "decor:bg-suite-primary-100"
          else                   "decor:bg-suite-primary-50"
          end
        end
      end
    end
  end
end
