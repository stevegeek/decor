# frozen_string_literal: true

require "rails/engine"
require "phlex-rails"
require "vident"
require "vident-phlex"
require "literal"

module Decor
  class Engine < ::Rails::Engine
    isolate_namespace Decor

    initializer "decor.assets" do |app|
      next unless app.config.respond_to?(:assets)
      app.config.assets.paths << root.join("app/assets/images")
    end

    initializer "decor.helpers" do |app|
      app.config.to_prepare do
        ActiveSupport.on_load(:action_controller_base) do
          helper ::Decor::FlashHelper
        end
      end
    end

    initializer "decor.lookbook", before: :set_autoload_paths do |app|
      next unless defined?(::Lookbook)
      preview_dir = root.join("test/components/previews").to_s
      page_dir = root.join("test/components/docs").to_s
      app.config.lookbook.preview_paths = Array(app.config.lookbook.preview_paths) + [preview_dir]
      app.config.lookbook.page_paths = Array(app.config.lookbook.page_paths) + [page_dir]
      # Register preview path with Rails autoload so Decor::Daisy::*Preview constants resolve.
      app.config.autoload_paths += [preview_dir]
      app.config.eager_load_paths += [preview_dir]
    end
  end
end
