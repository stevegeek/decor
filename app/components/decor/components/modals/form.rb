# frozen_string_literal: true

module Decor
  module Components
    module Modals
      class Form < ::Decor::PhlexComponent
        no_stimulus_controller

        VARIANT_OPTIONS = %i[neutral info success warning danger destructive].freeze
        SIZE_OPTIONS = %i[default wide extra_wide huge narrow].freeze
        SUBMIT_COLOR_OPTIONS = %i[primary error warning].freeze

        prop :title, String
        prop :description, _Nilable(String), default: nil
        prop :variant, _Union(*VARIANT_OPTIONS), default: :neutral
        prop :size, _Union(*SIZE_OPTIONS), default: :default
        prop :submit_label, String, default: "Save"
        prop :submit_color, _Union(*SUBMIT_COLOR_OPTIONS), default: :primary
        prop :cancel_label, String, default: "Cancel"
        prop :start_open, _Boolean, default: false

        # The id of the inner <form> the footer Submit button targets via the
        # HTML5 `form="..."` attribute. Auto-derived from the component's
        # Vident id when not explicitly passed.
        prop :form_id, _Nilable(String), default: nil, reader: :public

        # Lazy-load knobs forwarded to the inner Modal. When `content_href`
        # is set, the body is fetched on first open.
        prop :content_href, _Nilable(String), default: nil
        prop :initial_content, _Nilable(::ActiveSupport::SafeBuffer), default: nil

        def form_id
          @form_id ||= "#{id}-form"
        end
      end
    end
  end
end
