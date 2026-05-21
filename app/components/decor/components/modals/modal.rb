# frozen_string_literal: true

module Decor
  module Components
    module Modals
      # Abstract base for Modal. Owns the prop API + stimulus block.
      # Concrete skins (Daisy, Suite) inherit and provide `view_template`
      # plus their visual-language overrides.
      #
      # The Suite skin uses the native <dialog> element directly (Baseline 2025
      # APIs: showModal/close/closedby="any"/::backdrop) and wires Stimulus to
      # the dialog itself rather than to a wrapper. The Daisy skin keeps the
      # daisyUI-flavored overlay + modal-box markup.
      class Modal < ::Decor::PhlexComponent
        VARIANT_OPTIONS = %i[neutral info success warning danger destructive].freeze
        SIZE_OPTIONS = %i[default wide extra_wide huge narrow].freeze

        # ── shared props ────────────────────────────────────────────────────
        # `initial_content` is rendered raw HTML only when html_safe? — plain
        # Strings are escaped to prevent XSS via controller params being piped
        # straight into a modal body.
        prop :initial_content, _Nilable(String)
        prop :content_href, _Nilable(String)
        prop :start_shown, _Boolean, default: false
        prop :close_on_overlay_click, _Boolean, default: false

        # ── Suite-extended props (also surfaced for Daisy use if desired) ───
        prop :variant, _Union(*VARIANT_OPTIONS), default: :neutral
        prop :size, _Union(*SIZE_OPTIONS), default: :default

        prop :title, _Nilable(String)
        prop :description, _Nilable(String)

        # Three-state icon control:
        #   nil    — auto-select icon by variant (no icon for :neutral)
        #   false  — suppress icon entirely
        #   String — explicit icon name override (passed to Decor::Icon)
        prop :icon, _Nilable(_Union(FalseClass, String)), default: nil

        prop :closeable, _Boolean, default: true, predicate: :public, reader: :public
        prop :show_close_button, _Boolean, default: true, predicate: :public, reader: :public
        prop :start_open, _Boolean, default: false, predicate: :public, reader: :public

        stimulus do
          targets :overlay, :modal
          actions -> { [stimulus_scoped_event_on_window(:open), :handle_open_event] },
            -> { [stimulus_scoped_event_on_window(:close), :handle_close_event] }
          values_from_props :close_on_overlay_click, :content_href
          values show_initial: -> { @start_shown },
            start_open: -> { @start_open },
            closeable: -> { @closeable }
        end
      end
    end
  end
end
