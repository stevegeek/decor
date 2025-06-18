# frozen_string_literal: true

module Decor
  module Tables
    # Footer of DataTable with content sections and possible "calculations" section
    class DataTableFooter < PhlexComponent
      no_stimulus_controller

      attr_reader :left, :right

      def initialize(**attributes)
        super
      end

      def with_left(&block)
        @left = block
        self
      end

      def with_right(&block)
        @right = block
        self
      end

      class FooterSummaryLine < ::Literal::Data
        prop :title, String
        prop :value, String
        prop :separator, _Nilable(_Union(:section, :final))

        def start_section?
          @separator == :section
        end

        def final_line?
          @separator == :final
        end
      end

      attribute :summary_lines, type: Array, sub_type: FooterSummaryLine
      attribute :message, String

      def view_template
        render parent_element do
          if @left.present?
            div(class: "px-6 flex-1 sm:max-w-md") do
              instance_eval(@left)
            end
          elsif @message.present?
            div(class: "px-6 flex-1 sm:max-w-md") do
              p(class: "text-sm text-base-content/70 leading-relaxed") do
                @message
              end
            end
          end

          if @right.present?
            div(class: "mt-6 sm:mt-0 sm:ml-6 sm:flex-shrink-0") do
              instance_eval(@right)
            end
          elsif @summary_lines.present?
            div(class: "mt-6 sm:mt-0 sm:ml-6 sm:flex-shrink-0 sm:w-80") do
              div(class: "flow-root") do
                dl(class: "-my-3 divide-y divide-base-300 text-sm") do
                  @summary_lines.each do |line|
                    div(class: "grid grid-cols-1 gap-1 py-3 sm:grid-cols-3 sm:gap-4 #{line.start_section? ? "border-t-2 border-base-300 pt-4" : ""} #{line.final_line? ? "border-t-2 border-primary/20 pt-4 bg-base-50" : ""}") do
                      dt(class: "font-medium text-base-content #{line.final_line? ? "text-primary" : ""}") { line.title }
                      dd(class: "text-base-content/70 sm:col-span-2 font-semibold #{line.final_line? ? "text-primary text-base" : ""}") { line.value }
                    end
                  end
                end
              end
            end
          else
            div
          end
        end
      end

      private

      def element_classes
        "sm:flex sm:justify-between sm:items-start pt-6 pb-4 border-t border-base-300 bg-base-50/50"
      end
    end
  end
end
