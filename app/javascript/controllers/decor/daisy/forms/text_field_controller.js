import FormFieldController from "./form_field";

// Concrete form-field controller for TextField. Adds the leading/trailing
// text-add-on targets the Phlex component renders alongside the input.
export default class TextFieldController extends FormFieldController {
  static targets = ["leadingTextAddOn", "trailingTextAddOn"];
}
