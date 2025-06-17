# frozen_string_literal: true

class Sizes < Literal::Enum(Symbol)
  Xs = new(:xs)
  Sm = new(:sm)
  Md = new(:md)
  Lg = new(:lg)
  Xl = new(:xl)
  
  # Aliases for longer forms
  ExtraSmall = Xs
  Small = Sm
  Medium = Md
  Large = Lg
  ExtraLarge = Xl
end