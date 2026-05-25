source "https://rubygems.org"

gemspec

# Development + test only — what the dummy app needs to boot Lookbook and run tests
group :development, :test do
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
  gem "encoded_id-rails", github: "stevegeek/encoded_id", branch: "main"

  # Pin to 5.x — railties 8.1.x's line_filtering monkey-patch is not 6.0-compatible.
  gem "minitest", "~> 5.25"

  gem "standard", ">= 1.35.1"
  gem "nokogiri"

  gem "debug", platforms: %i[mri windows], require: "debug/prelude"
end
