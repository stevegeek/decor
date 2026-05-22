# frozen_string_literal: true

module Decor
  module Suite
    class SettingsList < ::Decor::Components::SettingsList
      class Group < ::Literal::Data
        prop :name, String
        prop :icon, _Nilable(String), default: nil
        prop :description, _Nilable(String), default: nil
        prop :rows, _Array(::Decor::Components::SettingsList::Row), default: -> { [] }
      end
    end
  end
end
