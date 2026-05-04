# frozen_string_literal: true

module Decor
  module Daisy
    module Tables
      class DataTableBuilder < ::Decor::Components::Tables::DataTableBuilder
        def view_template(&)
          vanish(&)
          render component do
            setup_component_slots(component)
          end
        end

        # Returns the daisy DataTable view component ready to render
        def component
          return @component if defined?(@component)
          @component = ::Decor::Daisy::Tables::DataTable.new(
            title: title,
            subtitle: subtitle,
            html_options: html_options
          )
        end
      end
    end
  end
end
