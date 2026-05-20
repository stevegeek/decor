# frozen_string_literal: true

module Decor
  module Suite
    module Tables
      # Suite DataTable — admin-density tabular surface with hairline chrome,
      # compact 13px body type, gray-25 header row, and dashed empty-state
      # callout. Matches the historical Suite identity (not the daisyUI-native
      # zebra/divider chrome).
      #
      # Slot API mirrors ConfinusUI semantics:
      #   - `with_data_table_header(&block)` — replaces the default chrome header
      #   - `with_search_and_filter(**attrs, &block)` — renders SearchAndFilter
      #     in the header band; chainable `.with_actions { ... }` forwards to it
      #   - `with_filter_bar(&block)` — block rendered between header and table
      #   - `with_data_table_header_row(**attrs, &block)` — adds a header row
      #   - `with_data_table_row(**attrs, &block)` — adds a body row
      #   - `with_pagination(**attrs)` — instantiates a Pagination
      #   - `with_bulk_actions_bar(**attrs, &block)` — bottom action bar
      #   - `with_data_table_footer(**attrs)` — bottom footer band
      class DataTable < ::Decor::Components::Tables::DataTable
        # Description rendered below the title in the header band.
        prop :description, _Nilable(String)
        # Toggles vertical gridlines between body cells (Suite parity with the
        # ConfinusUI `enabled_grid` option).
        prop :enabled_grid, _Boolean, default: false

        # NOTE: `classes:` and `html_options:` are inherited from Vident's
        # `Declarable` capability and forwarded to the root element by default.
        # The `table_html_options` prop is separate — it lands on the inner
        # `<table>` element, not the card root.

        # Suite skin uses its own Stimulus outlet identifiers (string-keyed so
        # the parallel Suite row/cell/bulk-actions skins don't need to exist
        # at load time).
        stimulus do
          outlets({
            "decor--suite--tables--data-table-header-row" => nil,
            "decor--suite--tables--data-table-row" => nil,
            "decor--suite--tables--bulk-actions-bar" => nil
          })
        end

        # Suite-specific slot extensions (Confinus signature: **attrs + block).
        def with_search_and_filter(**attrs, &block)
          @search_and_filter_attrs = attrs
          @search_and_filter_block = block
          self
        end

        # Forwarded to the SearchAndFilter slot so callers can chain
        # `table.with_search_and_filter.with_actions { ... }`.
        def with_actions(&block)
          @search_and_filter_actions_block = block
          @search_and_filter_attrs ||= {}
          self
        end

        def with_filter_bar(&block)
          @filter_bar_block = block
          self
        end

        def with_bulk_actions_bar(**attrs, &block)
          @bulk_actions_bar_attrs = attrs
          @bulk_actions_bar_block = block
          self
        end

        # Suite stores footer attrs and instantiates the Suite-skinned footer
        # at render time (parent stores a built component instance instead).
        def with_data_table_footer(component = nil, **attrs, &block)
          if component
            @data_table_footer = component
          else
            @data_table_footer_attrs = attrs
          end
          self
        end

        # Default Suite slot constructors prefer the Suite skin if it has been
        # loaded; otherwise fall back to the parent's Daisy default. This keeps
        # the port forward-compatible with the parallel Suite row/cell ports.
        def with_data_table_header_row(component = nil, **attributes, &block)
          if component
            super
          else
            row = suite_const_or_daisy(:DataTableHeaderRow).new(**attributes)
            @data_table_header_rows << [row, block]
            row
          end
        end

        def with_data_table_row(component = nil, **attributes, &block)
          if component
            super
          else
            row = suite_const_or_daisy(:DataTableRow).new(**attributes)
            @data_table_rows << [row, block]
            row
          end
        end

        def view_template(&)
          vanish(&)
          root_element do
            render_header_section
            render_filter_bar
            render_table_body
            render_bulk_actions_bar
            render_pagination
            render_footer
          end
        end

        private

        def suite_const_or_daisy(name)
          if defined?(::Decor::Suite::Tables) && ::Decor::Suite::Tables.const_defined?(name, false)
            ::Decor::Suite::Tables.const_get(name)
          else
            ::Decor::Daisy::Tables.const_get(name)
          end
        end

        def render_header_section
          return unless @title.present? || @data_table_header.present? || @search_and_filter_attrs

          render @data_table_header if @data_table_header.present?

          if @title.present? || @search_and_filter_attrs
            div(class: "decor:px-5 decor:py-[14px] decor:border-b decor:border-suite-hairline decor:flex decor:items-center decor:justify-between decor:gap-4") do
              div(class: "decor:min-w-0") do
                h3(class: "decor:suite-section-title decor:text-gray-900") { plain @title.to_s }
                if @subtitle.present?
                  p(class: "decor:suite-description decor:text-gray-500 decor:mt-[2px]") { plain @subtitle.to_s }
                end
                if @description.present?
                  p(class: "decor:suite-description decor:text-gray-500 decor:mt-[2px]") { plain @description.to_s }
                end
              end
              if @search_and_filter_attrs
                div(class: "decor:flex decor:gap-[6px] decor:items-center") do
                  sf_klass = if defined?(::Decor::Suite::SearchAndFilter)
                    ::Decor::Suite::SearchAndFilter
                  else
                    ::Decor::Daisy::SearchAndFilter
                  end
                  sf = sf_klass.new(**@search_and_filter_attrs)
                  sf.with_actions(&@search_and_filter_actions_block) if @search_and_filter_actions_block && sf.respond_to?(:with_actions)
                  render(sf, &@search_and_filter_block)
                end
              end
            end
          end
        end

        def render_filter_bar
          return unless @filter_bar_block
          render @filter_bar_block
        end

        def render_table_body
          div(class: "decor:flex decor:flex-col decor:overflow-hidden decor:relative") do
            div(
              class: "decor:overflow-x-auto",
              data: {
                **stimulus_target(:table_content_container),
                **stimulus_action(:scroll, :content_scrolled)
              }
            ) do
              table(class: table_classes, **@table_html_options) do
                if @data_table_header_rows.any?
                  thead(class: "decor:bg-suite-gray-25 decor:border-b decor:border-suite-hairline") do
                    @data_table_header_rows.each do |row, block|
                      render(row, &block)
                    end
                  end
                end
                tbody(data: {**stimulus_target(:table_body)}) do
                  @data_table_rows.each do |row, block|
                    render(row, &block)
                  end
                end
              end
              render_empty_state unless @data_table_rows.any?
            end
          end
        end

        def render_empty_state
          div(class: "decor:bg-white decor:relative decor:block decor:my-6 decor:mx-6 decor:border-2 decor:border-suite-hairline decor:border-dashed decor:rounded-suite-card decor:py-12 decor:text-center decor:hover:border-suite-hairline-strong") do
            render ::Decor::Icon.new(name: @empty_state_icon, html_options: {class: "decor:mx-auto decor:h-6 decor:w-6 decor:text-gray-400"})
            span(class: "decor:mt-2 decor:block decor:suite-body decor:font-medium decor:text-gray-900") { @empty_state_title }
          end
        end

        def render_bulk_actions_bar
          return unless @bulk_actions_bar_attrs
          bar_klass = if defined?(::Decor::Suite::Tables::BulkActionsBar)
            ::Decor::Suite::Tables::BulkActionsBar
          else
            ::Decor::Daisy::Tables::BulkActionsBar
          end
          bar = bar_klass.new(**@bulk_actions_bar_attrs)
          add_stimulus_outlets(bar) if respond_to?(:add_stimulus_outlets)
          render(bar, &@bulk_actions_bar_block)
        end

        def render_pagination
          return unless @pagination_block || @pagination_attrs
          if @pagination_block
            render @pagination_block
          elsif @pagination_attrs
            pag_klass = defined?(::Decor::Suite::Pagination) ? ::Decor::Suite::Pagination : ::Decor::Daisy::Pagination
            render pag_klass.new(**@pagination_attrs)
          end
        end

        # Suite supports both component-style footer (set via parent slot) and
        # attrs-style footer (set via overridden slot above).
        def render_footer
          if @data_table_footer.present?
            render @data_table_footer
          elsif @data_table_footer_attrs
            footer_klass = if defined?(::Decor::Suite::Tables::DataTableFooter)
              ::Decor::Suite::Tables::DataTableFooter
            else
              ::Decor::Daisy::Tables::DataTableFooter
            end
            render footer_klass.new(**@data_table_footer_attrs)
          end
        end

        # Suite `with_pagination(**attrs)` mirrors Confinus (attrs, not block).
        # Keep the parent's block-style as a fallback so existing callers work.
        public def with_pagination(*args, **attrs, &block)
          if block
            super(&block)
          else
            @pagination_attrs = attrs
            self
          end
        end

        def root_element_classes
          "decor:bg-white decor:border decor:border-suite-hairline decor:rounded-suite-card"
        end

        def table_classes
          # 13px dense body, hairline divider rows, full width. Suite tables do
          # NOT use daisyUI `.table` chrome — too tall, wrong color palette.
          # Last-row cells drop their bottom border so the table doesn't
          # double-border against the card edge. `enabled_grid` adds vertical
          # hairlines between every body cell for spreadsheet-style readback.
          [
            "decor:w-full decor:border-collapse decor:text-[13px]",
            "decor:[&_tbody_tr:last-child_td]:border-b-0",
            @enabled_grid ? "decor:[&_tbody_td]:border-r decor:[&_tbody_td]:border-suite-hairline decor:[&_tbody_td:last-child]:border-r-0 decor:[&_thead_th]:border-r decor:[&_thead_th]:border-suite-hairline decor:[&_thead_th:last-child]:border-r-0" : nil,
            @zebra ? "decor:[&_tbody_tr:nth-child(even)]:bg-suite-gray-25" : nil,
            @pin_rows ? "decor:[&_thead]:sticky decor:[&_thead]:top-0 decor:[&_thead]:z-10" : nil
          ].compact.join(" ")
        end
      end
    end
  end
end
