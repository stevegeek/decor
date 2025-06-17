# frozen_string_literal: true

class Variant < Literal::Enum(Symbol)
  Filled = new(:filled)
  Outlined = new(:outlined)
  Ghost = new(:ghost)
end

