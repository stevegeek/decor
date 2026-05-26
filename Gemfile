source "https://rubygems.org"

gemspec

# The dummy app at test/dummy/ uses these at runtime — boot, web,
# DB, assets, Lookbook. Kept at the top level (not in :development /
# :test groups) so Bundler in deployment mode still installs them
# when the dummy is the deploy target.
gem "sqlite3", ">= 2.1"
gem "puma", ">= 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "propshaft"
gem "bootsnap", require: false
gem "lookbook"
gem "solid_cache"
gem "solid_queue"
gem "solid_cable"
gem "quo", github: "stevegeek/quo", branch: "main"
gem "encoded_id-rails", "~> 1.1"

group :development do
  gem "standard", ">= 1.35.1"
  gem "debug", platforms: %i[mri windows], require: "debug/prelude"
end

group :test do
  # Pin to 5.x — railties 8.1.x's line_filtering monkey-patch is not 6.0-compatible.
  gem "minitest", "~> 6.0"
  gem "nokogiri"
  gem "capybara"
  gem "cuprite"
end
