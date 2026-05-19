import FormFieldController from "./form_field";

export default class CheckboxController extends FormFieldController {
  set checked(state) {
    this.inputTarget.checked = state;
    // Explicit checked toggles must reset indeterminate; otherwise the
    // visual tri-state persists even after the user makes a definite choice.
    this.inputTarget.indeterminate = false;
  }

  get checked() {
    return this.inputTarget.checked;
  }

  set indeterminate(state) {
    this.inputTarget.indeterminate = state;
  }

  get indeterminate() {
    return this.inputTarget.indeterminate;
  }
}
