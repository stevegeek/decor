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
              div(class: "decor:bg-base-200 decor:px-3 decor:sm:px-6 decor:py-5") do
                div(class: "decor:sm:flex decor:sm:items-center decor:sm:justify-between") do
                  div do
                    h3(class: "decor:text-lg decor:leading-6 decor:font-medium decor:text-base-content") do
                      @title
                    end
                    if @subtitle.present?
                      p(class: "decor:mt-1 decor:text-sm decor:text-base-content/70") do
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

            div(class: "decor:flex decor:flex-col decor:overflow-hidden decor:relative") do
              div(
                class: "decor:overflow-x-auto",
                data: {
                  **stimulus_target(:table_content_container),
                  **stimulus_action(:scroll, :content_scrolled)
                }
              ) do
                table(class: table_classes) do
                  if @data_table_header_rows.any?
                    thead(class: "decor:bg-base-200 decor:ltr:text-left decor:rtl:text-right") do
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
                  div(class: "decor:bg-base-100 decor:relative decor:block decor:my-6 decor:mx-6 decor:border-2 decor:border-base-300 decor:border-dashed decor:rounded-md decor:py-12 decor:text-center decor:hover:border-base-200") do
                    render ::Decor::Icon.new(name: "database", html_options: {class: "decor:mx-auto decor:h-6 decor:w-6 decor:text-base-content/40"})
                    span(class: "decor:mt-2 decor:block decor:text-sm decor:font-medium decor:text-base-content") { "No data..." }
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
            "decor:bg-base-100 decor:rounded-lg",
            style_classes
          ].compact_blank.join(" ")
        end

        def table_classes
          [
            "decor:d-table",
            size_classes,
            @zebra ? "decor:d-table-zebra" : nil,
            @pin_rows ? "decor:d-table-pin-rows" : nil,
            @pin_cols ? "decor:d-table-pin-cols" : nil,
            "decor:min-w-full decor:bg-base-100",
            @compact ? "decor:text-xs" : "decor:text-sm",
            (@style == :minimal) ? "decor:divide-y decor:divide-base-200" : "decor:divide-y-2 decor:divide-base-300",
            (@style == :bordered) ? "decor:border-collapse" : nil
          ].compact_blank.join(" ")
        end

        def tbody_classes
          [
            "decor:divide-y decor:divide-base-300",
            @striped ? "decor:*:even:bg-base-200" : nil
          ].compact_blank.join(" ")
        end

        def component_size_classes(size)
          case size
          when :xs then "decor:d-table-xs"
          when :sm then "decor:d-table-sm"
          when :lg then "decor:d-table-lg"
          when :xl then "decor:d-table-xl"
          else ""
          end
        end

        def component_style_classes(style)
          case style
          when :bordered then "decor:border decor:border-base-300"
          when :minimal then ""
          when :default then ""
          else ""
          end
        end
      end
    end
  end
end
