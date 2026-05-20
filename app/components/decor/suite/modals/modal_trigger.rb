# frozen_string_literal: true

module Decor
  module Suite
    module Modals
      # Suite ModalTrigger has two operating modes that share one class so the
      # caller picks the ergonomics that fit the call-site:
      #
      # 1. Transparent-wrapper mode — caller passes `modal_id:` and a content
      #    block. The block content becomes a clickable that dispatches the
      #    window-scoped `decor--suite--modals--modal:open` event. No padding,
      #    no border, no background; the wrapped element owns its own visual
      #    identity. Use this for non-button triggers (table rows, cards,
      #    avatars, links) and shared-modal patterns where one Modal is
      #    rendered separately and N triggers reference it by id.
      #
      # 2. Bundled trigger-plus-modal mode — caller passes the button-trigger
      #    vocabulary (`label:`, `color:`, `style:`, `size:`, `icon:`, etc.)
      #    plus the modal vocabulary (`modal_title:`, `modal_size:`,
      #    `modal_content_href:`, `modal_initial_content:`, etc.) and we
      #    render BOTH a `Suite::Modals::ModalOpenButton` AND a sibling
      #    `Suite::Modals::Modal` with id-wiring done automatically. Use this
      #    when one button opens one modal whose content is known at render
      #    time — the most common case in production code.
      #
      # Mode detection:
      #   - transparent → a content block is given AND `modal_title:` is not
      #     set AND `label:` is not set
      #   - bundled     → otherwise
      #
      # Bundled usage:
      #   render ::Decor::Suite::Modals::ModalTrigger.new(
      #     label: "Edit", color: :primary, style: :filled,
      #     modal_title: "Edit record"
      #   ) { p { "Body content" } }
      #
      # Transparent usage:
      #   render ::Decor::Suite::Modals::ModalTrigger.new(modal_id: "row-42") do
      #     plain "Edit row 42"
      #   end
      class ModalTrigger < ::Decor::Components::Modals::ModalTrigger
        # Mirror Suite::Button — adds :wide and :link sizes so legacy
        # ConfinusUI callers (size: :link inline-icon triggers) keep working.
        redefine_sizes :xs, :sm, :md, :lg, :xl, :wide, :link

        # Override the abstract base's required modal_id so bundled-mode
        # callers don't have to invent one — we auto-wire to the sibling
        # Modal's id below.
        prop :modal_id, _Nilable(String), reader: :public

        # ── trigger-button props (bundled mode) ────────────────────────────
        prop :label, _Nilable(String)
        prop :color, _Nilable(Symbol)
        prop :style, _Nilable(Symbol)
        prop :icon, _Nilable(String)
        prop :icon_variant, _Nilable(Symbol)
        prop :full_width, _Boolean, default: false, predicate: :public
        prop :disabled, _Boolean, default: false, predicate: :public
        # Extra CSS classes forwarded to the inner ModalOpenButton's root
        # element. Use when the trigger button needs layout-specific classes
        # (e.g. "ml-6 hidden md:block").
        prop :button_classes, _Union(String, _Array(String)), default: -> { [] }

        # ── modal props (bundled mode) ─────────────────────────────────────
        prop :modal_title, _Nilable(String)
        prop :modal_description, _Nilable(String)
        prop :modal_variant, _Nilable(Symbol)
        prop :modal_size, _Nilable(Symbol)
        prop :modal_closeable, _Boolean, default: true, predicate: :public
        prop :modal_content_href, _Nilable(String)
        prop :modal_initial_content, _Nilable(::ActiveSupport::SafeBuffer)
        prop :modal_icon, _Nilable(_Union(FalseClass, String))

        def view_template(&)
          @content_block = capture(&) if block_given?
          if bundled_mode?
            render_bundled
          else
            render_transparent
          end
        end

        private

        # Transparent mode is the default when there's content to wrap but no
        # modal-side vocabulary — i.e. the caller is building a one-of-many
        # trigger against an externally-rendered Modal.
        def bundled_mode?
          @modal_title.present? || @modal_description.present? || @modal_content_href.present? ||
            @modal_initial_content.present? || @label.present? || @icon.present? ||
            @color.present? || @style.present?
        end

        # ── bundled mode ───────────────────────────────────────────────────

        def render_bundled
          modal_opts = {
            initial_content: @modal_initial_content,
            content_href: @modal_content_href,
            closeable: modal_closeable?
          }
          modal_opts[:title] = @modal_title if @modal_title
          modal_opts[:description] = @modal_description if @modal_description
          modal_opts[:variant] = @modal_variant if @modal_variant
          modal_opts[:size] = @modal_size if @modal_size
          modal_opts[:icon] = @modal_icon unless @modal_icon.nil?

          modal = ::Decor::Suite::Modals::Modal.new(**modal_opts)

          button_opts = {modal_id: modal.id}
          button_opts[:label] = @label if @label
          button_opts[:color] = @color if @color
          button_opts[:style] = @style if @style
          button_opts[:size] = @size if @size
          button_opts[:icon] = @icon if @icon
          button_opts[:icon_variant] = @icon_variant if @icon_variant
          button_opts[:full_width] = true if full_width?
          button_opts[:disabled] = true if disabled?
          button_opts[:classes] = @button_classes if @button_classes.present?

          render ::Decor::Suite::Modals::ModalOpenButton.new(**button_opts)

          if @content_block.present?
            render(modal) { raw safe(@content_block) }
          else
            render modal
          end
        end

        # ── transparent mode ───────────────────────────────────────────────

        def render_transparent
          root_element do
            raw @content_block if @content_block.present?
          end
        end

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
