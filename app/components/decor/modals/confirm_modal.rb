# frozen_string_literal: true

module Decor
  module Modals
    class ConfirmModal < Modal
      MODAL_TYPES = [:info, :warning, :error, :success].freeze

      def view_template
        render parent_element do |s|
          div(class: "flex items-center justify-center min-h-screen pt-4 px-4 pb-20 text-center sm:p-0") do
            # The background overlay
            div(
              class: "fixed hidden inset-0 bg-gray-700 #{s.named_classes(:overlay_leaving_to)} transition-opacity",
              aria_hidden: true,
              data: {
                action: s.send(:parse_actions, [[:click, :overlay_clicked]]).join(" "),
                **s.send(:build_target_data_attributes, s.send(:parse_targets, [:overlay]))
              }
            )

            # This element is to trick the browser into centering the modal contents
            span(class: "hidden lg:inline-block lg:align-middle sm:h-screen", aria_hidden: true) { "&#8203;".html_safe }

            div(
              id: "#{id}-content",
              class: "#{s.named_classes(:modal_entering_from)} relative inline-block align-bottom bg-white rounded-lg px-4 pt-5 pb-4 text-left overflow-hidden shadow-xl transform transition-all sm:my-8 lg:align-middle max-w-xl sm:w-full sm:p-6",
              data: {**s.send(:build_target_data_attributes, s.send(:parse_targets, [:modal]))}
            ) do
              div(class: "bg-white px-4 pt-5 pb-4 sm:p-6 sm:pb-4") do
                div(class: "sm:flex sm:items-start") do
                  modal_types.each do |type|
                    div(class: "#{component_class_name}-#{type}-icon hidden mx-auto flex-shrink-0 flex items-center justify-center h-12 w-12 rounded-full #{icon_bg_color(type)} sm:mx-0 sm:h-10 sm:w-10") do
                      render ::Decor::Icon.new(name: icon_name(type), html_options: {class: "h-6 w-6 #{icon_color(type)}"})
                    end
                  end
                  div(class: "mt-3 text-center sm:mt-0 sm:ml-4 sm:text-left") do
                    h3(id: "#{id}-title", class: "text-lg leading-6 font-medium text-gray-900", data: {**s.send(:build_target_data_attributes, s.send(:parse_targets, [:title]))}) do
                      "Are you sure?"
                    end
                    div(class: "mt-2") do
                      p(id: "#{id}-message", class: "text-sm text-gray-500", data: {**s.send(:build_target_data_attributes, s.send(:parse_targets, [:message]))})
                    end
                  end
                end
              end
              div(class: "bg-gray-50 px-4 py-3 sm:px-6 flex flex-row-reverse") do
                render ::Decor::Button.new(
                  label: "Continue",
                  targets: [s.target(:positive_button)],
                  actions: [s.action(:click, :positive_button)],
                  html_options: {class: "ml-3 w-auto text-sm"}
                )
                render ::Decor::Button.new(
                  label: "Cancel",
                  color: :secondary,
                  variant: :outlined,
                  targets: [s.target(:negative_button)],
                  actions: [s.action(:click, :negative_button)],
                  html_options: {class: "ml-3 w-auto text-sm"}
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
          actions: [
            [:"#{js_event_name_prefix}:open@window", :handleOpenEvent],
            [:"#{js_event_name_prefix}:close@window", :handleCloseEvent]
          ],
          named_classes: {
            overlay_entering: "ease-out duration-300",
            overlay_entering_from: "opacity-0",
            overlay_entering_to: "opacity-50",
            overlay_leaving: "ease-in duration-200",
            overlay_leaving_from: "opacity-50",
            overlay_leaving_to: "opacity-0",
            modal_entering: "ease-out duration-300",
            modal_entering_from: "opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95",
            modal_entering_to: "opacity-100 translate-y-0 sm:scale-100",
            modal_leaving: "ease-in duration-200",
            modal_leaving_from: "opacity-100 translate-y-0 sm:scale-100",
            modal_leaving_to: "opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95"
          },
          values: [@close_on_overlay_click ? {close_on_overlay_click: true} : {}],
          html_options: {
            aria_modal: true,
            role: "dialog",
            aria_labelledby: "#{id}-title",
            aria_describedby: "#{id}-content"
          }
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
