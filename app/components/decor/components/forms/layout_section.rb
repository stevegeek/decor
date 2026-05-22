# frozen_string_literal: true

module Decor
  module Components
    module Forms
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
