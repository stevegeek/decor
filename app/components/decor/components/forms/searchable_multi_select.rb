# frozen_string_literal: true

module Decor
  module Components
    module Forms
      class SearchableMultiSelect < ::Decor::PhlexComponent
        # The form field name used by every hidden input emitted for a chip.
        prop :name, String

        # XHR endpoint that returns `{ results: [{id, label, sublabel?, right_label?, metadata?}], has_more }`.
        # Either :search_url OR :choices should be set.
        prop :search_url, _Nilable(String)

        # Local choices array — same shape as XHR results. When set the
        # dropdown filters in-process and no XHR is issued.
        prop :choices, _Nilable(_Array(_Any))

        # Extra query string appended to every XHR request (e.g.
        # "category_id=123&country=US"). Useful for scoping the search.
        prop :extra_search_params, _Nilable(String)

        # Optional descriptive label + helper description above the control.
        prop :label, _Nilable(String)
        prop :description, _Nilable(String)

        prop :placeholder, String, default: "Click to browse or type to search..."

        # Min chars typed before XHR fires (ignored in local-choices mode).
        prop :min_chars, Integer, default: 2
        prop :debounce_ms, Integer, default: 300
        prop :page_size, Integer, default: 15

        # Pre-populated chips, shape: [{ id:, label: }, ...]. Rendered server-
        # side as chips at mount; new picks append more chips client-side.
        prop :selected_items, _Array(_Any), default: -> { [] }

        # When true the user can press Enter (or type the delimiter) to commit
        # arbitrary text as a chip without matching a search result.
        prop :allow_free_text, _Boolean, default: false

        # The character that splits typed input into multiple free-text chips
        # (only meaningful when `allow_free_text` is true).
        prop :delimiter, String, default: ","

        prop :disabled, _Boolean, default: false

        # Helper / error caption — rendered below the control by skins that
        # support a FormField-style caption row.
        prop :helper_text, _Nilable(String)
        prop :error_messages, _Nilable(Array)

        stimulus do
          # See sibling SearchableSelect base for the rationale: `targets`
          # and `actions` listed here would emit on the controller root and
          # break Stimulus target resolution. Children declare their own.
          values(
            search_url: -> { @search_url || "" },
            choices: -> { normalized_choices.to_json },
            extra_search_params: -> { @extra_search_params || "" },
            min_chars: -> { @choices.present? ? 0 : @min_chars },
            debounce_ms: -> { @debounce_ms },
            page_size: -> { @page_size },
            selected_items: -> { (@selected_items || []).to_json },
            field_name: -> { @name },
            allow_free_text: -> { @allow_free_text },
            delimiter: -> { @delimiter }
          )
        end

        private

        # Accept both {id:, label:, ...} entries and Rails select-helper
        # [label, value] pairs (e.g. `*.for_select` output) so local choices
        # don't render blank-labelled.
        def normalized_choices
          (@choices || []).map do |choice|
            choice.is_a?(Array) ? {id: choice[1], label: choice[0]} : choice
          end
        end

        def disabled?
          @disabled
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
