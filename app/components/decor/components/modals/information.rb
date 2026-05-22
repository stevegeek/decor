# frozen_string_literal: true

module Decor
  module Components
    module Modals
      class Information < ::Decor::PhlexComponent
        no_stimulus_controller

        VARIANT_OPTIONS = %i[neutral info success warning danger destructive].freeze
        SIZE_OPTIONS = %i[default wide extra_wide huge narrow].freeze

        prop :title, String
        prop :description, _Nilable(String), default: nil
        prop :variant, _Union(*VARIANT_OPTIONS), default: :neutral
        prop :size, _Union(*SIZE_OPTIONS), default: :default
        prop :close_label, String, default: "Close"
        prop :start_open, _Boolean, default: false
      end
    end
  end
end
