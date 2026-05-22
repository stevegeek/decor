# frozen_string_literal: true

module Decor
  module Suite
    module Modals
      # DESTRUCTIVE_HEADER_CLASSES / DESTRUCTIVE_TITLE_CLASSES are deliberately
      # NOT duplicated here - Suite::Modals::Modal owns them as the single
      # source of truth (its header_classes / title_classes helpers reference
      # them too, and the server-rendered destructive path must match).
      module ConfirmShared
        VARIANT_ACCENT_CLASSES = {
          info: "decor:bg-suite-primary-500",
          success: "decor:bg-suite-success-500",
          warning: "decor:bg-suite-warning-500",
          danger: "decor:bg-suite-danger-500",
          destructive: "decor:bg-suite-danger-500",
          neutral: "decor:bg-gray-400"
        }.freeze

        VARIANT_ICON_NAMES = {
          info: "information-circle",
          success: "check-circle",
          warning: "exclamation-triangle",
          danger: "exclamation-circle",
          destructive: "trash"
        }.freeze

        VARIANT_ICON_COLOR_CLASSES = {
          info: "decor:text-suite-primary-600",
          success: "decor:text-suite-success-600",
          warning: "decor:text-suite-warning-600",
          danger: "decor:text-suite-danger-600",
          destructive: "decor:text-suite-danger-600",
          neutral: "decor:text-gray-500"
        }.freeze
      end
    end
  end
end
