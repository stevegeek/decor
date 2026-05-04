# frozen_string_literal: true

module Decor
  module Components
    module Chat
      # Abstract base for List. Owns the prop API + slot helper.
      # Concrete skins (Daisy, Suite) inherit and provide `view_template`
      # plus their visual-language overrides.
      class List < ::Decor::PhlexComponent
        prop :messages, _Array(::Decor::Daisy::Chat::ListMessage), default: -> { [] }
        prop :empty_state_title, String, default: "No messages yet."
        prop :empty_state_description, String, default: "Start a conversation by sending a message."

        def initialize(**attributes)
          @empty_state_action_block = nil
          super
        end

        def empty_state_action(&block)
          @empty_state_action_block = block
        end
      end
    end
  end
end
