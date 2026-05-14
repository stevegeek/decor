# frozen_string_literal: true

module Decor
  module Daisy
    module Modals
      class Modal < ::Decor::Components::Modals::Modal
        def view_template
          root_element do
            # Modal content box
            div(
              id: "#{id}-content",
              class: "decor:d-modal-box",
              data: {**stimulus_target(:modal)}
            ) do
              if @initial_content.present?
                plain(@initial_content)
              else
                render ::Decor::Daisy::Spinner.new(html_options: {class: "decor:mx-auto decor:w-8 decor:h-8"})
              end
            end

            # Modal backdrop - clicking outside closes if enabled
            form(
              method: "dialog",
              class: "decor:d-modal-backdrop",
              data: {
                **stimulus_action(:click, :overlay_clicked),
                **stimulus_target(:overlay)
              }
            ) do
              button { "" }
            end
          end
        end

        private

        def root_element_attributes
          {
            element_tag: :dialog,
            html_options: {
              aria_describedby: "#{id}-content"
            }
          }
        end

        def root_element_classes
          "decor:d-modal"
        end
      end
    end
  end
end
