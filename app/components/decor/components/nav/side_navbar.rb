# frozen_string_literal: true

module Decor
  module Components
    module Nav
      class SideNavbar < ::Decor::PhlexComponent
        prop :app_title, _Nilable(_String(_Predicate("present", &:present?)))
        prop :landscape_logo_url, _Nilable(String)
        prop :avatar_logo_url, _Nilable(String)
        prop :collapsed, _Boolean, default: false

        stimulus do
          actions -> { [stimulus_scoped_event_on_window(:toggle_mobile_menu), :toggle_mobile_menu] },
            [:touchstart, :handle_mouse_over],
            [:mouseenter, :handle_mouse_over],
            [:mouseleave, :handle_mouse_away]
          values_from_props :collapsed
          outlets({::Decor::Daisy::Nav::SideNavbarSection => nil})
        end

        def with_section(**attributes, &block)
          @sections ||= []
          section = ::Decor::Daisy::Nav::SideNavbarSection.new(**attributes)
          @sections << [section, block]
          section
        end

        def sections
          @sections ||= []
        end

        def id
          "decor--nav-sidebar"
        end
      end
    end
  end
end
