# frozen_string_literal: true

module Decor
  module Suite
    module Modals
      # Suite skin of ModalTrigger — a transparent wrapper that turns whatever
      # the consumer renders inside the block (link, card, avatar, custom
      # element) into a clickable that dispatches the same window-scoped
      # `decor--suite--modals--modal:open` event as Suite::Modals::ModalOpenButton.
      # The receiving Suite Modal matches on `id`; the event also carries
      # optional `content_href`, `initial_content`, `title` and
      # `closeOnOverlayClick`.
      #
      # Minimal chrome — no padding, no border, no background. The intent is
      # for the wrapped content to own its own visual identity; this
      # component only contributes the click target, keyboard activation, and
      # the focus ring.
      class ModalTrigger < ::Decor::Components::Modals::ModalTrigger
        def view_template(&)
          @content = capture(&) if block_given?
          root_element do
            raw @content if @content.present?
          end
        end

        private

        def root_element_attributes
          {
            element_tag: :span,
            html_options: {
              role: "button",
              tabindex: "0"
            }
          }
        end

        def root_element_classes
          [
            "decor:inline-block decor:cursor-pointer",
            "decor:rounded-suite-control",
            "decor:transition-all decor:duration-suite-fast decor:ease-out",
            "decor:focus-visible:outline-hidden",
            "decor:focus-visible:shadow-[0_0_0_3px_var(--color-suite-primary-100)]"
          ].join(" ")
        end
      end
    end
  end
end
