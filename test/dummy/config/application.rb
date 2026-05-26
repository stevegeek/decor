require_relative "boot"

require "rails/all"

$LOAD_PATH.unshift File.expand_path("../../../lib", __dir__)
require_relative "../../../lib/decor"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Decor
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])
    config.autoload_paths += ["#{Rails.root}/app/lib"]
    config.autoload_paths += ["#{Rails.root}/app/components"]

    # The dummy app runs against the gem's source tree at its real location
    # (two levels up from test/dummy/config/). Add gem-root JS source dirs to
    # the asset path so importmap-rails can resolve the pins in config/importmap.rb.
    gem_root = Pathname.new(File.expand_path("../../..", __dir__))
    config.assets.paths << gem_root.join("vendor/javascript").to_s
    config.assets.paths << gem_root.join("app/javascript").to_s

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
