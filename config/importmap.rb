# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"

# External SVG loader for dynamic SVG loading
pin "external-svg-loader", to: "https://ga.jspm.io/npm:external-svg-loader@1.7.1/dist/svg-loader.min.js"
