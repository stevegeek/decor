# frozen_string_literal: true

module Decor
  module Suite
    class EmptyState < ::Decor::Components::EmptyState
      def view_template
        root_element do
          render ::Decor::Icon.new(
            name: @icon_name,
            html_options: {class: "decor:mx-auto decor:h-8 decor:w-8 decor:text-gray-400"}
          )

          h3(class: "decor:mt-3 decor:suite-section-title decor:text-gray-900") do
            @title
          end

          if @description.present?
            p(class: "decor:mt-1 decor:suite-description decor:text-gray-500 decor:max-w-md decor:mx-auto") do
              @description
            end
          end

          if has_actions?
            div(class: "decor:mt-5 decor:flex decor:justify-center decor:items-center decor:gap-2") do
              if @secondary_action_label && @secondary_action_href
                render ::Decor::Suite::ButtonLink.new(
                  label: @secondary_action_label,
                  href: @secondary_action_href,
                  style: :outlined
                )
              end

              if @primary_action_label && @primary_action_href
                render ::Decor::Suite::ButtonLink.new(
                  label: @primary_action_label,
                  href: @primary_action_href,
                  color: :primary
                )
              end
            end
          end
        end
      end

      private

      def has_actions?
        (@primary_action_label && @primary_action_href) ||
          (@secondary_action_label && @secondary_action_href)
      end

      def root_element_classes
        "decor:bg-white decor:block decor:border-2 decor:border-suite-hairline decor:border-dashed " \
          "decor:rounded-suite-card decor:py-12 decor:px-6 decor:text-center " \
          "decor:transition-colors decor:duration-suite-fast decor:ease-out " \
          "decor:hover:border-suite-hairline-strong"
      end
    end
  end
end
