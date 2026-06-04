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

// Public JS surface for host apps: identifier constants and the controller
// classes intended for reuse/subclassing. Lets consumers import from "decor"
// (the prebuilt bundle) instead of reaching into the package's source tree.
export * from "./suite/identifiers.js";
export * from "./daisy/identifiers.js";

export { default as TextFieldController } from "../controllers/decor/suite/forms/text_field_controller.js";
export { default as NumberFieldController } from "../controllers/decor/suite/forms/number_field_controller.js";
export { default as FormFieldController } from "../controllers/decor/daisy/forms/form_field.js";
export { default as ConfirmTemplateController } from "../controllers/decor/daisy/modals/confirm_template_controller.js";
export { default as DataTableController } from "../controllers/decor/suite/tables/data_table_controller.js";
