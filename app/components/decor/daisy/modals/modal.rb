# frozen_string_literal: true

module Decor
  module Daisy
    module Modals
      class Modal < ::Decor::Components::Modals::Modal
        def view_template(&body_block)
          @body_block = capture(&body_block) if block_given?

          root_element do
            # Modal content box
            div(
              id: "#{id}-content",
              class: "decor:d-modal-box",
              data: {**stimulus_target(:modal)}
            ) do
              content = body_content
              if content.present?
                if content.respond_to?(:html_safe?) && content.html_safe?
                  raw safe(content.to_s)
                else
                  plain content.to_s
                end
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

        def body_content
          @body_block.presence || @initial_content
        end
      end
    end
  end
end
