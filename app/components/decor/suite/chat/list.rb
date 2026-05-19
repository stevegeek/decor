# frozen_string_literal: true

module Decor
  module Suite
    module Chat
      # Suite Chat::List — thread container with a hairline-divided list of
      # messages, or a Suite section-title empty state with optional action.
      class List < ::Decor::Components::Chat::List
        def view_template(&)
          yield(self) if block_given?

          root_element do
            if @messages.any?
              ul(role: "list", class: "decor:m-0 decor:p-0 decor:list-none decor:divide-y decor:divide-suite-hairline") do
                @messages.each do |message|
                  render message
                end
              end
            else
              render_empty_state
            end
          end
        end

        private

        def render_empty_state
          div(class: "decor:py-6 decor:px-0") do
            h3(class: "decor:suite-section-title decor:m-0") { @empty_state_title }
            if @empty_state_action_block
              p(class: "decor:mt-1 decor:suite-description decor:text-gray-500 decor:m-0") { @empty_state_description }
              div(class: "decor:mt-3", &@empty_state_action_block)
            end
          end
        end

        def root_element_classes
          classes = ["decor:w-full"]
          classes << "decor:not-prose" if @messages.any?
          classes.join(" ")
        end
      end
    end
  end
end
