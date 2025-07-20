# frozen_string_literal: true

module Decor
  class EmptyState < PhlexComponent
    prop :icon_name, String
    prop :title, String
    prop :description, String
    prop :primary_action_label, String
    prop :primary_action_href, String
    prop :secondary_action_label, _Nilable(String)
    prop :secondary_action_href, _Nilable(String)

    def view_template
      root_element do
        render Decor::Icon.new(name: @icon_name, size: :xl, classes: "text-base-content/60 mx-auto mb-4")

        h3(class: "text-lg font-semibold text-base-content mb-2") do
          @title
        end

        p(class: "text-base-content/70 mb-6") do
          @description
        end

        div(class: "flex justify-center gap-4") do
          if @secondary_action_label && @secondary_action_href
            render Decor::ButtonLink.new(
              label: @secondary_action_label,
              href: @secondary_action_href,
              variant: :outlined
            )
          end

          render Decor::ButtonLink.new(
            label: @primary_action_label,
            href: @primary_action_href,
            color: :primary
          )
        end
      end
    end

    def element_classes
      "text-center py-12"
    end
  end
end
