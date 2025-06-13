# Pin npm packages by running ./bin/importmap

pin "application"

pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"

# External SVG loader for dynamic SVG loading
pin "external-svg-loader" # @1.7.1
pin "swiper" # @11.2.8

pin "controllers/decor"
pin_all_from "app/javascript/controllers", under: "controllers"
