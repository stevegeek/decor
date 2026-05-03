# frozen_string_literal: true

module Decor
  module Components
    # Abstract base for ClickToCopy. Owns the prop API and the stimulus
    # contract (actions + values). Concrete skins inherit and provide
    # `view_template` plus the daisyUI / Suite class strings.
    class ClickToCopy < ::Decor::PhlexComponent
      prop :to_copy, _Nilable(String)

      stimulus do
        actions [:click, :copy]
        values_from_props :to_copy
      end
    end
  end
end
