# frozen_string_literal: true

module Decor
  module Forms
    module TagWrappers
      module ValidationParsers
        class TextField < Base
          validates_length
          validates_numericality_text_field
          validates_presence
          validates_format
        end
      end
    end
  end
end
