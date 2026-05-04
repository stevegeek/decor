# frozen_string_literal: true

module Decor
  module Daisy
    module Tables
      class DataTable < ::Decor::Components::Tables::DataTable
        def view_template(&)
          vanish(&)
          root_element do |el|
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
                    render ::Decor::Daisy::Icon.new(name: "database", html_options: {class: "mx-auto h-6 w-6 text-base-content/40"})
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
            "table",
            size_classes,
            @zebra ? "table-zebra" : nil,
            @pin_rows ? "table-pin-rows" : nil,
            @pin_cols ? "table-pin-cols" : nil,
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
          else ""
          end
        end

        def component_style_classes(style)
          case style
          when :bordered then "border border-base-300"
          when :minimal then ""
          when :default then ""
          else ""
          end
        end
      end
    end
  end
end
