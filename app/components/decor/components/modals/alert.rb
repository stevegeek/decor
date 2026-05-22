# frozen_string_literal: true

module Decor
  module Components
    module Modals
      class Alert < ::Decor::PhlexComponent
        no_stimulus_controller

        VARIANT_OPTIONS = ::Decor::Components::Modals::Modal::VARIANT_OPTIONS

        prop :title, String
        prop :message, String
        prop :variant, _Union(*VARIANT_OPTIONS), default: :info
        prop :button_label, String, default: "OK"
        prop :dismiss_event, _Nilable(String)
        prop :start_open, _Boolean, default: false
      end
    end
  end
end
