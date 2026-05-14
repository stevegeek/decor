import * as controllers from "./controllers.js";

export function register(application) {
  for (const [exportName, Controller] of Object.entries(controllers)) {
    const identifier = stimulusIdentifierFor(exportName);
    application.register(identifier, Controller);
  }
}

function stimulusIdentifierFor(exportName) {
  // ButtonComponent → button-component
  // ModalCloseButton → modal-close-button
  return exportName
    .replace(/Controller$/, "")
    .replace(/([a-z0-9])([A-Z])/g, "$1-$2")
    .replace(/([A-Z]+)([A-Z][a-z])/g, "$1-$2")
    .toLowerCase();
}

// Side-effect fallback: auto-register if host's Stimulus application is on the global
// AND this module is imported AFTER Application.start().
if (typeof window !== "undefined" && window.Stimulus) {
  register(window.Stimulus);
}

export { stimulusIdentifierFor };
