# frozen_string_literal: true

module Decor
  module Components
    module Chat
      class List < ::Decor::PhlexComponent
        prop :messages, _Array(::Decor::Components::Chat::ListMessage), default: -> { [] }
        prop :empty_state_title, String, default: "No messages yet."
        prop :empty_state_description, String, default: "Start a conversation by sending a message."

        def initialize(**attributes)
          @empty_state_action_block = nil
          super
        end

        def empty_state_action(&block)
          @empty_state_action_block = block
        end

        alias_method :with_empty_state_action, :empty_state_action

        def with_message(**attrs)
          @messages << message_class.new(**attrs)
        end

        private

        # Concrete skins override to point at their own ListMessage.
        def message_class
          ::Decor::Components::Chat::ListMessage
        end
      end
    end
  end
end
