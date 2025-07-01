# frozen_string_literal: true

module Decor
  class Icon < Svg
    no_stimulus_controller
    with_cache_key

    depends_on ::Decor::Svg

    attribute :inline, :boolean, default: false

    attribute :name, String, allow_nil: false
    attribute :file_name, String, allow_nil: true
    attribute :collection, Symbol, default: :heroicons, in: [:heroicons]
    attribute :variant, Symbol, default: :outline, in: [:outline, :solid, :small_solid]

    def file_name
      @file_name ||= "#{@collection}/#{@variant}/#{@name}.svg"
    end
  end
end
