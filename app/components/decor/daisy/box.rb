# frozen_string_literal: true

module Decor
  module Daisy
    class Box < ::Decor::Components::Box
      include ::Decor::Daisy::BoxTemplate
    end
  end
end
