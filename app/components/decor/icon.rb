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
    prop :variant, _Union(:outline, :solid, :small_solid), default: :outline

    def file_name
      @file_name ||= "#{@collection}/#{@variant}/#{@name}.svg"
    end
  end
end
