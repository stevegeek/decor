# Pin npm packages by running ./bin/importmap

pin "application"

pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"

pin "swiper" # @11.2.10

pin "controllers/decor"
pin "controllers/decor/http"

# Scan gem-root controller tree (one level above test/dummy)
pin_all_from File.expand_path("../../../app/javascript/controllers/decor", __dir__),
             under: "controllers/decor"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "cally" # @0.8.0
# https://github.com/rails/importmap-rails/issues/270
pin "@highlightjs/cdn-assets/es/highlight.min.js", to: "@highlightjs--cdn-assets--es--highlight.min.js.js", integrity: "sha384-QlXcD7dwbLo9NOccBV2mihDroW2zeQmdPoDV21rLWi99/xNQSZyW1O21PFxjbtfb" # @11.11.1
