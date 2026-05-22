# frozen_string_literal: true

module Decor
  module Suite
    module Tables
      class DataTableFooter < ::Decor::Components::Tables::DataTableFooter
        def view_template(&block)
          vanish(&block) if block

          root_element do
            render_left_side
            render_right_side
          end
        end

        private

        def render_left_side
          if @left
            render @left
          elsif @message.present?
            p(class: "decor:suite-description decor:text-gray-500 decor:max-w-sm decor:md:max-w-lg decor:xl:max-w-2xl decor:tabular-nums") do
              plain @message.to_s
            end
          end
        end

        def render_right_side
          if @right
            render @right
          elsif @summary_lines.present?
            div(class: "decor:shrink-0") do
              dl(class: "decor:font-medium decor:text-gray-500 decor:space-y-2") do
                @summary_lines.each { |line| render_summary_line(line) }
              end
            end
          else
            div
          end
        end

        def render_summary_line(line)
          div(class: summary_line_classes(line)) do
            dt(class: "decor:suite-description decor:flex-1") { plain line.title }
            dd(class: summary_value_classes(line)) do
              raw safe(line.value.to_s)
            end
          end
        end

        def summary_line_classes(line)
          base = "decor:flex decor:items-center decor:gap-6"
          base += " decor:pt-2" if line.start_section?
          base += " decor:border-t decor:border-suite-hairline decor:pt-2" if line.final_line?
          base
        end

        def summary_value_classes(line)
          if line.final_line?
            "decor:suite-body decor:font-semibold decor:text-primary decor:tabular-nums"
          else
            "decor:suite-description decor:font-medium decor:text-gray-700 decor:tabular-nums"
          end
        end

        def root_element_classes
          "decor:flex decor:flex-col decor:sm:flex-row decor:sm:items-center decor:sm:justify-between decor:gap-4 decor:px-5 decor:py-[10px] decor:border-t decor:border-suite-hairline decor:bg-suite-gray-25"
        end
      end
    end
  end
end
