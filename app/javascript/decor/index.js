import { CONTROLLERS } from "./controllers.js";

export function register(application) {
  for (const [identifier, Controller] of Object.entries(CONTROLLERS)) {
    application.register(identifier, Controller);
  }
}

// Side-effect fallback: auto-register if host's Stimulus application is on the
// global AND this module is imported AFTER Application.start().
if (typeof window !== "undefined" && window.Stimulus) {
  register(window.Stimulus);
}

export { CONTROLLERS };
