# frozen_string_literal: true

module Decor
  module Daisy
    module Tables
      class DataTableHeaderRow < ::Decor::Components::Tables::DataTableHeaderRow
        def view_template(&)
          vanish(&)
          root_element do |el|
            if @selectable_as.present?
              td(class: "decor:px-4") do
                render ::Decor::Daisy::Forms::Checkbox.new(
                  stimulus_actions: [el.stimulus_action(:change, :handle_checkbox_change)],
                  stimulus_outlet_host: el,
                  show_label: false,
                  name: @selectable_as,
                  checked: @selected,
                  disabled: @disabled,
                  collapsing_helper_text: true
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
end
