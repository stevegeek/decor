// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"

// Decor controllers come from the built bundle (decor.js). It auto-registers
// every decor controller with window.Stimulus (set by controllers/application,
// which is fully evaluated before this import runs). This replaces eager-loading
// decor's raw source, whose relative imports importmap can't resolve.
import "decor"

// Eager-load the dummy app's own controllers (e.g. event-logger).
eagerLoadControllersFrom("controllers", application)
