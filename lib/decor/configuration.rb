# frozen_string_literal: true

module Decor
  class Configuration
    attr_accessor :prefix
    attr_writer :class_merger

    def initialize
      @prefix = "decor:"
    end

    def class_merger
      @class_merger ||= Decor::ClassMerger.new(prefix: @prefix)
    end
  end
end
