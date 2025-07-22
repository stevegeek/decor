# frozen_string_literal: true

module Decor
  class Icon < Svg
    no_stimulus_controller
    with_cache_key

    depends_on ::Decor::Svg

    prop :inline, _Boolean, default: false

    prop :name, String
    prop :file_name, _Nilable(String)
    prop :collection, _Union(:heroicons), default: :heroicons
    # Icon uses domain-specific styles for icon types, not standard style system
    default_style :outline
    redefine_styles :outline, :solid, :small_solid

    def file_name
      @file_name ||= "#{@collection}/#{@style}/#{@name}.svg"
    end
  end
end
