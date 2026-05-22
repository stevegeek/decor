# frozen_string_literal: true

module Decor
  module Suite
    class Panel < ::Decor::Components::Panel
      def view_template(&)
        root_element do
          if @title.present? || @icon.present?
            div(class: "decor:flex decor:items-center decor:gap-2 decor:px-5 decor:py-4 decor:border-b decor:border-suite-hairline") do
              if @icon.present?
                render ::Decor::Icon.new(
                  name: @icon,
                  html_options: {class: "decor:shrink-0 decor:w-[18px] decor:h-[18px] decor:text-gray-500"}
                )
              end
              if @title.present?
                h3(class: "decor:suite-section-title decor:text-gray-900 decor:m-0") { plain @title }
              end
            end
          end
          div(class: "decor:px-5 decor:py-4 decor:suite-description decor:text-gray-500", &)
        end
      end

      private

      def root_element_classes
        "decor:bg-white decor:border decor:border-suite-hairline decor:rounded-suite-card decor:overflow-hidden"
      end
    end
  end
end
