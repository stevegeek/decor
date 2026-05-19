# frozen_string_literal: true

module Decor
  module Suite
    module AiChat
      # Suite AI-chat floating widget — a fixed bottom-right button that
      # toggles a chat panel with header, message stream, thinking indicator
      # and input row.
      #
      # Suite-only port (no Daisy peer or shared abstract). Inherits directly
      # from `Decor::PhlexComponent`. The controller is responsible for:
      #   * toggling the panel open/closed
      #   * POSTing the user message to `create_url`
      #   * appending streamed chunks dispatched on the
      #     `decor-ai-chat:broadcast` window event (so consumers can wire
      #     up any cable / SSE source)
      #
      # Other widgets can pop the panel open by dispatching `ai-chat:open` on
      # the window (stable event-name contract — not derived from the
      # controller identifier).
      class Widget < ::Decor::PhlexComponent
        prop :create_url, String, reader: :public
        prop :threads_url, String, reader: :public
        prop :greeting, _Nilable(String), reader: :public
        prop :greeting_subtitle, String,
          default: "Ask me about products, orders, or adding items to your cart.",
          reader: :public

        stimulus do
          action(:open).on(:"ai-chat:open").window
          values_from_props :create_url, :threads_url
        end

        def view_template
          root_element do
            render_toggle_button
            render_chat_panel
          end
        end

        private

        def root_element_classes
          "decor:fixed decor:bottom-4 decor:right-4 decor:z-50"
        end

        # ── toggle button ───────────────────────────────────────────────────

        def render_toggle_button
          child_element(
            :button,
            stimulus_action: [:click, :toggle],
            stimulus_target: :toggle_button,
            class: toggle_button_classes,
            aria_label: "Open AI Chat Assistant"
          ) do
            span(data: {**stimulus_target(:chat_icon)}, class: "decor:flex") do
              render ::Decor::Icon.new(name: "message-circle", width: 24, height: 24)
            end
            span(data: {**stimulus_target(:close_icon)}, class: "decor:hidden") do
              render ::Decor::Icon.new(name: "x", width: 24, height: 24)
            end
          end
        end

        def toggle_button_classes
          "decor:w-14 decor:h-14 decor:rounded-full " \
            "decor:bg-suite-primary-600 decor:hover:bg-suite-primary-700 decor:text-white " \
            "decor:shadow-lg decor:flex decor:items-center decor:justify-center " \
            "decor:transition-colors decor:duration-suite-fast decor:ease-out " \
            "decor:focus:outline-hidden decor:focus:ring-2 decor:focus:ring-suite-primary-500 decor:focus:ring-offset-2"
        end

        # ── chat panel ──────────────────────────────────────────────────────

        def render_chat_panel
          child_element(
            :div,
            stimulus_target: :panel,
            class: panel_classes
          ) do
            render_header
            render_messages_area
            render_thinking_indicator
            render_input_area
          end
        end

        def panel_classes
          "decor:hidden decor:absolute decor:bottom-16 decor:right-0 decor:w-96 decor:h-[32rem] " \
            "decor:bg-white decor:rounded-suite-card decor:shadow-lg decor:flex decor:flex-col " \
            "decor:overflow-hidden decor:border decor:border-suite-hairline"
        end

        # ── header ──────────────────────────────────────────────────────────

        def render_header
          div(class: "decor:flex decor:items-center decor:justify-between decor:px-4 decor:py-3 decor:bg-suite-primary-600 decor:text-white decor:rounded-t-suite-card") do
            div(class: "decor:flex decor:items-center decor:gap-2") do
              render ::Decor::Icon.new(name: "messages", width: 20, height: 20)
              span(class: "decor:suite-section-title decor:text-white") { "AI Assistant" }
            end
            child_element(
              :button,
              stimulus_action: [:click, :new_thread],
              type: "button",
              class: new_thread_button_classes,
              title: "New conversation"
            ) { "New Chat" }
          end
        end

        def new_thread_button_classes
          "decor:text-white/80 decor:hover:text-white decor:suite-caption " \
            "decor:px-2 decor:py-1 decor:rounded-suite-control decor:hover:bg-suite-primary-700 " \
            "decor:transition-colors decor:duration-suite-fast decor:ease-out"
        end

        # ── messages area ───────────────────────────────────────────────────

        def render_messages_area
          child_element(
            :div,
            stimulus_target: :messages,
            class: "decor:flex-1 decor:overflow-y-auto decor:px-4 decor:py-3 decor:space-y-3"
          ) do
            child_element(
              :div,
              stimulus_target: :welcome,
              class: "decor:text-center decor:py-8 decor:text-gray-500"
            ) do
              div(class: "decor:mx-auto decor:mb-3 decor:flex decor:items-center decor:justify-center decor:text-gray-300") do
                render ::Decor::Icon.new(name: "message-circle", width: 48, height: 48)
              end
              p(class: "decor:suite-body decor:font-medium") { plain(greeting || "Hi! I'm your AI assistant.") }
              p(class: "decor:suite-description decor:mt-1") { plain greeting_subtitle }
            end
          end
        end

        # ── thinking indicator ──────────────────────────────────────────────

        def render_thinking_indicator
          child_element(
            :div,
            stimulus_target: :thinking,
            class: "decor:hidden decor:px-4 decor:py-2"
          ) do
            div(class: "decor:flex decor:items-center decor:gap-2 decor:text-gray-500") do
              div(class: "decor:flex decor:gap-1") do
                span(class: "decor:w-2 decor:h-2 decor:bg-gray-400 decor:rounded-full decor:animate-bounce", style: "animation-delay: 0ms")
                span(class: "decor:w-2 decor:h-2 decor:bg-gray-400 decor:rounded-full decor:animate-bounce", style: "animation-delay: 150ms")
                span(class: "decor:w-2 decor:h-2 decor:bg-gray-400 decor:rounded-full decor:animate-bounce", style: "animation-delay: 300ms")
              end
              span(class: "decor:suite-description") { "Thinking..." }
            end
          end
        end

        # ── input area ──────────────────────────────────────────────────────

        def render_input_area
          div(class: "decor:border-t decor:border-suite-hairline decor:px-4 decor:py-3") do
            child_element(
              :form,
              stimulus_action: [:submit, :send],
              class: "decor:flex decor:items-center decor:gap-2"
            ) do
              child_element(
                :input,
                stimulus_target: :input,
                type: "text",
                placeholder: "Type your message...",
                class: input_classes,
                autocomplete: "off"
              )
              child_element(
                :button,
                stimulus_target: :send_button,
                type: "submit",
                class: send_button_classes
              ) { "Send" }
            end
            child_element(
              :div,
              stimulus_target: :error_banner,
              class: "decor:hidden decor:mt-2 decor:suite-description decor:text-suite-danger-600"
            )
          end
        end

        def input_classes
          "decor:flex-1 decor:rounded-suite-control decor:border decor:border-suite-hairline-strong " \
            "decor:px-3 decor:py-2 decor:suite-body decor:bg-white decor:text-gray-900 " \
            "decor:focus:outline-hidden decor:focus:ring-2 decor:focus:ring-suite-primary-500 decor:focus:border-transparent"
        end

        def send_button_classes
          "decor:rounded-suite-control decor:bg-suite-primary-600 decor:hover:bg-suite-primary-700 " \
            "decor:text-white decor:px-3 decor:py-2 decor:suite-description decor:font-medium " \
            "decor:transition-colors decor:duration-suite-fast decor:ease-out " \
            "decor:focus:outline-hidden decor:focus:ring-2 decor:focus:ring-suite-primary-500 decor:focus:ring-offset-2 " \
            "decor:disabled:opacity-50 decor:disabled:cursor-not-allowed"
        end
      end
    end
  end
end
