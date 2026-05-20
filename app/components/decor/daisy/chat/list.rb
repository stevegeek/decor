# frozen_string_literal: true

module Decor
  module Daisy
    module Chat
      class List < ::Decor::Components::Chat::List
        def view_template
          yield(self) if block_given?
          root_element do
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

        def message_class
          ::Decor::Daisy::Chat::ListMessage
        end

        def render_empty_state
          div(class: "decor:flex decor:flex-col decor:items-center decor:justify-center decor:py-12 decor:text-center") do
            div(class: "decor:text-base-content/60") do
              h3(class: "decor:text-lg decor:font-medium") { @empty_state_title }
              if @empty_state_action_block
                p(class: "decor:mt-2 decor:text-sm") { @empty_state_description }
                div(class: "decor:mt-6", &@empty_state_action_block)
              end
            end
          end
        end

        def root_element_classes
          "decor:flex decor:flex-col decor:gap-2 decor:p-4"
        end
      end
    end
  end
end
