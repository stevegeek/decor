# frozen_string_literal: true

module Decor
  module Forms
    module TagWrappers
      module ValidationParsers
        class NumberField < Base
          validates_length
          validates_numericality_number_field
          validates_presence
          validates_format
        end
      end
    end
  end
end
