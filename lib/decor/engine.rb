# frozen_string_literal: true

require "rails/engine"
require "phlex-rails"
require "vident"
require "vident-phlex"
require "literal"

module Decor
  class Engine < ::Rails::Engine
    initializer "decor.assets" do |app|
      next unless app.config.respond_to?(:assets)
      app.config.assets.paths << root.join("app/assets/images")
    end
  end
end
