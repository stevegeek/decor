# frozen_string_literal: true

module Decor
  module Tables
    module Builder
      class Column < ::Literal::Struct
        prop :index, Integer, default: 0
        prop :name, Symbol
        prop :cell_block, _Nilable(Proc)

        prop :sortable, _Boolean, default: false
        prop :sort_method, _Nilable(Proc)
        prop :stretch, _Boolean, default: false
        prop :min_width_rem, _Nilable(Numeric)
        prop :max_width, _Nilable(Integer)
        # When clickable, content is placed in an absolutely positioned div over
        # the cell, giving it first dibs on events.
        prop :content_clickable, _Nilable(_Boolean)
        # When false the cell omits the row's path on its path attribute.
        prop :navigates_to_path, _Boolean, default: true
        # When true a click in the cell does not propagate to the row.
        prop :stop_propagation, _Boolean, default: false

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
