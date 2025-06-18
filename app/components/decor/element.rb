# frozen_string_literal: true

# An element is simply a generic container that can be used to wrap other components.
# Useful to add custom Stimulus controllers/attributes around other components.
module Decor
  class Element < PhlexComponent
    # TODO: use literal ** ?
    attribute :options, default: {}

    def view_template
      render parent_element do
        yield
      end
    end

    def root_element_attributes
      @options
    end
  end
end
