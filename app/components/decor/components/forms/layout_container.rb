# frozen_string_literal: true

module Decor
  module Components
    module Forms
      # Abstract base for LayoutContainer. A LayoutContainer is a container for
      # a set of LayoutSections. Concrete skins (Daisy, Suite) inherit and
      # provide `view_template` plus their visual-language overrides.
      class LayoutContainer < ::Decor::PhlexComponent
        no_stimulus_controller

        def with_buttons(&block)
          @buttons = block
        end
      end
    end
  end
end
