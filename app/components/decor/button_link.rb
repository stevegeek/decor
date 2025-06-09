# frozen_string_literal: true

module Decor
  class ButtonLink < Button
    include Decor::Concerns::ActsAsLink

    no_stimulus_controller

    private

    # ButtonLink renders as button when disabled (preserving original behavior)
    def link_element_tag
      if @disabled
        :button
      else
        :a
      end
    end
  end
end
