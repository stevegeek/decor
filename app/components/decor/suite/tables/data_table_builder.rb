# frozen_string_literal: true

module Decor
  module Suite
    module Tables
      # Suite-skinned DataTableBuilder. Inherits the column / row / query
      # pipeline from `Decor::Components::Tables::DataTableBuilder` and emits
      # a `Decor::Suite::Tables::DataTable` instance with the Suite slot
      # semantics:
      #
      #   - `with_search_and_filter(**attrs, &block)` (kwargs + block)
      #   - `with_pagination(**attrs)`
      #   - `with_bulk_actions_bar(bulk_actions:, selected_ids_field_name:)`
      #   - header cells / body cells are pre-built and pre-rendered; the
      #     Suite DataTable does NOT use the Daisy `block.arity` dance.
      #
      # # ConfinusUI compatibility
      # - Constructor accepts both kwargs (`new(params:, helpers:, **attrs)`)
      #   and the Confinus positional shape (`new(attrs_hash, params, helpers)`).
      # - DSL block runs during `.new` (parity with ConfinusUI), so callers
      #   can inspect `bulk_actions`, `columns_hash`, etc. on the returned
      #   builder before render.
      # - `ilike_search` helper rebuilt on the Decor::Components-namespaced
      #   `Search` value object.
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

        # Constructor shim: accept both the ConfinusUI positional shape
        # (`new(attrs_hash, params, helpers, &block)`) and the kwargs form
        # used by Decor tests (`new(params:, helpers:, **attrs, &block)`).
        # The positional shape is detected by a leading Hash positional arg.
        def self.new(*args, **kwargs, &block)
          if args.length == 3 && args.first.is_a?(Hash) && args[1].is_a?(::ActionController::Parameters)
            attrs_hash, params, helpers = args
            super(params: params, helpers: helpers, **attrs_hash.symbolize_keys, **kwargs, &block)
          else
            super(*args, **kwargs, &block)
          end
        end

        # Yield the builder to the DSL block before `setup_data_table`
        # runs so subclass hooks can see columns/bulk-actions registered in
        # the block. Block runs during `.new` (Confinus parity), not at
        # render time — callers can read `bulk_actions` / `columns_hash`
        # before rendering.
        def after_component_initialize
          @params = @params.permit(keys_for_permit)
          merge_pagination_params
          merge_sort_and_filter_params
          @slots = {}
          @bulk_actions = []
          @row_nested_form_builders = nil
          Rails.logger.info { "[DEBUG] after_component_initialize block_given?=#{block_given?} self=#{self.class}" }
          yield self if block_given?
          Rails.logger.info { "[DEBUG] after_component_initialize columns_hash.size=#{columns_hash.size}" }
          setup_data_table
        end

        def view_template(&)
          # The DSL block was already consumed in `after_component_initialize`;
          # `vanish` discards any duplicate block passed at render time so the
          # column DSL isn't applied twice.
          vanish(&)
          render component
        end

        # Returns the Suite DataTable component instance (memoised).
        def component
          return @component if defined?(@component)
          @component = ::Decor::Suite::Tables::DataTable.new(
            title: @title,
            subtitle: @subtitle,
            description: @description,
            enabled_grid: @enabled_grid,
            table_identifier: resolved_table_identifier,
            enable_selection_persistence: should_persist_selections?,
            table_html_options: @html_options,
            classes: @classes
          )
          setup_component_slots(@component)
          @component
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

        # Override `class:` → `classes:` so callers can spell column CSS the
        # ERB way (Confinus parity). Literal reserves `class` as a keyword.
        def column(name, options = {}, &row_cell_block)
          if options.key?(:class)
            options = options.dup
            options[:classes] = options.delete(:class)
          end
          super
        end

        # Build an ILIKE search across one or more columns on a model/scope.
        # Handles sanitize_sql_like automatically.
        #
        #   ilike_search(name: "search", label: "Search...", model: ::Bid, columns: [:name, :encoded_id])
        #   ilike_search(name: "search", label: "Search...", scope: my_custom_scope, columns: [:email, :name])
        #
        def ilike_search(name:, label:, columns:, model: nil, scope: nil)
          search_scope = scope || model
          raise ArgumentError, "ilike_search requires either model: or scope:" unless search_scope

          arel_attrs = columns.map { |col| arel_attribute(col, search_scope) }

          ::Decor::Components::SearchAndFilter::Search.new(
            name: name,
            label: label,
            apply: ->(query, param) do
              like = sanitize_like(param)
              conditions = arel_attrs.reduce(nil) do |chain, attr|
                clause = search_scope.where(attr.matches(like))
                chain ? chain.or(clause) : clause
              end
              query + conditions
            end
          )
        end

        private

        def sanitize_like(param)
          "%#{ActiveRecord::Base.sanitize_sql_like(param)}%"
        end

        def arel_attribute(col, scope)
          if col.is_a?(Arel::Attributes::Attribute)
            col
          else
            scope.arel_table[col]
          end
        end

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

        # Hook: return the value to use when this row is selected (e.g.
        # `encoded_id`). Default tries `encoded_id` on either the raw or
        # transformed row. Subclasses override to supply alternate values.
        def selectable_value_for_row(row_data, transformed_data, _index, _item_index)
          if row_data.respond_to?(:encoded_id)
            row_data.encoded_id
          elsif transformed_data.respond_to?(:encoded_id)
            transformed_data.encoded_id
          elsif row_data.respond_to?(:[]) && row_data[:encoded_id].present?
            row_data[:encoded_id]
          elsif transformed_data.respond_to?(:[]) && transformed_data[:encoded_id].present?
            transformed_data[:encoded_id]
          end
        end

        # Parent returns `filters: nil` when no filters defined, but the
        # SearchAndFilter component types `filters:` as a non-nil Array.
        # Drop nils so its type-check passes.
        def resolved_search_and_filter_options
          super.compact
        end

        # Forward header_emphasis / header_weight onto every emitted header
        # cell so subclasses can dial down header chrome (`header_emphasis:
        # :low` for summary tables).
        def header_cell_attributes
          base = super
          base.map do |attrs|
            attrs.merge(
              emphasis: attrs[:emphasis] || @header_emphasis,
              weight: attrs[:weight] || @header_weight,
              row_height: @header_height
            ).compact
          end
        end

        def setup_component_slots(data_table_component)
          if search_or_filter_element?
            data_table_component.with_search_and_filter(**resolved_search_and_filter_options) do |sf|
              sf.with_actions(&@cta) if @cta && sf.respond_to?(:with_actions)
            end
          end

          header_row = data_table_component.with_data_table_header_row(selectable_as: @rows_selectable_as_name&.to_s)
          header_cell_attributes.each { |attrs| header_row.with_data_table_header_cell(**attrs) }

          prepare_table_rows.each_with_index do |row, ri|
            data_row = data_table_component.with_data_table_row(row.component)
            Rails.logger.info { "[DEBUG] builder loop row[#{ri}] class=#{row.class} row.cells.size=#{row.cells.size} data_row.class=#{data_row.class} data_row.eql_row=#{data_row.equal?(row.component)} dr_oid=#{data_row.object_id} rc_oid=#{row.component.object_id}" }

            if row.expanded_content_renderer
              expanded = row.expanded_content_renderer.call
              data_row.with_expanded_content { expanded } unless expanded.nil?
            end

            row.cells.each_with_index do |cell, ci|
              Rails.logger.info { "[DEBUG] pushing cell[#{ri},#{ci}] to data_row oid=#{data_row.object_id}" }
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
        #
        # Per-row form-builder cache: `fields_for` advances the parent's
        # `nested_child_index` counter on each yield, so we materialise one
        # builder per row up-front and hand the right one to each row.
        def data_to_rows_and_cells(data:, current_page:, page_size:)
          data.map.with_index do |row_data, index|
            item_index = index + ((current_page - 1) * page_size)
            transformed_data = transform_row(row_data, index, item_index)
            path_data = path_for_row(row_data, transformed_data, index, item_index)
            row_attrs = row_attributes(row_data, transformed_data, index, item_index) || {}
            cell_attrs = cell_attributes(row_data, transformed_data, index, item_index) || {}
            apply_relevance_highlight(row_attrs, index) if page_relevance_scores.present?
            builder_for_row = row_nested_form_builders[index]

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
                cell_attrs: cell_attrs,
                form_builder: builder_for_row
              )
            end

            suite_row_for(
              cells: cells,
              item_index: item_index,
              expanded_content_renderer: -> { row_expanded_content(row_data, transformed_data, index, item_index) },
              path: path_data,
              highlight: row_highlight(row_data, transformed_data, index, item_index),
              selectable_as: @rows_selectable_as_name ? "#{@rows_selectable_as_name}_#{item_index}" : nil,
              selectable_value: @rows_selectable_as_name ? selectable_value_for_row(row_data, transformed_data, index, item_index) : nil,
              form_builder: builder_for_row,
              row_attrs: row_attrs
            )
          end
        end

        # Cache one nested-form builder per row. Multi-row nested forms
        # require distinct builders because `fields_for` advances its
        # `nested_child_index` counter on each yield; reusing the same
        # builder across rows produces colliding `name` attributes.
        def row_nested_form_builders
          return @row_nested_form_builders if @row_nested_form_builders
          @row_nested_form_builders =
            if @row_nested_form.blank? || @row_nested_form_attribute_name.blank?
              []
            else
              builders = []
              @row_nested_form.fields_for(@row_nested_form_attribute_name) { |builder| builders << builder }
              builders
            end
        end

        # Lightweight PORO wrappers — the `Decor::Tables::Builder::{Cell,Row}`
        # Literal::Structs constrain `component:` to Daisy classes, so we
        # can't reuse them here. Suite only needs `.component`, `.cells`,
        # and `.expanded_content_renderer` for `setup_component_slots`.
        BuilderCell = Struct.new(:component, keyword_init: true)
        BuilderRow = Struct.new(:cells, :item_index, :expanded_content_renderer, :component, keyword_init: true)

        def suite_cell_for(column:, data:, untransformed:, item_index:, row_height:, path:, content_clickable:, stop_propagation:, cell_attrs:, form_builder: nil)
          rendered = ::Decor::Suite::Tables::Builder::Cell.render_content(
            column, data, item_index, untransformed, @helpers, form_builder: form_builder
          )
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

        def suite_row_for(cells:, item_index:, expanded_content_renderer:, path:, highlight:, selectable_as:, selectable_value:, form_builder:, row_attrs:)
          row_props = {
            path: path,
            highlight: highlight,
            selectable_as: selectable_as,
            selectable_value: selectable_value,
            form_builder: form_builder,
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
