# frozen_string_literal: true

module Decor
  module Forms
    module TagWrappers
      module ValidationParsers
        class RequiredField < Base
          validates_presence
        end
      end
    end
  end
end
