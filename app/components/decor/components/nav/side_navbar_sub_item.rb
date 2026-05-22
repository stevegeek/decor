# frozen_string_literal: true

module Decor
  module Components
    module Nav
      class SideNavbarSubItem < ::Decor::PhlexComponent
        include Phlex::Rails::Helpers::LinkTo

        prop :title, _String(_Predicate("present", &:present?))
        prop :icon, _Nilable(String)
        prop :path, String, default: "#"
        prop :selected, _Boolean, default: false
        prop :counter, _Nilable(Integer)

        stimulus do
          classes shown: "", filtered: "hidden"
        end
      end
    end
  end
end
