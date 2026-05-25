# frozen_string_literal: true

require_relative "lib/decor/version"

Gem::Specification.new do |spec|
  spec.name = "decor"
  spec.version = Decor::VERSION
  spec.authors = ["Stephen Ierodiaconou"]
  spec.summary = "Phlex + Vident + daisyUI 5 component library for Rails."
  spec.description = "A Phlex + Vident component library on top of Tailwind v4 and daisyUI v5, with two visual skins (Daisy and Suite)."
  spec.homepage = "https://github.com/stevegeek/decor"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.3"

  spec.metadata = {
    "homepage_uri" => spec.homepage,
    "source_code_uri" => "https://github.com/stevegeek/decor",
    "changelog_uri" => "https://github.com/stevegeek/decor/blob/main/CHANGELOG.md",
    "bug_tracker_uri" => "https://github.com/stevegeek/decor/issues"
  }

  spec.files = Dir[
    "lib/**/*.rb",
    "app/components/decor/**/*",
    "app/helpers/decor/**/*",
    "app/javascript/decor/**/*",
    "app/javascript/controllers/decor/**/*",
    "app/assets/stylesheets/decor/**/*",
    "app/assets/tailwind/decor.css",
    "app/assets/images/{sprites,svgs}/**/*",
    "app/assets/builds/decor.{css,js}",
    "app/assets/builds/decor.{css,js}.map",
    "config/routes.rb",
    "package.json",
    "README.md",
    "CHANGELOG.md",
    "LICENSE.decor.md"
  ]

  spec.add_dependency "rails", ">= 7.2", "< 9"
  spec.add_dependency "phlex-rails", ">= 2.0"
  spec.add_dependency "vident", "~> 3.1"
  spec.add_dependency "vident-phlex", "~> 3.1"
  spec.add_dependency "literal", ">= 1.0"
  spec.add_dependency "tailwind_merge", ">= 0.5.2", "< 2"
  spec.add_dependency "js_regex", "~> 3.5"
end
