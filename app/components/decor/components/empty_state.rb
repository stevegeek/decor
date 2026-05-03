# frozen_string_literal: true

module Decor
  module Components
    # Abstract base for EmptyState. Owns the prop API + size/variant tables.
    # Concrete skins (Daisy, Suite) inherit and provide `view_template`
    # plus class-builder overrides for their visual language.
    class EmptyState < ::Decor::PhlexComponent
      include Concerns::StyleColorClasses

      prop :icon_name, String
      prop :title, String
      prop :description, String
      prop :primary_action_label, _Nilable(String)
      prop :primary_action_href, _Nilable(String)
      prop :secondary_action_label, _Nilable(String)
      prop :secondary_action_href, _Nilable(String)
    end
  end
end
