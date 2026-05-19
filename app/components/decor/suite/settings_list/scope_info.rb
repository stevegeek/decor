# frozen_string_literal: true

module Decor
  module Suite
    class SettingsList < ::Decor::Components::SettingsList
      # Inheritance / override metadata for a setting that's configured
      # somewhere other than where it's being rendered. Mirrors the base
      # ScopeInfo prop API; lives in the Suite namespace so callers can
      # construct via `Decor::Suite::SettingsList::ScopeInfo` alongside
      # the rest of the Suite chrome.
      class ScopeInfo < ::Literal::Data
        prop :label, String
        prop :tooltip, String
        prop :link_path, _Nilable(String), default: nil
      end
    end
  end
end
