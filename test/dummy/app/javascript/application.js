// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import Rails from "@rails/ujs"
import "controllers"
import "confirm_wiring"

if (!window._rails_loaded) {
  Rails.start()
}

// Expose Rails globally for any code that reads window.Rails at runtime.
window.Rails = Rails
