# frozen_string_literal: true

module Decor
  module Chat
    class List < PhlexComponent
      slot :empty_state_action

      attribute :messages, Array, sub_type: ::Decor::Chat::ListMessage, default: []
      attribute :empty_state_title, String, default: "No messages yet."
      attribute :empty_state_description, String, default: "Start a conversation by sending a message."

      def view_template
        render parent_element do
          if @messages.any?
            @messages.each do |message|
              render message
            end
          else
            render_empty_state
          end
        end
      end

      private

      def render_empty_state
        div(class: "flex flex-col items-center justify-center py-12 text-center") do
          div(class: "text-base-content/60") do
            h3(class: "text-lg font-medium") { @empty_state_title }
            if empty_state_action_slot.present?
              p(class: "mt-2 text-sm") { @empty_state_description }
              div(class: "mt-6") do
                render empty_state_action_slot
              end
            end
          end
        end
      end

      def element_classes
        "flex flex-col gap-2 p-4"
      end
    end
  end
end
