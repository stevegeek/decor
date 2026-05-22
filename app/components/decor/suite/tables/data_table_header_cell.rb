# frozen_string_literal: true

module Decor
  module Suite
    module Tables
      class DataTableHeaderCell < ::Decor::Components::Tables::DataTableHeaderCell
        def view_template
          root_element do
            div(class: "decor:group decor:flex decor:items-center decor:gap-0.5") do
              span(class: "decor:flex-1") { plain resolved_content.to_s }
              if sort_key?
                span(class: sort_indicator_classes) do
                  plain sort_icon
                end
              end
            end
          end
        end

        def resolved_content
          @title || (@value || "")
        end

        private

        def root_element_attributes
          attrs = {
            element_tag: :th,
            html_options: {role: "columnheader", scope: "col"}
          }
          attrs[:html_options][:colspan] = @colspan if @colspan&.positive?
          attrs
        end

        def root_element_classes
          [
            sort_key? && "decor:cursor-pointer decor:hover:text-gray-700",
            @numeric ? "decor:text-right" : "decor:text-left",
            sorted_direction? && "decor:text-gray-700",
            header_padding_classes,
            stretch_class,
            "decor:suite-caption decor:font-medium decor:text-gray-500 decor:uppercase decor:tracking-[0.04em]",
            "decor:border-b decor:border-suite-hairline decor:whitespace-nowrap decor:select-none"
          ].compact_blank
        end

        def stretch_class
          return nil if @stretch_divisor.nil?
          case @stretch_divisor
          when 1 then "decor:w-full"
          when 2..5 then "decor:w-1/#{@stretch_divisor}"
          end
        end

        def header_padding_classes
          @compact ? "decor:px-3 decor:py-[6px]" : "decor:px-[14px] decor:py-[9px]"
        end

        def sort_indicator_classes
          opacity = sorted_direction? ? "decor:opacity-70" : "decor:opacity-0 decor:group-hover:opacity-40"
          "decor:ml-1 decor:text-[10px] #{opacity}"
        end

        def sort_icon
          (@sorted_direction == :asc) ? "↑" : "↓"
        end

        def sorted_direction?
          @sorted_direction.present?
        end
      end
    end
  end
end
