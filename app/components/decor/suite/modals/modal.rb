# frozen_string_literal: true

module Decor
  module Suite
    module Modals
      # Suite Modal — a primitive wrapping the native <dialog> element with
      # Suite chrome. The browser owns focus-trap, Escape, top-layer and
      # backdrop. `closedby="any"` activates native click-outside dismiss
      # (Baseline 2025) when `closeable: true`.
      #
      # Usage (direct):
      #   render ::Decor::Suite::Modals::Modal.new(variant: :danger, title: "Delete?", closeable: true) do
      #     plain "This cannot be undone."
      #   end
      #
      # Usage (with footer slot):
      #   modal = ::Decor::Suite::Modals::Modal.new(title: "Confirm", variant: :warning)
      #   modal.with_footer { render Suite::Button.new(label: "OK") }
      #   render modal
      #
      # Sizes: :default (420 px) | :wide (560 px) | :extra_wide (680 px)
      #        | :huge (1024 px) | :narrow (360 px)
      # Variants: :neutral | :info | :success | :warning | :danger | :destructive
      class Modal < ::Decor::Components::Modals::Modal
        # Single source of truth for the destructive header/title treatment.
        DESTRUCTIVE_HEADER_CLASSES = "decor:bg-suite-danger-50 decor:border-b decor:border-suite-danger-100"
        DESTRUCTIVE_TITLE_CLASSES = "decor:text-suite-danger-700"

        def after_component_initialize
          @footer_block = nil
        end

        # ── footer slot ─────────────────────────────────────────────────────
        def with_footer(&block)
          @footer_block = block
          self
        end

        # ── template ────────────────────────────────────────────────────────
        def view_template(&body_block)
          @body_block = capture(&body_block) if block_given?

          root_element do
            render_accent_bar
            render_header
            render_body
            render_footer
          end
        end

        private

        # ── root element ────────────────────────────────────────────────────
        #
        # Deliberately no `autofocus=""` on the <dialog> itself: when the dialog
        # element is far from the click in the DOM (shared-modal pattern at the
        # top of a long page), focusing the dialog scrolls the page to its
        # natural DOM position. Letting the browser's default showModal()
        # behaviour autofocus the first sequentially-focusable descendant keeps
        # focus inside the top-layer dialog where it doesn't scroll the page.
        def root_element_attributes
          opts = {
            element_tag: :dialog,
            html_options: {
              closedby: (closeable? ? "any" : nil),
              tabindex: "-1"
            }.compact
          }

          if @title.present?
            opts[:html_options][:aria_labelledby] = "#{id}-title"
          end

          # Always set aria-describedby — the body container is always
          # rendered (with an empty body when there's no content yet), and
          # remote-fetched / placeholder content lands into it after the
          # dialog opens. Computing this conditionally on a block-captured
          # @body_block would race against root_element_attributes being
          # resolved before view_template runs.
          opts[:html_options][:aria_describedby] = "#{id}-body"

          opts
        end

        # Do NOT add `relative` here — the UA stylesheet's `dialog:modal
        # { position: fixed; inset: 0; margin: auto }` is what centers the
        # dialog in the viewport. Forcing `position: relative` would drop it
        # back into normal flow and a trigger below the fold would leave the
        # dialog off-screen.
        def root_element_classes
          [
            "cf-modal",
            # `decor:flex` only when the <dialog> is actually open. Browsers
            # ship `dialog:not([open]) { display: none }` in the UA stylesheet,
            # but an unconditional `display: flex` from Tailwind overrides
            # that — leaving every modal visible on page load even though no
            # one called `showModal()`. The `open:` variant scopes the flex
            # layout to the open state only.
            "decor:open:flex decor:flex-col decor:bg-white decor:rounded-suite-card decor:shadow-2xl decor:p-0 decor:overflow-hidden",
            size_width_class,
            "decor:max-w-[calc(100vw-32px)]",
            "decor:max-h-[calc(100vh-32px)]",
            "decor:m-auto"
          ].join(" ")
        end

        # ── rendering helpers ───────────────────────────────────────────────

        def render_accent_bar
          return if @variant == :neutral || @variant == :destructive
          div(class: "decor:absolute decor:left-0 decor:top-0 decor:bottom-0 decor:w-[3px] #{accent_bar_color_class}")
        end

        def render_header
          return unless @title.present? || @description.present?

          div(class: header_classes) do
            render_header_icon
            div(class: "decor:flex-1 decor:min-w-0") do
              h3(id: "#{id}-title", class: title_classes) { plain @title.to_s }
              if @description.present?
                p(class: "cf-modal__description decor:suite-description decor:text-gray-500 decor:mt-0.5") { plain @description }
              end
            end
            render_close_button if closeable? && show_close_button?
          end
        end

        def render_header_icon
          return if icon_hidden?
          name = resolved_icon_name
          return unless name
          span(class: "decor:shrink-0 #{icon_color_class}") do
            render ::Decor::Icon.new(name: name, html_options: {class: "decor:w-4 decor:h-4"})
          end
        end

        def render_close_button
          button(
            type: "button",
            class: "decor:w-[22px] decor:h-[22px] decor:inline-flex decor:items-center decor:justify-center decor:rounded-suite-control decor:text-gray-400 decor:hover:bg-gray-100 decor:hover:text-gray-900 decor:shrink-0",
            aria_label: "Close",
            data: {
              action: "click->#{stimulus_identifier}#close"
            }
          ) do
            render ::Decor::Icon.new(name: "x-mark", html_options: {class: "decor:w-3.5 decor:h-3.5"})
          end
        end

        def render_body
          div(id: "#{id}-body", class: body_classes) do
            if body_content.present?
              raw safe(body_content)
            end
          end
        end

        # min-height reserves vertical space so the dialog doesn't visibly
        # resize when the async-loaded body lands.
        def body_classes
          base = "cf-modal__body decor:px-5 decor:pt-3 decor:pb-4 decor:suite-description decor:text-gray-500 decor:leading-[1.55]"
          @content_href.present? ? "#{base} decor:min-h-[120px]" : base
        end

        def render_footer
          return unless @footer_block.present?
          div(class: "cf-modal__footer decor:flex decor:justify-end decor:gap-1.5 decor:px-5 decor:py-3 decor:bg-suite-gray-25 decor:border-t decor:border-suite-hairline") do
            render @footer_block
          end
        end

        # ── variant helpers ─────────────────────────────────────────────────

        def header_classes
          base = "cf-modal__header decor:flex decor:items-center decor:gap-2.5 decor:px-5 decor:pt-3.5"
          if @variant == :destructive
            "#{base} cf-modal__header--destructive decor:pb-3.5 #{DESTRUCTIVE_HEADER_CLASSES}"
          else
            "#{base} decor:pb-3 decor:border-b decor:border-suite-hairline"
          end
        end

        def title_classes
          base = "cf-modal__title decor:suite-section-title decor:leading-[1.4]"
          if @variant == :destructive
            "#{base} #{DESTRUCTIVE_TITLE_CLASSES}"
          else
            "#{base} decor:text-gray-900"
          end
        end

        def accent_bar_color_class
          case @variant
          when :info then "decor:bg-suite-primary-500"
          when :success then "decor:bg-suite-success-500"
          when :warning then "decor:bg-suite-warning-500"
          when :danger then "decor:bg-suite-danger-500"
          when :destructive then "decor:bg-suite-danger-500"
          else ""
          end
        end

        def icon_color_class
          case @variant
          when :info then "decor:text-suite-primary-600"
          when :success then "decor:text-suite-success-600"
          when :warning then "decor:text-suite-warning-600"
          when :danger then "decor:text-suite-danger-600"
          when :destructive then "decor:text-suite-danger-600"
          else "decor:text-gray-500"
          end
        end

        def icon_hidden?
          @icon == false
        end

        def resolved_icon_name
          return @icon if @icon.is_a?(String)
          case @variant
          when :info then "information-circle"
          when :success then "check-circle"
          when :warning then "exclamation-triangle"
          when :danger then "exclamation-circle"
          when :destructive then "trash"
          end
          # :neutral returns nil — no icon
        end

        def size_width_class
          case @size
          when :wide then "decor:w-[560px]"
          when :extra_wide then "decor:w-[680px]"
          when :huge then "decor:w-[1024px]"
          when :narrow then "decor:w-[360px]"
          else "decor:w-[420px]"
          end
        end

        def body_content
          @body_block.presence || @initial_content
        end
      end
    end
  end
end
