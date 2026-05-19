# frozen_string_literal: true

module Decor
  module Suite
    module Tables
      # Suite-skinned DataTableBuilder. Inherits the column / row / query
      # pipeline from `Decor::Components::Tables::DataTableBuilder` and emits
      # a `Decor::Suite::Tables::DataTable` instance with the Suite slot
      # semantics:
      #
      #   - `with_search_and_filter(**attrs, &block)` (kwargs, not a block)
      #   - `with_pagination(**attrs)`
      #   - `with_bulk_actions_bar(bulk_actions:, selected_ids_field_name:)`
      #   - header cells / body cells are pre-built and pre-rendered; the
      #     Suite DataTable does NOT use the Daisy `block.arity` dance.
      #
      # # Dropped from the Confinus reference (737 LOC → ~150 LOC here)
      # The following responsibilities are intentionally NOT ported. They
      # depended on Confinus-internal classes that are not part of the Decor
      # gem surface; callers who need them should subclass and add hooks.
      #
      #   - `ilike_search` (depends on ::ConfinusUI::SearchAndFilter::Search)
      #   - `Search` / `Filter` Literal::Struct classes (Confinus-only —
      #     `mem_search` / `mem_filters` is duck-typed; return any object
      #     responding to `#name`, `#apply`, and `#value` from your overrides)
      #   - `ApplicationRelationBackedQuery` / `ApplicationCollectionBackedQuery`
      #     wrapping (replaced with `Quo.relation_backed_query_base_class.wrap`
      #     in the parent's pipeline — same behaviour, no app dependency)
      #   - `page_relevance_scores` virtual attr & search-relevance highlight
      #     (inherited from parent; setter not exposed in DSL — assign via
      #     subclass override of `setup_data_table` if needed)
      #
      # Anything else from the Confinus DataTableBuilder API surface (column
      # DSL, bulk actions, custom slot configuration, CTA blocks, nested
      # form builders, sort/filter/search overrides) is preserved.
      class DataTableBuilder < ::Decor::Components::Tables::DataTableBuilder
        # Bulk-action descriptor for the bulk-actions bar.
        #
        # Visibility/disabling is duck-typed — pass `visible:` as a Proc
        # returning true/false. The Suite BulkActionsBar reads these via
        # public readers.
        class BulkAction < ::Literal::Struct
          prop :name, Symbol, reader: :public
          prop :label, String, reader: :public
          prop :icon, _Nilable(String), reader: :public
          prop :icon_variant, _Union(:outline, :solid, :small_solid), default: -> { :outline }, reader: :public
          prop :style, _Union(:primary, :secondary, :danger, :warning, :success), default: -> { :primary }, reader: :public
          prop :confirm, _Nilable(String), reader: :public
          prop :disabled, _Boolean, default: -> { false }, reader: :public
          prop :visible, _Nilable(Proc), reader: :public
          prop :url, _Nilable(String), reader: :public
          prop :http_method, _Union(:get, :post, :put, :patch, :delete), default: -> { :post }, reader: :public
          prop :min_selection, Integer, default: -> { 1 }, reader: :public
          prop :max_selection, _Nilable(Integer), reader: :public
          prop :inline, _Boolean, default: -> { false }, reader: :public
          prop :modal, _Boolean, default: -> { false }, reader: :public

          def disabled? = disabled
          def inline? = inline
          def modal? = modal
        end

        # Suite-only props (Confinus parity).
        prop :description, _Nilable(String), reader: :private
        prop :enabled_grid, _Boolean, default: false, reader: :private
        prop :header_emphasis, _Nilable(_Union(:low, :standard, :high)), reader: :private
        prop :header_weight, _Nilable(_Union(:light, :regular, :medium, :bold)), reader: :private
        prop :table_identifier, _Nilable(String), reader: :private
        prop :enable_selection_persistence, _Boolean, default: true, reader: :private
        prop :classes, _Union(String, _Array(String)), default: -> { [] }, reader: :private

        def view_template(&)
          vanish(&)
          render component do
            setup_component_slots(component)
          end
        end

        # Returns the Suite DataTable component instance (memoised).
        def component
          return @component if defined?(@component)
          @component = ::Decor::Suite::Tables::DataTable.new(
            title: title,
            subtitle: subtitle,
            table_identifier: resolved_table_identifier,
            enable_selection_persistence: should_persist_selections?,
            table_html_options: html_options
          )
        end

        # DSL: register a custom slot that will be forwarded to the underlying
        # DataTable component via `with_<name>(**attrs, &block)`.
        def configure_slot(name, **attributes, &block)
          @slots ||= {}
          @slots[name] = {attributes: attributes, block: block}
          self
        end

        # DSL: register a bulk action.
        def bulk_action(name, options = {})
          @bulk_actions ||= []
          @bulk_actions << BulkAction.new(name: name, **options)
          self
        end

        def bulk_actions
          @bulk_actions ||= []
        end

        def should_persist_selections?
          return true if @enable_selection_persistence
          @rows_selectable_as_name.present? && bulk_actions.any?
        end

        private

        # Generate a stable identifier from the subclass name when one is
        # not provided explicitly. Falls back to the selectable group name.
        def resolved_table_identifier
          return @table_identifier if @table_identifier.present?
          return nil if @rows_selectable_as_name.blank?

          base_klass = ::Decor::Suite::Tables::DataTableBuilder
          if self.class != base_klass && self.class < base_klass
            self.class.name.to_s.underscore.tr("/", "_")
          else
            @rows_selectable_as_name.to_s.gsub(/[\[\]]/, "").gsub(/[^a-zA-Z0-9_]/, "_")
          end
        end

        # Wire the builder DSL outputs onto the Suite DataTable. Diverges
        # from the parent (Daisy) implementation in three places:
        #
        #   1. search_and_filter is passed as kwargs+block, not just a block
        #   2. header cells are added to the header row via `with_header_cell`
        #      (parent uses a block that yields the header row)
        #   3. body cells carry their rendered content as `value:` — no
        #      `exec_row_render_method` dispatch is needed at render time
        # Parent returns `filters: nil` when no filters defined, but the
        # SearchAndFilter component types `filters:` as a non-nil Array.
        # Drop nils so its type-check passes.
        def resolved_search_and_filter_options
          super.compact
        end

        def setup_component_slots(data_table_component)
          if search_or_filter_element?
            data_table_component.with_search_and_filter(**resolved_search_and_filter_options) do |sf|
              sf.with_actions(&@cta) if @cta && sf.respond_to?(:with_actions)
            end
          end

          header_row = data_table_component.with_data_table_header_row(selectable_as: @rows_selectable_as_name&.to_s)
          header_cell_attributes.each { |attrs| header_row.with_data_table_header_cell(**attrs) }

          prepare_table_rows.each do |row|
            data_row = data_table_component.with_data_table_row(row.component)

            if row.expanded_content_renderer
              expanded = row.expanded_content_renderer.call
              data_row.with_expanded_content { expanded } unless expanded.nil?
            end

            row.cells.each do |cell|
              data_row.with_data_table_cell(cell.component)
            end
          end

          if paginated?
            data_table_component.with_pagination(**resolved_pagination_options)
          end

          if @rows_selectable_as_name && bulk_actions.any?
            data_table_component.with_bulk_actions_bar(
              bulk_actions: bulk_actions,
              selected_ids_field_name: @rows_selectable_as_name.to_s
            )
          end

          (@slots || {}).each do |name, configuration|
            data_table_component.send(:"with_#{name}", **configuration[:attributes], &configuration[:block])
          end
        end

        # Override the abstract base's row/cell construction so we build
        # Suite-skinned cells (with pre-rendered `value:`) and Suite rows.
        # The parent hardcodes the Daisy variants.
        def data_to_rows_and_cells(data:, current_page:, page_size:)
          data.map.with_index do |row_data, index|
            item_index = index + ((current_page - 1) * page_size)
            transformed_data = transform_row(row_data, index, item_index)
            path_data = path_for_row(row_data, transformed_data, index, item_index)
            row_attrs = row_attributes(row_data, transformed_data, index, item_index) || {}
            cell_attrs = cell_attributes(row_data, transformed_data, index, item_index) || {}
            apply_relevance_highlight(row_attrs, index) if page_relevance_scores.present?

            cells = visible_columns.map do |column|
              suite_cell_for(
                column: column,
                data: transformed_data,
                untransformed: row_data,
                item_index: item_index,
                row_height: @row_height,
                path: column.navigates_to_path? ? path_data : nil,
                content_clickable: column.content_clickable?,
                stop_propagation: column.navigates_to_path? ? column.stop_propagation? : true,
                cell_attrs: cell_attrs
              )
            end

            suite_row_for(
              cells: cells,
              item_index: item_index,
              expanded_content_renderer: -> { row_expanded_content(row_data, transformed_data, index, item_index) },
              path: path_data,
              highlight: row_highlight(row_data, transformed_data, index, item_index),
              selectable_as: @rows_selectable_as_name ? "#{@rows_selectable_as_name}_#{item_index}" : nil,
              # ^ stringified for DataTableRow's String-typed `selectable_as`.
              row_attrs: row_attrs
            )
          end
        end

        # Lightweight PORO wrappers — the `Decor::Tables::Builder::{Cell,Row}`
        # Literal::Structs constrain `component:` to Daisy classes, so we
        # can't reuse them here. Suite only needs `.component`, `.cells`,
        # and `.expanded_content_renderer` for `setup_component_slots`.
        BuilderCell = Struct.new(:component, keyword_init: true)
        BuilderRow = Struct.new(:cells, :item_index, :expanded_content_renderer, :component, keyword_init: true)

        def suite_cell_for(column:, data:, untransformed:, item_index:, row_height:, path:, content_clickable:, stop_propagation:, cell_attrs:)
          rendered = ::Decor::Tables::Builder::Cell.rendered_content(column, data, item_index, untransformed)
          component_props = {
            numeric: column.numeric,
            colspan: column.colspan,
            min_width_rem: column.min_width_rem,
            max_width: column.max_width,
            emphasis: column.emphasis,
            weight: column.weight,
            value: rendered,
            row_height: row_height,
            path: path,
            content_clickable: content_clickable,
            stop_propagation: stop_propagation,
            **cell_attrs
          }.compact
          BuilderCell.new(component: ::Decor::Suite::Tables::DataTableCell.new(**component_props))
        end

        def suite_row_for(cells:, item_index:, expanded_content_renderer:, path:, highlight:, selectable_as:, row_attrs:)
          row_props = {
            path: path,
            highlight: highlight,
            selectable_as: selectable_as,
            **row_attrs
          }.compact
          BuilderRow.new(
            cells: cells,
            item_index: item_index,
            expanded_content_renderer: expanded_content_renderer,
            component: ::Decor::Suite::Tables::DataTableRow.new(**row_props)
          )
        end
      end
    end
  end
end
