# frozen_string_literal: true

class Colors < Literal::Enum(Symbol)
  Base = new(:base)
  Primary = new(:primary)
  Secondary = new(:secondary)
  Accent = new(:accent)
  Success = new(:success)
  Error = new(:error)
  Warning = new(:warning)
  Info = new(:info)
  Neutral = new(:neutral)
end
