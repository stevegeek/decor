# frozen_string_literal: true

module Decor
  module Daisy
    module Tables
      class DataTableFooter < ::Decor::Components::Tables::DataTableFooter
        def view_template
          root_element do
            if @left.present?
              div(class: "decor:px-6 decor:flex-1 decor:sm:max-w-md") do
                instance_eval(&@left)
              end
            elsif @message.present?
              div(class: "decor:px-6 decor:flex-1 decor:sm:max-w-md") do
                p(class: "decor:text-sm decor:text-base-content/70 decor:leading-relaxed") do
                  @message
                end
              end
            end

            if @right.present?
              div(class: "decor:mt-6 decor:sm:mt-0 decor:sm:ml-6 decor:sm:flex-shrink-0") do
                instance_eval(&@right)
              end
            elsif @summary_lines.present?
              div(class: "decor:mt-6 decor:sm:mt-0 decor:sm:ml-6 decor:sm:flex-shrink-0 decor:sm:w-80") do
                div(class: "decor:flow-root") do
                  dl(class: "decor:-my-3 decor:divide-y decor:divide-base-300 decor:text-sm") do
                    @summary_lines.each do |line|
                      # CODEMOD-REVIEW: interpolated class expression — verify var is already prefixed
                      div(class: "decor:grid decor:grid-cols-1 decor:gap-1 decor:py-3 decor:sm:grid-cols-3 decor:sm:gap-4 #{line.start_section? ? "decor:border-t-2 decor:border-base-300 decor:pt-4" : ""} #{line.final_line? ? "decor:border-t-2 decor:border-primary/20 decor:pt-4 decor:bg-base-50" : ""}") do
                        # CODEMOD-REVIEW: interpolated class expression — verify var is already prefixed
                        dt(class: "decor:font-medium decor:text-base-content #{line.final_line? ? "decor:text-primary" : ""}") { line.title }
                        # CODEMOD-REVIEW: interpolated class expression — verify var is already prefixed
                        dd(class: "decor:text-base-content/70 decor:sm:col-span-2 decor:font-semibold #{line.final_line? ? "decor:text-primary decor:text-base" : ""}") { line.value }
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

        def root_element_classes
          "decor:sm:flex decor:sm:justify-between decor:sm:items-start decor:pt-6 decor:pb-4 decor:border-t decor:border-base-300 decor:bg-base-50/50"
        end
      end
    end
  end
end
