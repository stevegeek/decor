# frozen_string_literal: true

module Decor
  module Daisy
    module Forms
      class TextField < ::Decor::Components::Forms::TextField
        include ::Decor::Daisy::Forms::TextFieldTemplate
      end
    end
  end
end
