# frozen_string_literal: true

module Decor
  module Modals
    class Modal < PhlexComponent
      attribute :initial_content, String
      attribute :content_href, String
      attribute :start_shown, :boolean, default: false
      attribute :close_on_overlay_click, :boolean, default: false

      def view_template
        render parent_element do |s|
          div(class: "flex items-center justify-center min-h-screen pt-4 px-4 pb-20 text-center sm:p-0") do
            # The background overlay
            div(
              id: "#{component_class_name}__overlay",
              class: "fixed hidden inset-0 bg-gray-700 #{@start_shown ? s.named_classes(:overlay_entering_to) : s.named_classes(:overlay_leaving_to)} transition-opacity",
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
              class: "#{@start_shown ? s.named_classes(:modal_entering_to) : s.named_classes(:modal_entering_from)} relative inline-block align-bottom bg-white rounded-lg px-4 pt-5 pb-4 text-left overflow-hidden shadow-xl transform transition-all sm:my-8 lg:align-middle sm:p-6",
              data: {**s.send(:build_target_data_attributes, s.send(:parse_targets, [:modal]))}
            ) do
              if @initial_content.present?
                raw(@initial_content)
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
          actions: [
            [:"#{js_event_name_prefix}:open@window", :handle_open_event],
            [:"#{js_event_name_prefix}:close@window", :handle_close_event]
          ],
          values: [
            @start_shown ? {show_initial: true} : {},
            @close_on_overlay_click ? {close_on_overlay_click: true} : {},
            @content_href ? {content_href: @content_href} : {}
          ],
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
