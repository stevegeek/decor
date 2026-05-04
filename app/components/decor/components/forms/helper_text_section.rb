# frozen_string_literal: true

module Decor
  module Components
    module Forms
      # Abstract base for HelperTextSection. Owns the prop API + defaults.
      # Concrete skins (Daisy, Suite) inherit and provide `view_template`
      # plus their visual-language overrides.
      class HelperTextSection < ::Decor::PhlexComponent
        prop :helper_text, _Nilable(String)
        prop :error_text, _Nilable(String)

        prop :disabled, _Boolean, default: false
        prop :error_section, _Boolean, default: true
        prop :collapsing_helper_text, _Boolean, default: false
      end
    end
  end
end
