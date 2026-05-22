# frozen_string_literal: true

module Decor
  module Components
    class ClickToCopy < ::Decor::PhlexComponent
      prop :to_copy, _Nilable(String)

      stimulus do
        actions [:click, :copy]
        values_from_props :to_copy
      end
    end
  end
end
