import FormFieldController from "./form_field";

// Radios are validated per-group via `missingRadioValue` in the base
// controller, which walks every <input> with the same `name`. A dedicated
// radio-group controller would be cleaner but isn't needed for validation
// today — the missing-value check finds the siblings on its own.
export default class RadioController extends FormFieldController {}
