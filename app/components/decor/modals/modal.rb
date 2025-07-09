# frozen_string_literal: true

module Decor
  module Modals
    class Modal < PhlexComponent
      prop :initial_content, _Nilable(String)
      prop :content_href, _Nilable(String)
      prop :start_shown, _Boolean, default: false
      prop :close_on_overlay_click, _Boolean, default: false

      stimulus do
        targets :overlay, :modal
        actions -> { [stimulus_scoped_event_on_window(:open), :handle_open_event] },
          -> { [stimulus_scoped_event_on_window(:close), :handle_close_event] }
        values_from_props :close_on_overlay_click, :content_href
        values show_initial: -> { @start_shown }
      end

      def view_template
        root_element do
          div(class: "flex items-center justify-center min-h-screen pt-4 px-4 pb-20 text-center sm:p-0") do
            # The background overlay
            div(
              id: "decor--modals--modal__overlay",
              class: "fixed hidden inset-0 bg-gray-700 transition-opacity",
              aria_hidden: true,
              data: {
                **stimulus_action(:click, :overlay_clicked),
                **stimulus_target(:overlay)
              }
            )

            # This element is to trick the browser into centering the modal contents
            span(class: "hidden lg:inline-block lg:align-middle sm:h-screen", aria_hidden: true) { "&#8203;".html_safe }

            div(
              id: "#{id}-content",
              class: "relative inline-block align-bottom bg-white rounded-lg px-4 pt-5 pb-4 text-left overflow-hidden shadow-xl transform transition-all sm:my-8 lg:align-middle sm:p-6",
              data: {**stimulus_target(:modal)}
            ) do
              if @initial_content.present?
                plain(@initial_content)
              else
                render ::Decor::Spinner.new(html_options: {class: "mx-auto w-8 h-8"})
              end
            end
          end
        end
      end

      private

      def root_element_attributes
        {
          element_tag: :aside,
          html_options: {
            aria_modal: true,
            role: "dialog",
            aria_describedby: "#{id}-content"
          }
        }
      end

      def element_classes
        "#{@start_shown ? "fixed" : "fixed hidden"} z-10 inset-0 overflow-y-auto"
      end
    end
  end
end
