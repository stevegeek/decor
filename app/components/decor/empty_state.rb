# frozen_string_literal: true

module Decor
  class EmptyState < PhlexComponent
    include Concerns::StyleColorClasses

    prop :icon_name, String
    prop :title, String
    prop :description, String
    prop :primary_action_label, _Nilable(String)
    prop :primary_action_href, _Nilable(String)
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
              style: :outlined
            )
          end

          if @primary_action_label && @primary_action_href
            render Decor::ButtonLink.new(
              label: @primary_action_label,
              href: @primary_action_href,
              color: :primary
            )
          end
        end
      end
    end

    def root_element_classes
      "text-center py-12"
    end

    def component_size_classes
      {
        xs: "py-6",
        sm: "py-8",
        md: "py-12",
        lg: "py-16",
        xl: "py-20"
      }
    end

    def component_variant_classes
      {
        default: "",
        minimal: "py-6",
        card: "bg-base-100 rounded-lg shadow-sm border border-base-300 p-8",
        hero: "bg-base-200 rounded-xl p-12"
      }
    end
  end
end
