# frozen_string_literal: true

module Decor
  module Forms
    # Maps a set of validation properties from the intermediate format from the ValidationMapper to attributes
    # that can be assigned on the TextField component
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
