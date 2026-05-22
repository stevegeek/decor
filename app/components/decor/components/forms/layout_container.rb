# frozen_string_literal: true

module Decor
  module Components
    module Forms
      class LayoutContainer < ::Decor::PhlexComponent
        no_stimulus_controller

        def with_buttons(&block)
          @buttons = block
        end
      end
    end
  end
end
