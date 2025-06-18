# frozen_string_literal: true

module Decor
  module Tables
    # A table which can include filters and pagination. Setup options using the DataTableBuilder to make life
    # easier.
    class DataTable < PhlexComponent
      attr_reader :data_table_header, :search_and_filter, :data_table_header_rows, :data_table_rows, :pagination, :data_table_footer

      def initialize(**attributes)
        super
        @data_table_header_rows = []
        @data_table_rows = []
      end

      def with_data_table_header(**attributes, &block)
        @data_table_header = block
        self
      end

      def with_search_and_filter(component = nil, **attributes, &block)
        @search_and_filter = component || block
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

      def with_pagination(component = nil, **attributes, &block)
        @pagination = component || ::Decor::Pagination.new(**attributes)
        self
      end

      def with_data_table_footer(component = nil, **attributes, &block)
        @data_table_footer = component || ::Decor::Tables::DataTableFooter.new(**attributes)
        self
      end

      attribute :title, String
      attribute :subtitle, String

      # Table styling variants
      attribute :variant, Symbol, default: :default, in: [:default, :bordered, :minimal]
      attribute :striped, :boolean, default: true
      attribute :compact, :boolean, default: false

      # DaisyUI enhancements
      attribute :size, Symbol, default: :md, in: [:xs, :sm, :md, :lg, :xl]
      attribute :zebra, :boolean, default: false
      attribute :pin_rows, :boolean, default: false
      attribute :pin_cols, :boolean, default: false

      def view_template(&)
        vanish(&)

        render parent_element do |el|
          # Data table header section
          if @title.present? || @data_table_header.present? || @search_and_filter.present?
            if @data_table_header.present?
              instance_eval(@data_table_header).html_safe
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
                if @search_and_filter.present?
                  if @search_and_filter.respond_to?(:call)
                    @search_and_filter.call
                  else
                    render @search_and_filter
                  end
                end
              end
            end
          end

          # Rows
          div(class: "flex flex-col overflow-hidden relative") do
            div(
              class: "overflow-x-auto",
              data: {
                action: el.send(:parse_actions, [[:scroll, :content_scrolled]]).join(" "),
                **el.send(:build_target_data_attributes, el.send(:parse_targets, [:table_content_container]))
              }
            ) do
              table(class: table_classes) do
                if @data_table_header_rows.any?
                  thead(class: "bg-base-200 ltr:text-left rtl:text-right") do
                    @data_table_header_rows.each do |header_row_data|
                      header_row, _ = header_row_data
                      # instance_eval(header_row).html_safe
                      render header_row
                    end
                  end
                end
                tbody(
                  class: tbody_classes,
                  data: {
                    **el.send(:build_target_data_attributes, el.send(:parse_targets, [:table_body]))
                  }
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

          if @pagination.present?
            render @pagination
          end

          if @data_table_footer.present?
            render @data_table_footer
          end
        end
      end

      private

      def root_element_attributes
        {
          outlets: [
            ::Decor::Tables::DataTableHeaderRow.stimulus_identifier,
            ::Decor::Tables::DataTableRow.stimulus_identifier
          ]
        }
      end

      def element_classes
        [
          "bg-base-100 rounded-lg",
          (@variant == :bordered) ? "border border-base-300" : nil
        ].compact_blank.join(" ")
      end

      def table_classes
        [
          # DaisyUI base table class
          "table",
          # DaisyUI size variants
          daisyui_size_class,
          # DaisyUI features
          @zebra ? "table-zebra" : nil,
          @pin_rows ? "table-pin-rows" : nil,
          @pin_cols ? "table-pin-cols" : nil,
          # Legacy support - maintain existing behavior with daisyUI colors
          "min-w-full bg-base-100",
          @compact ? "text-xs" : "text-sm",
          (@variant == :minimal) ? "divide-y divide-base-200" : "divide-y-2 divide-base-300",
          (@variant == :bordered) ? "border-collapse" : nil
        ].compact_blank.join(" ")
      end

      def tbody_classes
        [
          "divide-y divide-base-300",
          @striped ? "*:even:bg-base-200" : nil
        ].compact_blank.join(" ")
      end

      def daisyui_size_class
        case @size
        when :xs
          "table-xs"
        when :sm
          "table-sm"
        when :lg
          "table-lg"
        when :xl
          "table-xl"
        else
          nil # md is the default, no class needed
        end
      end
    end
  end
end
