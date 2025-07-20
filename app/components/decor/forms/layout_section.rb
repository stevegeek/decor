# frozen_string_literal: true

module Decor
  module Forms
    # A FormSection is a group of fields that are displayed in a form.
    class LayoutSection < PhlexComponent
      no_stimulus_controller

      def with_hero(&block)
        @hero = block
      end

      def with_cta(&block)
        @cta = block
      end

      prop :title, String
      prop :description, _Nilable(String)

      prop :flash, _Boolean, default: false
      prop :flash_message, _Nilable(String)

      prop :stacked, _Boolean, default: false
      prop :custom_content_wrapper, _Boolean, default: false

      def view_template
        root_element do
          render @hero if @hero.present?

          if @flash
            render ::Decor::Flash.new(
              text: @flash_message,
              collapse_if_empty: true,
              html_options: {class: "mb-8"}
            )
          end

          div(class: "flex justify-between items-center flex-wrap lg:flex-nowrap lg:space-x-3") do
            div do
              h3(class: "text-lg leading-6 font-medium text-gray-900") do
                @title
              end
              p(class: "mt-1 text-sm text-gray-500") do
                @description
              end
            end
            render @cta if @cta.present?
          end

          if @custom_content_wrapper
            yield if block_given?
          elsif block_given?
            div(class: "mt-6 #{@stacked ? "sm:mt-5 divide-y" : "grid grid-cols-1 gap-y-1 gap-x-4 sm:grid-cols-6"}") do
              yield
            end
          end
        end
      end

      private

      def element_classes
        "pt-5 mb-5"
      end
    end
  end
end
