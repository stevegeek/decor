import FormFieldController from "./form_field";

// Concrete Select controller. Manages the placeholder/blank styling (greyed
// option text when an empty placeholder is selected) and republishes the
// native change event under the controller's stimulus identifier so siblings
// can listen for it without coupling to a specific element.
export default class SelectController extends FormFieldController {
  static values = {
    ...FormFieldController.values,
    name: { type: String, default: "" },
    hasBlankOrPlaceholder: Boolean,
  };

  connect() {
    super.connect();
    this._boundHandleChange = this.handleChangeEvent.bind(this);
    this.inputTarget.addEventListener("change", this._boundHandleChange);
    this.styleOption();
  }

  disconnect() {
    this.inputTarget.removeEventListener("change", this._boundHandleChange);
    super.disconnect();
  }

  styleOption() {
    let blankSelected = false;
    for (const option of this.inputTarget.children) {
      const isBlank = this.hasBlankOrPlaceholderValue && option.value === "";
      if (isBlank && this.value === option.value) {
        blankSelected = true;
      }
    }
    this.toggleTargetElementClasses(
      this.inputTarget,
      blankSelected,
      [],
      ["text-disabled"],
    );
  }

  get optionsHTML() {
    return this.inputTarget.innerHTML;
  }

  // Replace the <option> list. `optionsHTML` is treated as trusted markup —
  // callers must escape user-provided strings themselves before passing
  // them in. There's no DOM sanitiser in scope here.
  set options(optionsHTML) {
    this.inputTarget.innerHTML = optionsHTML;
  }

  empty(message) {
    this.options = `<option value="" selected>${escapeText(message)}</option>`;
  }

  handleChangeEvent(evt) {
    const name = this.nameValue;
    const target = evt.target;
    this.styleOption();
    this.emitEvent(this.element, SelectController, "change", {
      name,
      index: target.selectedIndex,
      value: target.value,
    });
  }
}

function escapeText(s) {
  return String(s).replace(/[&<>"']/g, (c) => (
    { "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;" }[c]
  ));
}
