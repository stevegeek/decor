# frozen_string_literal: true

module Decor
  module Suite
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
          # If true the cell content is rendered inside an absolutely-positioned
          # div over the cell so interactive controls get first dibs on events.
          prop :content_clickable, _Nilable(_Boolean)
          # When false the cell does not adopt the row's navigation path.
          prop :navigates_to_path, _Boolean, default: true
          # If true a click in the cell will not propagate to the row.
          prop :stop_propagation, _Boolean, default: false

          prop :title, _Nilable(String)
          prop :colspan, _Nilable(Integer)
          prop :numeric, _Boolean, default: false
          prop :emphasis, _Nilable(Symbol)
          prop :weight, _Nilable(Symbol)

          prop :classes, _Nilable(_Union(String, _Array(String)))

          def sortable? = sortable
          def stretch? = stretch
          def content_clickable? = !!content_clickable
          # A content-clickable cell (e.g. a button or modal trigger) owns its
          # own click handling and must not also navigate to the row's path.
          def navigates_to_path? = navigates_to_path && !content_clickable?
          def stop_propagation? = stop_propagation
        end
      end
    end
  end
end
