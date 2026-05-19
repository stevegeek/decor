import FormFieldController from "./form_field";

// Stimulus does not merge `static targets` across the prototype chain, so
// the explicit re-declaration here is what keeps the parent targets in scope
// for this subclass. Without it the controller would only have its own
// (empty) target list and the base's helper/error wiring would no-op.
export default class ButtonRadioGroupController extends FormFieldController {
  static targets = FormFieldController.targets;
}
