# Pin npm packages by running ./bin/importmap

pin "application"

pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"

# External SVG loader for dynamic SVG loading
pin "external-svg-loader" # @1.7.1
pin "swiper" # @11.2.10

pin "controllers/decor"
pin "controllers/decor/http"

pin_all_from "app/javascript/controllers", under: "controllers"
pin "cally" # @0.8.0
# https://github.com/rails/importmap-rails/issues/270
pin "@highlightjs/cdn-assets/es/highlight.min.js", to: "@highlightjs--cdn-assets--es--highlight.min.js.js", integrity: "sha384-QlXcD7dwbLo9NOccBV2mihDroW2zeQmdPoDV21rLWi99/xNQSZyW1O21PFxjbtfb" # @11.11.1
