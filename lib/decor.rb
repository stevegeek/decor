# frozen_string_literal: true

require "decor/version"
require "decor/engine"
require "decor/configuration"
require "decor/class_merger"

module Decor
  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield configuration if block_given?
      configuration
    end
  end
end
