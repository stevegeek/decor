# frozen_string_literal: true

module Decor
  module Suite
    module Modals
      class ConfirmModal < ::Decor::Components::Modals::ConfirmModal
        def view_template
          root_element do
            # Header — title target
            div(class: "decor-modal__header decor:shrink-0 decor:flex decor:items-center decor:gap-2.5 decor:px-5 decor:pt-3.5 decor:pb-3 decor:border-b decor:border-suite-hairline") do
              h3(
                id: "#{id}-title",
                class: "decor-modal__title decor:suite-section-title decor:text-gray-900 decor:leading-[1.4]",
                data: {**stimulus_target(:title)}
              ) { "Are you sure?" }
            end

            # Body — message target
            div(
              id: "#{id}-body",
              class: "decor-modal__body decor:px-5 decor:pt-3 decor:pb-4 decor:suite-description decor:text-gray-500 decor:leading-[1.55]"
            ) do
              p(data: {**stimulus_target(:message)})
            end

            # Footer — positive / negative buttons
            div(class: "decor-modal__footer decor:shrink-0 decor:flex decor:justify-end decor:gap-1.5 decor:px-5 decor:py-3 decor:bg-suite-gray-25 decor:border-t decor:border-suite-hairline") do
              render ::Decor::Suite::Button.new(
                label: "Cancel",
                style: :outlined,
                size: :sm,
                html_options: {
                  data: {
                    **stimulus_target(:negative_button),
                    **stimulus_action(:click, :negative_button)
                  }
                }
              )
              render ::Decor::Suite::Button.new(
                label: "Continue",
                color: :primary,
                size: :sm,
                html_options: {
                  data: {
                    **stimulus_target(:positive_button),
                    **stimulus_action(:click, :positive_button)
                  }
                }
              )
            end
          end
        end

        private

        def root_element_attributes
          {
            element_tag: :dialog,
            html_options: {
              closedby: "any",
              tabindex: "-1",
              aria_labelledby: "#{id}-title",
              aria_describedby: "#{id}-body"
            }
          }
        end

        def root_element_classes
          "decor-modal decor:open:flex decor:flex-col decor:bg-white decor:rounded-suite-card decor:shadow-2xl decor:p-0 decor:overflow-hidden decor:w-[420px] decor:max-w-[calc(100vw-32px)] decor:max-h-[calc(100vh-32px)] decor:m-auto"
        end
      end
    end
  end
end
