# frozen_string_literal: true

module Decor
  module Daisy
    module Forms
      class NumberField < ::Decor::Components::Forms::NumberField
        include ::Decor::Daisy::Forms::TextFieldTemplate
      end
    end
  end
end
