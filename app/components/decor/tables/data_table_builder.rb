module Decor
  module Tables
    class DataTableBuilder
      include ::Literal::Properties
      include ::Decor::Concerns::SanitisedPaginationParams
      include ::Decor::Concerns::SanitisedSortAndFilterParams

      # An optional query object that the table is backed by
      prop :query, Object, default: nil

      # Title to display top left of table header
      prop :title, _Nilable(String)
      prop :subtitle, _Nilable(String)

      # Table settings
      # Whether rows should be striped or not
      prop :alternating, _Boolean, default: false
      # Whether rows should be striped or not
      prop :hover_highlight, _Boolean, default: false
      # Table has pagination
      prop :paginated, _Boolean, default: true
      # The header row height
      prop :header_height, _Nilable(_Union(:comfortable, :standard, :tight))
      # The rows height
      prop :row_height, _Nilable(_Union(:comfortable, :standard, :tight))
      # The name of the checkbox inputs (as a group) which will be used for the row
      # selection checkboxes
      prop :rows_selectable_as_name, _Nilable(Symbol)

      prop :download_path, _Nilable(String)

      prop :row_nested_form, Object, default: nil
      prop :row_nested_form_attribute_name, _Nilable(Symbol)

      prop :html_options, Hash, default: -> { {} }

      # Pagination props (set by merge_pagination_params)
      prop :current_page, _Nilable(Integer)
      prop :page_size, _Nilable(Integer)

      # Pagination parameter names
      prop :page_parameter_name, Symbol, default: :page
      prop :page_size_parameter_name, Symbol, default: :page_size
      prop :custom_page_sizes, _Array(Integer), default: -> { [] }

      # Sorting props (set by merge_sort_and_filter_params)
      prop :sorted_direction, _Nilable(Symbol)
      prop :sort_by, _Nilable(Symbol)
      prop :sort_parameter_name, Symbol, default: :sort_by
      prop :sorted_direction_parameter_name, Symbol, default: :sorted_direction
      prop :sorting_keys, _Array(Symbol), default: -> { [] }

      # Relevance data virtual attribute
      attr_reader :page_relevance_scores

      # The builder takes both the params to be able to get sort and filter query params, and the
      # view helpers to expose to subclasses to use as needed
      def initialize(attributes, params, helpers)
        # These methods rely on us overriding the *_name attrs with methods that return before attributes are set
        merge_pagination_params(attributes, params)
        merge_sort_and_filter_params(attributes, params)
        super(**attributes)
        @helpers = helpers
        @params = params.permit(keys_for_permit)
        @columns_hash = {}
        @slots = {}
        yield(self) if block_given?
        setup_data_table
      end

      # Public so controllers can use the builder as a way to filter params
      attr_reader :params

      def parse_current_page_param(param)
        return 1 unless param
        cleaned = param.tr("^0-9", "")
        cleaned.to_i
      end

      def parse_page_size_param(param)
        return unless param
        cleaned = param.tr("^0-9", "")
        cleaned.to_i
      end

      def merge_pagination_params(attrs, params)
        attrs.merge!(
          current_page: parse_current_page_param(params[attrs[:page_parameter_name] || :page]),
          page_size: parse_page_size_param(params[attrs[:page_size_parameter_name] || :page_size])
        )
      end

      def merge_sort_and_filter_params(attrs, params)
        direction = params[attrs[:sorted_direction_parameter_name] || :sorted_direction]
        key = params[attrs[:sort_parameter_name] || :sort_by]
        attrs.merge!(
          sorted_direction: direction&.to_sym,
          sort_by: key&.to_sym
        )
      end

      def configure_slot(name, **attributes, &block)
        @slots[name] = {attributes: attributes, block: block}
      end

      # Returns the view component ready to render
      def component
        return @component if defined?(@component)
        @component = ::Decor::Tables::DataTable.new(
          title: title,
          subtitle: subtitle,
          html_options: html_options
        ).tap do |new_component|
          setup_component_slots(new_component)
        end
      end

      # Define a column and how its cells are rendered -> used in views
      def column(name, options = {}, &row_cell_block)
        opts = columns_hash[name].present? ? columns_hash[name].attributes : {name: name}
        opts = opts.merge(options)
        opts = opts.merge(cell_block: row_cell_block) if row_cell_block
        if mem_sorting&.key?(name)
          opts = opts.merge(sortable: true, sort_method: mem_sorting[name])
        end
        opts[:title] = name.to_s.humanize if name && !opts[:title]
        opts[:index] = columns_hash.keys.size if opts[:index].blank?
        columns_hash[name] = ::Decor::Tables::Builder::Column.new(**opts)
        self
      end

      def with_cta(&render_block)
        @cta = render_block
      end

      private

      # Hooks & methods to override as needed

      # Implement this hook if needed in subclasses
      def setup_data_table
      end

      # The block returns the base Query object or AR query
      def resolved_query(collection = nil)
        @resolved_query ||= @query || collection
      end

      # Default sort to apply to table if none is provided
      def apply_default_table_sort(query)
        query
      end

      # Pagination options, override as needed
      def pagination_options
        {}
      end

      # Search and filter options, override as needed
      def search_and_filter_options
        {}
      end

      # Override to perform some data transform to row data before rendering
      def transform_row(row_data, _index, _item_index)
        row_data
      end

      # Override to return a path to link to for the given row
      def path_for_row(_row_data, _transformed_value, _index, _item_index)
      end

      # Override to provide row attributes
      def row_attributes(_row_data, _transformed_value, _index, _item_index)
        {}
      end

      # Override to provide cell attributes
      def cell_attributes(_row_data, _transformed_value, _index, _item_index)
        {}
      end

      # Returns symbol (:low, :medium, :high). By default highlight if we are alternating
      def row_highlight(_row, _transformed_value, index, _item_index)
        (alternating && index.odd?) ? :gray_low : nil
      end

      def row_expanded_content(_row, _transformed_value, _index, _item_index)
      end

      # Returns a hash of named filters
      def filters
      end

      # Returns a hash of named sorts
      def sorting
      end

      # Returns the search config
      def search
      end

      # Internal methods

      attr_reader :helpers, :columns_hash

      def mem_search
        @mem_search ||= search
      end

      def mem_filters
        @mem_filters ||= filters
      end

      def mem_sorting
        @mem_sorting ||= sorting
      end

      # Columns are sorted by the index attribute
      def columns
        columns_hash.values.sort_by(&:index)
      end

      def column_names
        columns.map(&:name)
      end

      # Prepare the slots of the component
      def setup_component_slots(data_table_component)
        if search_or_filter_element?
          filter_options = resolved_search_and_filter_options
          data_table_component.with_search_and_filter do
            render ::Decor::SearchAndFilter.new(**filter_options) do |component|
              component.with_actions(&@cta) if @cta
            end
          end
        end
        data_table_component.with_data_table_header_row(selectable_as: rows_selectable_as_name) do |header_row_component|
          header_cell_attributes.each { |col| header_row_component.with_data_table_header_cell(**col) }
        end
        prepare_table_rows.each do |row|
          data_table_component.with_data_table_row(**row.component) do |row_component|
            if row.expanded_content_renderer
              expanded_content = row.expanded_content_renderer.call
              row_component.with_expanded_content { expanded_content } unless expanded_content.nil?
            end
            row.cells.each do |cell|
              row_component.with_data_table_cell(**cell.component)
            end
          end
        end
        if paginated?
          pagination_options = resolved_pagination_options
          data_table_component.with_pagination do
            render ::Decor::Pagination.new(**pagination_options)
          end
        end

        @slots.each do |name, configuration|
          data_table_component.send(:"with_#{name}", **configuration[:attributes], &configuration[:block])
        end
      end

      def header_cell_attributes
        @header_cell_attributes ||=
          visible_header_columns.map do |col|
            col.to_h.slice(
              :weight,
              :title,
              :numeric,
              :colspan,
              :emphasis,
              :weight
            ).compact_blank!.merge(
              row_height: header_height,
              stretch_divisor: col.stretch ? visible_columns.count(&:stretch) : nil,
              sort_key: (col.sortable && !search_enabled?) ? col.name : nil,
              sorted_direction: resolved_sort_direction(col)
            )
          end
      end

      def visible_header_columns
        @visible_header_columns ||= if columns.all? { |c| c.title.blank? }
          []
        else
          columns.filter { |c| c.colspan != 0 }
        end
      end

      def visible_columns
        @visible_columns ||= columns.filter(&:cell_block)
      end

      def search_enabled?
        search_with_value&.value&.present?
      end

      def search_or_filter_element?
        mem_search.present? || mem_filters.present? || @cta.present? || download_path.present?
      end

      # The params keys needed by this table
      def keys_for_permit
        k = []
        k += [
          page_parameter_name,
          page_size_parameter_name,
          sort_parameter_name,
          sorted_direction_parameter_name
        ]
        k.compact_blank.concat(filter_param_keys).map(&:to_s)
      end

      def filter_param_keys
        (Array.wrap(mem_filters) + [mem_search]).compact.pluck(:name)
      end

      def resolved_pagination_options
        {
          page_size_selector: true,
          page_parameter_name: page_parameter_name,
          page_size_parameter_name: page_size_parameter_name,
          current_page: current_page,
          page_size: page_size,
          custom_page_sizes: custom_page_sizes
        }.merge(pagination_options).merge(
          collection: prepared_query_objects[:count],
          page_size: prepared_row_query_object.page_size
        )
      end

      # These are the options that will be passed to the Query and then
      # subsequently this info will be used by Pagination
      def query_pagination_options
        {page: sanitised_current_page, page_size: sanitised_page_size}
      end

      def search_with_value
        return unless mem_search
        filter_set_current_param_value(mem_search)
      end

      def resolved_search_and_filter_options
        options = search_and_filter_options
        options[:download_path] = download_path if download_path.present?
        options[:filters] = mem_filters&.map do |filter|
          filter_set_current_param_value(filter)
        end
        options[:search] = search_with_value if mem_search
        options
      end

      def filter_set_current_param_value(filter)
        if params[filter.name].present?
          filter.class.new(**filter.attributes.merge(value: params[filter.name]))
        else
          filter
        end
      end

      def resolved_sort_direction(col)
        if search_enabled?
          nil
        else
          (sanitised_sort_by&.to_sym == col.name) ? sanitised_sorted_direction : nil
        end
      end

      def sorting_keys
        columns.select(&:sortable).pluck(:name)
      end

      # Methods to work with the collection underlying the table

      # Prepare the rows and cells for the current page of data
      def prepare_table_rows
        query = prepared_row_query_object
        data_to_rows_and_cells(
          data: final_db_query.results.to_a,
          current_page: query.page || 1,
          page_size: query.page_size
        )
      end

      # The underlying data Query which will be used to fetch a page of data to render
      def prepared_query_objects
        @prepared_query_objects ||=
          begin
            q = resolved_query
            # If not a query object, wrap it
            query_object = if q.is_a? ::Quo::Query
              q
            elsif q.is_a?(::ActiveRecord::Relation)
              if paginated?
                ::Quo.relation_backed_query_base_class.wrap(q).new(**query_pagination_options)
              else
                ::Quo.collection_backed_query_base_class.wrap(q).new
              end
            else
              ::Quo.collection_backed_query_base_class.wrap(q).new
            end

            queries = {rows: query_object, count: query_object}

            # Apply filters
            filters_and_search = mem_filters&.dup || []
            filters_and_search << mem_search if mem_search
            filters_and_search&.each do |filter|
              param = params[filter.name]
              next if param.blank?
              r = filter.apply.call(queries[:rows], param)
              if r.is_a?(Hash)
                c = filter.apply.call(queries[:count], param)
                queries = {rows: r[:rows], count: c[:count]}
              else
                queries = {rows: r, count: r}
              end
            end

            # FIXME: should we really allow the filter to return anything but instances of Quo::Query?

            if paginated?
              queries[:rows] = if queries[:rows].is_a?(::Quo::Query)
                queries[:rows].copy(**query_pagination_options)
              elsif queries[:rows].is_a?(::ActiveRecord::Relation)
                ::Quo.relation_backed_query_base_class.wrap(queries[:rows]).new(**query_pagination_options)
              else
                ::Quo.collection_backed_query_base_class.wrap(queries[:rows]).new(**query_pagination_options)
              end
              queries[:count] = if queries[:count].is_a?(::Quo::Query)
                queries[:count].copy(**query_pagination_options)
              elsif queries[:count].is_a?(::ActiveRecord::Relation)
                ::Quo.relation_backed_query_base_class.wrap(queries[:count]).new(**query_pagination_options)
              else
                ::Quo.collection_backed_query_base_class.wrap(queries[:count]).new(**query_pagination_options)
              end
            else
              queries[:rows] = if queries[:rows].is_a?(::Quo::Query)
                queries[:rows]
              elsif queries[:rows].is_a?(::ActiveRecord::Relation)
                ::Quo.relation_backed_query_base_class.wrap(queries[:rows]).new
              else
                ::Quo.collection_backed_query_base_class.wrap(queries[:rows]).new
              end
              queries[:count] = if queries[:count].is_a?(::Quo::Query)
                queries[:count]
              elsif queries[:count].is_a?(::ActiveRecord::Relation)
                ::Quo.relation_backed_query_base_class.wrap(queries[:count]).new
              else
                ::Quo.collection_backed_query_base_class.wrap(queries[:count]).new
              end
            end

            queries
          end
      end

      def prepared_row_query_object
        prepared_query_objects[:rows]
      end

      # Returns a collecton or AR relation
      def final_db_query
        @final_db_query ||= begin
          col_for_sort = columns_hash[sanitised_sort_by] if sanitised_sort_by
          q = prepared_row_query_object

          # When searching, we don't want to apply any sorting as the search results are already sorted by relevance..
          # Finrl db query is returning a AR or Array, but then we loose our tranformations at the query level... we should
          # not need to unwrap.....
          #
          if search_enabled?
            q
          else
            col_for_sort&.sortable ?
              apply_sort(
                query: q,
                sort_by: sanitised_sort_by,
                sorted_direction: sanitised_sorted_direction,
                sort_method: col_for_sort.sort_method
              ) :
              apply_default_table_sort(q)
          end
        end
      end

      # Sorting, returns a AR or Array
      def apply_sort(query:, sort_by:, sorted_direction:, sort_method:)
        if query.is_a?(Quo::Query) && query.relation?
          default_relation_sort_method(query, sort_by, sorted_direction, sort_method)
        else
          default_sort_method(query, sort_by, sorted_direction, sort_method)
        end
      end

      # Sort an enumerable collection (ie this should never be called with a relation backed query or AR relation)
      def default_sort_method(query, sort_by_key, direction, mapper)
        # Extract first item if query is a Collection backed query
        first_item = query.is_a?(Quo::Query) ? query.unwrap.first : query.first
        # check if sort_by_key is valid
        return query unless mapper || sort_key_valid?(first_item, sort_by_key)
        q = query.is_a?(Quo::Query) ? query.results.to_a : query
        q.sort do |a, b|
          a_value = extract_sort_value(sort_by_key, a, mapper)
          b_value = extract_sort_value(sort_by_key, b, mapper)
          (direction == :asc) ? a_value <=> b_value : b_value <=> a_value
        end
      end

      # If an AR relation apply sort at query level
      def default_relation_sort_method(query, sort_by, direction, sort_method)
        return sort_method.call(query, direction == :asc) if sort_method
        return query unless query.unwrap.model.column_names.include?(sort_by.to_s)
        query.order([[sort_by, direction]].to_h)
      end

      # Is it possible to sort the elements by the given key?
      def sort_key_valid?(element, sort_by_key)
        element&.respond_to?(sort_by_key) || (element&.respond_to?(:key?) && element.key?(sort_by_key))
      end

      # The value to sort, as specified by the sort_key, from the element
      def extract_sort_value(sort_by_key, input, mapper)
        if mapper
          mapper.call(input)
        elsif input.respond_to?(sort_by_key)
          input.send(sort_by_key)
        elsif input.key?(sort_by_key)
          input[sort_by_key]
        else
          raise StandardError,
            "Dont know how to get #{sort_by_key} from #{input}. Did you expect a attribute to exist " \
  "or to have defined a column `mapper`?"
        end
      end

      def data_to_rows_and_cells(data:, current_page:, page_size:)
        data.map.with_index do |row_data, index|
          item_index = index + ((current_page - 1) * page_size)
          transformed_data = transform_row(row_data, index, item_index)
          path_data = path_for_row(row_data, transformed_data, index, item_index)
          row_attrs = row_attributes(row_data, transformed_data, index, item_index) || {}
          cell_attrs = cell_attributes(row_data, transformed_data, index, item_index) || {}
          apply_relevance_highlight(row_attrs, index) if page_relevance_scores.present?

          ::Decor::Tables::Builder::Row.new(
            cells: visible_columns.map do |column|
              ::Decor::Tables::Builder::Cell.new(
                column: column,
                data: transformed_data,
                untransformed: row_data,
                item_index: item_index,
                row_height: row_height,
                path: column.navigates_to_path? ? path_data : nil,
                content_clickable: column.content_clickable?,
                stop_propagation: column.stop_propagation?,
                **cell_attrs
              )
            end,
            item_index: item_index,
            path: path_data,
            highlight: row_highlight(row_data, transformed_data, index, item_index),
            prepared_form_builder: row_nested_form_builder,
            expanded_content_renderer: -> do
              row_expanded_content(row_data, transformed_data, index, item_index)
            end,
            **row_attrs
          )
        end
      end

      def row_nested_form_builder
        return if row_nested_form.blank? || row_nested_form_attribute_name.blank?

        # Here we exit early from the method from inside the block to allow us to nab the builder instance for the
        # nested object
        row_nested_form.fields_for(row_nested_form_attribute_name) { |builder| return builder }
      end

      private

      # Setup colors for use in highlights
      HIGHLIGHT_RANK = [nil, nil, :gray_low, :low].freeze

      def apply_relevance_highlight(row_attrs, index)
        rank = page_relevance_scores ? page_relevance_scores[index] : nil
        return unless rank
        color_index = rank ? [4, ((rank + 0.25) * 4.0).floor.to_i].min - 1 : 0
        row_attrs[:highlight] = HIGHLIGHT_RANK[color_index]
        row_attrs
      end

      def exec_row_render_method(
        cell_component,
        row_component,
        block,
        item = nil,
        item_index = nil,
        untransformed = nil
      )
        # Execute the block and output the result
        result = case block.arity
        when -2, -1, 1
          block.call(item).to_s
        when 2
          block.call(item, item_index).to_s
        when 3
          block.call(item, item_index, untransformed).to_s
        when 4
          block.call(item, item_index, untransformed, row_component).to_s
        when 5
          block.call(item, item_index, untransformed, row_component, self).to_s
        else
          block.call.to_s
        end

        # Output the result directly
        cell_component.plain(result)
      end
    end
  end
end
