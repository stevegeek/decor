# frozen_string_literal: true

module Decor
  module Tables
    # A table which can include filters and pagination. Setup options using the DataTableBuilder to make life
    # easier.
    class DataTable < PhlexComponent
      attr_reader :data_table_header, :data_table_header_rows, :data_table_rows, :data_table_footer

      def after_component_initialize
        @data_table_header_rows = []
        @data_table_rows = []
      end

      def with_data_table_header(**attributes, &block)
        @data_table_header = block
        self
      end

      def with_search_and_filter(&block)
        @search_and_filter_block = block
        self
      end

      def with_data_table_header_row(component = nil, **attributes, &block)
        header_row = component || ::Decor::Tables::DataTableHeaderRow.new(**attributes)
        @data_table_header_rows << if block_given?
          [header_row, block]
        else
          [header_row, nil]
        end
        header_row
      end

      def with_data_table_row(component = nil, **attributes, &block)
        row = component || ::Decor::Tables::DataTableRow.new(**attributes)
        @data_table_rows << if block_given?
          [row, block]
        else
          [row, nil]
        end
        row
      end

      def with_pagination(&block)
        @pagination_block = block
        self
      end

      def with_data_table_footer(component = nil, **attributes, &block)
        @data_table_footer = component || ::Decor::Tables::DataTableFooter.new(**attributes)
        self
      end

      prop :title, _Nilable(String)
      prop :subtitle, _Nilable(String)

      # Use unified prop system
      default_size :md
      default_color :base  # Tables typically use base styling
      default_style :default

      # DataTable uses domain-specific styles for table presentation
      redefine_styles :default, :bordered, :minimal

      prop :striped, _Boolean, default: true
      prop :compact, _Boolean, default: false
      prop :zebra, _Boolean, default: false
      prop :pin_rows, _Boolean, default: false
      prop :pin_cols, _Boolean, default: false

      stimulus do
        outlets header_row: ::Decor::Tables::DataTableHeaderRow.stimulus_identifier, row: ::Decor::Tables::DataTableRow.stimulus_identifier
      end

      def view_template(&)
        vanish(&)

        root_element do |el|
          # Data table header section
          if @title.present? || @data_table_header.present? || @search_and_filter_block.present?
            if @data_table_header.present?
              render @data_table_header
            end
            div(class: "bg-base-200 px-3 sm:px-6 py-5") do
              div(class: "sm:flex sm:items-center sm:justify-between") do
                div do
                  h3(class: "text-lg leading-6 font-medium text-base-content") do
                    @title
                  end
                  if @subtitle.present?
                    p(class: "mt-1 text-sm text-base-content/70") do
                      @subtitle
                    end
                  end
                end
                if @search_and_filter_block.present?
                  render @search_and_filter_block
                end
              end
            end
          end

          # Rows
          div(class: "flex flex-col overflow-hidden relative") do
            div(
              class: "overflow-x-auto",
              data: {
                **stimulus_target(:table_content_container),
                **stimulus_action(:scroll, :content_scrolled)
              }
            ) do
              table(class: table_classes) do
                if @data_table_header_rows.any?
                  thead(class: "bg-base-200 ltr:text-left rtl:text-right") do
                    @data_table_header_rows.each do |header_row_data|
                      header_row, block = header_row_data
                      render(header_row, &block)
                    end
                  end
                end
                tbody(
                  class: tbody_classes,
                  data: {**stimulus_target(:table_body)}
                ) do
                  @data_table_rows.each do |row_data|
                    row, block = row_data
                    render(row, &block)
                  end
                end
              end
              unless @data_table_rows.any?
                div(class: "bg-base-100 relative block my-6 mx-6 border-2 border-base-300 border-dashed rounded-md py-12 text-center hover:border-base-200") do
                  render ::Decor::Icon.new(name: "database", html_options: {class: "mx-auto h-6 w-6 text-base-content/40"})
                  span(class: "mt-2 block text-sm font-medium text-base-content") { "No data..." }
                end
              end
            end
          end

          if @pagination_block.present?
            render @pagination_block
          end

          if @data_table_footer.present?
            render @data_table_footer
          end
        end
      end

      private

      def root_element_classes
        [
          "bg-base-100 rounded-lg",
          style_classes
        ].compact_blank.join(" ")
      end

      def table_classes
        [
          # DaisyUI base table class
          "table",
          # DaisyUI size variants
          size_classes,
          # DaisyUI features
          @zebra ? "table-zebra" : nil,
          @pin_rows ? "table-pin-rows" : nil,
          @pin_cols ? "table-pin-cols" : nil,
          # Legacy support - maintain existing behavior with daisyUI colors
          "min-w-full bg-base-100",
          @compact ? "text-xs" : "text-sm",
          (@style == :minimal) ? "divide-y divide-base-200" : "divide-y-2 divide-base-300",
          (@style == :bordered) ? "border-collapse" : nil
        ].compact_blank.join(" ")
      end

      def tbody_classes
        [
          "divide-y divide-base-300",
          @striped ? "*:even:bg-base-200" : nil
        ].compact_blank.join(" ")
      end

      def component_size_classes(size)
        case size
        when :xs then "table-xs"
        when :sm then "table-sm"
        when :lg then "table-lg"
        when :xl then "table-xl"
        else ""  # md is default, no class needed
        end
      end

      def component_style_classes(style)
        case style
        when :bordered then "border border-base-300"
        when :minimal then ""  # handled in table_classes method
        when :default then ""
        else ""
        end
      end
    end
  end
end
