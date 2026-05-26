# Pin npm packages by running ./bin/importmap

pin "application"

pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin "@rails/ujs", to: "https://cdn.jsdelivr.net/npm/@rails/ujs@7.1.3/+esm"

# Externals required by the built decor.js bundle, vendored locally as
# self-contained ESM (esm.sh .bundle.mjs) so the harness has no CDN deps.
pin "swiper" # @11.2.10 (vendored swiper.js — self-contained)
pin "swiper/modules", to: "swiper--modules.js"
pin "@floating-ui/dom", to: "floating-ui--dom.js"

# Decor's JS is consumed as the built esbuild bundle (the package.json `main`),
# NOT the raw source tree: the raw controllers use relative cross-module imports
# (../../base, ../../../../lib/util/*) that importmap can't resolve, so the field
# controllers fail to register. The bundle resolves those at build time and
# auto-registers every controller with window.Stimulus on import.
pin "decor", to: "decor.js"

pin "controllers/decor"
pin "controllers/decor/http"

pin_all_from "app/javascript/controllers", under: "controllers"
pin "cally" # @0.8.0
# https://github.com/rails/importmap-rails/issues/270
pin "@highlightjs/cdn-assets/es/highlight.min.js", to: "@highlightjs--cdn-assets--es--highlight.min.js.js", integrity: "sha384-QlXcD7dwbLo9NOccBV2mihDroW2zeQmdPoDV21rLWi99/xNQSZyW1O21PFxjbtfb" # @11.11.1
