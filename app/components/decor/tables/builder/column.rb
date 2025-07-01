# frozen_string_literal: true

module Decor
  module Tables
    module Builder
      class Column < ::Literal::Struct
        # Column index
        prop :index, Integer, default: 0
        # Column unique name
        prop :name, Symbol
        # The block called for each cell in this column
        prop :cell_block, _Nilable(Proc)

        # Column settings
        prop :sortable, _Boolean, default: false
        prop :sort_method, _Nilable(Proc)
        prop :stretch, _Boolean, default: false
        prop :min_width_rem, _Nilable(Numeric)
        prop :max_width, _Nilable(Integer)
        # If clickable the content is placed in an absolutely positioned div over the cell, thus
        # allowing it first dibs on events
        prop :content_clickable, _Nilable(_Boolean)
        # By setting navigates to path to false the cell will not have its path attribute
        # set to the path of the row.
        prop :navigates_to_path, _Boolean, default: true
        # If the cell is meant to stop propagation of events, then a click in the cell will
        # prevent the event from propagating to the row.
        prop :stop_propagation, _Boolean, default: false

        # Header cell attributes
        prop :title, _Nilable(String)
        prop :colspan, _Nilable(Integer)
        prop :numeric, _Boolean, default: false
        prop :emphasis, _Nilable(Symbol)
        prop :weight, _Nilable(Symbol)

        def navigates_to_path?
          @navigates_to_path
        end

        def content_clickable?
          !!@content_clickable
        end

        def stop_propagation?
          !!@stop_propagation
        end
      end
    end
  end
end
