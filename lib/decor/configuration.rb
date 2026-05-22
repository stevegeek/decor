# frozen_string_literal: true

module Decor
  class Configuration
    attr_accessor :prefix, :default_skin
    attr_writer :class_merger

    def initialize
      @prefix = "decor:"
      @default_skin = :daisy
    end

    def class_merger
      @class_merger ||= Decor::ClassMerger.new(prefix: @prefix)
    end
  end
end
