import { Application } from "@hotwired/stimulus"
import "controllers/decor"

const application = Application.start()

// Configure Stimulus development experience
application.debug = true
window.Stimulus   = application

export { application }
