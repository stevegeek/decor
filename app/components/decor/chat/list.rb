# frozen_string_literal: true

module Decor
  module Chat
    class List < PhlexComponent
      attribute :messages, Array, sub_type: ::Decor::Chat::ListMessage, default: []
      attribute :empty_state_title, String, default: "No messages yet."
      attribute :empty_state_description, String, default: "Start a conversation by sending a message."

      def initialize(**attributes)
        @empty_state_action_block = nil
        super
      end

      def empty_state_action(&block)
        @empty_state_action_block = block
      end

      def view_template
        yield(self) if block_given?
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
            if @empty_state_action_block
              p(class: "mt-2 text-sm") { @empty_state_description }
              div(class: "mt-6", &@empty_state_action_block)
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
