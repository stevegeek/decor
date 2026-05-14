# frozen_string_literal: true

module Decor
  module Daisy
    module Tables
      class DataTableRow < ::Decor::Components::Tables::DataTableRow
        def view_template(&)
          vanish(&)
          root_element do |el|
            if @selectable_as.present?
              td(class: "decor:px-4") do
                render ::Decor::Daisy::Forms::Checkbox.new(
                  stimulus_targets: [stimulus_target(:checkbox)],
                  stimulus_actions: [stimulus_action(:change, :row_selected)],
                  show_label: false,
                  name: @selectable_as,
                  checked: @selected,
                  disabled: @disabled,
                  collapsing_helper_text: true,
                  stimulus_outlet_host: el
                )
              end
            end
            @data_table_cells.each do |cell_info|
              cell, block = cell_info
              add_stimulus_outlets(cell)
              render(cell, &block)
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
            element_tag: :tr
          }
        end

        def root_element_classes
          [
            @expanded_content.present? ? "decor:border-b decor:border-white" : nil,
            @hover_highlight && "decor:hover:bg-base-200 decor:transition-colors decor:duration-150",
            @highlight && highlight_bg,
            @disabled && "decor:opacity-50",
            @hidden && "decor:hidden"
          ].compact_blank
        end

        def highlight_bg
          case @highlight
          when :gray_low
            "decor:bg-gray-50"
          when :gray_medium
            "decor:bg-gray-100"
          when :gray_high
            "decor:bg-gray-200"
          when :low
            "decor:bg-primary-50"
          when :high
            "decor:bg-primary-200"
          when :primary
            "decor:bg-primary/20"
          when :secondary
            "decor:bg-secondary/20"
          when :accent
            "decor:bg-accent/20"
          when :info
            "decor:bg-info/20"
          when :success
            "decor:bg-success/20"
          when :warning
            "decor:bg-warning/20"
          when :error
            "decor:bg-error/20"
          else
            "decor:bg-primary-100"
          end
        end
      end
    end
  end
end
