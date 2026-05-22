# frozen_string_literal: true

module Decor
  module Daisy
    class ButtonLink < ::Decor::Components::ButtonLink
      include ::Decor::Daisy::ButtonTemplate
      include ::Decor::Daisy::ButtonClasses
    end
  end
end
