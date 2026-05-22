# frozen_string_literal: true

module Decor
  module Components
    module Tables
      class DataTableCell < ::Decor::PhlexComponent
        # The value to be rendered in the cell
        # Could be a string or a number, or anything that will be coerced to a string
        prop :value, _Nilable(_Interface(:to_s))

        # Whether the cell contains numeric content or not
        prop :numeric, _Boolean, default: false

        # Number of columns to span. For a column header a colspan of zero means hide the column header
        prop :colspan, _Nilable(Integer)
        # Min width in rem of the cell
        prop :min_width_rem, _Nilable(Numeric)
        # Max width in pixel of the cell # TODO: change to rem
        prop :max_width, _Nilable(Numeric)

        # If 'clickable' the contents is placed in an absolutely positioned div over the cell to
        # ensure the contents capture the mouse click event.
        prop :content_clickable, _Boolean, default: false

        # The cell is meant to stop propagation of events
        prop :stop_propagation, _Boolean, default: false

        # A cell can optionally link to another page.
        prop :path, _Nilable(String)

        # Typography emphasis
        prop :emphasis, _Union(:regular, :low), default: :regular
        # Typography weight
        prop :weight, _Union(:light, :regular, :medium), default: :regular
        # Row height
        prop :row_height, _Union(:comfortable, :standard, :tight), default: :standard
        # Compact horizontal padding
        prop :compact, _Boolean, default: false
        # Content alignment (overrides numeric-based alignment when set)
        prop :align, _Nilable(_Union(:left, :center, :right))

        # Use unified color system (in addition to existing emphasis system)
        default_color :base  # No color by default

        stimulus do
          actions -> { [:click, :handle_cell_click_to_stop_propagation] if @stop_propagation }
          values no_path_navigation: -> { @path.nil? }
        end
      end
    end
  end
end
