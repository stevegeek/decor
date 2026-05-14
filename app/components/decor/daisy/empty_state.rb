# frozen_string_literal: true

module Decor
  module Daisy
    # An empty state component for displaying when there's no content to show.
    # Typically includes an icon, title, description, and optional action buttons.
    # Used for search results, empty lists, error states, and success confirmations.
    class EmptyState < ::Decor::Components::EmptyState
      def view_template
        root_element do
          render ::Decor::Icon.new(name: @icon_name, size: :xl, classes: "decor:text-base-content/60 decor:mx-auto decor:mb-4")

          h3(class: "decor:text-lg decor:font-semibold decor:text-base-content decor:mb-2") do
            @title
          end

          p(class: "decor:text-base-content/70 decor:mb-6") do
            @description
          end

          div(class: "decor:flex decor:justify-center decor:gap-4") do
            if @secondary_action_label && @secondary_action_href
              render ::Decor::Daisy::ButtonLink.new(
                label: @secondary_action_label,
                href: @secondary_action_href,
                style: :outlined
              )
            end

            if @primary_action_label && @primary_action_href
              render ::Decor::Daisy::ButtonLink.new(
                label: @primary_action_label,
                href: @primary_action_href,
                color: :primary
              )
            end
          end
        end
      end

      private

      def root_element_classes
        "decor:text-center decor:py-12"
      end

      def component_size_classes
        {
          xs: "decor:py-6",
          sm: "decor:py-8",
          md: "decor:py-12",
          lg: "decor:py-16",
          xl: "decor:py-20"
        }
      end

      def component_variant_classes
        {
          default: "",
          minimal: "decor:py-6",
          card: "decor:bg-base-100 decor:rounded-lg decor:shadow-sm decor:border decor:border-base-300 decor:p-8",
          hero: "decor:bg-base-200 decor:rounded-xl decor:p-12"
        }
      end
    end
  end
end
