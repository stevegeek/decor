# frozen_string_literal: true

module Decor
  module Components
    class Element < ::Decor::PhlexComponent
      no_stimulus_controller

      prop :root_element_attributes, Hash, default: -> { {} }, reader: :private
    end
  end
end
