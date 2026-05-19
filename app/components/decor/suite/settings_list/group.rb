# frozen_string_literal: true

module Decor
  module Suite
    class SettingsList < ::Decor::Components::SettingsList
      # A section of related setting rows within a Suite SettingsList.
      # Mirrors the base Group prop API; lives in the Suite namespace so
      # callers can construct via `Decor::Suite::SettingsList::Group`
      # alongside the rest of the Suite chrome.
      class Group < ::Literal::Data
        prop :name, String
        prop :icon, _Nilable(String), default: nil
        prop :description, _Nilable(String), default: nil
        prop :rows, _Array(::Decor::Components::SettingsList::Row), default: -> { [] }
      end
    end
  end
end
