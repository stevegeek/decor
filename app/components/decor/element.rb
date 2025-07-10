# frozen_string_literal: true

# An element is simply a generic container that can be used to wrap other components.
# Useful to add custom Stimulus controllers/attributes around other components.
module Decor
  class Element < PhlexComponent
    no_stimulus_controller

    prop :root_element_attributes, Hash, default: -> { {} }, reader: :private

    def view_template
      root_element do
        yield if block_given?
      end
    end
  end
end
