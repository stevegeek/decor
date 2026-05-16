# frozen_string_literal: true

module Decor
  module Components
    module Forms
      # Abstract base for LayoutSection. A LayoutSection is a group of fields
      # that are displayed in a form. Concrete skins (Daisy, Suite) inherit
      # and provide `view_template` plus their visual-language overrides.
      class LayoutSection < ::Decor::PhlexComponent
        no_stimulus_controller

        def with_hero(&block)
          @hero = block
        end

        def with_cta(&block)
          @cta = block
        end

        prop :title, _Nilable(String)
        prop :description, _Nilable(String)

        prop :flash, _Boolean, default: false
        prop :flash_message, _Nilable(String)

        prop :stacked, _Boolean, default: false
        prop :custom_content_wrapper, _Boolean, default: false
      end
    end
  end
end
