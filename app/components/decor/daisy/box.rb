# frozen_string_literal: true

module Decor
  module Daisy
    # daisyUI card-styled box with title, description, and content areas.
    class Box < ::Decor::Components::Box
      include ::Decor::Daisy::BoxTemplate
    end
  end
end
