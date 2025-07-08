# frozen_string_literal: true

module Decor
  module Modals
    class ConfirmModal < Modal
      MODAL_TYPES = [:info, :warning, :error, :success].freeze

      stimulus do
        targets :positive_button, :negative_button, :title, :message
        actions [stimulus_scoped_event_on_window(:open), :handle_open_event],
                [stimulus_scoped_event_on_window(:close), :handle_close_event]
        values_from_props :close_on_overlay_click
      end

      def view_template
        root_element do
          div(class: "flex items-center justify-center min-h-screen pt-4 px-4 pb-20 text-center sm:p-0") do
            # The background overlay
            div(
              class: "fixed hidden inset-0 bg-gray-700 transition-opacity #{class_list_for_stimulus_classes(:overlay_leaving_to)} ",
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
              class: "#{class_list_for_stimulus_classes(:modal_entering_from)} relative inline-block align-bottom bg-white rounded-lg px-4 pt-5 pb-4 text-left overflow-hidden shadow-xl transform transition-all sm:my-8 lg:align-middle max-w-xl sm:w-full sm:p-6",
              data: stimulus_target(:modal)
            ) do
              div(class: "bg-white px-4 pt-5 pb-4 sm:p-6 sm:pb-4") do
                div(class: "sm:flex sm:items-start") do
                  modal_types.each do |type|
                    div(class: "#{component_name}-#{type}-icon hidden mx-auto flex-shrink-0 flex items-center justify-center h-12 w-12 rounded-full #{icon_bg_color(type)} sm:mx-0 sm:h-10 sm:w-10") do
                      render ::Decor::Icon.new(name: icon_name(type), classes: "h-6 w-6 #{icon_color(type)}")
                    end
                  end
                  div(class: "mt-3 text-center sm:mt-0 sm:ml-4 sm:text-left") do
                    h3(id: "#{id}-title", class: "text-lg leading-6 font-medium text-gray-900", data: stimulus_target(:title)) do
                      "Are you sure?"
                    end
                    div(class: "mt-2") do
                      p(id: "#{id}-message", class: "text-sm text-gray-500", data: stimulus_target(:message))
                    end
                  end
                end
              end
              div(class: "bg-gray-50 px-4 py-3 sm:px-6 flex flex-row-reverse") do
                render ::Decor::Button.new(
                  label: "Continue",
                  classes: "ml-3 w-auto text-sm",
                  html_options: {
                    data: {
                      **stimulus_target(:positive_button),
                      **stimulus_action(:click, :positive_button)
                    }
                  }
                )
                render ::Decor::Button.new(
                  label: "Cancel",
                  color: :secondary,
                  variant: :outlined,
                  classes: "ml-3 w-auto text-sm",
                  html_options: {
                    data: {
                      **stimulus_target(:negative_button),
                      **stimulus_action(:click, :negative_button)
                    }
                  }
                )
              end
            end
          end
        end
      end

      private

      def root_element_attributes
        {
          element_tag: :aside,
          aria_modal: true,
          role: "dialog",
          aria_labelledby: "#{id}-title",
          aria_describedby: "#{id}-content"
        }
      end

      def element_classes
        "fixed hidden z-10 inset-0 overflow-y-auto"
      end

      def modal_types
        MODAL_TYPES
      end

      def icon_name(type)
        case type
        when :warning
          "exclamation"
        when :error
          "exclamation-circle"
        when :success
          "check"
        else
          "information-circle"
        end
      end

      def icon_color(type)
        case type
        when :warning
          "text-warning"
        when :error
          "text-error"
        when :success
          "text-success"
        else
          "text-gray-900"
        end
      end

      def icon_bg_color(type)
        case type
        when :warning
          "bg-warning-pale"
        when :error
          "bg-error-pale"
        when :success
          "bg-success-pale"
        else
          "bg-gray-300"
        end
      end
    end
  end
end
