# frozen_string_literal: true

module Decor
  module Components
    module Forms
      class SearchableSelect < ::Decor::PhlexComponent
        # The form field name for the hidden input that carries the selected id.
        prop :name, String

        # XHR endpoint that returns `{ results: [{id, label, sublabel?, right_label?, metadata?}], has_more }`.
        # Either :search_url OR :choices should be set.
        prop :search_url, _Nilable(String)

        # Local choices array — same shape as XHR results. When set the
        # dropdown filters in-process and no XHR is issued.
        prop :choices, _Nilable(_Array(_Any))

        # Optional descriptive label + helper description above the control.
        prop :label, _Nilable(String)
        prop :description, _Nilable(String)

        prop :placeholder, String, default: "Click to browse or type to search..."

        # Min chars typed before XHR fires (ignored in local-choices mode).
        prop :min_chars, Integer, default: 2
        prop :debounce_ms, Integer, default: 300
        prop :page_size, Integer, default: 15

        # Pre-selected item, shape: { id:, label: }. When present the input
        # is hidden and the chip is shown instead.
        prop :selected_item, _Nilable(Hash)

        # Whether the chip carries an X to clear the selection.
        prop :allow_clear, _Boolean, default: true

        # When true, picking (or clearing) a value submits the closest form.
        prop :auto_submit, _Boolean, default: false

        # Label position — top is default; other positions are passed through
        # for parity with FormChild but most skins render label-top.
        prop :label_position, _Union(:top, :left, :inside), default: :top

        prop :disabled, _Boolean, default: false

        # Helper / error caption — rendered below the control by skins that
        # support a FormField-style caption row.
        prop :helper_text, _Nilable(String)
        prop :error_messages, _Nilable(Array)

        stimulus do
          # NB: do NOT list `targets ...` or `actions ...` here — those
          # Vident DSL forms emit `data-{identifier}-target="..."` and
          # `data-action="..."` on the controller ROOT, and Stimulus's
          # `[data-...-target~="input"]` matcher then resolves `inputTarget`
          # to the wrapper <div>, breaking every controller method that
          # touches `inputTarget.value`. The actual `<input>` /
          # `<dropdown>` / etc. children declare their own targets and
          # actions inline via `child_element(stimulus_target:, stimulus_actions:)`.
          values(
            search_url: -> { @search_url || "" },
            choices: -> { normalized_choices.to_json },
            min_chars: -> { @choices.present? ? 0 : @min_chars },
            debounce_ms: -> { @debounce_ms },
            page_size: -> { @page_size },
            selected_item: -> { (@selected_item || {}).to_json },
            allow_clear: -> { @allow_clear },
            auto_submit: -> { @auto_submit },
            field_name: -> { @name }
          )
        end

        private

        # The JS controller and XHR results use {id:, label:, ...} entries.
        # Also accept Rails select-helper format ([label, value] pairs) so
        # callers can pass `*.for_select` / OptionsForSelect output directly
        # without the dropdown rendering blank-labelled options.
        def normalized_choices
          (@choices || []).map do |choice|
            choice.is_a?(Array) ? {id: choice[1], label: choice[0]} : choice
          end
        end

        def disabled?
          @disabled
        end

        def selected?
          @selected_item.present?
        end

        def error_text
          @error_messages.present? ? @error_messages.join(", ") : ""
        end

        def errors?
          error_text.present?
        end
      end
    end
  end
end
