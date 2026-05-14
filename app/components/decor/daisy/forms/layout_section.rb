# frozen_string_literal: true

module Decor
  module Daisy
    module Forms
      class LayoutSection < ::Decor::Components::Forms::LayoutSection
        def view_template
          root_element do
            render @hero if @hero.present?

            if @flash
              render ::Decor::Daisy::Flash.new(
                text: @flash_message,
                collapse_if_empty: true,
                html_options: {class: "decor:mb-8"},
                flash_data: nil
              )
            end

            div(class: "decor:flex decor:justify-between decor:items-center decor:flex-wrap decor:lg:flex-nowrap decor:lg:space-x-3") do
              div do
                h3(class: "decor:text-lg decor:leading-6 decor:font-medium decor:text-gray-900") do
                  @title
                end
                p(class: "decor:mt-1 decor:text-sm decor:text-gray-500") do
                  @description
                end
              end
              render @cta if @cta.present?
            end

            if @custom_content_wrapper
              yield if block_given?
            elsif block_given?
              div(class: "decor:mt-6 #{@stacked ? "decor:sm:mt-5 decor:divide-y" : "decor:grid decor:grid-cols-1 decor:gap-y-1 decor:gap-x-4 decor:sm:grid-cols-6"}") do
                yield
              end
            end
          end
        end

        private

        def root_element_classes
          "decor:pt-5 decor:mb-5"
        end
      end
    end
  end
end
