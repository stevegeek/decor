# frozen_string_literal: true

module Decor
  module Components
    module Chat
      # Abstract base for List. Owns the prop API + slot helper.
      # Concrete skins (Daisy, Suite) inherit and provide `view_template`
      # plus their visual-language overrides.
      class List < ::Decor::PhlexComponent
        # Accept any ListMessage subclass (Daisy + Suite skins). Previously
        # typed to Daisy only, which rejected Suite-built lists with
        # "expected Decor::Daisy::Chat::ListMessage, got Decor::Suite::…".
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

        # Alias matching the legacy Phlex `with_*` slot-naming convention used
        # by ConfinusUI callers. Lets `list.with_empty_state_action { … }`
        # work alongside the new `list.empty_state_action { … }`.
        alias_method :with_empty_state_action, :empty_state_action

        # Backward-compat helper used by ConfinusUI-era callers that built
        # messages one-at-a-time inside a list block via `list.with_message(**attrs)`
        # rather than passing the full `messages: [...]` array on construction.
        # Builds a skin-appropriate ListMessage and appends it.
        def with_message(**attrs)
          @messages << message_class.new(**attrs)
        end

        private

        # Concrete skins override this to point at their own ListMessage.
        def message_class
          ::Decor::Components::Chat::ListMessage
        end
      end
    end
  end
end
