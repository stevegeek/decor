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
          # Modal content box
          div(
            id: "#{id}-content",
            class: "modal-box",
            data: {**stimulus_target(:modal)}
          ) do
            if @initial_content.present?
              plain(@initial_content)
            else
              render ::Decor::Spinner.new(html_options: {class: "mx-auto w-8 h-8"})
            end
          end
          
          # Modal backdrop - clicking outside closes if enabled
          form(
            method: "dialog", 
            class: "modal-backdrop",
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
        "modal"
      end
    end
  end
end
